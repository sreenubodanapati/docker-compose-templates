# ActiveMQ Docker Compose Setup

This directory contains production-ready ActiveMQ setups with Docker Compose, supporting both **ActiveMQ Artemis** (next-generation) and **ActiveMQ Classic**.

## Features

- **ActiveMQ Artemis 2.33.0** (default) - High-performance, next-generation messaging
- **ActiveMQ Classic 5.18.3** (optional) - Traditional ActiveMQ for legacy compatibility
- **Multiple protocols**: AMQP, STOMP, MQTT, OpenWire, HornetQ
- **Web management console** with monitoring
- **Volume persistence** for data and logs
- **Health checks** and monitoring
- **Security** with secrets management
- **Resource limits** and performance tuning

## Quick Start

### Start ActiveMQ Artemis (Default)
```bash
# Start Artemis
docker-compose up -d

# View logs
docker-compose logs -f activemq

# Stop services
docker-compose down
```

### Start ActiveMQ Classic (Optional)
```bash
# Start Classic version
docker-compose --profile classic up -d

# Start both versions
docker-compose --profile classic up -d activemq activemq-classic
```

## Access Points

### ActiveMQ Artemis
- **ARTEMIS Port**: 61616
- **AMQP Port**: 5672
- **STOMP Port**: 61613
- **MQTT Port**: 1883
- **Web Console**: http://localhost:8161/console

### ActiveMQ Classic
- **OpenWire Port**: 61617
- **AMQP Port**: 5673
- **STOMP Port**: 61614
- **MQTT Port**: 1884
- **Web Console**: http://localhost:8162/admin

## Default Credentials

- **Username**: admin
- **Password**: activeMQSecure123!

## Supported Protocols

### ActiveMQ Artemis
- **CORE**: Native Artemis protocol (fastest)
- **AMQP 1.0**: Advanced Message Queuing Protocol
- **STOMP**: Simple Text Oriented Messaging Protocol
- **MQTT**: IoT/lightweight messaging
- **OpenWire**: ActiveMQ native protocol
- **HornetQ**: Legacy JBoss messaging

### ActiveMQ Classic
- **OpenWire**: Native ActiveMQ protocol
- **AMQP**: Message queuing protocol
- **STOMP**: Text-based protocol
- **MQTT**: IoT messaging
- **JMS**: Java Message Service

## Configuration Files

### Artemis
- `config/broker.xml`: Main broker configuration
- `config/bootstrap.xml`: Bootstrap and web console settings
- `config/artemis.profile`: JVM and runtime settings
- `config/jolokia-access.xml`: JMX access configuration

### Security
- `secrets/`: Contains sensitive credentials

## Pre-configured Resources

### Addresses and Queues
- `jms.queue.DLQ`: Dead Letter Queue
- `jms.queue.ExpiryQueue`: Expired messages
- `jms.topic.notifications`: Topic for notifications
- `jms.queue.orders`: Durable queue for orders

### Security Roles
- `admin`: Full administrative access
- `user`: Standard messaging operations

## Performance Features

### Artemis Optimizations
- **Async I/O**: High-performance journal
- **G1 Garbage Collector**: Optimized for low latency
- **String Deduplication**: Memory optimization
- **Page Management**: Efficient memory usage
- **Critical Analyzer**: Deadlock detection

### Connection Tuning
- Large TCP buffers for high throughput
- Optimized credit management for AMQP
- Duplicate detection enabled
- Advisory message suppression

## Monitoring and Metrics

- **JVM Metrics**: Memory, GC, threads
- **Broker Metrics**: Queue depths, message rates
- **Connection Metrics**: Active connections, throughput
- **Jolokia JMX**: Remote monitoring support

## Health Monitoring

Both containers include health checks that verify:
- Web console accessibility
- Broker service availability
- Protocol endpoint connectivity

## Volume Management

### Artemis
- `activemq_data`: Message data and journals
- `activemq_logs`: Application logs

### Classic
- `activemq_classic_data`: Message store
- `activemq_classic_logs`: Application logs

## Resource Limits

### Artemis
- **Memory**: 2.5GB limit
- **CPU**: 1.0 cores limit
- **JVM Heap**: 512M-2G

### Classic
- **Memory**: 1.5GB limit
- **CPU**: 0.8 cores limit

## Use Cases

### ActiveMQ Artemis (Recommended)
- High-performance applications
- Modern microservices
- IoT and real-time messaging
- Multi-protocol requirements

### ActiveMQ Classic
- Legacy application compatibility
- Existing OpenWire integrations
- Traditional enterprise messaging

## Customization

To customize the setup:

1. **Modify broker config**: Edit `config/broker.xml`
2. **Update JVM settings**: Modify `config/artemis.profile`
3. **Change credentials**: Update files in `secrets/`
4. **Add queues/topics**: Update address configuration
5. **Adjust resources**: Modify limits in docker-compose.yml

## Client Connection Examples

### Java (Artemis Core)
```java
ConnectionFactory cf = new ActiveMQConnectionFactory("tcp://localhost:61616");
```

### Java (AMQP)
```java
ConnectionFactory cf = new JmsConnectionFactory("amqp://localhost:5672");
```

### Python (STOMP)
```python
import stomp
conn = stomp.Connection([('localhost', 61613)])
```

## Troubleshooting

```bash
# Check container status
docker-compose ps

# View detailed logs
docker-compose logs activemq

# Execute commands in container
docker-compose exec activemq /opt/apache-artemis/bin/artemis queue stat

# Check JVM status
docker-compose exec activemq jps -l

# Reset data (WARNING: deletes all data)
docker-compose down -v
```

## Production Considerations

- Change default passwords before deployment
- Configure SSL/TLS for secure communication
- Set up clustering for high availability
- Implement proper backup strategies for persistence
- Configure external monitoring and alerting
- Use external secrets management
- Tune JVM settings based on workload
- Configure appropriate disk space monitoring
