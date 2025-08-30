# Prometheus Docker Compose

This setup includes:
- **Prometheus** server for metrics collection
- **Node Exporter** for host metrics
- **cAdvisor** for container metrics

## Quick Start

```bash
docker-compose up -d
```

## Access
- Prometheus UI: http://localhost:9090
- Node Exporter metrics: http://localhost:9100/metrics
- cAdvisor UI: http://localhost:8080

## Configuration

### Environment Variables
- `PROMETHEUS_RETENTION_TIME`: Data retention period (default: 15d)

### Volumes
- `prometheus_data`: Persistent storage for metrics data
- `./config/prometheus.yml`: Prometheus configuration
- `./rules/`: Alert rules directory

## Adding New Targets

Edit `config/prometheus.yml` to add new scrape targets:

```yaml
scrape_configs:
  - job_name: 'my-app'
    static_configs:
      - targets: ['my-app:8080']
```

## Security Considerations

- Enable authentication for production use
- Use HTTPS for external access
- Restrict network access with firewalls
- Regularly update images

## Monitoring

Health checks are configured for all services. Check status with:
```bash
docker-compose ps
```
