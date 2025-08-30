# Apache Superset Docker Compose

Modern data visualization platform with:
- **Apache Superset** for dashboards and visualization
- **PostgreSQL** as metadata database
- **Redis** for caching and Celery
- **Celery Worker** for async queries
- **Example MySQL** database for testing

## Quick Start

1. Set up environment:
   ```bash
   copy .env.example .env
   # Edit .env with your values
   ```

2. Initialize Superset:
   ```bash
   docker-compose --profile init up
   ```

3. Start services:
   ```bash
   docker-compose up -d
   ```

4. With async worker:
   ```bash
   docker-compose --profile worker up -d
   ```

5. With example database:
   ```bash
   docker-compose --profile examples up -d
   ```

## Access
- Superset UI: http://localhost:8088
- Default login: admin/admin

## Configuration

### Environment Variables
- `POSTGRES_DB`: Database name (default: superset)
- `POSTGRES_USER`: Database user (default: superset)
- `POSTGRES_PASSWORD`: Database password
- `SUPERSET_SECRET_KEY`: Flask secret key
- `SMTP_*`: Email configuration for alerts

### Custom Configuration
Edit `config/superset_config.py` for:
- Authentication providers
- Feature flags
- Cache settings
- Security options

## Database Connections

### PostgreSQL
```
postgresql://user:password@host:5432/database
```

### MySQL
```
mysql://user:password@host:3306/database
```

### SQLite
```
sqlite:////path/to/database.db
```

### BigQuery
```
bigquery://project-id/dataset-id
```

### Snowflake
```
snowflake://user:password@account/database/schema
```

## Creating Dashboards

1. **Add Database**:
   - Navigate to Data → Databases
   - Add your database connection

2. **Create Dataset**:
   - Data → Datasets
   - Choose table or write SQL query

3. **Build Chart**:
   - Charts → Create new chart
   - Select visualization type
   - Configure metrics and filters

4. **Create Dashboard**:
   - Dashboards → Create new dashboard
   - Add charts and arrange layout

## Chart Types

- **Time Series**: Line charts, area charts
- **Tables**: Data tables with sorting/filtering  
- **Big Numbers**: KPI metrics
- **Maps**: Geographic visualizations
- **Distributions**: Histograms, box plots
- **Correlations**: Scatter plots, heatmaps
- **Rankings**: Bar charts, treemaps

## SQL Lab

Interactive SQL editor features:
- Query history
- Query sharing
- Result caching
- CSV/Excel export
- Query scheduling

## Security

### Authentication Options
- Database (default)
- LDAP/Active Directory
- OAuth (Google, GitHub, etc.)
- OpenID Connect
- Custom authentication

### Row Level Security
Configure in dataset settings:
```sql
WHERE user_id = '{{ current_user_id() }}'
```

## Performance

### Caching
- Redis for query results
- Browser caching for static assets
- Database query caching

### Async Queries
Enable Celery worker for long-running queries:
```bash
docker-compose --profile worker up -d
```

## Customization

### Custom CSS
Add custom styling in superset_config.py:
```python
CUSTOM_CSS = """
.your-custom-class {
    color: #your-color;
}
"""
```

### Custom Visualization Plugins
1. Develop custom viz plugin
2. Build and include in Docker image
3. Register in configuration

## Data Import

### CSV Upload
1. Enable in feature flags
2. Configure upload directory
3. Use Data → Upload CSV

### Programmatic Import
```python
from superset import app, db
from superset.models.slice import Slice

# Create chart programmatically
```

## Alerts & Reports

### Email Reports
1. Configure SMTP settings
2. Create dashboard
3. Set up scheduled email

### Slack Integration
Configure Slack webhook for notifications.

## Production Deployment

1. **Security**:
   - Use strong secret keys
   - Enable HTTPS
   - Configure authentication
   - Set up proper CORS

2. **Performance**:
   - Use external Redis cluster
   - Configure database pooling
   - Enable query caching
   - Scale Celery workers

3. **Monitoring**:
   - Enable application metrics
   - Monitor database performance
   - Set up log aggregation
   - Configure health checks

## Troubleshooting

- Check logs: `docker-compose logs superset`
- Database connection: Test in Data → Databases
- Cache issues: Restart Redis
- Permission errors: Check database grants
- Performance: Monitor query execution time
