#!/bin/bash

# get os type
osType=$(uname)
if [ "${osType}" == "Darwin" ]; then
    osType="darwin"
elif [ "${osType}" == "Linux" ]; then
    osType="linux"
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

# check docker version
_docker_version=$(docker version --format '{{ .Server.Version }}')
if [ "$(printf '%s\n' "$_docker_version" "23.0" | sort -V | head -n1)" == "$_docker_version" ] && [ "$_docker_version" != "23.0" ]; then
    echo "Warning: docker version $_docker_version less than 23.0" >&2
fi

# check tar command
if ! [ -x "$(command -v tar)" ]; then
    echo "Error: tar is not installed." >&2
    exit 1
fi

# load univer image
docker load -i univer-image.tar.gz

# load observability image
docker load -i observability-image.tar.gz

# check docker-compose directory
tar_overwrite=""
if [ -f docker-compose/.env ] && [ -f docker-compose/run.sh ]; then
    read -r -p "docker-compose directory already exists, do you want to overwrite it? [y/N] " response
    if [ "$response" == "y" ] || [ "$response" == "Y" ]; then
        case "$osType" in
            "darwin")
                tar_overwrite="-U"
                ;;
            "linux")
                tar_overwrite="--overwrite"
                ;;
        esac
    else
        case "$osType" in
            "darwin")
                tar_overwrite="-k"
                ;;
            "linux")
                tar_overwrite="--skip-old-files"
                ;;
        esac
    fi
fi

mkdir -p docker-compose \
    && cd docker-compose \
    && cp ../univer.tar.gz . \
    && tar -xzf univer.tar.gz $tar_overwrite \
    && if [ -f ../license-univer ]; then cp ../license-univer ./configs/; fi \
    && NOT_CHECK_REGION=true bash run.sh \
    && cd ..

# check service health
bash docker-compose/run.sh check

rm univer-image.tar.gz observability-image.tar.gz univer.tar.gz