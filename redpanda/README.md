# Redpanda Docker Compose Setup

This directory contains a production-ready Redpanda setup with Docker Compose, featuring Kafka-compatible streaming with better performance and simpler operations.

## Features

- **Redpanda 23.3.3** - Kafka-compatible streaming platform
- **Redpanda Console** - Modern web UI for management
- **Schema Registry** - Confluent-compatible schema management
- **REST Proxy (Pandaproxy)** - HTTP API for Kafka operations
- **RPK CLI tools** - Command-line management
- **Volume persistence** for data
- **Health checks** and monitoring
- **Auto-topic creation** and management
- **Developer mode** enabled for easy testing

## Quick Start

### Basic Redpanda Cluster
```bash
# Start Redpanda
docker-compose up -d

# View logs
docker-compose logs -f

# Stop services
docker-compose down
```

### With Management Tools
```bash
# Start with RPK CLI tools
docker-compose --profile tools up -d

# Access RPK tools
docker-compose exec redpanda-rpk bash
```

## Access Points

- **Kafka API**: localhost:19092
- **Schema Registry**: localhost:18081
- **REST Proxy**: localhost:18082
- **Admin API**: localhost:19644
- **Redpanda Console**: http://localhost:8080

## Key Advantages over Kafka

### Performance
- **10x faster** than Apache Kafka
- **Built in C++** for minimal overhead
- **No JVM** - no garbage collection pauses
- **Vectorized processing** for high throughput

### Simplicity
- **No Zookeeper** required
- **Single binary** deployment
- **Self-managing** - automatic leadership election
- **Easy scaling** - add/remove nodes seamlessly

### Compatibility
- **100% Kafka API compatible**
- **Confluent Schema Registry compatible**
- **Kafka Connect compatible**
- **Drop-in replacement** for Kafka

## Configuration Files

- `config/redpanda.yaml`: Main Redpanda configuration
- `config/console-config.yml`: Console web UI configuration

## RPK CLI Operations

```bash
# Access RPK CLI
docker-compose exec redpanda-rpk bash

# Cluster operations
rpk cluster info --brokers redpanda:9092
rpk cluster health --brokers redpanda:9092

# Topic operations
rpk topic list --brokers redpanda:9092
rpk topic create events --partitions 3 --replicas 1 --brokers redpanda:9092
rpk topic describe events --brokers redpanda:9092

# Producer/Consumer testing
rpk topic produce events --brokers redpanda:9092
rpk topic consume events --brokers redpanda:9092

# Schema Registry operations
rpk registry schema list --brokers redpanda:9092
```

## Redpanda Console Features

The web console provides:
- **Topic Management**: Create, configure, and monitor topics
- **Message Browser**: View and search messages
- **Consumer Group Monitoring**: Track lag and performance
- **Schema Registry**: Manage Avro/JSON schemas
- **Cluster Overview**: Health and performance metrics
- **ACL Management**: Security and permissions (when enabled)

## API Endpoints

### Kafka API (Port 19092)
Standard Kafka protocol for producers and consumers

### Schema Registry (Port 18081)
```bash
# List schemas
curl http://localhost:18081/subjects

# Create schema
curl -X POST http://localhost:18081/subjects/events-value/versions \
  -H "Content-Type: application/vnd.schemaregistry.v1+json" \
  -d '{"schema": "{\"type\":\"record\",\"name\":\"Event\",\"fields\":[{\"name\":\"id\",\"type\":\"string\"},{\"name\":\"timestamp\",\"type\":\"long\"}]}"}'
```

### REST Proxy (Port 18082)
```bash
# Produce message
curl -X POST http://localhost:18082/topics/events \
  -H "Content-Type: application/vnd.kafka.json.v2+json" \
  -d '{"records":[{"value":{"id":"123","message":"Hello Redpanda"}}]}'

# Create consumer
curl -X POST http://localhost:18082/consumers/my-group \
  -H "Content-Type: application/vnd.kafka.v2+json" \
  -d '{"name": "my-consumer", "format": "json", "auto.offset.reset": "earliest"}'
```

### Admin API (Port 19644)
```bash
# Cluster status
curl http://localhost:19644/v1/cluster/health_overview

# Broker configuration
curl http://localhost:19644/v1/cluster/config

# Partition info
curl http://localhost:19644/v1/topics
```

## Client Integration

### Java (Kafka Client)
```java
Properties props = new Properties();
props.put("bootstrap.servers", "localhost:19092");
props.put("key.serializer", "org.apache.kafka.common.serialization.StringSerializer");
props.put("value.serializer", "org.apache.kafka.common.serialization.StringSerializer");

KafkaProducer<String, String> producer = new KafkaProducer<>(props);
producer.send(new ProducerRecord<>("events", "key", "Hello Redpanda"));
```

### Python (kafka-python)
```python
from kafka import KafkaProducer, KafkaConsumer

# Producer
producer = KafkaProducer(
    bootstrap_servers=['localhost:19092'],
    value_serializer=lambda x: json.dumps(x).encode('utf-8')
)
producer.send('events', {'message': 'Hello Redpanda'})

# Consumer
consumer = KafkaConsumer(
    'events',
    bootstrap_servers=['localhost:19092'],
    value_deserializer=lambda m: json.loads(m.decode('utf-8'))
)
for message in consumer:
    print(message.value)
```

### Node.js (kafkajs)
```javascript
const { Kafka } = require('kafkajs');

const kafka = Kafka({
  clientId: 'my-app',
  brokers: ['localhost:19092']
});

const producer = kafka.producer();
await producer.send({
  topic: 'events',
  messages: [{ value: 'Hello Redpanda' }]
});

const consumer = kafka.consumer({ groupId: 'my-group' });
await consumer.subscribe({ topic: 'events' });
await consumer.run({
  eachMessage: async ({ message }) => {
    console.log(message.value.toString());
  }
});
```

## Schema Management

### Avro Schema Example
```bash
# Create Avro schema
curl -X POST http://localhost:18081/subjects/user-value/versions \
  -H "Content-Type: application/vnd.schemaregistry.v1+json" \
  -d '{
    "schema": "{\"type\":\"record\",\"name\":\"User\",\"fields\":[{\"name\":\"id\",\"type\":\"string\"},{\"name\":\"name\",\"type\":\"string\"},{\"name\":\"email\",\"type\":\"string\"}]}"
  }'
```

### JSON Schema Example
```bash
# Create JSON schema
curl -X POST http://localhost:18081/subjects/order-value/versions \
  -H "Content-Type: application/vnd.schemaregistry.v1+json" \
  -d '{
    "schemaType": "JSON",
    "schema": "{\"type\":\"object\",\"properties\":{\"orderId\":{\"type\":\"string\"},\"amount\":{\"type\":\"number\"},\"currency\":{\"type\":\"string\"}},\"required\":[\"orderId\",\"amount\"]}"
  }'
```

## Performance Tuning

### Producer Optimization
- **Batching**: Enable batching for higher throughput
- **Compression**: Use snappy or lz4 compression
- **Idempotence**: Enable for exactly-once semantics
- **Acks**: Configure acknowledgment levels

### Consumer Optimization
- **Fetch size**: Optimize fetch.min.bytes and fetch.max.wait.ms
- **Concurrency**: Use multiple consumers in a group
- **Offset management**: Choose appropriate offset reset policy

### Broker Optimization
- **Memory allocation**: Adjust based on workload
- **Log segment size**: Optimize for your message patterns
- **Compression**: Enable broker-side compression
- **Replication**: Balance durability vs performance

## Monitoring

### Built-in Metrics
- **Throughput**: Messages/second, bytes/second
- **Latency**: End-to-end message latency
- **Storage**: Disk usage and log compaction
- **Consumer Lag**: Real-time lag monitoring

### Prometheus Integration
```bash
# Add Prometheus metrics endpoint (requires configuration)
curl http://localhost:19644/public_metrics
```

## Development Workflow

```bash
# 1. Start Redpanda
docker-compose up -d

# 2. Create topics
docker-compose exec redpanda-rpk rpk topic create events orders notifications --brokers redpanda:9092

# 3. Access console
# Open http://localhost:8080 in browser

# 4. Test with CLI
docker-compose exec redpanda-rpk rpk topic produce events --brokers redpanda:9092
docker-compose exec redpanda-rpk rpk topic consume events --brokers redpanda:9092
```

## Volume Management

- `redpanda_data`: Persistent storage for topics and logs
- Configuration files mounted as read-only

## Security (Production Setup)

For production, enable security features:

### SASL Authentication
```yaml
# In redpanda.yaml
kafka_api:
  - address: 0.0.0.0
    port: 9092
    authentication_method: sasl
```

### TLS Encryption
```yaml
# In redpanda.yaml  
kafka_api_tls:
  - address: 0.0.0.0
    port: 9093
    cert_file: /etc/redpanda/certs/cert.pem
    key_file: /etc/redpanda/certs/key.pem
```

### ACLs (Access Control Lists)
```bash
# Enable ACLs
rpk security acl create --allow-principal User:alice --operation read --topic events
```

## Clustering

For multi-node clusters:

1. **Update seed servers** in `redpanda.yaml`
2. **Configure unique node IDs**
3. **Set appropriate replication factors**
4. **Enable inter-node communication**

```yaml
# Example 3-node cluster configuration
seed_servers:
  - host: { address: redpanda-1, port: 33145 }
  - host: { address: redpanda-2, port: 33145 }
  - host: { address: redpanda-3, port: 33145 }
```

## Troubleshooting

```bash
# Check cluster health
docker-compose exec redpanda rpk cluster health

# View broker logs
docker-compose logs redpanda

# Check topic configuration
docker-compose exec redpanda rpk topic describe events

# Monitor consumer groups
docker-compose exec redpanda rpk group list
docker-compose exec redpanda rpk group describe my-group

# Storage information
docker-compose exec redpanda rpk cluster storage

# Reset data (WARNING: deletes all data)
docker-compose down -v
```

## Migration from Kafka

Redpanda is a drop-in replacement for Kafka:

1. **Update connection strings** to point to Redpanda
2. **Remove Zookeeper dependencies**
3. **Update monitoring** to use Redpanda APIs
4. **Leverage simplified operations** (no manual partition rebalancing)

## Production Considerations

- Remove `developer_mode: true` for production
- Enable SASL authentication and TLS encryption
- Configure appropriate retention policies
- Set up monitoring and alerting
- Plan storage capacity for topics
- Configure backup strategies
- Use external secrets management
- Implement proper network security
- Consider multi-region deployment for DR
- Monitor resource usage and scale appropriately
