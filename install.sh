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

# check curl command
if ! [ -x "$(command -v curl)" ]; then
    echo "Error: curl is not installed." >&2
    exit 1
fi

# check unzip command
if ! [ -x "$(command -v unzip)" ]; then
    echo "Error: unzip is not installed." >&2
    exit 1
fi

read -p "enter your email: " email
if [ -z "$email" ]; then
    echo "Error: email is required." >&2
    exit 1
fi

read -p "enter license.zip absolute path if you have: " license

mkdir -p docker-compose \
    && cd docker-compose \
    && curl -s -o univer.zip https://release-univer.oss-cn-shenzhen.aliyuncs.com/release-demo/docker-compose.zip \
    && unzip -q univer.zip \
    && rm univer.zip \
    && if [ -f "$license" ]; then unzip -q "$license" -d configs; fi \
    && bash run.sh

curl -s "https://univer.ai/license-manage-api/license/deploy-access?email=${email}" > /dev/null 2>&1

# check universer start by 8000 port in loop
for i in {1..100}; do
    if curl -s http://localhost:8000 > /dev/null 2>&1; then
        break
    fi
    sleep 1
done

sleep 5

docker run --net=univer-prod --rm --name univer-collaboration-lite -p 3010:3010 univer-acr-registry.cn-shenzhen.cr.aliyuncs.com/release/univer-collaboration-lite:latest