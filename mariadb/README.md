# MariaDB Docker Compose Setup

This directory contains a complete MariaDB setup with Docker Compose, including primary-replica replication, phpMyAdmin interface, and automated backups.

## Features

- **MariaDB 11.2**: Latest stable version
- **Primary-Replica Setup**: Master-slave replication for high availability
- **phpMyAdmin**: Web-based database administration
- **Automated Backups**: Daily backup with compression and cleanup
- **Security**: Docker secrets for credential management
- **Persistent Storage**: Data persists in Docker volumes
- **Health Checks**: Built-in health monitoring

## Quick Start

1. **Start the services:**
   ```bash
   docker-compose up -d
   ```

2. **Access the services:**
   - MariaDB Primary: `localhost:3306`
   - MariaDB Replica: `localhost:3307`
   - phpMyAdmin: `http://localhost:8082`

3. **Default credentials:**
   - Root password: `SecureMariaDBRoot123!`
   - App user: `appuser` / `SecureAppUserPass123!`

4. **Stop the services:**
   ```bash
   docker-compose down
   ```

## Configuration

### Database Details

- **Primary Database**: `appdb`
- **Test Database**: `testdb`
- **Character Set**: utf8mb4
- **Collation**: utf8mb4_unicode_ci

### Default Credentials

- **Root**: SecureMariaDBRoot123!
- **App User**: appuser / SecureAppUserPass123!
- **Read-Only**: readonly / ReadOnlyPass123!
- **Backup User**: backup / BackupSecure123!
- **Replication**: replication / ReplicationSecure123!

⚠️ **Security Note**: Change all default passwords in the secrets files before production use!

## File Structure

```
mariadb/
├── docker-compose.yml        # Main compose file
├── README.md                 # This file
├── config/
│   └── my.cnf               # MariaDB configuration
├── init-scripts/
│   ├── 01-schema.sql        # Database schema and sample data
│   └── 02-users.sql         # User creation and permissions
├── scripts/
│   └── backup.sh            # Backup script
└── secrets/
    ├── mysql_root_password.txt      # Root password
    ├── mysql_user.txt               # App username
    ├── mysql_password.txt           # App password
    └── mysql_replication_password.txt # Replication password
```

## Services

### MariaDB Primary
- **Port**: 3306
- **Role**: Master database for read/write operations
- **Features**: Binary logging, replication master

### MariaDB Replica
- **Port**: 3307
- **Role**: Slave database for read operations
- **Features**: Replication slave, read scaling

### phpMyAdmin
- **Port**: 8082
- **Features**: Web interface for database management

### Backup Service
- **Schedule**: Daily backups
- **Features**: Compression, automatic cleanup, full database dumps

## Volumes

- `mariadb_primary_data`: Primary database data
- `mariadb_replica_data`: Replica database data
- `mariadb_backups`: Backup storage

## Networking

- Network: `mariadb_network` (bridge driver)
- Internal communication between primary and replica
- External access on ports 3306, 3307, and 8082

## Sample Schema

The setup includes a complete e-commerce schema:

### Tables
- **users**: User accounts and profiles
- **categories**: Product categories with hierarchy
- **products**: Product catalog with inventory
- **orders**: Customer orders
- **order_items**: Order line items

### Features
- Foreign key relationships
- Indexes for performance
- Stored procedures and functions
- Views for complex queries

## Common Operations

### 1. Connect to Primary Database
```bash
docker exec -it mariadb-primary mysql -u root -p
```

### 2. Connect to Replica Database
```bash
docker exec -it mariadb-replica mysql -u root -p
```

### 3. Check Replication Status
```sql
-- On master
SHOW MASTER STATUS;

-- On slave
SHOW SLAVE STATUS\G
```

### 4. Manual Backup
```bash
docker exec mariadb-backup /backup.sh
```

### 5. View Backup Logs
```bash
docker exec mariadb-backup ls -la /backups/
```

### 6. Restore from Backup
```bash
# Extract backup
docker exec mariadb-backup gunzip /backups/mariadb_backup_YYYYMMDD_HHMMSS.sql.gz

# Restore
docker exec -i mariadb-primary mysql -u root -p < /backups/mariadb_backup_YYYYMMDD_HHMMSS.sql
```

## Monitoring

### 1. Check Database Size
```sql
SELECT 
    table_schema AS 'Database',
    ROUND(SUM(data_length + index_length) / 1024 / 1024, 2) AS 'Size (MB)'
FROM information_schema.tables
GROUP BY table_schema;
```

### 2. Monitor Active Connections
```sql
SHOW PROCESSLIST;
```

### 3. Check Performance Metrics
```sql
SHOW GLOBAL STATUS LIKE 'Threads_connected';
SHOW GLOBAL STATUS LIKE 'Queries';
SHOW GLOBAL STATUS LIKE 'Uptime';
```

## Production Considerations

1. **Security**:
   - Change all default passwords
   - Configure SSL/TLS encryption
   - Implement proper user access controls
   - Regular security updates

2. **Performance**:
   - Tune memory settings based on available resources
   - Configure appropriate buffer sizes
   - Monitor and optimize slow queries
   - Set up proper indexing strategies

3. **High Availability**:
   - Configure multiple replicas
   - Set up failover mechanisms
   - Implement load balancing for reads
   - Regular replication monitoring

4. **Backup & Recovery**:
   - Test restore procedures regularly
   - Store backups in multiple locations
   - Implement point-in-time recovery
   - Document recovery procedures

## Troubleshooting

- **Replication Issues**: Check network connectivity and replication user privileges
- **Connection Issues**: Verify firewall settings and bind-address configuration
- **Performance Issues**: Monitor memory usage and slow query log
- **Startup Issues**: Check logs with `docker-compose logs mariadb-primary`
