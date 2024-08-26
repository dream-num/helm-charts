#!/bin/bash

set -eu

# get operating system
os_type=$(uname)
if [ "$os_type" == "Darwin" ]; then
    echo "Operating System: macOS"
    os_type="darwin"
elif [ "$os_type" == "Linux" ]; then
    echo "Operating System: Linux"
    os_type="linux"
else
    echo "Unknown Operating System: $os_type"
fi

# get architecture
architecture=$(uname -m)
if [ "$architecture" == "aarch64" ]; then
    echo "Architecture: ARM 64-bit (aarch64)"
    architecture="arm64"
elif [ "$architecture" == "x86_64" ]; then
    echo "Architecture: AMD 64-bit (x86_64)"
    architecture="amd64"
else
    echo "Not Support Architecture: $architecture"
    exit 1
fi

# check docker and docker-compose
if ! [ -x "$(command -v docker)" ]; then
    echo "Error: docker is not installed." >&2
    exit 1
fi

if ! [ -x "$(command -v docker-compose)" ] && ! [ -x "$(command -v docker compose)" ]; then
    echo "Error: docker-compose is not installed." >&2
    exit 1
fi

# check docker daemon
if ! docker info > /dev/null 2>&1; then
    echo "Error: docker daemon is not running." >&2
    exit 1
fi

# check curl command
if ! [ -x "$(command -v curl)" ]; then
    echo "Error: curl is not installed." >&2
    exit 1
fi

# check unzip command
UNZIP="unzip"
if ! [ -x "$(command -v $UNZIP)" ]; then
    # download unzip
    if [ "$os_type" == "darwin" ] || [ "$os_type" == "linux" ]; then
        if [ "$architecture" == "arm64" ] || [ "$architecture" == "amd64" ]; then
            curl -s -o /tmp/unzip "https://release-univer.oss-cn-shenzhen.aliyuncs.com/release-demo/unzip-${os_type}-${architecture}"
            chmod +x /tmp/unzip
            UNZIP="/tmp/unzip"
        else
            echo "Error: unzip is not installed." >&2
            exit 1
        fi
    else
        echo "Error: unzip is not installed." >&2
        exit 1
    fi
fi


tokenPath="${HOME}/.univer/"
tokenFileName="${tokenPath}/deploy_token"
getTokenURL="https://univer.ai/cli-auth"
verifyTokenURL="https://univer.ai/license-manage-api/cli-auth/verify-token"


unzip_file() {
    local file="$1"
    local dest="$2"
    
    if [ "$UNZIP" == "unzip" ]; then
        $UNZIP -q "$file" -d "$dest"
    else
        $UNZIP "$file" "$dest"
    fi

    # Check if the command was successful
    if [ $? -eq 0 ]; then
        # "File unzipped successfully."
        return 0
    else
        # "Failed to unzip file."
        return 1
    fi
}


openURL() {
    local url="$1"
    local openCommand

    # Determine the appropriate command to open the URL based on the OS
    if [[ "$(uname -r)" == *microsoft* ]]; then
        # Assuming running under WSL
        openCommand="cmd.exe /c start"
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        # xdg-open is available in most Linux distributions.
        # It opens a file or URL in the user's preferred browser (configurable with xdg-settings).
        if command -v xdg-open > /dev/null; then
          openCommand="xdg-open"
        else
          return 1
        fi
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        openCommand="open"
    elif [[ "$OSTYPE" == "msys" ]]; then
        # Assuming running mingw
        openCommand="start"
    else
        # "Unsupported environment for openURL function."
        return 1
    fi

    # Attempt to open the URL
    if [[ "$openCommand" == "cmd.exe*" ]]; then
        $openCommand "${url//ir/ri}"  # "$(echo "$url" | sed 's/&/^&/')"  Escaping '&' for cmd.exe
    else
        $openCommand "$url"
    fi

    # Check if the command was successful
    if [ $? -eq 0 ]; then
        # "URL opened successfully."
        return 0
    else
        # "Failed to open URL."
        return 1
    fi
}

verifyToken() {
  reqToken=$1
  verbose=$2
  response="$(curl -s -w "\n%{http_code}" ${verifyTokenURL} -H 'X-Session-Token: '"${reqToken}" -d "token=${reqToken}&source=deploy")";
  # http_body="$(echo "${response}" | head -n -1)";
  http_code="$(echo "${response}" | tail -n 1)";

  if [[ "$http_code" -ne 200 ]] ; then
    ${verbose} && echo "That's not a valid token! (server response code:$http_code)"
    return 1
  else
    echo "Welcome! You're authenticated."
  fi
  return 0
}

getLicense(){
  while true ; do
     read -r -p "Enter the path for license.zip or press Enter to continue: " license
     if [ -z "${license}" ]; then
       break
     elif [ -d "${license}" ]; then
       echo "ERROR: need a file path"
     elif [ -f "${license}" ]; then
       mkdir -p docker-compose/configs
       unzip_file "$license" docker-compose/configs
       break
     else
       echo "file not exist"
     fi
  done
}


token=""
if [[ -s ${tokenFileName} ]]; then
  # check saved token
  token=$(cat "${tokenFileName}")
  if ! verifyToken "${token}" false; then
    token=""
    echo -n "" > "${tokenFileName}"
  fi
fi

if [ -z "$token" ]; then
  echo "Please authenticate the CLI to subscribe to our upgrade notifications"
  openURL "${getTokenURL}" && 
        echo -e "Your browser has been opened to visit:\n\n\t ${getTokenURL} \n" || 
        echo -e "Open the following in your browser:\n\n\t ${getTokenURL} \n"

  while true ; do
    read -r -p "> Paste your token here: " token
    if verifyToken "${token}" true; then
      mkdir -p "${tokenPath}"
      echo -n "${token}" > "${tokenFileName}"
      break
    fi
  done
fi

getLicense

mkdir -p docker-compose \
    && cd docker-compose \
    && curl -s -o univer.zip https://release-univer.oss-cn-shenzhen.aliyuncs.com/release-demo/docker-compose.zip \
    && unzip_file univer.zip . \
    && rm univer.zip \
    && bash run.sh


# check universer start by 8000 port in loop
for i in {1..100}; do
    if curl -s http://localhost:8000 > /dev/null 2>&1; then
        break
    fi
    sleep 1
done

sleep 5

docker pull univer-acr-registry.cn-shenzhen.cr.aliyuncs.com/release/univer-collaboration-lite:latest

docker run --net=univer-prod --rm --name univer-collaboration-lite -p 3010:3010 univer-acr-registry.cn-shenzhen.cr.aliyuncs.com/release/univer-collaboration-lite:latest
