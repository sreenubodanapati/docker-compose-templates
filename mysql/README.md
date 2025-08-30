# MySQL Docker Compose Template

This template provides a production-ready MySQL 8.0 database setup with Docker Compose.

## 🚀 Quick Start

1. **Start the service:**
   ```bash
   docker-compose up -d
   ```

2. **Stop the service:**
   ```bash
   docker-compose down
   ```

## 📋 Configuration

### Environment Variables

Create a `.env` file to customize your MySQL deployment:

```env
MYSQL_ROOT_PASSWORD=your_secure_root_password
MYSQL_DATABASE=your_database_name
MYSQL_USER=your_username
MYSQL_PASSWORD=your_secure_password
```

### Volume Mounts

- `mysql_data` - MySQL data directory (persistent storage)
- `./my.cnf` - Custom MySQL configuration file
- `./init/` - Initialization scripts directory

### Custom Configuration

Create a `my.cnf` file for custom MySQL settings:

```ini
[mysqld]
# Custom MySQL configuration
max_connections = 200
innodb_buffer_pool_size = 256M
innodb_log_file_size = 64M
innodb_flush_log_at_trx_commit = 2

# Character set
character-set-server = utf8mb4
collation-server = utf8mb4_unicode_ci

[mysql]
default-character-set = utf8mb4

[client]
default-character-set = utf8mb4
```

### Initialization Scripts

Place SQL scripts in the `init/` directory to run during container startup:

```sql
-- init/01-create-tables.sql
CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- init/02-insert-data.sql
INSERT INTO users (username, email) VALUES 
('admin', 'admin@example.com'),
('user1', 'user1@example.com');
```

## 🔍 Service Details

- **Image**: `mysql:8.0`
- **Port**: `3306:3306`
- **Health Check**: MySQL ping command
- **Restart Policy**: `unless-stopped`
- **Authentication**: `mysql_native_password`

## 🔐 Security Notes

- Always change default passwords in production
- Use strong, unique passwords
- Consider using Docker secrets for sensitive data
- Limit network exposure in production environments

## 🌐 Connecting to MySQL

### From Host Machine
```bash
mysql -h localhost -P 3306 -u your_username -p
```

### Connection String Examples

**PHP:**
```php
$pdo = new PDO('mysql:host=localhost;port=3306;dbname=your_database', 'your_username', 'your_password');
```

**Node.js:**
```javascript
const mysql = require('mysql2');
const connection = mysql.createConnection({
  host: 'localhost',
  port: 3306,
  user: 'your_username',
  password: 'your_password',
  database: 'your_database'
});
```

**Python:**
```python
import mysql.connector
connection = mysql.connector.connect(
    host='localhost',
    port=3306,
    user='your_username',
    password='your_password',
    database='your_database'
)
```

## 📊 Management

### Backup Database
```bash
docker exec mysql mysqldump -u root -p your_database > backup.sql
```

### Restore Database
```bash
docker exec -i mysql mysql -u root -p your_database < backup.sql
```

### Access MySQL Shell
```bash
docker exec -it mysql mysql -u root -p
```
