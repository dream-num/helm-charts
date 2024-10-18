#!/bin/bash

RELEASE_TIME="1729239096" # RELEASE_TIME

PLATFORM=$(uname)
SED="sed -i"
if [ "$PLATFORM" == "Darwin" ]; then
    SED="sed -i \"\""
fi

DOCKER_COMPOSE="docker compose"
$DOCKER_COMPOSE version &>/dev/null
if [ $? -ne 0 ]; then
    DOCKER_COMPOSE="docker-compose"
    $DOCKER_COMPOSE version &>/dev/null
    if [ $? -ne 0 ]; then
        echo "need docker compose."
        exit 1
    fi
fi

COMPOSE_FILE="docker-compose.yaml"
ENV_FILE=".env"
DATABASE_DSN='host=${DATABASE_HOST} port=${DATABASE_PORT} dbname=${DATABASE_DBNAME} user=${DATABASE_USERNAME} password=${DATABASE_PASSWORD} sslmode=disable TimeZone=Asia/Shanghai'
DATABASE_REPLICA_DSN=""
NOT_CHECK_REGION=${NOT_CHECK_REGION:-false}

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

    if [ "${DATABASE_READ_HOST}" != "" ]; then
        case "$DATABASE_DRIVER" in
        "postgresql")
            DATABASE_REPLICA_DSN='host=${DATABASE_READ_HOST} port=${DATABASE_PORT} dbname=${DATABASE_DBNAME} user=${DATABASE_USERNAME} password=${DATABASE_PASSWORD} sslmode=disable TimeZone=Asia/Shanghai'
        ;;
        "mysql")
            DATABASE_REPLICA_DSN='${DATABASE_USERNAME}:${DATABASE_PASSWORD}@tcp(${DATABASE_READ_HOST}:${DATABASE_PORT})/${DATABASE_DBNAME}?charset=utf8mb4\&parseTime=True\&loc=Local'
        ;;
        "dameng")
            DATABASE_REPLICA_DSN='dm://${DATABASE_USERNAME}:${DATABASE_PASSWORD}@${DATABASE_READ_HOST}:${DATABASE_PORT}?autoCommit=true'
        ;;
        "gaussdb")
            DATABASE_REPLICA_DSN='host=${DATABASE_READ_HOST} port=${DATABASE_PORT} dbname=${DATABASE_DBNAME} user=${DATABASE_USERNAME} password=${DATABASE_PASSWORD} sslmode=disable TimeZone=Asia/Shanghai'
        ;;
        esac
    fi
}

checkLicense() {
  if [ -f configs/license.txt ] ; then
    license_content=$(cat configs/license.txt)
    IFS='-' read -r -a license_parts <<< "$license_content"
    fourth_part=${license_parts[4]}
    # echo "Fourth part of the license: $fourth_part"
    if [ "$fourth_part" -lt "$RELEASE_TIME" ]; then
      formatted_date=$(date -d @"$fourth_part" +"%Y-%m-%d")
      echo "license not support current version. supports versions release before ${formatted_date}."
      exit 1
    fi
  else
    echo "No license has been configured, which will limit some functionalities. More information can be found here: https://univer.ai/pro/license"
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
    if [ "$NOT_CHECK_REGION" == "true" ]; then
        return
    fi
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
    s='s|${DATABASE_DSN}|'$DATABASE_DSN'|'
    $SED -e "$s" ./configs/config.yaml

    s='s|${DATABASE_REPLICA_DSN}|'$DATABASE_REPLICA_DSN'|'
    $SED -e "$s" ./configs/config.yaml

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

check_failed_message() {
    service="$1"
    if [ "$service" == "" ]; then
        service="universer"
    fi
    echo -e "\n $service is not ready. \
        \nPlease use 'docker compose logs $service' to check the logs, \
        \nand check the Q&A in https://www.univer.ai/guides/sheet/server/docker#troubleshooting- may helpful."
}

check_docker_service() {
    # check docker compose service status
    for i in {1..10}; do
        echo "Checking docker compose $1 service..." $i
        $DOCKER_COMPOSE -f $COMPOSE_FILE ps --format '{{.State}}' $1 2>/dev/null | grep -q "running"
        if [ $? -eq 0 ]; then
            $DOCKER_COMPOSE -f $COMPOSE_FILE ps --format '{{.Status}}' $1 2>/dev/null | grep -q "Up"
            if [ $? -eq 0 ]; then
                echo "success"
                break
            fi
        fi
        if [ $i -eq 10 ]; then
            return 1
        fi
        sleep $i
    done
}

check_service() {
    # check universer service
    echo "Checking universer service..."
    for i in {1..30}; do
        docker run --rm --network=univer-prod --env no_proxy=universer univer-acr-registry.cn-shenzhen.cr.aliyuncs.com/release/universer-check:0.0.1 > /dev/null
        if [ $? -eq 0 ]; then
            echo "check completed."
            return 0
        fi
        sleep $i
    done

    check_failed_message universer
    return 1
}

start_demo_ui() {
    $DOCKER_COMPOSE -f $COMPOSE_FILE --profile demo-ui up univer-demo-ui
    $DOCKER_COMPOSE -f $COMPOSE_FILE --profile demo-ui rm -sf univer-demo-ui
}

help() {
    echo "Usage: ./run.sh [COMMAND] [OPTION]"
    echo "Options:"
    echo "  -h, --help                   Show help for the script"
    echo "  --enterprise                 Use enterprise edition"
    echo "  --load /path/image.tar.gz    Use to load enterprise edition image"
    echo "Commands:"
    echo "  start             Start the service"
    echo "  stop              Stop the service"
    echo "  restart           Restart the service"
    echo "  check             Check the service health"
    echo "  start-demo-ui     Start the sdk demo ui"
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
    checkLicense
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
    checkLicense
    choose_compose_file
    init_config
    stop
    prepare_image
    start
    ;;
  "check")
    check_service
    ;;
  "start-demo-ui")
    _env
    start_demo_ui
    ;;
  *)
    echo "Unknown option: $option"
    help
    exit 1
    ;;
esac