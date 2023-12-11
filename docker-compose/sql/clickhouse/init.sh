#!/bin/bash

# ClickHouse 连接信息
CLICKHOUSE_HOST="localhost"
CLICKHOUSE_PORT="9000"
CLICKHOUSE_USER="clickhouse"
CLICKHOUSE_PASSWORD="clickhouse"

# 执行 SQL 查询
clickhouse-client --host=${CLICKHOUSE_HOST} --port=${CLICKHOUSE_PORT} --user=${CLICKHOUSE_USER} --password=${CLICKHOUSE_PASSWORD} --queries-file=/docker-entrypoint-initdb.d/main.sql
