# Traefik Docker Compose

Modern reverse proxy with automatic service discovery and Let's Encrypt integration.

## Quick Start

1. Create external network:
   ```bash
   docker network create web
   ```

2. Start Traefik:
   ```bash
   docker-compose up -d
   ```

3. Start with demo app:
   ```bash
   docker-compose --profile demo up -d
   ```

## Access
- Traefik Dashboard: http://localhost:8080
- Demo app: http://whoami.localhost (with demo profile)

## Configuration

### Environment Variables
- `TRAEFIK_LOG_LEVEL`: Log level (DEBUG, INFO, WARN, ERROR)
- `TRAEFIK_DASHBOARD_USERS`: Basic auth users for dashboard
- `TRAEFIK_DOMAIN`: Primary domain for certificates

### Auto-Discovery
Traefik automatically discovers services with proper labels:

```yaml
services:
  my-app:
    image: nginx:alpine
    labels:
      - "traefik.enable=true"
      - "traefik.http.routers.myapp.rule=Host(`myapp.localhost`)"
      - "traefik.http.routers.myapp.entrypoints=websecure"
      - "traefik.http.routers.myapp.tls.certresolver=letsencrypt"
      - "traefik.http.services.myapp.loadbalancer.server.port=80"
    networks:
      - web
```

## Let's Encrypt Setup

1. Update email in `config/traefik.yml`
2. Set your domain:
   ```bash
   export TRAEFIK_DOMAIN=yourdomain.com
   ```
3. For DNS challenge (Cloudflare):
   ```bash
   export CLOUDFLARE_EMAIL=your@email.com
   export CLOUDFLARE_API_KEY=your_api_key
   ```

## Middlewares

Pre-configured middlewares in `config/dynamic/middlewares.yml`:
- Basic authentication
- Security headers
- Rate limiting
- IP whitelisting

## Load Balancing

Traefik automatically load balances between multiple instances:
```yaml
deploy:
  replicas: 3
```

## Monitoring

- Prometheus metrics: http://localhost:8080/metrics
- Access logs in `/var/log/access.log`
- Health check: http://localhost:8080/ping

## Production Setup

1. **Security**: 
   - Enable dashboard authentication
   - Use secure headers middleware
   - Configure IP whitelisting

2. **SSL**:
   - Configure DNS challenge for wildcard certs
   - Use production ACME server
   - Set up certificate storage

3. **Monitoring**:
   - Enable access logs
   - Configure Prometheus metrics
   - Set up alerting
