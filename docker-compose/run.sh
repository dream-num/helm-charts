#!/bin/bash

PLATFORM=$(uname)
SED="sed -i"
if [ "$PLATFORM" == "Darwin" ]; then
    SED="sed -i \"\""
fi

DOCKER_COMPOSE="docker compose"
if [! $DOCKER_COMPOSE version] &> /dev/null; then
    DOCKER_COMPOSE="docker-compose"
fi
if [! $DOCKER_COMPOSE version] &> /dev/null; then
    echo "need docker compose."
    exit 1
fi

cp ./configs/config.yaml.template ./configs/config.yaml

while IFS='=' read -r name value ; do
    # Replace variable with value. 
    $SED -e 's|${'"${name}"'}|'"${value}"'|' ./configs/config.yaml
done < .env

$DOCKER_COMPOSE down

$DOCKER_COMPOSE up -d