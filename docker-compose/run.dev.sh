#!/bin/bash

cp ./configs/config.yaml.template ./configs/config.yaml

DATABASE_DSN='host=${DATABASE_HOST} port=${DATABASE_PORT} dbname=${DATABASE_DBNAME} user=${DATABASE_USERNAME} password=${DATABASE_PASSWORD} sslmode=disable TimeZone=Asia/Shanghai'
sed -i  -e 's|${DATABASE_DSN}|'"${DATABASE_DSN}"'|' ./configs/config.yaml

while IFS='=' read -r name value ; do
    # Replace variable with value. 
    sed -i 's|${'"${name}"'}|'"${value}"'|' ./configs/config.yaml
done < <(envsubst '$DATABASE_PASSWORD $RABBITMQ_PASSWORD $CLICKHOUSE_PASSWORD $UNIVERSER_ADMIN_PASSWORD $GRAFANA_PASSWORD \
    $S3_USER $S3_PASSWORD $S3_REGION $S3_PATH_STYLE $S3_ENDPOINT $S3_ENDPOINT_PUBLIC $S3_DEFAULT_BUCKET \
    $AUTH_COOKIE_DOMAIN $AUTH_OIDC_ENABLED $AUTH_OIDC_CLIENT_ID $AUTH_OIDC_CLIENT_SECRET $AUTH_OIDC_ISSUER $AUTH_OIDC_CALLBACK_URL'< .env.dev)
docker compose -f docker-compose.dev.yaml down

echo "docker login ..."
# echo $REGISTRY_PASSWORD | docker login univer-acr-registry.cn-shenzhen.cr.aliyuncs.com -u $REGISTRY_USERNAME --password-stdin
docker login -u "${REGISTRY_USERNAME}" -p "${REGISTRY_PASSWORD}" univer-acr-registry.cn-shenzhen.cr.aliyuncs.com

docker pull univer-acr-registry.cn-shenzhen.cr.aliyuncs.com/univer/universer:latest
docker pull univer-acr-registry.cn-shenzhen.cr.aliyuncs.com/univer/univer-collaboration:latest
docker pull univer-acr-registry.cn-shenzhen.cr.aliyuncs.com/univer/univer-collaboration-demo:latest
docker pull univer-acr-registry.cn-shenzhen.cr.aliyuncs.com/univer/worker-exchange:latest

docker compose -f docker-compose.dev.yaml --env-file .env.dev up $SERVICE -d

docker logout univer-acr-registry.cn-shenzhen.cr.aliyuncs.com