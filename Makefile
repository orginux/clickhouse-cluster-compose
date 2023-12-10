up:
	docker compose up -d

down:
	docker compose down

client:
	docker exec -it clickhouse-01-01 clickhouse client

version:
	@docker exec clickhouse-01-01 clickhouse client --query "SELECT version()"

test-zookeeper:
	@docker exec clickhouse-01-01 clickhouse client --query "SELECT * FROM system.zookeeper WHERE path = '/'"
