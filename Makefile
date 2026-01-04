up:
	@docker compose up -d --remove-orphans

up-with-grafana: up wait-for-clickhouse
	@mkdir --mode 777 -p grafana-data
	@docker compose --file docker-compose-grafana.yml up -d
	@echo "----------------------------------------"
	@echo "Grafana is running on http://localhost:3000"
	@echo "Username: admin Password: admin"
	@echo "Add Clickhouse datasource with Server Address: clickhouse-01-01:9000"
	@echo "Username: 'default' with no password"
	@echo "----------------------------------------"

up-with-redpanda-connect: up wait-for-clickhouse
	@docker compose --file docker-compose-redpanda-connect.yml up -d
	@echo "Creating ClickHouse tables from schema/redpanda/events.sql"
	@docker exec -i clickhouse-01-01 clickhouse client < schema/redpanda/events.sql
	@echo "Query example: docker exec clickhouse-01-01 clickhouse client --query 'SELECT count() FROM redpanda.events'"

down:
	@docker compose --file docker-compose-redpanda-connect.yml down
	@docker compose --file docker-compose-grafana.yml down
	@docker compose down

client:
	docker exec -it clickhouse-01-01 clickhouse client --multiquery --multiline

wait-for-clickhouse:
	@docker exec clickhouse-02-02 bash -c "until wget --no-verbose --tries=1 --spider localhost:8123/ping; do sleep 1; done"

version:
	@docker exec clickhouse-01-01 clickhouse client --query "SELECT version()"

test-zookeeper:
	@docker exec clickhouse-01-01 clickhouse client --query "SELECT * FROM system.zookeeper WHERE path = '/'"

clickhouse-err-log:
	@docker exec clickhouse-01-01 tail -n 100 /var/log/clickhouse-server/clickhouse-server.err.log
