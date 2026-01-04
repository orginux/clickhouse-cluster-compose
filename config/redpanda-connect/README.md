# RedPanda Connect Configuration

Two-service pipeline for data streaming between RedPanda Connect and ClickHouse.

## Configuration Files

- **producer.yaml** - Generates data and inserts to ClickHouse
- **consumer.yaml** - Receives HTTP callbacks and prints to stdout
- **all-in-one-config.example.yaml** - Example bidirectional config (not used)

## Pipeline Flow

```
┌──────────────────────┐      ┌────────────────────────────┐
│  Producer Service    │      │    ClickHouse Cluster      │
│  (producer.yaml)     │      │                            │
│                      │      │  ┌──────────────────────┐  │
│  Generate (50ms)     │      │  │ events_local         │  │
│      │               │      │  │ (ReplicatedMergeTree)│  │
│      v               │      │  └──────────┬───────────┘  │
│  SQL Insert ─────────┼─────>│             │              │
│  Batch: 1000/1s      │      │             v              │
└──────────────────────┘      │  ┌──────────────────────┐  │
                              │  │ events_to_url_mv     │  │
                              │  │ (filter: value = 42) │  │
┌──────────────────────┐      │  └──────────┬───────────┘  │
│  Consumer Service    │      │             │              │
│  (consumer.yaml)     │      │             v              │
│                      │      │  ┌──────────────────────┐  │
│  HTTP Server         │<─────┼──│ events_url           │  │
│  :4195/events        │      │  │ (URL table)          │  │
│      │               │      │  └──────────────────────┘  │
│      v               │      └────────────────────────────┘
│  Stdout (print)      │
└──────────────────────┘
```

## Data Flow

1. **Producer** generates events (timestamp, id, value 1-100)
2. Events inserted to ClickHouse `redpanda.events_local`
3. Materialized view filters events where `value = 42`
4. URL table POSTs filtered events to Consumer HTTP endpoint
5. **Consumer** formats and prints to stdout

### Producer (producer.yaml)
- **Input**: Generate random events every 50ms
- **Output**: SQL insert to ClickHouse
- **Batching**: 1000 events or 1 second
- **Target**: `redpanda.events_local` table

### Consumer (consumer.yaml)
- **Input**: HTTP server on port 4195
- **Processing**: Unarchive batched JSON from ClickHouse
- **Output**: Formatted stdout messages
- **Key**: `http.enabled: false` (avoids port conflict)
