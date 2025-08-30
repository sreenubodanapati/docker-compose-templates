# Caddy Docker Compose

Modern web server with automatic HTTPS and HTTP/3 support.

## Quick Start

1. Create external network:
   ```bash
   docker network create web
   ```

2. Start Caddy:
   ```bash
   docker-compose up -d
   ```

3. With demo services:
   ```bash
   docker-compose --profile demo up -d
   ```

## Access
- Main site: http://localhost
- API endpoint: http://api.localhost  
- App with auth: http://app.localhost
- Admin interface: http://admin.localhost
- Health check: http://health.localhost/health

## Configuration

### Environment Variables
- `ACME_EMAIL`: Email for Let's Encrypt certificates
- `CADDY_ADMIN`: Admin API address (default: 0.0.0.0:2019)

### Automatic HTTPS
Caddy automatically obtains and renews certificates:
- Let's Encrypt for public domains
- Self-signed for localhost/internal

### Caddyfile Examples

**Simple reverse proxy:**
```
myapp.example.com {
    reverse_proxy backend:8080
}
```

**Static files with API:**
```
example.com {
    root * /srv
    file_server
    
    handle /api/* {
        reverse_proxy api-backend:3000
    }
}
```

**Load balancing:**
```
app.example.com {
    reverse_proxy backend1:8080 backend2:8080 backend3:8080 {
        lb_policy round_robin
        health_uri /health
        health_interval 30s
    }
}
```

## Features

### Security
- Automatic security headers
- Rate limiting
- IP restrictions
- Basic authentication
- JWT validation

### Performance
- HTTP/3 support
- Gzip compression
- Static file caching
- Connection pooling

### Monitoring
- Admin API: http://localhost:2019/
- Metrics endpoint: http://localhost:2019/metrics
- Access logs in JSON format

## Production Setup

1. **Domain Configuration**:
   ```
   yourdomain.com {
       reverse_proxy your-app:8080
   }
   ```

2. **SSL Configuration**:
   - Automatic with Let's Encrypt
   - Custom certificates supported
   - OCSP stapling enabled

3. **Performance Tuning**:
   - Configure worker processes
   - Set connection limits
   - Enable compression

## Admin API

Manage Caddy via REST API:
```bash
# Get config
curl http://localhost:2019/config/

# Load new config
curl -X POST http://localhost:2019/load \
  -H "Content-Type: application/json" \
  -d @new-config.json
```
