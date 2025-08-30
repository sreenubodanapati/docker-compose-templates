# Varnish Cache Docker Compose

High-performance HTTP caching reverse proxy with:
- **Varnish Cache** for web acceleration
- **Nginx Backend** for serving content
- **Prometheus Exporter** for monitoring

## Quick Start

```bash
docker-compose up -d
```

## Access
- Cached content: http://localhost:80
- Backend direct: http://localhost:8080
- Varnish stats: http://localhost:6082
- Metrics: http://localhost:9131/metrics (monitoring profile)

## Configuration

### Environment Variables
- `VARNISH_SIZE`: Cache memory size (default: 128M)
- `BACKEND_HOST`: Backend server host (default: backend)
- `BACKEND_PORT`: Backend server port (default: 80)

### VCL Configuration
The `config/default.vcl` file contains:
- Backend definitions
- Caching rules
- Purging ACLs
- Custom headers
- Performance optimizations

## Usage

### Cache Testing
```bash
# First request (cache miss)
curl -I http://localhost/

# Second request (cache hit)
curl -I http://localhost/
```

### Cache Purging
```bash
curl -X PURGE http://localhost/path/to/purge
```

### Cache Statistics
```bash
# Via admin interface
echo "stats" | nc localhost 6082

# Via varnishstat
docker-compose exec varnish varnishstat
```

## Performance Features

### Cache Rules
- Static assets: 1 hour TTL
- HTML pages: 5 minutes TTL
- API responses: Custom TTL
- Error pages: No caching

### Optimization
- Gzip compression
- Cookie cleaning
- ESI (Edge Side Includes)
- Load balancing

## Monitoring

### Built-in Stats
- Hit/miss ratios
- Response times
- Memory usage
- Backend health

### Prometheus Integration
Enable monitoring profile for metrics collection.

## Production Considerations

- Configure SSL termination
- Set up health checks
- Implement proper purging strategy
- Monitor cache hit ratios
- Configure multiple backends
- Set appropriate TTL values
