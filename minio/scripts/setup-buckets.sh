#!/bin/sh

# MinIO Client Setup Script
# This script configures MinIO client and creates initial buckets

# Wait for MinIO to be ready
sleep 10

# Get credentials
MINIO_USER=$(cat /run/secrets/minio_root_user)
MINIO_PASS=$(cat /run/secrets/minio_root_password)

# Configure MinIO client
mc alias set minio http://minio1:9000 $MINIO_USER $MINIO_PASS

# Create buckets
echo "Creating buckets..."

# Create various buckets for different use cases
mc mb minio/uploads --ignore-existing
mc mb minio/images --ignore-existing
mc mb minio/documents --ignore-existing
mc mb minio/backups --ignore-existing
mc mb minio/logs --ignore-existing
mc mb minio/static-assets --ignore-existing
mc mb minio/user-data --ignore-existing

# Set bucket policies
echo "Setting bucket policies..."

# Public read policy for static assets
mc anonymous set download minio/static-assets

# Private policy for user data (default)
mc anonymous set none minio/user-data

# Public read policy for images
mc anonymous set download minio/images

# Set versioning on important buckets
echo "Enabling versioning..."
mc version enable minio/user-data
mc version enable minio/documents
mc version enable minio/backups

# Set lifecycle policies
echo "Setting lifecycle policies..."

# Create lifecycle policy for logs (delete after 30 days)
cat > /tmp/logs-lifecycle.json << EOF
{
    "Rules": [
        {
            "ID": "DeleteOldLogs",
            "Status": "Enabled",
            "Expiration": {
                "Days": 30
            }
        }
    ]
}
EOF

mc ilm import minio/logs < /tmp/logs-lifecycle.json

# Create lifecycle policy for uploads (delete after 7 days if not moved)
cat > /tmp/uploads-lifecycle.json << EOF
{
    "Rules": [
        {
            "ID": "CleanupUploads",
            "Status": "Enabled",
            "Expiration": {
                "Days": 7
            }
        }
    ]
}
EOF

mc ilm import minio/uploads < /tmp/uploads-lifecycle.json

# Upload sample files
echo "Uploading sample files..."

# Create sample files
echo "Hello MinIO!" > /tmp/sample.txt
echo '{"message": "Sample JSON file", "timestamp": "'$(date)'"}' > /tmp/sample.json

# Upload to different buckets
mc cp /tmp/sample.txt minio/documents/
mc cp /tmp/sample.json minio/static-assets/

echo "MinIO setup completed successfully!"

# List all buckets and their contents
echo "Created buckets:"
mc ls minio/

echo "Bucket details:"
for bucket in uploads images documents backups logs static-assets user-data; do
    echo "--- $bucket ---"
    mc ls minio/$bucket/ || echo "Empty bucket"
    echo
done
