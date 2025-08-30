#!/bin/bash

# MariaDB Backup Script
# This script creates a full backup of all databases

BACKUP_DIR="/backups"
DATE=$(date +%Y%m%d_%H%M%S)
BACKUP_FILE="mariadb_backup_${DATE}.sql"
LOG_FILE="$BACKUP_DIR/backup_${DATE}.log"

# Database connection details
DB_HOST="mariadb-primary"
DB_PORT="3306"
DB_USER="root"
DB_PASS=$(cat /run/secrets/mysql_root_password)

# Create backup directory if it doesn't exist
mkdir -p $BACKUP_DIR

echo "Starting backup at $(date)" > $LOG_FILE

# Create full database backup
mysqldump -h$DB_HOST -P$DB_PORT -u$DB_USER -p$DB_PASS \
    --single-transaction \
    --routines \
    --triggers \
    --events \
    --all-databases \
    --master-data=2 \
    --flush-logs \
    --hex-blob \
    --complete-insert > "$BACKUP_DIR/$BACKUP_FILE" 2>>$LOG_FILE

if [ $? -eq 0 ]; then
    echo "Backup completed successfully at $(date)" >> $LOG_FILE
    
    # Compress the backup
    gzip "$BACKUP_DIR/$BACKUP_FILE"
    echo "Backup compressed: $BACKUP_FILE.gz" >> $LOG_FILE
    
    # Remove backups older than 7 days
    find $BACKUP_DIR -name "mariadb_backup_*.sql.gz" -mtime +7 -delete
    echo "Old backups cleaned up" >> $LOG_FILE
    
else
    echo "Backup failed at $(date)" >> $LOG_FILE
    exit 1
fi

echo "Backup process finished at $(date)" >> $LOG_FILE
