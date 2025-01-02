#!/bin/bash

pwd
cp -r ../docker-compose ./
sed -i -e 's/^\s*prepare_image$/#&/' ./docker-compose/run.sh

source docker-compose/.env

mv docker-compose univer-server-${UNIVERSER_VERSION}

echo "save univer image"
docker pull univer-acr-registry.cn-shenzhen.cr.aliyuncs.com/release/universer:${UNIVERSER_VERSION}
docker pull univer-acr-registry.cn-shenzhen.cr.aliyuncs.com/release/universer-sql:${UNIVERSER_SQL_VERSION}
docker pull nginx:alpine-slim
docker pull univer-acr-registry.cn-shenzhen.cr.aliyuncs.com/release/univer-collaboration:${COLLABORATION_SERVER_VERSION}
docker pull postgres:${POSTGRES_VERSION}
docker pull rabbitmq:${RABBITMQ_VERSION}
docker pull bitnami/redis:${REDIS_VERSION}
docker pull temporalio/auto-setup:${TEMPORAL_VERSION}
docker pull bitnami/minio:${MINIO_VERSION}
docker pull univer-acr-registry.cn-shenzhen.cr.aliyuncs.com/release/worker-exchange:${UNIVER_WORKER_EXCHANGE_VERSION}
docker pull univer-acr-registry.cn-shenzhen.cr.aliyuncs.com/release/univer-collaboration-lite:${UNIVER_DEMO_UI_VERSION}
docker pull univer-acr-registry.cn-shenzhen.cr.aliyuncs.com/release/universer-check:0.0.1
docker pull envoyproxy/envoy:v1.31.3
docker pull univer-acr-registry.cn-shenzhen.cr.aliyuncs.com/release/usip-server:latest
docker save \
    univer-acr-registry.cn-shenzhen.cr.aliyuncs.com/release/universer:${UNIVERSER_VERSION} \
    univer-acr-registry.cn-shenzhen.cr.aliyuncs.com/release/universer-sql:${UNIVERSER_SQL_VERSION} \
    nginx:alpine-slim \
    univer-acr-registry.cn-shenzhen.cr.aliyuncs.com/release/univer-collaboration:${COLLABORATION_SERVER_VERSION} \
    postgres:${POSTGRES_VERSION} \
    rabbitmq:${RABBITMQ_VERSION} \
    bitnami/redis:${REDIS_VERSION} \
    temporalio/auto-setup:${TEMPORAL_VERSION} \
    bitnami/minio:${MINIO_VERSION} \
    univer-acr-registry.cn-shenzhen.cr.aliyuncs.com/release/worker-exchange:${UNIVER_WORKER_EXCHANGE_VERSION} \
    univer-acr-registry.cn-shenzhen.cr.aliyuncs.com/release/univer-collaboration-lite:${UNIVER_DEMO_UI_VERSION} \
    univer-acr-registry.cn-shenzhen.cr.aliyuncs.com/release/universer-check:0.0.1 \
    envoyproxy/envoy:v1.31.3 \
    univer-acr-registry.cn-shenzhen.cr.aliyuncs.com/release/usip-server:latest \
    | gzip > univer-image.tar.gz

echo "save observability image"
docker pull grafana/loki:${LOKI_VERSION}
docker pull grafana/promtail:${PROMTAIL_VERSION}
docker pull grafana/grafana:${GRAFANA_VERSION}
docker pull bitnami/prometheus:${PROMETHEUS_VERSION}
docker pull oliver006/redis_exporter:${REDIS_EXPORTER_VERSION}
docker pull bitnami/postgres-exporter:${POSTGRES_EXPORTER_VERSION}
docker pull kbudde/rabbitmq-exporter:${RABBITMQ_EXPORTER_VERSION}
docker save \
    grafana/loki:${LOKI_VERSION} \
    grafana/promtail:${PROMTAIL_VERSION} \
    grafana/grafana:${GRAFANA_VERSION} \
    bitnami/prometheus:${PROMETHEUS_VERSION} \
    oliver006/redis_exporter:${REDIS_EXPORTER_VERSION} \
    bitnami/postgres-exporter:${POSTGRES_EXPORTER_VERSION} \
    kbudde/rabbitmq-exporter:${RABBITMQ_EXPORTER_VERSION} \
    | gzip > observability-image.tar.gz

mkdir all-in-one.$1.${UNIVERSER_VERSION}
mv univer-image.tar.gz observability-image.tar.gz univer-server-${UNIVERSER_VERSION}/ load-images.sh ./all-in-one.$1.${UNIVERSER_VERSION}

tar -cvf all-in-one.$1.${UNIVERSER_VERSION}.tar ./all-in-one.$1.${UNIVERSER_VERSION}

echo "ALLINONE_PATH=$(echo $PWD/all-in-one.$1.${UNIVERSER_VERSION}.tar)" >> $GITHUB_ENV
echo "ALLINONE_TAR=$(echo all-in-one.$1.${UNIVERSER_VERSION}.tar)" >> $GITHUB_ENV