CREATE DATABASE IF NOT EXISTS redpanda ON CLUSTER '{cluster}'
;

CREATE TABLE IF NOT EXISTS redpanda.events_local ON CLUSTER '{cluster}'
(
    timestamp   DateTime,
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

-- Materialized view to send even 'value' events to an external URL
CREATE TABLE IF NOT EXISTS redpanda.events_url ON CLUSTER '{cluster}'
(
    timestamp   DateTime,
    id          UUID,
    value       UInt32
)
ENGINE = URL('http://clickhouse-redpanda-consumer:4195/events', 'JSONEachRow')
;

CREATE MATERIALIZED VIEW IF NOT EXISTS redpanda.events_to_url_mv ON CLUSTER '{cluster}' TO redpanda.events_url
AS SELECT
    timestamp,
    id,
    value
FROM redpanda.events_local
WHERE (value % 2) = 0
;
