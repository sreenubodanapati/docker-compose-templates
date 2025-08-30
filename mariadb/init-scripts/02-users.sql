-- Additional setup for replication and users

-- Create replication user (this will be created on master)
CREATE USER IF NOT EXISTS 'replication'@'%' IDENTIFIED BY 'ReplicationSecure123!';
GRANT REPLICATION SLAVE ON *.* TO 'replication'@'%';

-- Create application user with limited privileges
CREATE USER IF NOT EXISTS 'appuser'@'%' IDENTIFIED BY 'SecureAppUserPass123!';
GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, DROP, INDEX, ALTER ON appdb.* TO 'appuser'@'%';
GRANT SELECT, INSERT, UPDATE, DELETE ON testdb.* TO 'appuser'@'%';

-- Create read-only user for reporting
CREATE USER IF NOT EXISTS 'readonly'@'%' IDENTIFIED BY 'ReadOnlyPass123!';
GRANT SELECT ON appdb.* TO 'readonly'@'%';
GRANT SELECT ON testdb.* TO 'readonly'@'%';

-- Create backup user
CREATE USER IF NOT EXISTS 'backup'@'%' IDENTIFIED BY 'BackupSecure123!';
GRANT SELECT, LOCK TABLES, SHOW VIEW, EVENT, TRIGGER ON *.* TO 'backup'@'%';

-- Flush privileges to apply changes
FLUSH PRIVILEGES;

-- Show created users
SELECT user, host FROM mysql.user WHERE user IN ('replication', 'appuser', 'readonly', 'backup');
