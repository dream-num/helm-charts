#!/bin/bash

cp ./configs/config.yaml.template ./configs/config.yaml

while IFS='=' read -r name value ; do
    # Replace variable with value. 
    sed -i 's|${'"${name}"'}|'"${value}"'|' ./configs/config.yaml
done < <(envsubst '$POSTGRES_PASSWORD $RABBITMQ_PASSWORD $CLICKHOUSE_PASSWORD $UNIVERSER_ADMIN_PASSWORD $GRAFANA_PASSWORD'< .env.dev)

docker compose -f docker-compose.dev.yaml down

echo $REGISTRY_PASSWORD | docker login univer-acr-registry.cn-shenzhen.cr.aliyuncs.com -u $REGISTRY_USERNAME --password-stdin

docker pull univer-acr-registry.cn-shenzhen.cr.aliyuncs.com/univer/universer:latest
docker pull univer-acr-registry.cn-shenzhen.cr.aliyuncs.com/univer/univer-collaboration:latest
docker pull univer-acr-registry.cn-shenzhen.cr.aliyuncs.com/univer/univer-collaboration-demo:latest
docker pull univer-acr-registry.cn-shenzhen.cr.aliyuncs.com/univer/univer-worker:latest

docker compose -f docker-compose.dev.yaml --env-file .env.dev up $SERVICE -d

docker logout univer-acr-registry.cn-shenzhen.cr.aliyuncs.com