DBZURI=127.0.0.1:8083
INFLUX_SINK_URI=127.0.0.1:8084
SCHEMA_REGISTRY_URI=http://schema-registry:8081
TOPIC_TRANSACTIONS=postgres.public.transactions
TOPIC_FEES=postgres.public.fees
# BROKER_URI=kafka:9092
BROKER_URI=broker:29092
NETWORK_NAME=postgresql-with-debezium_default
CONNECTOR_NAME=core-ledger-connector

up:
	docker-compose up -d

down:
	docker-compose down -v --remove-orphans

# post-dbz-connector:
# 	curl -i -X POST -H "Accept:application/json" -H "Content-Type:application/json" ${DBZURI}/connectors --data "@debezium.json"

# put-dbz-connector:
# 	curl -i -X PUT -H "Accept:application/json" -H "Content-Type:application/json" ${DBZURI}/connectors/${CONNECTOR_NAME}/config --data "@debezium-update.json"

# post-influx-connector:
# 	curl -i -X POST -H "Accept:application/json" -H "Content-Type:application/json" ${DBZINFLUX_SINK_URIURI}/connectors --data "@influx.json"

# put-influx-connector:
# 	curl -i -X PUT -H "Accept:application/json" -H "Content-Type:application/json" ${INFLUX_SINK_URI}/connectors/${CONNECTOR_NAME}/config --data "@influx-update.json"

consume-transactions:
	docker run --platform linux/x86_64 --tty --network ${NETWORK_NAME} confluentinc/cp-kafkacat kafkacat -b ${BROKER_URI} -C -s key=s -s value=avro -r ${SCHEMA_REGISTRY_URI} -t ${TOPIC_TRANSACTIONS}

consume-fees:
	docker run --platform linux/x86_64 --tty --network ${NETWORK_NAME} confluentinc/cp-kafkacat kafkacat -b ${BROKER_URI} -C -s key=s -s value=avro -r ${SCHEMA_REGISTRY_URI} -t ${TOPIC_FEES}

		