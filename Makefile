up:
	docker compose up -d

down:
	docker compose down

client:
	docker exec -it clickhouse-01-01 clickhouse client

wait-for-clickhouse:
	@docker exec clickhouse-02-02 bash -c "until wget --no-verbose --tries=1 --spider localhost:8123/ping; do sleep 5; done"

version:
	@docker exec clickhouse-01-01 clickhouse client --query "SELECT version()"

test-zookeeper:
	@docker exec clickhouse-01-01 clickhouse client --query "SELECT * FROM system.zookeeper WHERE path = '/'"
