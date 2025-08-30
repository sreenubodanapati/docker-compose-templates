# MinIO Docker Compose Setup

This directory contains a complete MinIO object storage setup with Docker Compose, including a distributed MinIO cluster, load balancer, and automated bucket configuration.

## Features

- **MinIO Latest**: High-performance S3-compatible object storage
- **Distributed Setup**: 2-node cluster with 4 drives each
- **Load Balancer**: Nginx for distributing requests
- **Web Console**: Modern web interface for management
- **Auto-Configuration**: Automated bucket creation and policies
- **Security**: Docker secrets for credential management
- **Persistence**: Data persists in Docker volumes

## Quick Start

1. **Start the services:**
   ```bash
   docker-compose up -d
   ```

2. **Access the services:**
   - MinIO API (Load Balanced): `http://localhost:9090`
   - MinIO Console (Node 1): `http://localhost:9001`
   - MinIO Console (Node 2): `http://localhost:9003`
   - Direct API (Node 1): `http://localhost:9000`
   - Direct API (Node 2): `http://localhost:9002`

3. **Default credentials:**
   - Username: `minioadmin`
   - Password: `MinIOSecurePass123!`

4. **Stop the services:**
   ```bash
   docker-compose down
   ```

## Configuration

### Cluster Details

- **Nodes**: 2 MinIO servers
- **Drives per Node**: 4 virtual drives
- **Total Drives**: 8 drives
- **Erasure Set Size**: 8 (N/2 = 4 drives can fail)

### Default Credentials

- **Root User**: minioadmin
- **Root Password**: MinIOSecurePass123!

⚠️ **Security Note**: Change the default credentials in the secrets files before production use!

## File Structure

```
minio/
├── docker-compose.yml          # Main compose file
├── README.md                   # This file
├── nginx/
│   └── nginx.conf             # Load balancer configuration
├── scripts/
│   └── setup-buckets.sh       # Bucket initialization script
└── secrets/
    ├── minio_root_user.txt     # MinIO root username
    └── minio_root_password.txt # MinIO root password
```

## Services

### MinIO Node 1
- **API Port**: 9000
- **Console Port**: 9001
- **Role**: Primary node in distributed setup

### MinIO Node 2
- **API Port**: 9002
- **Console Port**: 9003
- **Role**: Secondary node for redundancy

### Nginx Load Balancer
- **Port**: 9090
- **Features**: Round-robin load balancing, health checks

### MinIO Client (mc)
- **Role**: Initial setup and bucket configuration
- **Features**: Creates buckets, sets policies, configures lifecycle rules

## Volumes

- `minio_data1` through `minio_data4`: Node 1 storage drives
- `minio2_data1` through `minio2_data4`: Node 2 storage drives

## Pre-configured Buckets

The setup automatically creates these buckets:

1. **uploads**: Temporary file uploads (7-day lifecycle)
2. **images**: Public read access for image assets
3. **documents**: Private document storage with versioning
4. **backups**: Long-term backup storage with versioning
5. **logs**: Log storage (30-day lifecycle)
6. **static-assets**: Public web assets
7. **user-data**: Private user data with versioning

## Networking

- Network: `minio_network` (bridge driver)
- Load balancer distributes traffic between nodes
- High availability through redundancy

## Common Operations

### 1. Access Web Console
Navigate to `http://localhost:9001` and login with the credentials.

### 2. MinIO Client Commands
```bash
# Configure client
docker exec minio-mc mc alias set myminio http://minio1:9000 minioadmin MinIOSecurePass123!

# List buckets
docker exec minio-mc mc ls myminio/

# Upload file
docker exec minio-mc mc cp /tmp/myfile.txt myminio/uploads/

# Download file
docker exec minio-mc mc cp myminio/uploads/myfile.txt /tmp/downloaded.txt

# Set bucket policy
docker exec minio-mc mc anonymous set public myminio/public-bucket
```

### 3. S3 API Examples

Using AWS CLI or any S3-compatible client:

```bash
# Configure AWS CLI
aws configure set aws_access_key_id minioadmin
aws configure set aws_secret_access_key MinIOSecurePass123!

# List buckets
aws --endpoint-url http://localhost:9000 s3 ls

# Upload file
aws --endpoint-url http://localhost:9000 s3 cp myfile.txt s3://uploads/

# Download file
aws --endpoint-url http://localhost:9000 s3 cp s3://uploads/myfile.txt downloaded.txt
```

### 4. Check Cluster Health
```bash
docker exec minio1 mc admin info minio
```

### 5. Monitor Performance
```bash
docker exec minio1 mc admin prometheus metrics minio
```

## Storage Policies

### Bucket Policies
- **static-assets**: Public download access
- **images**: Public download access
- **uploads, documents, backups, logs, user-data**: Private access

### Lifecycle Policies
- **uploads**: Auto-delete after 7 days
- **logs**: Auto-delete after 30 days
- **documents, backups, user-data**: Versioning enabled

## Monitoring

### 1. Server Information
```bash
docker exec minio1 mc admin info minio
```

### 2. Heal Status (Check for corrupted data)
```bash
docker exec minio1 mc admin heal minio --recursive
```

### 3. Performance Stats
```bash
docker exec minio1 mc admin prometheus metrics minio
```

### 4. Drive Usage
```bash
docker exec minio1 mc admin info minio --json | jq '.info.drives'
```

## Production Considerations

1. **Security**:
   - Change default credentials
   - Enable TLS/SSL encryption
   - Configure IAM policies
   - Set up network security

2. **Performance**:
   - Use SSD storage for better performance
   - Configure appropriate drive counts
   - Monitor network bandwidth
   - Tune erasure coding settings

3. **High Availability**:
   - Deploy across multiple availability zones
   - Use external load balancers
   - Configure backup and disaster recovery
   - Monitor drive health

4. **Backup**:
   - Set up cross-region replication
   - Configure bucket versioning
   - Implement lifecycle policies
   - Regular integrity checks

## Troubleshooting

- **Startup Issues**: Check drive permissions and network connectivity
- **Performance Issues**: Monitor drive I/O and network bandwidth
- **Cluster Issues**: Verify all nodes can communicate
- **Storage Issues**: Check drive space and health status
- **Access Issues**: Verify credentials and bucket policies

## Integration Examples

### Python (boto3)
```python
import boto3

s3 = boto3.client('s3',
    endpoint_url='http://localhost:9000',
    aws_access_key_id='minioadmin',
    aws_secret_access_key='MinIOSecurePass123!'
)

# List buckets
response = s3.list_buckets()
print(response['Buckets'])
```

### Node.js (AWS SDK)
```javascript
const AWS = require('aws-sdk');

const s3 = new AWS.S3({
    endpoint: 'http://localhost:9000',
    accessKeyId: 'minioadmin',
    secretAccessKey: 'MinIOSecurePass123!',
    s3ForcePathStyle: true,
    signatureVersion: 'v4'
});

// List buckets
s3.listBuckets((err, data) => {
    if (err) console.log(err);
    else console.log(data.Buckets);
});
```

This setup provides a robust, S3-compatible object storage solution that can handle everything from simple file uploads to complex data archiving and content delivery scenarios.
