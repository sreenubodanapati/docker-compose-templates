# ELK Stack Docker Compose

Complete ELK Stack with:
- **Elasticsearch** for search and analytics
- **Logstash** for log processing
- **Kibana** for visualization
- **Filebeat** for log shipping

## Quick Start

1. Update secrets:
   ```bash
   echo "your_elastic_password" > secrets/elastic_password.txt
   ```

2. Start services:
   ```bash
   docker-compose up -d
   ```

3. Wait for Elasticsearch to be ready (check logs):
   ```bash
   docker-compose logs -f elasticsearch
   ```

## Access
- Elasticsearch: http://localhost:9200
- Kibana: http://localhost:5601
- Logstash: http://localhost:9600
- Default login: elastic / (password from secrets file)

## Configuration

### Environment Variables
- `KIBANA_ENCRYPTION_KEY`: 32-character key for saved objects encryption

### System Requirements
- At least 4GB RAM recommended
- Increase vm.max_map_count for production:
  ```bash
  sysctl -w vm.max_map_count=262144
  ```

## Data Collection

### Filebeat Configuration
Collects logs from:
- Docker containers
- System logs

### Custom Log Processing
Edit `pipeline/logstash.conf` to add custom processing rules.

## Production Setup

1. **Security**:
   - Enable SSL/TLS
   - Configure authentication
   - Set up role-based access

2. **Performance**:
   - Increase heap sizes
   - Configure index templates
   - Set up index lifecycle policies

3. **Monitoring**:
   - Enable X-Pack monitoring
   - Set up alerting rules
   - Configure watcher

## Troubleshooting

- Check service health: `docker-compose ps`
- View logs: `docker-compose logs [service]`
- Test Elasticsearch: `curl -u elastic:password http://localhost:9200/_cluster/health`
