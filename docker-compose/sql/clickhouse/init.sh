#!/bin/bash

# ClickHouse 连接信息
CLICKHOUSE_HOST="localhost"
CLICKHOUSE_PORT="9000"
CLICKHOUSE_USER="clickhouse"
CLICKHOUSE_PASSWORD="clickhouse"

# 要创建的数据库名称
DATABASE_NAME="univer"

# 构建 SQL 查询
QUERY="CREATE DATABASE ${DATABASE_NAME};"

# 执行 SQL 查询
clickhouse-client --host=${CLICKHOUSE_HOST} --port=${CLICKHOUSE_PORT} --user=${CLICKHOUSE_USER} --password=${CLICKHOUSE_PASSWORD} --query="${QUERY}"
