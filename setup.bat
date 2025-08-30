@echo off
setlocal enabledelayedexpansion

:: Docker Compose Templates Setup Script (Windows)
:: Run this script to set up all services with proper secrets and configuration

echo 🐳 Docker Compose Templates Setup
echo ==================================

:: Function to generate random password
call :generate_password password

:: Check if Docker is running
docker info >nul 2>&1
if errorlevel 1 (
    echo ❌ Docker is not running. Please start Docker and try again.
    exit /b 1
)

:: Create networks
echo Creating Docker networks...
call :create_network "web"
call :create_network "monitoring" 
call :create_network "data"
call :create_network "backend"

:: List of all services
set services=prometheus grafana loki elk-stack jaeger traefik kong caddy sonarqube jenkins portainer keycloak memcached varnish airflow spark superset

:: Setup each service
for %%s in (%services%) do (
    call :setup_service "%%s"
)

echo.
echo 🎉 Setup complete!
echo.
echo 📋 Next Steps:
echo 1. Review and customize .env files in each service directory
echo 2. Update secrets in secrets\*.txt files
echo 3. Start services with: cd ^<service^>\ ^&^& docker-compose up -d
echo 4. Check SERVICES-README.md for detailed documentation
echo.
echo 🚀 Quick Start Commands:
echo # Monitoring stack
echo cd prometheus\ ^&^& docker-compose up -d
echo cd grafana\ ^&^& docker-compose up -d
echo.
echo # Development tools  
echo cd jenkins\ ^&^& docker-compose up -d
echo cd portainer\ ^&^& docker-compose up -d
echo.
echo # API Gateway
echo cd traefik\ ^&^& docker-compose up -d
echo.
echo ⚠ Important Notes:
echo - Review security settings before production use
echo - Change all default passwords
echo - Configure proper domain names and SSL certificates
echo - Monitor resource usage and adjust limits as needed

goto :end

:generate_password
set "chars=ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
set "password="
for /l %%i in (1,1,25) do (
    set /a "rand=!random! %% 62"
    for %%j in (!rand!) do set "password=!password!!chars:~%%j,1!"
)
set "%~1=!password!"
goto :eof

:create_network
set network_name=%~1
docker network ls | findstr /c:" %network_name% " >nul
if errorlevel 1 (
    docker network create "%network_name%"
    echo ✓ Created network: %network_name%
) else (
    echo ⚠ Network already exists: %network_name%
)
goto :eof

:setup_service
set service_name=%~1
echo.
echo 📦 Setting up %service_name%...

if exist "%service_name%" (
    pushd "%service_name%"
    
    :: Update secrets
    if exist "secrets" (
        for %%f in (secrets\*.txt) do (
            call :generate_password new_password
            echo !new_password! > "%%f"
            echo ✓ Updated %%~nxf
        )
    )
    
    :: Create .env file if example exists
    if exist ".env.example" (
        if not exist ".env" (
            copy ".env.example" ".env" >nul
            echo ✓ Created .env file
        ) else (
            echo ⚠ .env file already exists
        )
    )
    
    popd
    echo ✅ %service_name% setup complete
) else (
    echo ❌ Service directory not found: %service_name%
)
goto :eof

:end
pause
