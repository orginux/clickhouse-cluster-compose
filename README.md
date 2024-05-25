# ClickHouse Cluster with ClickHouse Keeper

This repository provides a simple example of how to deploy a ClickHouse cluster with ClickHouse Keeper using Docker Compose. The cluster consists of two shards and two replicas.

## Setup

1. Ensure Docker is installed and running on your system.

2. Clone this repository to your local machine.

3. Open a terminal window and navigate to the project directory.

## Usage

### Start the Cluster

To start the cluster, run the following command:

```bash
make up
```

This will start the ClickHouse server and keeper containers.
The containers will be named `clickhouse-<shard-id>-<replica-id>` and `clickhouse-keeper-<id>`.

#### Grafana
Optionally, you can start Grafana by running the following command:

```bash
make up-with-grafana
```
This will start the ClickHouse server, keeper, and Grafana containers. The Grafana will be available at `http://localhost:3000`.


### Access ClickHouse Client

To access the ClickHouse client, you can run the following command:

```bash
make client
```

This will open a bash terminal in the container for the first ClickHouse server (`clickhouse-01-01`), allowing you to execute SQL queries against the cluster.

### Stop the Cluster

To stop the cluster, run the following command:

```bash
make down
```
