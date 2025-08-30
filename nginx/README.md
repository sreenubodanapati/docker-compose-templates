# Nginx Docker Compose Template

This template provides a production-ready Nginx web server setup with Docker Compose.

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

You can customize the deployment using environment variables in a `.env` file:

```env
NGINX_HOST=localhost
NGINX_PORT=80
```

### Volume Mounts

- `./nginx.conf` - Main Nginx configuration file
- `./conf.d/` - Directory for additional configuration files
- `./html/` - Static web content directory
- `./ssl/` - SSL certificates directory
- `nginx_logs` - Nginx log files

### Default Configuration Files

Create these configuration files in the nginx directory:

**nginx.conf** (Main configuration):
```nginx
events {
    worker_connections 1024;
}

http {
    include       /etc/nginx/mime.types;
    default_type  application/octet-stream;
    
    sendfile        on;
    keepalive_timeout  65;
    
    include /etc/nginx/conf.d/*.conf;
}
```

**conf.d/default.conf** (Server configuration):
```nginx
server {
    listen       80;
    server_name  localhost;
    
    location / {
        root   /usr/share/nginx/html;
        index  index.html index.htm;
    }
    
    error_page   500 502 503 504  /50x.html;
    location = /50x.html {
        root   /usr/share/nginx/html;
    }
}
```

## 🔍 Service Details

- **Image**: `nginx:alpine`
- **Ports**: 
  - HTTP: `80:80`
  - HTTPS: `443:443`
- **Health Check**: HTTP request to localhost
- **Restart Policy**: `unless-stopped`

## 🌐 Accessing the Service

- **HTTP**: http://localhost
- **HTTPS**: https://localhost (requires SSL configuration)

## 📝 Notes

- Place your static files in the `html/` directory
- SSL certificates should be placed in the `ssl/` directory
- Additional server configurations can be added to `conf.d/`
- Logs are stored in the `nginx_logs` volume
