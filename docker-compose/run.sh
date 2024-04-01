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

. .env

DATABASE_DSN='host=${DATABASE_HOST} port=${DATABASE_PORT} dbname=${DATABASE_DBNAME} user=${DATABASE_USERNAME} password=${DATABASE_PASSWORD} sslmode=disable TimeZone=Asia/Shanghai'
if [ "$DATABASE_DRIVER" == "mysql" ]; then
    DATABASE_DSN='${DATABASE_USERNAME}:${DATABASE_PASSWORD}@tcp(${DATABASE_HOST}:${DATABASE_PORT})/${DATABASE_DBNAME}?charset=utf8mb4\&parseTime=True\&loc=Local'
fi

COMPOSE_FILE="docker-compose.yaml"
if [ "$DATABASE_DRIVER" == "mysql" ]; then
    COMPOSE_FILE="docker-compose.mysql.yaml"
fi

cp ./configs/config.yaml.template ./configs/config.yaml
$SED -e 's|${DATABASE_DSN}|'"${DATABASE_DSN}"'|' ./configs/config.yaml

while IFS='=' read -r name value ; do
    # Replace variable with value. 
    $SED -e 's|${'"${name}"'}|'"${value}"'|' ./configs/config.yaml
done < .env

$DOCKER_COMPOSE -f $COMPOSE_FILE down

$DOCKER_COMPOSE -f $COMPOSE_FILE up -d