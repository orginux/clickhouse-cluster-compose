# RedPanda Connect Configuration

Bidirectional data pipeline between RedPanda Connect and ClickHouse.

## Pipeline Flow

```
┌─────────────────────────────────────────────────────────┐
│                   RedPanda Connect                       │
│                                                          │
│  Generate (50ms)                                        │
│      │                                                   │
│      v                                                   │
│  Insert → ClickHouse (redpanda.events_local)           │
│             │                                            │
│             └─> Materialized View (filter: value % 2)   │
│                       │                                  │
│                       v                                  │
│  HTTP Server ← URL Table (even values only)            │
│  :4195/events                                           │
│      │                                                   │
│      v                                                   │
│  Stdout (print)                                         │
└─────────────────────────────────────────────────────────┘
```

## Configuration

- **Inputs**: Generator + HTTP Server (broker pattern)
- **Outputs**: SQL Insert + Stdout (switch routing)
- **Key Setting**: `http.enabled: false` (avoid port conflict)
- **Batching**: 1000 events or 1s (whichever first)
