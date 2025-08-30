# Loki Docker Compose

This setup includes:
- **Loki** for log aggregation
- **Promtail** for log collection
- **Grafana** for log visualization

## Quick Start

1. Update secrets:
   ```bash
   echo "your_admin_password" > secrets/grafana_admin_password.txt
   ```

2. Start services:
   ```bash
   docker-compose up -d
   ```

## Access
- Loki API: http://localhost:3100
- Grafana UI: http://localhost:3001
- Default login: admin / (password from secrets file)

## Configuration

### Log Collection
Promtail is configured to collect:
- System logs from `/var/log/`
- Docker container logs

### Storage
- Local filesystem storage
- Data retention: Configure in `loki.yml`

## Usage

### Query Examples
In Grafana, use LogQL to query logs:
```
{job="containerlogs"}
{job="varlogs"} |= "error"
{container_name="nginx"} | json
```

### Custom Log Sources
Edit `config/promtail.yml` to add custom log sources:
```yaml
scrape_configs:
  - job_name: myapp
    static_configs:
      - targets:
          - localhost
        labels:
          job: myapp
          __path__: /path/to/logs/*.log
```

## Production Considerations

- Use object storage (S3, GCS) for scalability
- Configure retention policies
- Set up alerting rules
- Enable authentication
- Use TLS for secure communication
