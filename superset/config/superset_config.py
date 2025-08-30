import os
from cachelib.redis import RedisCache

# Database Configuration
SQLALCHEMY_DATABASE_URI = f"postgresql://{os.getenv('DATABASE_USER')}:{os.getenv('DATABASE_PASSWORD')}@{os.getenv('DATABASE_HOST')}/{os.getenv('DATABASE_DB')}"

# Redis Configuration
REDIS_HOST = os.getenv('REDIS_HOST', 'redis')
REDIS_PORT = os.getenv('REDIS_PORT', 6379)

# Cache Configuration
CACHE_CONFIG = {
    'CACHE_TYPE': 'RedisCache',
    'CACHE_DEFAULT_TIMEOUT': 300,
    'CACHE_KEY_PREFIX': 'superset_',
    'CACHE_REDIS_HOST': REDIS_HOST,
    'CACHE_REDIS_PORT': REDIS_PORT,
    'CACHE_REDIS_DB': 1,
}

DATA_CACHE_CONFIG = CACHE_CONFIG

# Celery Configuration
class CeleryConfig:
    broker_url = f"redis://{REDIS_HOST}:{REDIS_PORT}/0"
    imports = ('superset.sql_lab',)
    result_backend = f"redis://{REDIS_HOST}:{REDIS_PORT}/0"
    worker_log_level = 'DEBUG'
    worker_prefetch_multiplier = 10
    task_acks_late = True
    task_annotations = {
        'sql_lab.get_sql_results': {'rate_limit': '100/s'},
    }

CELERY_CONFIG = CeleryConfig

# Security
SECRET_KEY = os.getenv('SUPERSET_SECRET_KEY', 'your-secret-key-here')
WTF_CSRF_ENABLED = True
WTF_CSRF_TIME_LIMIT = None

# Feature Flags
FEATURE_FLAGS = {
    "ALERT_REPORTS": True,
    "DASHBOARD_RBAC": True,
    "EMBEDDABLE_CHARTS": True,
    "ENABLE_TEMPLATE_PROCESSING": True,
    "SCHEDULED_QUERIES": True,
    "SQL_VALIDATORS_BY_ENGINE": True,
    "THUMBNAILS": True,
    "DASHBOARD_CACHE": True,
}

# Email Configuration
SMTP_HOST = os.getenv('SMTP_HOST', 'localhost')
SMTP_STARTTLS = True
SMTP_SSL = False
SMTP_USER = os.getenv('SMTP_USER', '')
SMTP_PASSWORD = os.getenv('SMTP_PASSWORD', '')
SMTP_MAIL_FROM = os.getenv('SMTP_MAIL_FROM', 'superset@example.com')

# Security Configuration
AUTH_TYPE = 1  # Database authentication
AUTH_USER_REGISTRATION = True
AUTH_USER_REGISTRATION_ROLE = "Public"

# CORS
ENABLE_CORS = True
CORS_OPTIONS = {
    'supports_credentials': True,
    'allow_headers': ['*'],
    'resources': ['*'],
    'origins': ['*']
}

# SQL Lab Configuration
SQLLAB_CTAS_NO_LIMIT = True
SQLLAB_TIMEOUT = 300
SQLLAB_ASYNC_TIME_LIMIT_SEC = 60 * 60 * 6  # 6 hours

# Upload Configuration
UPLOAD_FOLDER = '/app/superset_home/uploads/'
IMG_UPLOAD_FOLDER = '/app/superset_home/uploads/'
IMG_UPLOAD_URL = '/static/uploads/'

# CSV/Excel Upload
CSV_TO_HIVE_UPLOAD_S3_BUCKET = os.getenv('S3_BUCKET', '')
CSV_TO_HIVE_UPLOAD_DIRECTORY = '/tmp/superset_uploads/'

# Logging
ENABLE_TIME_ROTATE = True
FILENAME = '/app/superset_home/superset.log'
ROLLOVER = 'midnight'
INTERVAL = 1
BACKUP_COUNT = 30

# Custom CSS
CUSTOM_CSS = """
.navbar-brand {
    font-weight: bold;
}
"""
