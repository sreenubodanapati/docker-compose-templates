# Grafana Docker Compose

This setup includes:
- **Grafana** for dashboards and visualization
- **PostgreSQL** as backend database

## Quick Start

1. Update secrets:
   ```bash
   echo "your_admin_password" > secrets/grafana_admin_password.txt
   echo "your_postgres_password" > secrets/postgres_password.txt
   ```

2. Start services:
   ```bash
   docker-compose up -d
   ```

## Access
- Grafana UI: http://localhost:3000
- Default login: admin / (password from secrets file)

## Configuration

### Environment Variables
- `GRAFANA_ADMIN_USER`: Admin username (default: admin)
- `GRAFANA_ALLOW_SIGNUP`: Allow user registration (default: false)
- `GRAFANA_SMTP_*`: SMTP configuration for alerts
- `POSTGRES_DB`: Database name (default: grafana)
- `POSTGRES_USER`: Database user (default: grafana)

### Volumes
- `grafana_data`: Persistent storage for Grafana data
- `postgres_data`: PostgreSQL data storage
- `./config/grafana.ini`: Grafana configuration
- `./provisioning/`: Auto-provisioning config

## Data Sources

Pre-configured data sources:
- Prometheus (http://prometheus:9090)
- Loki (http://loki:3100)

## Custom Dashboards

Place dashboard JSON files in `./dashboards/` directory for auto-import.

## Production Considerations

- Enable HTTPS
- Configure SMTP for alerts
- Set up authentication providers (LDAP, OAuth)
- Configure data source permissions
- Set up regular backups
