up:
	docker compose up -d

down:
	docker compose down

client:
	docker exec -it clickhouse-01-01 clickhouse client
