# MongoDB Docker Compose Setup

This directory contains a complete MongoDB setup with Docker Compose, including MongoDB server and Mongo Express web interface.

## Features

- **MongoDB 7.0**: Latest stable version of MongoDB
- **Mongo Express**: Web-based MongoDB admin interface
- **Security**: Uses Docker secrets for credentials
- **Persistence**: Data persists in Docker volumes
- **Health Checks**: Built-in health monitoring
- **Initialization**: Automatic database setup with sample data

## Quick Start

1. **Start the services:**
   ```bash
   docker-compose up -d
   ```

2. **Access MongoDB:**
   - MongoDB Server: `localhost:27017`
   - Mongo Express UI: `http://localhost:8081`

3. **Stop the services:**
   ```bash
   docker-compose down
   ```

## Configuration

### Environment Variables

- `MONGODB_DATABASE`: Database name (default: appdb)

### Default Credentials

- **Username**: admin
- **Password**: SecureMongoPassword123!

⚠️ **Security Note**: Change the default credentials in the secrets files before production use!

## File Structure

```
mongodb/
├── docker-compose.yml        # Main compose file
├── README.md                 # This file
├── secrets/
│   ├── mongodb_user.txt      # MongoDB username
│   └── mongodb_password.txt  # MongoDB password
└── init-scripts/
    └── init.js              # Database initialization script
```

## Volumes

- `mongodb_data`: MongoDB data files
- `mongodb_config`: MongoDB configuration files

## Networking

- Network: `mongodb_network` (bridge driver)
- Ports:
  - MongoDB: 27017
  - Mongo Express: 8081

## Health Checks

MongoDB includes health checks that verify the database is responsive before dependent services start.

## Customization

### Adding Custom Initialization Scripts

Place `.js` files in the `init-scripts/` directory. They will be executed when MongoDB starts for the first time.

### Changing Credentials

1. Update `secrets/mongodb_user.txt` and `secrets/mongodb_password.txt`
2. Restart the services: `docker-compose down && docker-compose up -d`

### Production Considerations

1. Change default passwords
2. Configure MongoDB authentication properly
3. Set up SSL/TLS encryption
4. Configure backup strategies
5. Monitor resource usage
6. Consider replica sets for high availability
