# SonarQube Docker Compose

Code quality and security analysis platform with:
- **SonarQube Community Edition**
- **PostgreSQL** database backend
- **Sonar Scanner** for CI/CD integration

## Quick Start

1. Set system requirements:
   ```bash
   # Increase virtual memory (Linux/macOS)
   sudo sysctl -w vm.max_map_count=262144
   sudo sysctl -w fs.file-max=65536
   
   # Windows (run as Administrator)
   wsl -d docker-desktop sysctl -w vm.max_map_count=262144
   ```

2. Update secrets:
   ```bash
   echo "your_postgres_password" > secrets/postgres_password.txt
   echo "your_sonar_token" > secrets/sonar_token.txt
   ```

3. Start services:
   ```bash
   docker-compose up -d
   ```

4. Access SonarQube: http://localhost:9000
   - Default login: admin/admin

## Configuration

### Environment Variables
- `POSTGRES_USER`: Database user (default: sonar)
- `POSTGRES_DB`: Database name (default: sonar)

### First Setup
1. Change default admin password
2. Generate authentication token
3. Configure quality gates
4. Set up project analysis

## Code Analysis

### Using Scanner Container
1. Start scanner service:
   ```bash
   docker-compose --profile scanner up -d
   ```

2. Copy project to analyze:
   ```bash
   cp -r /path/to/project ./projects/my-project
   ```

3. Run analysis:
   ```bash
   docker-compose exec sonar-scanner sonar-scanner \
     -Dsonar.projectKey=my-project \
     -Dsonar.sources=/usr/src/my-project \
     -Dsonar.host.url=http://sonarqube:9000 \
     -Dsonar.login=$(cat secrets/sonar_token.txt)
   ```

### Manual Analysis
For local development:

**Java/Maven:**
```bash
mvn sonar:sonar \
  -Dsonar.host.url=http://localhost:9000 \
  -Dsonar.login=your_token
```

**JavaScript/Node.js:**
```bash
npx sonarqube-scanner \
  -Dsonar.projectKey=my-project \
  -Dsonar.sources=src \
  -Dsonar.host.url=http://localhost:9000 \
  -Dsonar.login=your_token
```

**Python:**
```bash
sonar-scanner \
  -Dsonar.projectKey=my-python-project \
  -Dsonar.sources=. \
  -Dsonar.host.url=http://localhost:9000 \
  -Dsonar.login=your_token
```

## CI/CD Integration

### Jenkins Pipeline
```groovy
stage('SonarQube Analysis') {
    withSonarQubeEnv('SonarQube') {
        sh 'mvn sonar:sonar'
    }
}
```

### GitHub Actions
```yaml
- name: SonarQube Analysis
  uses: sonarqube-quality-gate-action@master
  env:
    GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
    SONAR_TOKEN: ${{ secrets.SONAR_TOKEN }}
    SONAR_HOST_URL: http://localhost:9000
```

## Quality Gates

Configure quality gates to fail builds on:
- Code coverage < 80%
- Duplicated lines > 3%
- Maintainability rating > A
- Reliability rating > A
- Security rating > A

## Plugins

Install additional language plugins:
- C/C++/Objective-C
- C#/.NET
- Go
- Kotlin
- PHP
- Python
- TypeScript

## Production Considerations

- Use external PostgreSQL for scalability
- Configure LDAP/Active Directory authentication
- Set up SSL/TLS certificates
- Configure mail server for notifications
- Enable security features
- Set up regular database backups
- Monitor performance and disk usage

## Troubleshooting

- Check logs: `docker-compose logs sonarqube`
- Verify database connection
- Ensure sufficient memory allocation
- Check file permissions on mounted volumes
