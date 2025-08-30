# Docker Compose Templates - Production Ready

This repository contains a collection of production-ready Docker Compose templates for various services and applications. These templates are designed with security, performance, and reliability best practices for production environments.

## 🔒 Production-Ready Features

All templates include:
- **Security**: Secret management, non-root users, read-only filesystems where applicable
- **Resource Management**: CPU and memory limits/reservations
- **Monitoring**: Health checks and proper logging configuration
- **Performance**: Optimized configurations for production workloads
- **High Availability**: Clustering and replication support where applicable

## 📁 Repository Structure

Each service/application has its own directory containing:
- `docker-compose.yml` - Production-ready compose file with service definitions
- `README.md` - Detailed documentation and usage instructions
- `.env.example` - Environment variables template
- `secrets/` - Directory for secret files (passwords, keys)
- Configuration files and examples

```
docker-compose-templates/
├── nginx/
│   ├── docker-compose.yml
│   ├── README.md
│   └── .env.example
├── mysql/
│   ├── docker-compose.yml
│   ├── README.md
│   ├── .env.example
│   ├── my.cnf
│   └── secrets/
├── postgresql/
│   ├── docker-compose.yml
│   ├── README.md
│   ├── .env.example
│   ├── postgresql.conf
│   └── secrets/
├── redis/
│   ├── docker-compose.yml
│   ├── README.md
│   ├── .env.example
│   ├── redis.conf
│   ├── sentinel.conf
│   └── secrets/
├── kafka/
│   ├── docker-compose.yml
│   ├── README.md
│   └── .env.example
├── mongodb/
│   ├── docker-compose.yml
│   ├── README.md
│   ├── init-scripts/
│   └── secrets/
├── mariadb/
│   ├── docker-compose.yml
│   ├── README.md
│   ├── config/
│   ├── init-scripts/
│   ├── scripts/
│   └── secrets/
├── cassandra/
│   ├── docker-compose.yml
│   ├── README.md
│   ├── config/
│   ├── init-scripts/
│   └── secrets/
├── elasticsearch/
│   ├── docker-compose.yml
│   ├── README.md
│   ├── config/
│   └── secrets/
├── minio/
│   ├── docker-compose.yml
│   ├── docker-compose.dev.yml
│   ├── README.md
│   ├── nginx/
│   ├── scripts/
│   └── secrets/
└── README.md
```

## 🚀 Available Templates

Currently available production-ready templates:

### 📊 Databases & Caching
- **[Redis](./redis/)** - High-performance in-memory data structure store with Sentinel support
- **[MySQL](./mysql/)** - Production-optimized MySQL with secure configuration
- **[PostgreSQL](./postgresql/)** - Advanced PostgreSQL setup with pgAdmin and monitoring
- **[MongoDB](./mongodb/)** - NoSQL database with Mongo Express interface
- **[MariaDB](./mariadb/)** - MySQL alternative with primary-replica setup
- **[Cassandra](./cassandra/)** - Distributed NoSQL database cluster

### 🔍 Search & Analytics
- **[Elasticsearch](./elasticsearch/)** - Search and analytics engine with ELK stack

### 📦 Storage Services
- **[MinIO](./minio/)** - S3-compatible object storage with high availability

### 🌐 Web Servers & Proxies
- **[Nginx](./nginx/)** - Production-ready Nginx with security hardening

### 🔄 Message Queues & Streaming
- **[Kafka](./kafka/)** - Production Kafka cluster with Zookeeper and management UI

## 🔧 Quick Start

1. **Clone the repository:**
   ```bash
   git clone <repository-url>
   cd docker-compose-templates
   ```

2. **Choose a service and navigate to its directory:**
   ```bash
   cd <service-name>
   ```

3. **Copy and customize the environment file:**
   ```bash
   cp .env.example .env
   # Edit .env with your production values
   ```

4. **Set up secrets (if applicable):**
   ```bash
   # Generate secure passwords for secret files
   echo "YourSecurePassword" > secrets/password.txt
   chmod 600 secrets/*.txt
   ```

5. **Deploy the service:**
   ```bash
   docker-compose up -d
   ```

## 🛡️ Security Considerations

### Secrets Management
- All sensitive data uses Docker secrets or secret files
- Default passwords are provided as examples - **CHANGE THEM**
- Secret files should have restricted permissions (600)

### Network Security
- Services use custom networks with bridge drivers
- Exposed ports are configurable via environment variables
- Consider using reverse proxy for external access

### Container Security
- Non-root users where applicable
- Read-only root filesystems
- `no-new-privileges` security option
- Resource limits to prevent DoS

## 📈 Production Deployment Tips

### Resource Planning
- Review and adjust CPU/memory limits based on your workload
- Monitor resource usage and scale accordingly
- Use external volumes for data persistence

### Monitoring and Logging
- All containers have structured JSON logging with rotation
- Health checks are configured for all services
- Consider integrating with monitoring solutions (Prometheus, ELK stack)

### Backup Strategy
- Implement regular database backups
- Test backup restoration procedures
- Store backups securely off-site

### High Availability
- Use Docker Swarm or Kubernetes for orchestration
- Configure load balancing for web services
- Set up database replication where needed

## 🔧 Environment Variables

Each template supports extensive customization through environment variables:

- `ENVIRONMENT` - Environment name (prod, staging, dev)
- `TIMEZONE` - Container timezone (default: UTC)
- Service-specific ports, memory limits, and configurations

See individual service `.env.example` files for complete options.
   ```bash
   git clone <repository-url>
   cd docker-compose-templates
   ```

2. **Navigate to the desired service directory:**
   ```bash
   cd nginx    # or mysql, postgresql, redis, kafka
   ```

3. **Start the service:**
   ```bash
   docker-compose up -d
   ```

4. **Stop the service:**
   ```bash
   docker-compose down
   ```

## 📋 Prerequisites

- Docker installed on your system
- Docker Compose installed on your system

### Installation Links:
- [Docker Desktop](https://www.docker.com/products/docker-desktop/)
- [Docker Compose](https://docs.docker.com/compose/install/)

## ✨ Features

- **Production-Ready**: All templates include health checks, restart policies, and security considerations
- **Well-Documented**: Each service includes comprehensive README with examples and configuration options
- **Environment Variables**: Easy customization through `.env` files
- **Persistent Storage**: Proper volume configurations for data persistence
- **Networking**: Isolated networks for each service stack
- **Management Tools**: Many templates include web-based management interfaces

## ⚙️ Quick Commands

```bash
# Start all services in detached mode
docker-compose up -d

# View logs
docker-compose logs -f [service-name]

# Stop services
docker-compose down

# Stop services and remove volumes (⚠️ data loss)
docker-compose down -v

# Pull latest images
docker-compose pull
```

## 🔐 Security Considerations

- Change default passwords in production environments
- Review exposed ports before deploying
- Use environment variables for sensitive configuration
- Consider using Docker secrets for production deployments

## 🤝 Contributing

Contributions are welcome! Please follow these steps:

1. Fork the repository
2. Create a new branch for your template
3. Add your Docker Compose template in a new directory
4. Include proper documentation
5. Test your template
6. Submit a pull request

### Template Structure Guidelines:
```
service-name/
├── docker-compose.yml
├── README.md (service-specific documentation)
├── .env.example (if environment variables are needed)
└── config/ (configuration files if applicable)
```

## 📝 Template Guidelines

When creating new templates:

- Use the latest stable versions of images
- Include environment variables for customization
- Provide clear documentation
- Use meaningful service names
- Include health checks where applicable
- Set appropriate restart policies
- Use named volumes for persistent data

## 🐛 Issues & Support

If you encounter any issues or have suggestions:
- Open an issue in this repository
- Provide detailed information about your environment
- Include relevant error messages

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🏷️ Tags

`docker` `docker-compose` `templates` `microservices` `containers` `development` `devops` `infrastructure`

---

**Happy Containerizing! 🐳**
