# PostgreSQL Docker Compose Template

This template provides a production-ready PostgreSQL 15 database setup with Docker Compose, including pgAdmin for database management.

## 🚀 Quick Start

1. **Start the services:**
   ```bash
   docker-compose up -d
   ```

2. **Stop the services:**
   ```bash
   docker-compose down
   ```

## 📋 Configuration

### Environment Variables

Create a `.env` file to customize your PostgreSQL deployment:

```env
# PostgreSQL Configuration
POSTGRES_DB=your_database_name
POSTGRES_USER=your_username
POSTGRES_PASSWORD=your_secure_password
POSTGRES_INITDB_ARGS=--encoding=UTF-8

# pgAdmin Configuration
PGADMIN_EMAIL=admin@example.com
PGADMIN_PASSWORD=your_admin_password
```

### Volume Mounts

- `postgres_data` - PostgreSQL data directory (persistent storage)
- `pgadmin_data` - pgAdmin data directory (persistent storage)
- `./postgresql.conf` - Custom PostgreSQL configuration file
- `./init/` - Initialization scripts directory

### Custom Configuration

Create a `postgresql.conf` file for custom PostgreSQL settings:

```conf
# postgresql.conf - Custom PostgreSQL configuration

# Connection settings
listen_addresses = '*'
max_connections = 100

# Memory settings
shared_buffers = 256MB
effective_cache_size = 1GB
work_mem = 4MB
maintenance_work_mem = 64MB

# WAL settings
wal_buffers = 16MB
checkpoint_completion_target = 0.9

# Logging settings
log_destination = 'stderr'
logging_collector = on
log_directory = 'log'
log_filename = 'postgresql-%Y-%m-%d_%H%M%S.log'
log_min_messages = warning
log_min_error_statement = error

# Performance settings
random_page_cost = 1.1
effective_io_concurrency = 200
```

### Initialization Scripts

Place SQL scripts in the `init/` directory to run during container startup:

```sql
-- init/01-create-extensions.sql
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pg_trgm";

-- init/02-create-tables.sql
CREATE TABLE IF NOT EXISTS users (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- init/03-insert-data.sql
INSERT INTO users (username, email) VALUES 
('admin', 'admin@example.com'),
('user1', 'user1@example.com');
```

## 🔍 Service Details

### PostgreSQL
- **Image**: `postgres:15-alpine`
- **Port**: `5432:5432`
- **Health Check**: `pg_isready` command
- **Restart Policy**: `unless-stopped`

### pgAdmin
- **Image**: `dpage/pgadmin4`
- **Port**: `8080:80`
- **Web Interface**: http://localhost:8080

## 🌐 Accessing the Services

### PostgreSQL Database
```bash
# From host machine
psql -h localhost -p 5432 -U your_username -d your_database

# From Docker container
docker exec -it postgresql psql -U your_username -d your_database
```

### pgAdmin Web Interface
1. Open http://localhost:8080 in your browser
2. Login with your pgAdmin credentials
3. Add server connection:
   - Host: `postgresql`
   - Port: `5432`
   - Database: `your_database`
   - Username: `your_username`
   - Password: `your_password`

## 🔐 Security Notes

- Always change default passwords in production
- Use strong, unique passwords
- Consider using Docker secrets for sensitive data
- Limit network exposure in production environments
- Enable SSL/TLS in production

## 📊 Connection Examples

### Python (psycopg2)
```python
import psycopg2
connection = psycopg2.connect(
    host='localhost',
    port=5432,
    database='your_database',
    user='your_username',
    password='your_password'
)
```

### Node.js (pg)
```javascript
const { Client } = require('pg');
const client = new Client({
  host: 'localhost',
  port: 5432,
  database: 'your_database',
  user: 'your_username',
  password: 'your_password'
});
```

### Java (JDBC)
```java
String url = "jdbc:postgresql://localhost:5432/your_database";
Connection connection = DriverManager.getConnection(url, "your_username", "your_password");
```

## 📊 Management Commands

### Backup Database
```bash
docker exec postgresql pg_dump -U your_username your_database > backup.sql
```

### Restore Database
```bash
docker exec -i postgresql psql -U your_username -d your_database < backup.sql
```

### Access PostgreSQL Shell
```bash
docker exec -it postgresql psql -U your_username -d your_database
```

### View Logs
```bash
docker logs postgresql
docker logs pgadmin
```
