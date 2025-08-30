# Memcached Docker Compose

High-performance, distributed memory caching system.

## Quick Start

```bash
docker-compose up -d
```

## Access
- Memcached: localhost:11211
- Demo app: http://localhost:8080 (demo profile)
- Metrics: http://localhost:9150/metrics (monitoring profile)

## Deployment Options

### Basic Memcached
```bash
docker-compose up -d
```

### With Monitoring
```bash
docker-compose --profile monitoring up -d
```

### With Demo App
```bash
docker-compose --profile demo up -d
```

### With PHP Support
```bash
docker-compose --profile php up -d
```

### With Redis Alternative
```bash
docker-compose --profile redis up -d
```

## Configuration

### Environment Variables
- `MEMCACHED_MEMORY`: Memory allocation in MB (default: 64)
- `MEMCACHED_MAX_CONNECTIONS`: Max connections (default: 1024)

### Memory Tuning
Adjust memory allocation based on your needs:
```bash
export MEMCACHED_MEMORY=512
docker-compose up -d
```

## Usage Examples

### PHP
```php
<?php
$memcached = new Memcached();
$memcached->addServer('localhost', 11211);

// Set value with 1 hour expiration
$memcached->set('user:123', $userData, 3600);

// Get value
$userData = $memcached->get('user:123');

// Delete value
$memcached->delete('user:123');
?>
```

### Python
```python
import memcache

# Connect to Memcached
mc = memcache.Client(['localhost:11211'], debug=0)

# Set value
mc.set('key', 'value', time=3600)

# Get value
value = mc.get('key')

# Delete value
mc.delete('key')
```

### Node.js
```javascript
const memjs = require('memjs');
const client = memjs.Client.create('localhost:11211');

// Set value
client.set('key', 'value', {expires: 3600}, (err, val) => {
    // Handle response
});

// Get value
client.get('key', (err, val) => {
    console.log(val.toString());
});
```

### Java
```java
import net.spy.memcached.MemcachedClient;
import java.net.InetSocketAddress;

MemcachedClient client = new MemcachedClient(
    new InetSocketAddress("localhost", 11211)
);

// Set value
client.set("key", 3600, "value");

// Get value
Object value = client.get("key");
```

## Performance Tuning

### Connection Pooling
Use connection pooling for high-traffic applications:
```php
$memcached = new Memcached('pool');
$memcached->setOption(Memcached::OPT_LIBKETAMA_COMPATIBLE, true);
```

### Consistent Hashing
For multiple Memcached instances:
```python
mc = memcache.Client([
    'memcached-1:11211',
    'memcached-2:11211',
    'memcached-3:11211'
])
```

## Monitoring

### Stats Command
```bash
echo "stats" | nc localhost 11211
```

### Common Stats
- `curr_items`: Current stored items
- `bytes`: Current bytes used
- `cmd_get`: GET commands issued
- `cmd_set`: SET commands issued
- `get_hits`: GET hits
- `get_misses`: GET misses

### Prometheus Monitoring
With monitoring profile enabled:
- Metrics endpoint: http://localhost:9150/metrics
- Grafana dashboard available

## Scaling

### Horizontal Scaling
Add multiple Memcached instances:
```yaml
memcached-1:
  image: memcached:1.6-alpine
  ports:
    - "11211:11211"

memcached-2:
  image: memcached:1.6-alpine
  ports:
    - "11212:11211"
```

### Client-Side Sharding
Configure consistent hashing in your application.

## Security

### Network Security
- Use private networks
- Implement firewall rules
- Consider VPN for remote access

### Authentication
Memcached doesn't have built-in authentication:
- Use SASL for enterprise versions
- Implement application-level security
- Use reverse proxy with auth

## Comparison with Redis

| Feature | Memcached | Redis |
|---------|-----------|--------|
| Data Types | Strings only | Rich data types |
| Persistence | None | Optional |
| Replication | None | Built-in |
| Clustering | Client-side | Built-in |
| Memory Usage | Lower overhead | Higher overhead |
| Performance | Faster for simple ops | More features |

## Troubleshooting

- Check connection: `telnet localhost 11211`
- Monitor stats: `echo "stats" | nc localhost 11211`
- Check logs: `docker-compose logs memcached`
- Memory issues: Increase MEMCACHED_MEMORY
- Connection issues: Check network configuration
