# Elasticsearch Docker Compose Setup

This directory contains a complete Elasticsearch stack with Docker Compose, including Elasticsearch, Kibana, and Logstash (ELK Stack).

## Features

- **Elasticsearch 8.11.0**: Search and analytics engine
- **Kibana 8.11.0**: Data visualization and management
- **Logstash 8.11.0**: Data processing pipeline
- **Security**: X-Pack security enabled with authentication
- **Persistence**: Data persists in Docker volumes
- **Health Checks**: Built-in health monitoring for all services

## Quick Start

1. **Start the services:**
   ```bash
   docker-compose up -d
   ```

2. **Access the services:**
   - Elasticsearch API: `http://localhost:9200`
   - Kibana UI: `http://localhost:5601`
   - Logstash: Port 5044 (Beats), 5000 (TCP), 8080 (HTTP)

3. **Default credentials:**
   - Username: `elastic`
   - Password: `ElasticSearchSecure123!`

4. **Stop the services:**
   ```bash
   docker-compose down
   ```

## Configuration

### Environment Variables

The setup uses the following key configurations:
- Single-node discovery mode
- Security enabled with password authentication
- SSL disabled for development
- Memory settings: 2GB heap size

### Default Credentials

- **Username**: elastic
- **Password**: ElasticSearchSecure123!

⚠️ **Security Note**: Change the default password in `secrets/elastic_password.txt` before production use!

## File Structure

```
elasticsearch/
├── docker-compose.yml           # Main compose file
├── README.md                   # This file
├── config/
│   ├── elasticsearch.yml      # Elasticsearch configuration
│   ├── logstash.conf          # Logstash pipeline configuration
│   └── logstash.yml           # Logstash settings
└── secrets/
    └── elastic_password.txt    # Elasticsearch password
```

## Services

### Elasticsearch
- **Ports**: 9200 (HTTP), 9300 (Transport)
- **Memory**: 2GB heap size
- **Features**: Full-text search, analytics, clustering

### Kibana
- **Port**: 5601
- **Features**: Data visualization, index management, dev tools

### Logstash
- **Ports**: 5044 (Beats), 5000 (TCP), 8080 (HTTP), 9600 (API)
- **Features**: Data ingestion, transformation, and forwarding

## Volumes

- `elasticsearch_data`: Elasticsearch data and indices
- `kibana_data`: Kibana configurations and visualizations

## Networking

- Network: `elasticsearch_network` (bridge driver)
- All services communicate internally through the network

## Health Checks

Both Elasticsearch and Kibana include health checks to ensure services are ready before dependent services start.

## Usage Examples

### 1. Index a Document
```bash
curl -X PUT "localhost:9200/my-index/_doc/1" \
  -H "Content-Type: application/json" \
  -u elastic:ElasticSearchSecure123! \
  -d '{"message": "Hello, Elasticsearch!"}'
```

### 2. Search Documents
```bash
curl -X GET "localhost:9200/my-index/_search" \
  -u elastic:ElasticSearchSecure123!
```

### 3. Send Log to Logstash (TCP)
```bash
echo '{"message":"Hello Logstash","timestamp":"2024-01-01T10:00:00Z"}' | nc localhost 5000
```

## Production Considerations

1. **Security**:
   - Change default passwords
   - Enable SSL/TLS encryption
   - Configure proper authentication and authorization

2. **Performance**:
   - Adjust heap sizes based on available memory
   - Configure appropriate cluster settings
   - Set up index templates and lifecycle policies

3. **High Availability**:
   - Set up multi-node cluster
   - Configure proper discovery settings
   - Implement backup strategies

4. **Monitoring**:
   - Use X-Pack monitoring features
   - Set up alerts and notifications
   - Monitor resource usage and performance metrics

## Troubleshooting

- **Memory Issues**: Increase Docker memory allocation or adjust heap sizes
- **Connection Issues**: Check network configuration and firewall settings
- **Performance Issues**: Monitor resource usage and adjust configurations
- **Authentication Issues**: Verify credentials and X-Pack security settings
