#!/bin/bash

SED="sed -i"

UNIVER_RUN_ENGINE=${UNIVER_RUN_ENGINE:-"docker"}

# get os type
osType=$(uname)
if [ "${osType}" == "Darwin" ]; then
    osType="darwin"
    SED="sed -i \"\""
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


function _check_docker() {
    # check docker and docker-compose
    if ! [ -x "$(command -v docker)" ]; then
        echo "Error: docker is not installed." >&2
        exit 1
    fi

    DOCKER="docker"
    DOCKER_COMPOSE="docker compose"

    docker compose version &>/dev/null
    if [ $? -ne 0 ]; then
        docker-compose version &>/dev/null
        if [ $? -ne 0 ]; then
            echo "Error: docker compose is not installed."
            exit 1
        fi
        DOCKER_COMPOSE="docker-compose"
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
}

function _check_podman() {
    if ! [ -x "$(command -v podman)" ]; then
        echo "Error: podman is not installed." >&2
        exit 1
    fi

    DOCKER="podman"
    DOCKER_COMPOSE="podman compose"

    docker-compose version &>/dev/null
    if [ $? -ne 0 ]; then
        echo "Error: podman need docker-compose, but it is not installed." >&2
        exit 1
    fi

    podman compose version &>/dev/null
    if [ $? -ne 0 ]; then
        echo "Error: podman compose is not installed." >&2
        exit 1
    fi
}

DOCKER=""
DOCKER_COMPOSE=""

if [ "$UNIVER_RUN_ENGINE" == "docker" ]; then
    _check_docker
elif [ "$UNIVER_RUN_ENGINE" == "podman" ]; then
    _check_podman
else
    echo "Error: Unknown UNIVER_RUN_ENGINE value: $UNIVER_RUN_ENGINE"
    exit 1
fi


# check tar command
if ! [ -x "$(command -v tar)" ]; then
    echo "Error: tar is not installed." >&2
    exit 1
fi

# load univer image
$DOCKER load -i univer-image.tar.gz

# load observability image
$DOCKER load -i observability-image.tar.gz
