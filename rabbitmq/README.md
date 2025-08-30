# RabbitMQ Docker Compose Setup

This directory contains a production-ready RabbitMQ setup with Docker Compose.

## Features

- **RabbitMQ 3.13** with Management UI
- **Prometheus metrics** integration
- **Custom configurations** and definitions
- **Volume persistence** for data
- **Health checks** for container monitoring
- **Security** with secrets management
- **Resource limits** and network isolation

## Quick Start

```bash
# Start RabbitMQ
docker-compose up -d

# View logs
docker-compose logs -f

# Stop services
docker-compose down
```

## Access Points

- **AMQP Port**: 5672
- **Management UI**: http://localhost:15672
- **Prometheus Metrics**: http://localhost:15692/metrics

## Default Credentials

- **Username**: admin
- **Password**: rabbitSecure123!

## Configuration Files

- `config/rabbitmq.conf`: Main RabbitMQ configuration
- `config/definitions.json`: Queue, exchange, and binding definitions
- `secrets/`: Contains sensitive credentials

## Management UI Features

The management UI provides:
- Queue monitoring and management
- Exchange and binding configuration
- User and virtual host management
- Performance metrics and monitoring
- Message tracing and debugging

## Virtual Hosts

- `/`: Default virtual host
- `/app`: Application-specific virtual host

## Pre-configured Resources

### Exchanges
- `app.events`: Topic exchange for application events

### Queues
- `app.notifications`: Durable queue with TTL and max length

### Users
- `admin`: Administrator with full access
- `app_user`: Application user with limited access

## Health Monitoring

Container includes health checks that verify:
- RabbitMQ service availability
- Management plugin status
- Node connectivity

## Security Features

- Secrets managed via Docker secrets
- Resource limits to prevent resource exhaustion
- Network isolation with custom bridge network
- Guest user disabled for security

## Volume Management

- `rabbitmq_data`: Persistent storage for RabbitMQ data
- Configuration files mounted as read-only

## Resource Limits

- **Memory**: 1GB limit
- **CPU**: 0.5 cores limit
- **Disk**: 2GB minimum free space threshold

## Customization

To customize the setup:

1. **Modify configurations**: Edit files in `config/` directory
2. **Update credentials**: Change files in `secrets/` directory
3. **Add definitions**: Modify `config/definitions.json`
4. **Adjust resources**: Update limits in `docker-compose.yml`

## Troubleshooting

```bash
# Check container status
docker-compose ps

# View detailed logs
docker-compose logs rabbitmq

# Execute commands in container
docker-compose exec rabbitmq rabbitmq-diagnostics status

# Reset data (WARNING: deletes all data)
docker-compose down -v
```

## Production Considerations

- Change default passwords before deployment
- Configure appropriate resource limits
- Set up external monitoring and alerting
- Consider clustering for high availability
- Implement proper backup strategies
- Use external secrets management in production
