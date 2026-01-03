CREATE DATABASE IF NOT EXISTS redpanda ON CLUSTER '{cluster}'
;

CREATE TABLE IF NOT EXISTS redpanda.events_local ON CLUSTER '{cluster}'
(
    timestamp   DateTime64,
    id          UUID,
    value       UInt32
)
ENGINE = ReplicatedReplacingMergeTree('/clickhouse/tables/{shard}/{database}/events', '{replica}', timestamp)
ORDER BY (timestamp, id)
;

CREATE TABLE IF NOT EXISTS redpanda.events ON CLUSTER '{cluster}'
        AS redpanda.events_local
ENGINE = Distributed('{cluster}', redpanda, events_local)
;
