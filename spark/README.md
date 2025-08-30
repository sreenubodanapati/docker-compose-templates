# Apache Spark Docker Compose

Big data processing platform with:
- **Spark Master** for cluster coordination
- **Spark Workers** for task execution
- **Jupyter Notebook** for development
- **Spark History Server** for job monitoring
- **MinIO** for S3-compatible storage

## Quick Start

1. Start basic cluster:
   ```bash
   docker-compose up -d
   ```

2. With multiple workers:
   ```bash
   docker-compose --profile multi-worker up -d
   ```

3. With Jupyter and storage:
   ```bash
   docker-compose --profile jupyter --profile storage up -d
   ```

## Access
- Spark Master UI: http://localhost:8080
- Spark Worker 1: http://localhost:8081
- Spark Worker 2: http://localhost:8082 (multi-worker profile)
- Jupyter Notebook: http://localhost:8888 (jupyter profile)
- History Server: http://localhost:18080 (history profile)
- MinIO Console: http://localhost:9001 (storage profile)

## Configuration

### Environment Variables
- `SPARK_WORKER_MEMORY`: Worker memory allocation (default: 2g)
- `SPARK_WORKER_CORES`: Worker CPU cores (default: 2)
- `JUPYTER_TOKEN`: Jupyter access token (default: spark)
- `MINIO_ROOT_USER`: MinIO username (default: minioadmin)
- `MINIO_ROOT_PASSWORD`: MinIO password (default: minioadmin)

## Running Applications

### Submit Spark Job
```bash
docker-compose exec spark-master spark-submit \
  --master spark://spark-master:7077 \
  --deploy-mode client \
  /opt/bitnami/spark/apps/wordcount.py
```

### Python Shell
```bash
docker-compose exec spark-master pyspark --master spark://spark-master:7077
```

### Scala Shell
```bash
docker-compose exec spark-master spark-shell --master spark://spark-master:7077
```

### SQL Shell
```bash
docker-compose exec spark-master spark-sql --master spark://spark-master:7077
```

## Sample Applications

### PySpark Example
```python
from pyspark.sql import SparkSession

spark = SparkSession.builder \
    .appName("My App") \
    .master("spark://spark-master:7077") \
    .getOrCreate()

# Read data
df = spark.read.csv("/opt/bitnami/spark/data/sample.csv", header=True)

# Process data
result = df.groupBy("category").count()
result.show()

spark.stop()
```

### Scala Example
```scala
import org.apache.spark.sql.SparkSession

val spark = SparkSession.builder()
  .appName("Scala App")
  .master("spark://spark-master:7077")
  .getOrCreate()

import spark.implicits._

val data = Seq(("Alice", 25), ("Bob", 30), ("Charlie", 35))
val df = data.toDF("name", "age")

df.show()
spark.stop()
```

## Data Sources

### File Formats
- Parquet
- JSON
- CSV
- Avro
- ORC

### Databases
Configure JDBC connections:
```python
df = spark.read.format("jdbc") \
    .option("url", "jdbc:postgresql://postgres:5432/mydb") \
    .option("dbtable", "mytable") \
    .option("user", "username") \
    .option("password", "password") \
    .load()
```

### Streaming
```python
from pyspark.streaming import StreamingContext

ssc = StreamingContext(spark.sparkContext, 10)
lines = ssc.socketTextStream("localhost", 9999)
words = lines.flatMap(lambda line: line.split(" "))
word_counts = words.map(lambda word: (word, 1)).reduceByKey(lambda a, b: a + b)
word_counts.pprint()

ssc.start()
ssc.awaitTermination()
```

## Jupyter Integration

### PySpark in Jupyter
```python
import os
import sys

# Set Spark path
os.environ['SPARK_HOME'] = '/opt/bitnami/spark'
sys.path.append('/opt/bitnami/spark/python')

from pyspark.sql import SparkSession

spark = SparkSession.builder \
    .appName("Jupyter Spark") \
    .master("spark://spark-master:7077") \
    .getOrCreate()
```

## Performance Tuning

### Memory Settings
```bash
export SPARK_WORKER_MEMORY=4g
export SPARK_EXECUTOR_MEMORY=2g
export SPARK_DRIVER_MEMORY=1g
```

### Parallelism
```python
spark.conf.set("spark.sql.adaptive.enabled", "true")
spark.conf.set("spark.sql.adaptive.coalescePartitions.enabled", "true")
spark.conf.set("spark.sql.adaptive.skewJoin.enabled", "true")
```

## Monitoring

### Spark UI
- Application tracking
- Job execution details
- Storage information
- Environment settings

### History Server
Track completed applications:
```bash
docker-compose --profile history up -d
```

### Metrics
Configure metrics collection:
```python
spark.conf.set("spark.metrics.conf.*.sink.prometheus.class", 
               "org.apache.spark.metrics.sink.PrometheusServlet")
```

## Scaling

### Add Workers
```bash
docker-compose up --scale spark-worker-1=3 -d
```

### Dynamic Allocation
```python
spark = SparkSession.builder \
    .appName("Dynamic App") \
    .config("spark.dynamicAllocation.enabled", "true") \
    .config("spark.dynamicAllocation.minExecutors", "1") \
    .config("spark.dynamicAllocation.maxExecutors", "10") \
    .getOrCreate()
```

## Production Deployment

### Kubernetes
Use Spark on Kubernetes:
```bash
spark-submit \
  --master k8s://https://kubernetes-api:443 \
  --deploy-mode cluster \
  --conf spark.kubernetes.container.image=spark:latest \
  my-app.py
```

### Hadoop Integration
```yaml
environment:
  - HADOOP_CONF_DIR=/opt/hadoop/etc/hadoop
volumes:
  - ./hadoop-conf:/opt/hadoop/etc/hadoop:ro
```

## Storage Integration

### HDFS
```python
df = spark.read.parquet("hdfs://namenode:9000/path/to/data")
```

### S3 (via MinIO)
```python
spark.conf.set("spark.hadoop.fs.s3a.endpoint", "http://minio:9000")
spark.conf.set("spark.hadoop.fs.s3a.access.key", "minioadmin")
spark.conf.set("spark.hadoop.fs.s3a.secret.key", "minioadmin")

df = spark.read.parquet("s3a://bucket/path/to/data")
```

## Troubleshooting

- Check cluster status: http://localhost:8080
- View application logs in Spark UI
- Monitor resource usage per worker
- Check network connectivity between services
- Verify memory and CPU allocation
