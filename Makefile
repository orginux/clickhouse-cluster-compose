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

replicas-status:
	@docker exec clickhouse-01-01 wget --no-verbose --tries=1 --spider localhost:8123/replicas_status
