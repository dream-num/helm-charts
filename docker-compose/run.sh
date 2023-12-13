#!/bin/bash

cp ./configs/config.yaml.template ./configs/config.yaml

while IFS='=' read -r name value ; do
    # Replace variable with value. 
    sed -i 's|${'"${name}"'}|'"${value}"'|' ./configs/config.yaml
done < .env

docker compose down

docker compose up -d