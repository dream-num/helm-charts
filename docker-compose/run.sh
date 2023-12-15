#!/bin/bash

PLATFORM=$(uname)
SED="sed -i"
if [ "$PLATFORM" == "Darwin" ]; then
    SED="sed -i \"\""
fi

cp ./configs/config.yaml.template ./configs/config.yaml

while IFS='=' read -r name value ; do
    # Replace variable with value. 
    $SED -e 's|${'"${name}"'}|'"${value}"'|' ./configs/config.yaml
done < .env

docker compose down

docker compose up -d