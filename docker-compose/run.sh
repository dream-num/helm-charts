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

COMPOSE_FILE="docker-compose.yaml"
ENV_FILE=".env"
DATABASE_DSN='host=${DATABASE_HOST} port=${DATABASE_PORT} dbname=${DATABASE_DBNAME} user=${DATABASE_USERNAME} password=${DATABASE_PASSWORD} sslmode=disable TimeZone=Asia/Shanghai'
DATABASE_REPLICA_DSN=""

choose_compose_file() {
    case "$DATABASE_DRIVER" in
    "mysql")
        DATABASE_DSN='${DATABASE_USERNAME}:${DATABASE_PASSWORD}@tcp(${DATABASE_HOST}:${DATABASE_PORT})/${DATABASE_DBNAME}?charset=utf8mb4\&parseTime=True\&loc=Local'
        COMPOSE_FILE="docker-compose.mysql.yaml"
    ;;
    "dameng")
        DATABASE_DSN='dm://${DATABASE_USERNAME}:${DATABASE_PASSWORD}@${DATABASE_HOST}:${DATABASE_PORT}?autoCommit=true'
        COMPOSE_FILE="docker-compose.db.yaml"
    ;;
    "gaussdb")
        DATABASE_DSN='host=${DATABASE_HOST} port=${DATABASE_PORT} dbname=${DATABASE_DBNAME} user=${DATABASE_USERNAME} password=${DATABASE_PASSWORD} sslmode=disable TimeZone=Asia/Shanghai'
        COMPOSE_FILE="docker-compose.db.yaml"
    ;;
    esac

    if [ "${DATABASE_REPLICA_HOST}" != "" ]; then
        case "$DATABASE_DRIVER" in
        "postgresql")
            DATABASE_REPLICA_DSN='host=${DATABASE_REPLICA_HOST} port=${DATABASE_PORT} dbname=${DATABASE_DBNAME} user=${DATABASE_USERNAME} password=${DATABASE_PASSWORD} sslmode=disable TimeZone=Asia/Shanghai'
        ;;
        "mysql")
            DATABASE_REPLICA_DSN='${DATABASE_USERNAME}:${DATABASE_PASSWORD}@tcp(${DATABASE_REPLICA_HOST}:${DATABASE_PORT})/${DATABASE_DBNAME}?charset=utf8mb4\&parseTime=True\&loc=Local'
        ;;
        "dameng")
            DATABASE_REPLICA_DSN='dm://${DATABASE_USERNAME}:${DATABASE_PASSWORD}@${DATABASE_REPLICA_HOST}:${DATABASE_PORT}?autoCommit=true'
        ;;
        "gaussdb")
            DATABASE_REPLICA_DSN='host=${DATABASE_REPLICA_HOST} port=${DATABASE_PORT} dbname=${DATABASE_DBNAME} user=${DATABASE_USERNAME} password=${DATABASE_PASSWORD} sslmode=disable TimeZone=Asia/Shanghai'
        ;;
        esac
    fi
}

check_abroad_region() {
    status_code=$(curl -o /dev/null -s -w "%{http_code}" --connect-timeout 5 -m 10 "https://www.google.com")
    if [ $status_code -ne 200 ]; then
        return 1
    fi
}

check_docker_proxy() {
    proxy=$(docker info -f '{{ .HTTPSProxy }}')
    if [ "$proxy" == "" ]; then
        return 1
    fi
}

prepare_image() {
    check_abroad_region
    if [ $? -ne 0 ]; then
        # not in abroad
        check_docker_proxy
        if [ $? -ne 0 ]; then
            # not set proxy
            $SED -e 's|image: nginx:|image: univer-acr-registry.cn-shenzhen.cr.aliyuncs.com/release/nginx:|' $COMPOSE_FILE
            $SED -e 's|image: postgres:|image: univer-acr-registry.cn-shenzhen.cr.aliyuncs.com/release/postgres:|' $COMPOSE_FILE
            $SED -e 's|image: rabbitmq:|image: univer-acr-registry.cn-shenzhen.cr.aliyuncs.com/release/rabbitmq:|' $COMPOSE_FILE
            $SED -e 's|image: bitnami/redis:|image: univer-acr-registry.cn-shenzhen.cr.aliyuncs.com/release/redis:|' $COMPOSE_FILE
            $SED -e 's|image: temporalio/auto-setup:|image: univer-acr-registry.cn-shenzhen.cr.aliyuncs.com/release/temporal:|' $COMPOSE_FILE
            $SED -e 's|image: bitnami/minio:|image: univer-acr-registry.cn-shenzhen.cr.aliyuncs.com/release/minio:|' $COMPOSE_FILE
            $SED -e 's|image: mysql:|image: univer-acr-registry.cn-shenzhen.cr.aliyuncs.com/release/mysql:|' $COMPOSE_FILE
        fi
    fi
}

init_config() {
    cp ./configs/config.yaml.template ./configs/config.yaml
    $SED -e 's|${DATABASE_DSN}|'"${DATABASE_DSN}"'|' ./configs/config.yaml

    while IFS='=' read -r name value ; do
        # Replace variable with value. 
        $SED -e 's|${'"${name}"'}|'"${value}"'|' ./configs/config.yaml
    done < .env
}

start() {
    $DOCKER_COMPOSE -f $COMPOSE_FILE --env-file $ENV_FILE up -d
}

stop() {
    $DOCKER_COMPOSE -f $COMPOSE_FILE --env-file $ENV_FILE down
}

enterprise() {
    cp .env .env.enterprise
    $SED -e 's|EDITION=.*|EDITION=univer|' .env.enterprise
    ENV_FILE=".env.enterprise"
}

load_image() {
    echo "Loading image..."
    docker load -i $1 -q
    _file_name=$(basename $1)
    univer_version=${_file_name%.tar.gz}
}

_env() {
    . $ENV_FILE
}

help() {
    echo "Usage: ./run.sh [COMMAND] [OPTION]"
    echo "Options:"
    echo "  -h, --help                   Show help for the script"
    echo "  --enterprise                 Use enterprise edition"
    echo "  --load /path/image.tar.gz    Use to load enterprise edition image"
    echo "Commands:"
    echo "  start    Start the service"
    echo "  stop     Stop the service"
    echo "  restart  Restart the service"
    echo "Default command:"
    echo "  ./run.sh start"
}

command="$1"
options=("$@")
start_index=2

case "$command" in
  "-h" | "--help")
    help
    ;;
  "start")
    for ((i = $start_index; i <= $#; i++)); do
        case "${options[$i - 1]}" in
        "--enterprise")
            enterprise
            ;;
        "--load")
            load_image ${options[$i]}
            i=$((i + 1))
            ;;
        esac
    done
    if [ -f .env.enterprise ] && [ "${univer_version}" != "" ] ; then
        $SED -e 's|UNIVERSER_VERSION=.*|UNIVERSER_VERSION='"${univer_version}"'|' .env.enterprise
    fi
    echo "Staring the service..."
    _env
    choose_compose_file
    init_config
    prepare_image
    start
    ;;
  "stop")
    echo "Stopping the service..."
    for ((i = $start_index; i <= $#; i++)); do
        case "${options[$i - 1]}" in
        "--enterprise")
            ENV_FILE=".env.enterprise"
            ;;
        esac
    done
    choose_compose_file
    stop
    ;;
  "" | "restart")
    echo "Restarting the service..."
    for ((i = $start_index; i <= $#; i++)); do
        case "${options[$i - 1]}" in
        "--enterprise")
            ENV_FILE=".env.enterprise"
            ;;
        "--load")
            load_image ${options[$i]}
            i=$((i + 1))
            ;;
        esac
    done
    if [ -f .env.enterprise ] && [ "${univer_version}" != "" ] ; then
        $SED -e 's|UNIVERSER_VERSION=.*|UNIVERSER_VERSION='"${univer_version}"'|' .env.enterprise
    fi
    _env
    choose_compose_file
    init_config
    stop
    prepare_image
    start
    ;;
  *)
    echo "Unknown option: $option"
    help
    exit 1
    ;;
esac