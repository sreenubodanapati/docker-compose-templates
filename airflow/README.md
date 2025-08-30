# Apache Airflow Docker Compose

Workflow orchestration platform with:
- **Airflow Webserver** for UI and API
- **Airflow Scheduler** for workflow execution
- **Airflow Worker** for task execution
- **Airflow Triggerer** for deferrable tasks
- **PostgreSQL** as metadata database
- **Redis** as message broker
- **Flower** for Celery monitoring

## Quick Start

1. Set up environment:
   ```bash
   copy .env.example .env
   # Edit .env with your values
   ```

2. Initialize Airflow:
   ```bash
   docker-compose up airflow-init
   ```

3. Start services:
   ```bash
   docker-compose up -d
   ```

4. With Flower monitoring:
   ```bash
   docker-compose --profile flower up -d
   ```

## Access
- Airflow UI: http://localhost:8080
- Flower UI: http://localhost:5555 (flower profile)
- Default login: admin/admin (or from .env file)

## Configuration

### Environment Variables (Required)
Create `.env` file from `.env.example`:
- `POSTGRES_PASSWORD`: Database password
- `REDIS_PASSWORD`: Redis password  
- `AIRFLOW_FERNET_KEY`: Encryption key
- `AIRFLOW_UID`: User ID (Linux: `echo $UID`)

### Directory Structure
```
airflow/
├── dags/          # DAG definitions
├── logs/          # Execution logs
├── plugins/       # Custom plugins
├── config/        # Configuration files
└── .env          # Environment variables
```

## DAG Development

### Sample DAG
See `dags/example_dag.py` for a basic example.

### Custom DAG
```python
from airflow import DAG
from airflow.operators.python import PythonOperator
from datetime import datetime

with DAG(
    'my_dag',
    start_date=datetime(2024, 1, 1),
    schedule='@daily',
    catchup=False
) as dag:
    
    def my_task():
        print("Hello World!")
    
    task = PythonOperator(
        task_id='my_task',
        python_callable=my_task
    )
```

## Operators

### Common Operators
- `BashOperator`: Run bash commands
- `PythonOperator`: Run Python functions
- `DockerOperator`: Run Docker containers
- `KubernetesPodOperator`: Run Kubernetes pods
- `HttpSensor`: Wait for HTTP endpoints
- `FileSensor`: Wait for files

### Database Operators
- `PostgresOperator`: Run SQL on PostgreSQL
- `MySqlOperator`: Run SQL on MySQL
- `SqliteOperator`: Run SQL on SQLite

## Connections

Configure connections in Airflow UI:
1. Admin → Connections
2. Add connection details for:
   - Databases
   - APIs
   - Cloud services
   - File systems

## Variables & Secrets

### Variables
Store configuration in Airflow Variables:
```python
from airflow.models import Variable
api_key = Variable.get("api_key")
```

### Secrets
Use external secret backends:
- HashiCorp Vault
- AWS Secrets Manager
- Google Secret Manager
- Kubernetes Secrets

## Monitoring

### Web UI Features
- DAG execution history
- Task logs and status
- Connection testing
- Variable management
- User management

### Flower (Celery Monitor)
- Worker status
- Task routing
- Queue monitoring
- Real-time updates

### Health Checks
```bash
# Check webserver
curl http://localhost:8080/health

# Check scheduler
docker-compose exec airflow-scheduler airflow jobs check --job-type SchedulerJob

# Check workers
docker-compose exec airflow-worker celery inspect ping
```

## Scaling

### Worker Scaling
Scale Celery workers:
```bash
docker-compose up --scale airflow-worker=3 -d
```

### Kubernetes Executor
For Kubernetes deployment:
```yaml
AIRFLOW__CORE__EXECUTOR: KubernetesExecutor
AIRFLOW__KUBERNETES__NAMESPACE: airflow
```

## Security

### Authentication
Configure authentication backends:
- LDAP
- OAuth (Google, GitHub)
- Database
- RBAC roles

### Network Security
- Use internal networks
- Enable TLS
- Configure firewalls
- Use secrets management

## Backup & Recovery

### Database Backup
```bash
docker-compose exec postgres pg_dump -U airflow airflow > airflow_backup.sql
```

### DAGs Backup
DAGs are stored in `./dags/` directory - use Git for version control.

## Production Deployment

1. **Resource Requirements**:
   - Minimum 4GB RAM
   - 2+ CPU cores
   - 10GB+ disk space

2. **Configuration**:
   - Use external PostgreSQL
   - Configure Redis cluster
   - Set up load balancer
   - Enable SSL/TLS

3. **Monitoring**:
   - Set up Prometheus metrics
   - Configure log aggregation
   - Monitor resource usage
   - Set up alerting

## Troubleshooting

- Check logs: `docker-compose logs [service]`
- Database issues: Verify PostgreSQL connection
- Task failures: Check task logs in UI
- Worker issues: Monitor Flower dashboard
- Permission errors: Check AIRFLOW_UID setting
