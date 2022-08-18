DBZURI=127.0.0.1:8083
SCHEMA_REGISTRY_URI=http://schema-registry:8081
TOPIC_TRANSACTIONS=postgres.public.transactions
TOPIC_FEES=postgres.public.fees
BROKER_URI=kafka:9092
NETWORK_NAME=postgresql-with-debezium_default
CONNECTOR_NAME=core-ledger-connector

up:
	docker-compose up -d

down:
	docker-compose down -v --remove-orphans

post-dbz-connector:
	curl -i -X POST -H "Accept:application/json" -H "Content-Type:application/json" ${DBZURI}/connectors --data "@debezium.json"

put-dbz-connector:
	curl -i -X PUT -H "Accept:application/json" -H "Content-Type:application/json" ${DBZURI}/connectors/${CONNECTOR_NAME} --data "@debezium.json"

consume-transactions:
	docker run --platform linux/x86_64 --tty --network ${NETWORK_NAME} confluentinc/cp-kafkacat kafkacat -b ${BROKER_URI} -C -s key=s -s value=avro -r ${SCHEMA_REGISTRY_URI} -t ${TOPIC_TRANSACTIONS}

consume-fees:
	docker run --platform linux/x86_64 --tty --network ${NETWORK_NAME} confluentinc/cp-kafkacat kafkacat -b ${BROKER_URI} -C -s key=s -s value=avro -r ${SCHEMA_REGISTRY_URI} -t ${TOPIC_FEES}

	