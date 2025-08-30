# Portainer Docker Compose

Docker container management platform with web UI:
- **Portainer CE** for container management
- **Portainer Agent** for remote management
- Demo applications for testing

## Quick Start

1. Update secrets (for demo profile):
   ```bash
   echo "your_mysql_root_password" > secrets/mysql_root_password.txt
   echo "your_mysql_password" > secrets/mysql_password.txt
   ```

2. Start Portainer:
   ```bash
   docker-compose up -d
   ```

3. With demo applications:
   ```bash
   docker-compose --profile demo up -d
   ```

## Access
- Portainer UI: http://localhost:9000
- Portainer HTTPS: https://localhost:9443
- Demo Nginx: http://localhost:8080 (demo profile)

## Initial Setup

1. Open Portainer UI
2. Create admin user (first time)
3. Select "Docker" environment
4. Connect to local Docker socket

## Features

### Container Management
- Start, stop, restart containers
- View logs and stats
- Execute commands in containers
- Monitor resource usage

### Image Management
- Pull, build, push images
- Manage image registry connections
- Scan for vulnerabilities (Business Edition)

### Stack Management
- Deploy Docker Compose stacks
- Template library
- Git repository integration
- Stack templates

### Network & Volume Management
- Create and manage Docker networks
- Manage Docker volumes
- Network topology visualization

## Multi-Environment Setup

### Add Remote Docker Host
1. Start agent on remote host:
   ```bash
   docker-compose --profile agent up -d
   ```
2. In Portainer UI: Environments → Add Environment
3. Use Agent connection with endpoint: `remote-host:9001`

### Kubernetes Support
Portainer also supports Kubernetes clusters:
1. Add Environment → Kubernetes
2. Use kubeconfig or service account token

## User Management

### Teams & Roles
- Administrator: Full access
- Operator: Container operations
- Helpdesk: Read-only access
- Standard User: Limited access

### Access Control
Configure resource access per team:
- Container groups
- Registry access
- Stack deployment permissions

## Templates

Create custom application templates:
1. App Templates → Add Template
2. Configure Docker Compose template
3. Set variables and descriptions

## Business Edition Features

Upgrade to Portainer Business Edition for:
- Role-based access control
- Registry scanning
- Activity auditing
- OAuth authentication
- Support for edge computing

## Backup & Migration

### Backup Data
```bash
docker run --rm -v portainer_data:/backup-source -v $(pwd):/backup alpine tar czf /backup/portainer-backup.tar.gz -C /backup-source .
```

### Restore Data
```bash
docker run --rm -v portainer_data:/restore-target -v $(pwd):/backup alpine tar xzf /backup/portainer-backup.tar.gz -C /restore-target
```

## Troubleshooting

- Check container logs: `docker-compose logs portainer`
- Verify Docker socket permissions
- Ensure port 9000 is not in use
- Check firewall settings for remote agents
