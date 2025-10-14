#!/bin/bash

pwd
cp -r ../docker-compose ./
sed -i -e 's/^\s*prepare_image$/#&/' ./docker-compose/run.sh

source docker-compose/.env

mv docker-compose univer-server-${UNIVERSER_VERSION}

pull_image() {
    docker pull "$1"
    if [ $? -ne 0 ]; then
        echo "Failed to pull image: $1"
        exit 1
    fi
}

echo "save univer image"
pull_image univer-acr-registry.cn-shenzhen.cr.aliyuncs.com/release/universer:${UNIVERSER_VERSION}
pull_image univer-acr-registry.cn-shenzhen.cr.aliyuncs.com/release/universer-sql:${UNIVERSER_SQL_VERSION}
pull_image nginx:alpine-slim
pull_image univer-acr-registry.cn-shenzhen.cr.aliyuncs.com/release/univer-collaboration:${COLLABORATION_SERVER_VERSION}
pull_image postgres:${POSTGRES_VERSION}
pull_image rabbitmq:${RABBITMQ_VERSION}
pull_image univerai/redis:${REDIS_VERSION}
pull_image temporalio/auto-setup:${TEMPORAL_VERSION}
pull_image univerai/minio:${MINIO_VERSION}
pull_image univer-acr-registry.cn-shenzhen.cr.aliyuncs.com/release/worker-exchange:${UNIVER_WORKER_EXCHANGE_VERSION}
pull_image univer-acr-registry.cn-shenzhen.cr.aliyuncs.com/release/univer-collaboration-lite:${UNIVER_DEMO_UI_VERSION}
pull_image univer-acr-registry.cn-shenzhen.cr.aliyuncs.com/release/universer-check:0.0.1
pull_image envoyproxy/envoy:v1.31.3
pull_image univer-acr-registry.cn-shenzhen.cr.aliyuncs.com/release/usip-server:latest
docker save \
    univer-acr-registry.cn-shenzhen.cr.aliyuncs.com/release/universer:${UNIVERSER_VERSION} \
    univer-acr-registry.cn-shenzhen.cr.aliyuncs.com/release/universer-sql:${UNIVERSER_SQL_VERSION} \
    nginx:alpine-slim \
    univer-acr-registry.cn-shenzhen.cr.aliyuncs.com/release/univer-collaboration:${COLLABORATION_SERVER_VERSION} \
    postgres:${POSTGRES_VERSION} \
    rabbitmq:${RABBITMQ_VERSION} \
    univerai/redis:${REDIS_VERSION} \
    temporalio/auto-setup:${TEMPORAL_VERSION} \
    univerai/minio:${MINIO_VERSION} \
    univer-acr-registry.cn-shenzhen.cr.aliyuncs.com/release/worker-exchange:${UNIVER_WORKER_EXCHANGE_VERSION} \
    univer-acr-registry.cn-shenzhen.cr.aliyuncs.com/release/univer-collaboration-lite:${UNIVER_DEMO_UI_VERSION} \
    univer-acr-registry.cn-shenzhen.cr.aliyuncs.com/release/universer-check:0.0.1 \
    envoyproxy/envoy:v1.31.3 \
    univer-acr-registry.cn-shenzhen.cr.aliyuncs.com/release/usip-server:latest \
    | gzip > univer-image.tar.gz

echo "save observability image"
pull_image grafana/loki:${LOKI_VERSION}
pull_image grafana/promtail:${PROMTAIL_VERSION}
pull_image grafana/grafana:${GRAFANA_VERSION}
pull_image univerai/prometheus:${PROMETHEUS_VERSION}
pull_image oliver006/redis_exporter:${REDIS_EXPORTER_VERSION}
pull_image univerai/postgres-exporter:${POSTGRES_EXPORTER_VERSION}
pull_image kbudde/rabbitmq-exporter:${RABBITMQ_EXPORTER_VERSION}
docker save \
    grafana/loki:${LOKI_VERSION} \
    grafana/promtail:${PROMTAIL_VERSION} \
    grafana/grafana:${GRAFANA_VERSION} \
    univerai/prometheus:${PROMETHEUS_VERSION} \
    oliver006/redis_exporter:${REDIS_EXPORTER_VERSION} \
    univerai/postgres-exporter:${POSTGRES_EXPORTER_VERSION} \
    kbudde/rabbitmq-exporter:${RABBITMQ_EXPORTER_VERSION} \
    | gzip > observability-image.tar.gz

mkdir all-in-one.$1.${UNIVERSER_VERSION}
mv univer-image.tar.gz observability-image.tar.gz univer-server-${UNIVERSER_VERSION}/ load-images.sh ./all-in-one.$1.${UNIVERSER_VERSION}

tar -cvf all-in-one.$1.${UNIVERSER_VERSION}.tar ./all-in-one.$1.${UNIVERSER_VERSION}

echo "ALLINONE_PATH=$(echo $PWD/all-in-one.$1.${UNIVERSER_VERSION}.tar)" >> $GITHUB_ENV
echo "ALLINONE_TAR=$(echo all-in-one.$1.${UNIVERSER_VERSION}.tar)" >> $GITHUB_ENV