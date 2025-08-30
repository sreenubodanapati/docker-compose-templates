# NATS Docker Compose Setup

This directory contains a production-ready NATS setup with Docker Compose, featuring high-performance messaging and streaming capabilities.

## Features

- **NATS 2.10** - Latest high-performance messaging server
- **JetStream** - Built-in persistence and streaming
- **Multiple accounts** and user authentication
- **HTTP monitoring** with metrics
- **NATS Box** - CLI tools for testing and management
- **NATS Surveyor** - Advanced monitoring dashboard
- **Volume persistence** for JetStream data
- **Health checks** and container monitoring
- **Resource limits** and performance optimization

## Quick Start

### Basic NATS Server
```bash
# Start NATS server
docker-compose up -d nats

# View logs
docker-compose logs -f nats

# Stop services
docker-compose down
```

### With Management Tools
```bash
# Start with NATS Box (CLI tools)
docker-compose --profile tools up -d

# Start with Surveyor (monitoring dashboard)
docker-compose --profile monitoring up -d

# Start everything
docker-compose --profile tools --profile monitoring up -d
```

## Access Points

- **NATS Port**: 4222
- **HTTP Monitoring**: http://localhost:8222
- **NATS Surveyor**: http://localhost:7777 (with monitoring profile)
- **Cluster Port**: 6222 (for multi-node setups)

## Default Credentials

### System Account
- **Username**: sys_user
- **Password**: sysSecure123!

### Application Account
- **Username**: app_user / admin
- **Password**: appSecure123! / adminSecure123!

## NATS Features

### Core Messaging
- **Publish/Subscribe**: Traditional pub/sub patterns
- **Request/Reply**: Synchronous communication
- **Queue Groups**: Load balancing and work distribution
- **Wildcards**: Flexible subject matching

### JetStream (Streaming)
- **Persistent streams**: Durable message storage
- **Consumers**: Pull and push-based consumption
- **Message deduplication**: Exactly-once delivery
- **Stream replication**: High availability
- **Message retention**: Time and size-based policies

### Security
- **Multi-tenancy**: Account-based isolation
- **Fine-grained permissions**: Subject-level access control
- **JWT authentication**: Token-based security (configurable)
- **TLS encryption**: Secure communication (configurable)

## Configuration Files

- `config/nats.conf`: Main server configuration
- `secrets/auth.conf`: Authentication settings

## NATS CLI Tools (via NATS Box)

```bash
# Access NATS Box
docker-compose exec nats-box sh

# Basic pub/sub testing
nats pub --server nats://nats:4222 "test.subject" "Hello NATS"
nats sub --server nats://nats:4222 "test.subject"

# JetStream operations
nats stream add --server nats://nats:4222 EVENTS
nats consumer add --server nats://nats:4222 EVENTS PROCESSOR

# Server information
nats server info --server nats://nats:4222
nats server report --server nats://nats:4222

# Benchmarking
nats bench --server nats://nats:4222 test.bench --pub 5 --sub 5
```

## JetStream Configuration

### Creating Streams
```bash
# Create a stream for events
nats stream add EVENTS \
  --subjects "events.>" \
  --storage file \
  --retention limits \
  --max-msgs 1000000 \
  --max-bytes 1GB \
  --max-age 24h

# Create a work queue stream
nats stream add WORK_QUEUE \
  --subjects "work.>" \
  --storage file \
  --retention work \
  --max-msgs 100000
```

### Creating Consumers
```bash
# Durable consumer
nats consumer add EVENTS PROCESSOR \
  --filter "events.processed" \
  --ack explicit \
  --max-deliver 3 \
  --delivery work

# Ephemeral consumer
nats consumer add EVENTS --ephemeral \
  --filter "events.alerts" \
  --delivery push
```

## Monitoring

### HTTP Monitoring Endpoints
- `/varz`: Server information and statistics
- `/connz`: Connection information
- `/routez`: Route information
- `/subsz`: Subscription information
- `/leafz`: Leaf node information
- `/gatewayz`: Gateway information
- `/jsz`: JetStream information

### Example Monitoring Commands
```bash
# Server stats
curl http://localhost:8222/varz

# Connection info
curl http://localhost:8222/connz

# JetStream info
curl http://localhost:8222/jsz
```

## Account-Based Security

The setup includes multiple accounts:

### SYS Account
- **Purpose**: System operations and monitoring
- **Access**: Full server management

### APP Account
- **Purpose**: Application messaging
- **Subjects**: `app.>`, `events.>`
- **Users**: `app_user` (limited), `admin` (full access)

## Performance Features

- **Zero-copy message routing**: Minimal CPU overhead
- **Subject-based routing**: Fast message delivery
- **Clustered routing**: Horizontal scalability
- **Memory optimization**: Efficient memory usage
- **Connection multiplexing**: High connection density

## High Availability Setup

For production clustering, uncomment cluster configuration in `nats.conf`:

```bash
# Deploy 3-node cluster
docker-compose up -d nats-1 nats-2 nats-3

# Check cluster status
nats server report clusters
```

## Development vs Production

### Development
```bash
# Simple setup with tools
docker-compose --profile tools up -d
```

### Production
```bash
# Minimal setup
docker-compose up -d nats

# With monitoring
docker-compose --profile monitoring up -d
```

## Volume Management

- `nats_jetstream`: JetStream persistent storage
- Configuration mounted as read-only
- Secrets mounted securely

## Security Configuration

### Enable TLS (Production)
1. Generate certificates
2. Uncomment TLS section in `nats.conf`
3. Mount certificates as volumes
4. Update client connections to use TLS

### JWT Authentication (Advanced)
1. Generate JWT tokens using `nsc` tool
2. Configure JWT resolver in `nats.conf`
3. Distribute tokens to clients

## Client Connection Examples

### Go
```go
nc, _ := nats.Connect("nats://localhost:4222")
defer nc.Close()

// Publish
nc.Publish("test.subject", []byte("Hello NATS"))

// Subscribe
sub, _ := nc.Subscribe("test.subject", func(m *nats.Msg) {
    fmt.Printf("Received: %s\n", string(m.Data))
})
```

### Python
```python
import asyncio
import nats

async def main():
    nc = await nats.connect("nats://localhost:4222")
    
    # Publish
    await nc.publish("test.subject", b"Hello NATS")
    
    # Subscribe
    async def message_handler(msg):
        print(f"Received: {msg.data.decode()}")
    
    await nc.subscribe("test.subject", cb=message_handler)

asyncio.run(main())
```

### JavaScript/Node.js
```javascript
const { connect } = require('nats');

async function main() {
    const nc = await connect({ servers: 'nats://localhost:4222' });
    
    // Subscribe
    const sub = nc.subscribe('test.subject');
    (async () => {
        for await (const m of sub) {
            console.log(`Received: ${new TextDecoder().decode(m.data)}`);
        }
    })();
    
    // Publish
    nc.publish('test.subject', new TextEncoder().encode('Hello NATS'));
}

main();
```

## Troubleshooting

```bash
# Check server status
docker-compose exec nats nats server check

# View server info
docker-compose exec nats nats server info

# Check JetStream status
docker-compose exec nats nats stream list

# Monitor connections
curl http://localhost:8222/connz

# Reset JetStream data (WARNING: deletes all streams)
docker-compose down -v
```

## Production Considerations

- Enable TLS for secure communication
- Use JWT authentication for scalable security
- Configure clustering for high availability
- Set up external monitoring and alerting
- Implement proper backup strategies for JetStream
- Use external secrets management
- Configure resource limits based on workload
- Monitor disk usage for JetStream storage
- Consider leaf nodes for edge connectivity
- Plan subject namespace design carefully
