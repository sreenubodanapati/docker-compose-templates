# Redis Docker Compose Template

This template provides a production-ready Redis setup using Docker Compose with Redis 7 Alpine image.

## 🚀 Quick Start

1. **Navigate to the redis directory:**
   ```bash
   cd redis
   ```

2. **Start Redis service:**
   ```bash
   docker-compose up -d
   ```

3. **Check service status:**
   ```bash
   docker-compose ps
   ```

4. **View logs:**
   ```bash
   docker-compose logs redis
   ```

5. **Stop the service:**
   ```bash
   docker-compose down
   ```

## 📋 Service Configuration

### Container Details
- **Image:** `redis:7-alpine`
- **Container Name:** `redis`
- **Port:** `6379:6379` (host:container)
- **Restart Policy:** `unless-stopped`

### Features Included
- ✅ Health checks for service monitoring
- ✅ Persistent data storage with named volumes
- ✅ Custom Redis configuration support
- ✅ Password protection (optional)
- ✅ Dedicated network for isolation
- ✅ Automatic restart on failure

## 🔧 Configuration

### Environment Variables

Create a `.env` file in the redis directory for custom configuration:

```env
# Redis password (optional)
REDIS_PASSWORD=your_secure_password_here
```

### Custom Redis Configuration

The template includes support for a custom `redis.conf` file. Create one in the redis directory with your preferred settings:

```conf
# Example redis.conf
maxmemory 256mb
maxmemory-policy allkeys-lru
save 900 1
save 300 10
save 60 10000
```

## 🔌 Connection Details

### From Host Machine
- **Host:** `localhost`
- **Port:** `6379`
- **Connection String:** `redis://localhost:6379`

### From Other Docker Containers
- **Host:** `redis` (service name)
- **Port:** `6379`
- **Connection String:** `redis://redis:6379`

## 🛠️ Common Commands

### Connect to Redis CLI
```bash
# Connect to Redis CLI inside the container
docker-compose exec redis redis-cli

# Connect with password (if set)
docker-compose exec redis redis-cli -a your_password
```

### Test Redis Connection
```bash
# Test connection from host
docker-compose exec redis redis-cli ping

# Should return: PONG
```

### Monitor Redis
```bash
# Monitor Redis commands in real-time
docker-compose exec redis redis-cli monitor
```

### Get Redis Info
```bash
# Get Redis server information
docker-compose exec redis redis-cli info
```

## 📊 Data Persistence

- **Volume Name:** `redis_data`
- **Mount Point:** `/data` (inside container)
- **Persistence:** Data survives container restarts and recreation

### Backup Data
```bash
# Create a backup
docker-compose exec redis redis-cli save
docker cp redis:/data/dump.rdb ./backup-$(date +%Y%m%d).rdb
```

### Restore Data
```bash
# Stop Redis
docker-compose down

# Replace the dump file
docker cp backup-file.rdb redis_volume_location/dump.rdb

# Start Redis
docker-compose up -d
```

## 🔍 Health Checks

The service includes automated health checks:
- **Command:** `redis-cli ping`
- **Interval:** Every 30 seconds
- **Timeout:** 10 seconds
- **Retries:** 3 attempts
- **Start Period:** 30 seconds grace period

## 🌐 Network Configuration

- **Network Name:** `redis_network`
- **Driver:** `bridge`
- **Isolation:** Redis runs in its own network for security

## 🔐 Security Considerations

### For Development
- Default configuration is suitable for development environments
- No password required by default

### For Production
1. **Set a strong password:**
   ```env
   REDIS_PASSWORD=your_very_secure_password_here
   ```

2. **Limit network access:**
   - Remove port mapping if Redis is only accessed by other containers
   - Use firewall rules to restrict access

3. **Configure Redis security:**
   ```conf
   # Add to redis.conf
   requirepass your_secure_password
   protected-mode yes
   bind 0.0.0.0
   ```

## 🚨 Troubleshooting

### Service Won't Start
```bash
# Check logs for errors
docker-compose logs redis

# Check if port is already in use
netstat -an | grep 6379
```

### Connection Issues
```bash
# Test network connectivity
docker-compose exec redis redis-cli ping

# Check if Redis is listening
docker-compose exec redis netstat -tlnp | grep 6379
```

### Performance Issues
```bash
# Check Redis memory usage
docker-compose exec redis redis-cli info memory

# Check slow queries
docker-compose exec redis redis-cli slowlog get 10
```

## 📚 Useful Resources

- [Redis Official Documentation](https://redis.io/documentation)
- [Redis Configuration Reference](https://redis.io/topics/config)
- [Redis Commands Reference](https://redis.io/commands)
- [Redis Docker Hub](https://hub.docker.com/_/redis)

## 🏷️ Tags

`redis` `cache` `database` `in-memory` `docker` `docker-compose`
