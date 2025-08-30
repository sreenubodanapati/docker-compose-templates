# Jaeger Docker Compose

Distributed tracing platform with multiple deployment options:

## Deployment Options

### 1. All-in-One (Default)
Memory storage, perfect for development:
```bash
docker-compose up -d
```

### 2. With Elasticsearch Backend
For production with persistent storage:
```bash
docker-compose --profile elasticsearch up -d
```

### 3. With Demo Application
Includes HotROD demo app for testing:
```bash
docker-compose --profile demo up -d
```

## Access
- Jaeger UI: http://localhost:16686
- Jaeger with Elasticsearch: http://localhost:16687
- HotROD Demo: http://localhost:8080 (demo profile)

## Configuration

### Environment Variables
- `JAEGER_STORAGE_TYPE`: Storage backend (memory/elasticsearch)
- `JAEGER_MEMORY_MAX_TRACES`: Max traces in memory (default: 50000)

### Ports
- **16686**: Jaeger UI
- **14268**: HTTP collector
- **14250**: gRPC collector  
- **6831/UDP**: Jaeger thrift compact
- **6832/UDP**: Jaeger thrift binary
- **5778**: Config server
- **9411**: Zipkin compatible

## Integration

### Application Integration
For applications to send traces:

**Java:**
```java
JAEGER_ENDPOINT=http://localhost:14268/api/traces
```

**Node.js:**
```javascript
const jaeger = require('jaeger-client');
const config = {
  serviceName: 'my-service',
  sampler: { type: 'const', param: 1 },
  reporter: { endpoint: 'http://localhost:14268/api/traces' }
};
```

**Python:**
```python
from jaeger_client import Config
config = Config(
    config={
        'sampler': {'type': 'const', 'param': 1},
        'local_agent': {'reporting_host': 'localhost', 'reporting_port': 6831}
    },
    service_name='my-service'
)
```

## Storage Backends

### Memory (Development)
- Fast startup
- No persistence
- Limited capacity

### Elasticsearch (Production)
- Persistent storage
- Scalable
- Advanced querying

## Monitoring

Check service health:
```bash
curl http://localhost:16686/api/services
```
