# Kong API Gateway Docker Compose

Enterprise-grade API Gateway with:
- **Kong Gateway** for API management
- **PostgreSQL** database backend
- **Konga** web-based admin GUI

## Quick Start

1. Update secrets:
   ```bash
   echo "your_postgres_password" > secrets/kong_postgres_password.txt
   ```

2. Start services:
   ```bash
   docker-compose up -d
   ```

3. Access Kong Manager:
   - Manager UI: http://localhost:8002
   - Admin API: http://localhost:8001
   - Konga UI: http://localhost:1337

## Ports

- **8000**: Proxy HTTP
- **8443**: Proxy HTTPS
- **8001**: Admin API HTTP
- **8444**: Admin API HTTPS
- **8002**: Manager UI HTTP
- **8445**: Manager UI HTTPS
- **8003**: Dev Portal HTTP
- **8446**: Dev Portal HTTPS
- **1337**: Konga Admin UI

## Configuration

### Environment Variables
- `KONG_PG_USER`: PostgreSQL user (default: kong)
- `KONG_PG_DATABASE`: PostgreSQL database (default: kong)
- `KONGA_PG_DATABASE`: Konga database (default: konga)
- `KONGA_ENV`: Environment (production/development)

## API Management

### Add a Service
```bash
curl -i -X POST http://localhost:8001/services/ \
  --data "name=my-service" \
  --data "url=http://my-backend-service"
```

### Add a Route
```bash
curl -i -X POST http://localhost:8001/services/my-service/routes \
  --data "hosts[]=my-service.localhost"
```

### Enable Authentication
```bash
curl -i -X POST http://localhost:8001/services/my-service/plugins/ \
  --data "name=key-auth"
```

## Plugins

Kong comes with many plugins:
- Authentication (JWT, OAuth, Key Auth)
- Security (Rate Limiting, IP Restriction)
- Traffic Control (Load Balancing, Circuit Breaker)
- Analytics & Monitoring
- Transformations

## Monitoring

### Health Check
```bash
curl http://localhost:8001/status
```

### Metrics
Kong provides metrics at:
- Prometheus: Enable prometheus plugin
- StatsD: Built-in support

## Production Considerations

- Use Kong Enterprise for advanced features
- Configure SSL certificates
- Set up database clustering
- Enable logging and monitoring
- Configure rate limiting and security plugins
- Use declarative configuration for GitOps
