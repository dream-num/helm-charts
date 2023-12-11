CREATE DATABASE univer;

CREATE TABLE univer.connector
(
    `id` UUID DEFAULT generateUUIDv4(),

    `connector_id` String,

    `config` String,

    `catalog` String,

    `states` String,

    `table_map` String
)
ENGINE = MergeTree
ORDER BY id;