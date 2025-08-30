# 🐳 Comprehensive Docker Compose Templates

A complete collection of production-ready Docker Compose templates for DevOps, development, and data processing tools.

## 📁 Available Services

### 🔍 DevOps & Observability Tools
| Service | Description | Ports | Status |
|---------|-------------|--------|--------|
| **[Prometheus](./prometheus/)** | Metrics collection & monitoring | 9090, 9100, 8080 | ✅ |
| **[Grafana](./grafana/)** | Dashboards and visualization | 3000 | ✅ |
| **[Loki](./loki/)** | Centralized logging solution | 3100, 3001 | ✅ |
| **[ELK Stack](./elk-stack/)** | Elasticsearch + Logstash + Kibana | 9200, 5601, 5044 | ✅ |
| **[Jaeger](./jaeger/)** | Distributed tracing | 16686, 14268 | ✅ |

### 🌐 API Gateways & Reverse Proxies
| Service | Description | Ports | Status |
|---------|-------------|--------|--------|
| **[Traefik](./traefik/)** | Modern auto-discovering reverse proxy | 80, 443, 8080 | ✅ |
| **[Kong](./kong/)** | API Gateway with management | 8000, 8001, 1337 | ✅ |
| **[Caddy](./caddy/)** | Auto HTTPS reverse proxy | 80, 443, 2019 | ✅ |

### 🛠️ Development & CI/CD Tools
| Service | Description | Ports | Status |
|---------|-------------|--------|--------|
| **[SonarQube](./sonarqube/)** | Code quality & security scanning | 9000 | ✅ |
| **[Jenkins](./jenkins/)** | CI/CD automation server | 8080, 50000 | ✅ |
| **[Portainer](./portainer/)** | Docker container management UI | 9000, 9443 | ✅ |
| **[Keycloak](./keycloak/)** | Identity & access management | 8080, 8443 | ✅ |

### ⚡ Caching & Performance Tools
| Service | Description | Ports | Status |
|---------|-------------|--------|--------|
| **[Memcached](./memcached/)** | High-performance caching layer | 11211 | ✅ |
| **[Varnish](./varnish/)** | Web caching for fast delivery | 80, 6082 | ✅ |

### 🤖 AI/ML & Data Processing
| Service | Description | Ports | Status |
|---------|-------------|--------|--------|
| **[Apache Airflow](./airflow/)** | Workflow orchestration | 8080, 5555 | ✅ |
| **[Apache Spark](./spark/)** | Big data processing | 8080, 8081, 8888 | ✅ |
| **[Apache Superset](./superset/)** | Data visualization platform | 8088 | ✅ |

## 🚀 Quick Start Guide

### Individual Services
Navigate to any service directory and run:
```bash
cd service-name/
docker-compose up -d
```

### Network Setup
Create external networks for inter-service communication:
```bash
docker network create web
docker network create monitoring
docker network create data
```

### Complete Observability Stack
```bash
# Start monitoring stack
cd prometheus/ && docker-compose up -d
cd ../grafana/ && docker-compose up -d
cd ../loki/ && docker-compose up -d

# Or start ELK stack instead
cd ../elk-stack/ && docker-compose up -d
```

### Development Environment
```bash
# Start development tools
cd jenkins/ && docker-compose up -d
cd ../sonarqube/ && docker-compose up -d
cd ../portainer/ && docker-compose up -d
```

## 🔧 Common Configuration

### Environment Variables
Each service includes:
- `.env.example` files for easy setup
- Secrets management via Docker secrets
- Configurable resource limits
- Health checks and monitoring

### Security Features
- Secrets stored in dedicated files
- Network isolation
- Authentication configuration
- SSL/TLS support where applicable

### Volume Management
- Named volumes for persistence
- Configuration file mounts
- Data directory mappings
- Log file access

## 📊 Monitoring Stack Integration

### Prometheus + Grafana Setup
1. Start Prometheus: `cd prometheus/ && docker-compose up -d`
2. Start Grafana: `cd grafana/ && docker-compose up -d`
3. Import dashboards from Grafana UI
4. Configure alerts and notifications

### ELK Stack Setup
1. Set vm.max_map_count: `sysctl -w vm.max_map_count=262144`
2. Start ELK: `cd elk-stack/ && docker-compose up -d`
3. Access Kibana: http://localhost:5601
4. Create index patterns and visualizations

## 🔒 Security Best Practices

### Secrets Management
```bash
# Generate strong passwords
openssl rand -base64 32

# Update all secrets files
find . -name "*.txt" -path "*/secrets/*" -exec echo "new_password" > {} \;
```

### Network Security
```bash
# Create secure networks
docker network create --driver bridge monitoring
docker network create --driver bridge backend
```

### Authentication
- Change default passwords
- Enable 2FA where supported
- Configure LDAP/OAuth integration
- Use API keys for service communication

## 🚦 Health Monitoring

### Service Status
```bash
# Check all running containers
docker ps

# Check specific service
docker-compose -f service/docker-compose.yml ps
```

### Resource Usage
```bash
# Monitor resource usage
docker stats

# Check logs
docker-compose -f service/docker-compose.yml logs -f
```

## 🔄 Backup & Recovery

### Data Backup
```bash
# Backup volumes
docker run --rm -v service_data:/data -v $(pwd):/backup alpine tar czf /backup/service_backup.tar.gz -C /data .

# Backup databases
docker-compose exec postgres pg_dump -U user database > backup.sql
```

### Configuration Backup
```bash
# Backup configurations
tar czf configs_backup.tar.gz */config/ */secrets/
```

## 🎯 Production Deployment

### Performance Tuning
- Allocate sufficient resources (CPU, RAM, storage)
- Configure appropriate JVM settings
- Set up log rotation
- Monitor disk usage

### High Availability
- Use external databases
- Configure load balancers
- Set up container orchestration
- Implement backup strategies

### Scaling
```bash
# Scale specific services
docker-compose up --scale worker=3 -d

# Use Docker Swarm for clustering
docker swarm init
docker stack deploy -c docker-compose.yml mystack
```

## 🆘 Troubleshooting

### Common Issues
1. **Port conflicts**: Change ports in docker-compose.yml
2. **Permission errors**: Check file permissions and user IDs
3. **Memory issues**: Increase Docker memory limits
4. **Network connectivity**: Verify network configuration

### Debug Commands
```bash
# Service logs
docker-compose logs [service_name]

# Container inspection
docker inspect [container_name]

# Network debugging
docker network ls
docker network inspect [network_name]

# Volume inspection
docker volume ls
docker volume inspect [volume_name]
```

## 📝 Contributing

### Adding New Services
1. Create service directory
2. Add docker-compose.yml with proper structure
3. Include configuration files and secrets
4. Write comprehensive README
5. Add to main README table

### Template Structure
```
service-name/
├── docker-compose.yml
├── README.md
├── .env.example
├── config/
├── secrets/
├── init-scripts/
└── docs/
```

## 📚 Additional Resources

- [Docker Compose Documentation](https://docs.docker.com/compose/)
- [Docker Security Best Practices](https://docs.docker.com/develop/security-best-practices/)
- [Container Networking](https://docs.docker.com/network/)
- [Volume Management](https://docs.docker.com/storage/volumes/)

## 🏷️ Service Tags

- **monitoring**: Prometheus, Grafana, Loki, ELK, Jaeger
- **gateway**: Traefik, Kong, Caddy
- **cicd**: Jenkins, SonarQube
- **auth**: Keycloak
- **cache**: Memcached, Varnish, Redis
- **data**: Airflow, Spark, Superset
- **management**: Portainer

---

*Last updated: August 2025*
*Maintained by: DevOps Team*
