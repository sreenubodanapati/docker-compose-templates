#!/bin/bash

# Docker Compose Templates Setup Script
# Run this script to set up all services with proper secrets and configuration

set -e

echo "🐳 Docker Compose Templates Setup"
echo "=================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to generate random password
generate_password() {
    openssl rand -base64 32 | tr -d "=+/" | cut -c1-25
}

# Function to update secrets
update_secrets() {
    local service=$1
    echo -e "${BLUE}Setting up secrets for $service...${NC}"
    
    if [ -d "$service/secrets" ]; then
        for secret_file in "$service/secrets"/*.txt; do
            if [ -f "$secret_file" ]; then
                local password=$(generate_password)
                echo "$password" > "$secret_file"
                echo -e "${GREEN}✓ Updated $(basename $secret_file)${NC}"
            fi
        done
    fi
}

# Function to create .env files
create_env_files() {
    local service=$1
    echo -e "${BLUE}Creating environment file for $service...${NC}"
    
    if [ -f "$service/.env.example" ]; then
        if [ ! -f "$service/.env" ]; then
            cp "$service/.env.example" "$service/.env"
            echo -e "${GREEN}✓ Created .env file${NC}"
        else
            echo -e "${YELLOW}⚠ .env file already exists${NC}"
        fi
    fi
}

# Function to create external networks
create_networks() {
    echo -e "${BLUE}Creating Docker networks...${NC}"
    
    networks=("web" "monitoring" "data" "backend")
    
    for network in "${networks[@]}"; do
        if ! docker network ls | grep -q " $network "; then
            docker network create "$network"
            echo -e "${GREEN}✓ Created network: $network${NC}"
        else
            echo -e "${YELLOW}⚠ Network already exists: $network${NC}"
        fi
    done
}

# Function to setup individual service
setup_service() {
    local service=$1
    echo -e "\n${BLUE}📦 Setting up $service...${NC}"
    
    if [ -d "$service" ]; then
        cd "$service"
        update_secrets "."
        create_env_files "."
        cd ..
        echo -e "${GREEN}✅ $service setup complete${NC}"
    else
        echo -e "${RED}❌ Service directory not found: $service${NC}"
    fi
}

# Main setup function
main() {
    echo -e "${BLUE}Starting setup process...${NC}\n"
    
    # Check if Docker is running
    if ! docker info > /dev/null 2>&1; then
        echo -e "${RED}❌ Docker is not running. Please start Docker and try again.${NC}"
        exit 1
    fi
    
    # Create networks
    create_networks
    
    # List of all services
    services=(
        "prometheus"
        "grafana" 
        "loki"
        "elk-stack"
        "jaeger"
        "traefik"
        "kong"
        "caddy"
        "sonarqube"
        "jenkins"
        "portainer"
        "keycloak"
        "memcached"
        "varnish"
        "airflow"
        "spark"
        "superset"
    )
    
    # Setup each service
    for service in "${services[@]}"; do
        setup_service "$service"
    done
    
    echo -e "\n${GREEN}🎉 Setup complete!${NC}"
    echo -e "\n${BLUE}📋 Next Steps:${NC}"
    echo "1. Review and customize .env files in each service directory"
    echo "2. Update secrets in secrets/*.txt files"
    echo "3. Start services with: cd <service>/ && docker-compose up -d"
    echo "4. Check SERVICES-README.md for detailed documentation"
    
    echo -e "\n${BLUE}🚀 Quick Start Commands:${NC}"
    echo "# Monitoring stack"
    echo "cd prometheus/ && docker-compose up -d"
    echo "cd grafana/ && docker-compose up -d"
    echo ""
    echo "# Development tools"
    echo "cd jenkins/ && docker-compose up -d" 
    echo "cd portainer/ && docker-compose up -d"
    echo ""
    echo "# API Gateway"
    echo "cd traefik/ && docker-compose up -d"
    
    echo -e "\n${YELLOW}⚠ Important Notes:${NC}"
    echo "- Review security settings before production use"
    echo "- Change all default passwords"
    echo "- Configure proper domain names and SSL certificates"
    echo "- Monitor resource usage and adjust limits as needed"
}

# Help function
show_help() {
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  -h, --help     Show this help message"
    echo "  -s, --service  Setup specific service only"
    echo "  -n, --networks Create networks only"
    echo ""
    echo "Examples:"
    echo "  $0                    # Setup all services"
    echo "  $0 -s prometheus      # Setup only Prometheus"
    echo "  $0 -n                 # Create networks only"
}

# Parse command line arguments
case "${1:-}" in
    -h|--help)
        show_help
        exit 0
        ;;
    -s|--service)
        if [ -z "${2:-}" ]; then
            echo -e "${RED}❌ Service name required${NC}"
            show_help
            exit 1
        fi
        setup_service "$2"
        ;;
    -n|--networks)
        create_networks
        ;;
    "")
        main
        ;;
    *)
        echo -e "${RED}❌ Unknown option: $1${NC}"
        show_help
        exit 1
        ;;
esac
