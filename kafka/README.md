# Kafka Docker Compose Template

This template provides a production-ready Apache Kafka setup with Docker Compose, including Zookeeper and Kafka UI for easy management.

## 🚀 Quick Start

1. **Start the services:**
   ```bash
   docker-compose up -d
   ```

2. **Stop the services:**
   ```bash
   docker-compose down
   ```

## 📋 Configuration

### Environment Variables

Create a `.env` file to customize your Kafka deployment:

```env
# Kafka Configuration
KAFKA_AUTO_CREATE_TOPICS=true
KAFKA_DELETE_TOPIC_ENABLE=true
KAFKA_LOG_RETENTION_HOURS=168

# Kafka UI Configuration
KAFKA_UI_READONLY=false
```

### Volume Mounts

- `zookeeper_data` - Zookeeper data directory (persistent storage)
- `zookeeper_logs` - Zookeeper log directory
- `kafka_data` - Kafka data directory (persistent storage)

## 🔍 Service Details

### Zookeeper
- **Image**: `confluentinc/cp-zookeeper:7.4.0`
- **Port**: `2181:2181`
- **Health Check**: Zookeeper 'ruok' command

### Kafka
- **Image**: `confluentinc/cp-kafka:7.4.0`
- **Ports**: 
  - `9092:9092` (External connections)
  - `9101:9101` (JMX monitoring)
- **Health Check**: Kafka broker API versions check
- **Dependencies**: Healthy Zookeeper service

### Kafka UI
- **Image**: `provectuslabs/kafka-ui:latest`
- **Port**: `8080:8080`
- **Web Interface**: http://localhost:8080
- **Dependencies**: Healthy Kafka service

## 🌐 Accessing the Services

### Kafka Broker
- **External**: `localhost:9092`
- **Internal**: `kafka:29092`

### Kafka UI
- **URL**: http://localhost:8080
- **Features**: Topic management, message browsing, consumer groups monitoring

### Zookeeper
- **Port**: `2181`

## 📊 Kafka Management Commands

### Create Topic
```bash
docker exec kafka kafka-topics --create \
  --topic my-topic \
  --bootstrap-server localhost:9092 \
  --partitions 3 \
  --replication-factor 1
```

### List Topics
```bash
docker exec kafka kafka-topics --list \
  --bootstrap-server localhost:9092
```

### Describe Topic
```bash
docker exec kafka kafka-topics --describe \
  --topic my-topic \
  --bootstrap-server localhost:9092
```

### Delete Topic
```bash
docker exec kafka kafka-topics --delete \
  --topic my-topic \
  --bootstrap-server localhost:9092
```

### Produce Messages
```bash
docker exec -it kafka kafka-console-producer \
  --topic my-topic \
  --bootstrap-server localhost:9092
```

### Consume Messages
```bash
docker exec -it kafka kafka-console-consumer \
  --topic my-topic \
  --bootstrap-server localhost:9092 \
  --from-beginning
```

### List Consumer Groups
```bash
docker exec kafka kafka-consumer-groups \
  --list \
  --bootstrap-server localhost:9092
```

### Describe Consumer Group
```bash
docker exec kafka kafka-consumer-groups \
  --describe \
  --group my-group \
  --bootstrap-server localhost:9092
```

## 🔧 Client Configuration Examples

### Java Producer
```java
Properties props = new Properties();
props.put("bootstrap.servers", "localhost:9092");
props.put("key.serializer", "org.apache.kafka.common.serialization.StringSerializer");
props.put("value.serializer", "org.apache.kafka.common.serialization.StringSerializer");

Producer<String, String> producer = new KafkaProducer<>(props);
```

### Java Consumer
```java
Properties props = new Properties();
props.put("bootstrap.servers", "localhost:9092");
props.put("group.id", "my-group");
props.put("key.deserializer", "org.apache.kafka.common.serialization.StringDeserializer");
props.put("value.deserializer", "org.apache.kafka.common.serialization.StringDeserializer");

Consumer<String, String> consumer = new KafkaConsumer<>(props);
```

### Python Producer (kafka-python)
```python
from kafka import KafkaProducer

producer = KafkaProducer(
    bootstrap_servers=['localhost:9092'],
    value_serializer=lambda x: x.encode('utf-8')
)
```

### Python Consumer (kafka-python)
```python
from kafka import KafkaConsumer

consumer = KafkaConsumer(
    'my-topic',
    bootstrap_servers=['localhost:9092'],
    group_id='my-group',
    value_deserializer=lambda m: m.decode('utf-8')
)
```

### Node.js Producer (kafkajs)
```javascript
const { Kafka } = require('kafkajs');

const kafka = Kafka({
  clientId: 'my-app',
  brokers: ['localhost:9092']
});

const producer = kafka.producer();
```

### Node.js Consumer (kafkajs)
```javascript
const consumer = kafka.consumer({ groupId: 'my-group' });

await consumer.subscribe({ topic: 'my-topic' });
```

## 📊 Monitoring

### JMX Metrics
Kafka exposes JMX metrics on port `9101`. You can connect JMX monitoring tools or integrate with monitoring systems like Prometheus.

### Log Files
```bash
# Kafka logs
docker logs kafka

# Zookeeper logs  
docker logs zookeeper

# Kafka UI logs
docker logs kafka-ui
```

## 🔐 Security Notes

- This setup uses PLAINTEXT protocol for simplicity
- For production, consider:
  - Enabling SSL/TLS
  - Setting up SASL authentication
  - Configuring ACLs (Access Control Lists)
  - Network security and firewall rules

## 🚀 Production Considerations

- Increase replication factor for topics
- Configure proper retention policies
- Set up monitoring and alerting
- Use multiple Kafka brokers for high availability
- Configure appropriate heap sizes
- Enable authentication and authorization
- Use dedicated Zookeeper ensemble
