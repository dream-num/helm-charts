#!/bin/bash

_CI_TEST=${_CI_TEST:-false}
_HOST=${_HOST:-"univer.ai"}

# get os type
osType=$(uname)
if [ "${osType}" == "Darwin" ]; then
    osType="darwin"
elif [ "${osType}" == "Linux" ]; then
    osType="linux"
elif [[ "${osType}" == MINGW64* ]]; then
    osType="mingw"
else
    echo "Warning: Unknow OS type ${osType}"
fi

# get arch type
archType=$(uname -m)
if [ "${archType}" == "x86_64" ]; then
    archType="amd64"
elif [ "${archType}" == "aarch64" ] || [ "$archType" == "arm64" ]; then
    archType="arm64"
else
    echo "Error: Unsupport arch type ${archType}"
    exit 1
fi

SCRIPT_DIR="/tmp/univer-script"

# check curl command
if ! [ -x "$(command -v curl)" ]; then
    echo "Error: curl is not installed." >&2
    exit 1
fi

if ! [ -x "$(command -v docker)" ]; then
    echo "Docker is not installed."
    read -p "Do you want to install Docker? (Y/n): " choice
    choice=${choice:-Y}  # Default to 'Y' if no input is provided
    case "$choice" in
        y|Y )
            mkdir -p $SCRIPT_DIR/get-docker
            curl -s -o $SCRIPT_DIR/get-docker/get-docker.sh https://release-univer.oss-cn-shenzhen.aliyuncs.com/tool/get-docker.sh
            curl -s -o $SCRIPT_DIR/get-docker/get-docker-official-script.sh https://release-univer.oss-cn-shenzhen.aliyuncs.com/tool/get-docker-official-script.sh
            # run get-docker script from local get-docker/get-docker.sh
            bash $SCRIPT_DIR/get-docker/get-docker.sh || { echo "Failed to install Docker"; exit 1; }
            # TODO(zsq1234): newgrp docker interupt the script, so use sudo chmod 666 /var/run/docker.sock instead and temporary
            sudo chmod 666 /var/run/docker.sock
            rm -rf $SCRIPT_DIR/get-docker
            ;;
        n|N )
            echo "Installation aborted. Docker is required to proceed." >&2
            exit 1
            ;;
        * )
            echo "Invalid input. Installation aborted." >&2
            exit 1
            ;;
    esac
fi

docker compose version &>/dev/null
if [ $? -ne 0 ]; then
    docker-compose version &>/dev/null
    if [ $? -ne 0 ]; then
        echo "Error: docker compose is not installed."
        exit 1
    fi
fi

# check docker daemon
if ! docker info > /dev/null 2>&1; then
    echo "Error: docker daemon is not running." >&2
    exit 1
fi

set -eu

# check docker version
_docker_version=$(docker version --format '{{ .Server.Version }}')
if [ "$(printf '%s\n' "$_docker_version" "23.0" | sort -V | head -n1)" == "$_docker_version" ] && [ "$_docker_version" != "23.0" ]; then
    echo "Warning: docker version $_docker_version less than 23.0" >&2
fi

checkPort() {
    if ! [ -x "$(command -v netstat)" ] || ! [ -x "$(command -v awk)" ] ; then
        docker run --network=host --rm univer-acr-registry.cn-shenzhen.cr.aliyuncs.com/release/network-tool:0.0.1 netstat -tuln | awk '{print $4}' | grep -q ":$1"
    else
        netstat -tuln | awk '{print $4}' | grep -q ":$1"
    fi
    if [ $? -eq 0 ]; then
        echo "Port $1 is already in use."
        exit 1
    fi
}


tokenPath="${HOME}/.univer/"
tokenFileName="${tokenPath}/deploy_token"

getTokenURL="https://${_HOST}/cli-auth"
verifyTokenURL="https://${_HOST}/license-manage-api/cli-auth/verify-token"


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
  http_body="$(echo "${response}" | sed  '$d')";
  http_code="$(echo "${response}" | tail -n 1)";

  if [[ "$http_code" -ne 200 ]] ; then
    ${verbose} && echo "That's not a valid token! (server response code:$http_code)"
    return 1
  else
    echo "Welcome! You're authenticated."
  fi
  return 0
}

token=""

getToken(){
  if [ -s ${tokenFileName} ]; then
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

    while [ "$_CI_TEST" != "true" ] ; do
      read -r -p "> Paste your token here: " token
      if verifyToken "${token}" true; then
        mkdir -p "${tokenPath}"
        echo -n "${token}" > "${tokenFileName}"
        break
      fi
    done
  fi
}

getToken

# download specfied version
work_dir=$PWD
tmp_dir=$(mktemp -d)

mkdir -p "$tmp_dir" && cd "$tmp_dir"
if [ $# == 1 ]; then
    echo "start download version:$1..."
    curl -s -o univer.tar.gz https://release-univer.oss-cn-shenzhen.aliyuncs.com/release/docker-compose.$1.tar.gz
else
    echo "start download the latest version..."
    curl -s -o univer.tar.gz https://release-univer.oss-cn-shenzhen.aliyuncs.com/release/docker-compose.tar.gz
fi
tar -xzf univer.tar.gz && rm univer.tar.gz
# get real version
. .env
version=$UNIVERSER_VERSION
if [ $# == 1 ] && [ "$version" != "$1" ]; then
    echo "the specified version:$1 not exists."
    rm -r $tmp_dir
    exit 1
fi

# mv to work dir
cd "$work_dir"
target_dir="$work_dir/universer-${version}"

if [ -d "$target_dir" ]; then
    echo "the version:${version} already exists."
    rm -r $tmp_dir
    exit 1
fi

mv "$tmp_dir" "$target_dir"
echo "download success, target dir is:${target_dir}"
