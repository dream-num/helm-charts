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

# check tar command
if ! [ -x "$(command -v tar)" ]; then
    echo "Error: tar is not installed." >&2
    exit 1
fi

# tar -xf all-in-one.tar

# load univer image
docker load -i univer-image.tar.gz

# load observability image
docker load -i observability-image.tar.gz

mkdir -p docker-compose \
    && cd docker-compose \
    && cp ../univer.zip . \
    && unzip univer.zip \
    && if [ -f ../license.zip ]; then cp ../license.zip . && unzip license.zip -d configs && rm license.zip; fi \
    && bash run.sh \
    && cd ..

# check universer start by 8000 port in loop
for i in {1..100}; do
    if curl -s http://localhost:8000 > /dev/null 2>&1; then
        break
    fi
    sleep 1
done

sleep 5

rm univer-image.tar.gz observability-image.tar.gz univer.zip