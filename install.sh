#!/bin/bash

# check docker and docker-compose
if ! [ -x "$(command -v docker)" ]; then
    echo "Error: docker is not installed." >&2
    exit 1
fi

if ! [ -x "$(command -v docker-compose)" ]; then
    echo "Error: docker-compose is not installed." >&2
    exit 1
fi

# check docker daemon
if ! docker info > /dev/null 2>&1; then
    echo "Error: docker daemon is not running." >&2
    exit 1
fi

# check wget and curl command
if ! [ -x "$(command -v wget)" ]; then
    echo "Error: wget is not installed." >&2
    exit 1
fi

if ! [ -x "$(command -v curl)" ]; then
    echo "Error: curl is not installed." >&2
    exit 1
fi

mkdir -p docker-compose \
    && cd docker-compose \
    && wget https://release-univer.oss-cn-shenzhen.aliyuncs.com/release-demo/docker-compose.zip -O univer.zip \
    && unzip univer.zip \
    && rm univer.zip \
    && if [ -f ../license.zip ]; then cp ../license.zip . && unzip license.zip -d configs && rm license.zip; fi \
    && bash run.sh

# check universer start by 8000 port in loop
for i in {1..100}; do
    if curl -s http://localhost:8000 > /dev/null 2>&1; then
        break
    fi
    sleep 1
done

sleep 5

docker run --net=univer-prod --rm --name univer-collaboration-lite -p 3010:3010 univer-acr-registry.cn-shenzhen.cr.aliyuncs.com/release/univer-collaboration-lite:latest