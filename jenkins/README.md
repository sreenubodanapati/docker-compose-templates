# Jenkins Docker Compose

CI/CD automation server with multiple agent options:
- **Jenkins LTS** controller
- **Jenkins Agent** for distributed builds
- **Docker-in-Docker** for containerized builds
- **PostgreSQL** for advanced configurations

## Quick Start

1. Update secrets:
   ```bash
   echo "your_admin_password" > secrets/jenkins_admin_password.txt
   echo "your_postgres_password" > secrets/postgres_password.txt
   ```

2. Start Jenkins:
   ```bash
   docker-compose up -d
   ```

3. Access Jenkins: http://localhost:8080
   - Login: admin / (password from secrets file)

## Deployment Options

### Basic Setup
```bash
docker-compose up -d
```

### With Jenkins Agent
```bash
docker-compose --profile agent up -d
```

### With Docker-in-Docker
```bash
docker-compose --profile dind up -d
```

### With PostgreSQL
```bash
docker-compose --profile postgres up -d
```

## Configuration

### Environment Variables
- `JENKINS_ADMIN_USER`: Admin username (default: admin)
- `JENKINS_OPTS`: Jenkins startup options
- `JAVA_OPTS`: Java runtime options
- `JENKINS_AGENT_SECRET`: Secret for agent connection

### Configuration as Code (CasC)
Jenkins is pre-configured via `config/jenkins.yaml`:
- Admin user setup
- Security configuration
- Tool installations
- Global libraries

## Pipeline Examples

### Declarative Pipeline
```groovy
pipeline {
    agent any
    
    stages {
        stage('Build') {
            steps {
                sh 'echo "Building..."'
            }
        }
        
        stage('Test') {
            steps {
                sh 'echo "Testing..."'
            }
        }
        
        stage('Deploy') {
            steps {
                sh 'echo "Deploying..."'
            }
        }
    }
}
```

### Docker Pipeline
```groovy
pipeline {
    agent {
        docker {
            image 'node:16'
        }
    }
    
    stages {
        stage('Build') {
            steps {
                sh 'npm install'
                sh 'npm run build'
            }
        }
    }
}
```

## Agent Configuration

### Docker Agent
Configure in Jenkins UI:
1. Manage Jenkins → Manage Nodes
2. Add new permanent agent
3. Use connection method: "Launch agent by connecting it to the controller"

### Dynamic Docker Agents
Install Docker plugin and configure:
```groovy
pipeline {
    agent {
        docker {
            image 'maven:3.8.1-openjdk-11'
            args '-v /var/run/docker.sock:/var/run/docker.sock'
        }
    }
}
```

## Plugins

Essential plugins included:
- Git
- Pipeline
- Docker
- Blue Ocean
- Configuration as Code

Install additional plugins via:
- Jenkins UI: Manage Jenkins → Plugin Manager
- Dockerfile: `RUN jenkins-plugin-cli --plugins plugin-name`

## Security

### Production Setup
1. **Authentication**:
   - Configure LDAP/AD
   - Enable matrix-based security
   - Set up proper user roles

2. **Network Security**:
   - Use HTTPS (configure reverse proxy)
   - Restrict admin interface access
   - Configure CSRF protection

3. **Agent Security**:
   - Use agent-to-controller security
   - Configure proper secrets management
   - Use dedicated agent networks

## Backup & Restore

### Backup
```bash
docker run --rm -v jenkins_home:/backup-source -v $(pwd):/backup alpine tar czf /backup/jenkins-backup.tar.gz -C /backup-source .
```

### Restore
```bash
docker run --rm -v jenkins_home:/restore-target -v $(pwd):/backup alpine tar xzf /backup/jenkins-backup.tar.gz -C /restore-target
```

## Monitoring

- System info: http://localhost:8080/systemInfo
- Build executor status: http://localhost:8080/computer/
- Plugin manager: http://localhost:8080/pluginManager/
