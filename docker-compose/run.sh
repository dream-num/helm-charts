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

choose_compose_file() {
    . $ENV_FILE

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
    choose_compose_file
    init_config
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
    choose_compose_file
    init_config
    stop
    start
    ;;
  *)
    echo "Unknown option: $option"
    help
    exit 1
    ;;
esac