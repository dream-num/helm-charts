#!/bin/bash

cp ./configs/config.yaml.template ./configs/config.yaml

while IFS='=' read -r name value ; do
    # Replace variable with value. 
    sed -i 's|${'"${name}"'}|'"${value}"'|' ./configs/config.yaml
done < .env.dev

docker compose -f docker-compose.dev.yaml down

docker login --username=$REGISTRY_USRENAME --password=$REGISTRY_PASSWORD univer-acr-registry.cn-shenzhen.cr.aliyuncs.com

docker pull univer-acr-registry.cn-shenzhen.cr.aliyuncs.com/univer/universer:latest
docker pull univer-acr-registry.cn-shenzhen.cr.aliyuncs.com/univer/univer-collaboration:latest
docker pull univer-acr-registry.cn-shenzhen.cr.aliyuncs.com/univer/univer-collaboration-demo:latest
docker pull univer-acr-registry.cn-shenzhen.cr.aliyuncs.com/univer/univer-worker:latest

docker compose -f docker-compose.dev.yaml --env-file .env.dev up -d

docker logout univer-acr-registry.cn-shenzhen.cr.aliyuncs.com