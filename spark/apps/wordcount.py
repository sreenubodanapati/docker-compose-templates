from pyspark.sql import SparkSession
from pyspark.sql.functions import *

# Create Spark session
spark = SparkSession.builder \
    .appName("WordCount Example") \
    .master("spark://spark-master:7077") \
    .config("spark.sql.adaptive.enabled", "true") \
    .config("spark.sql.adaptive.coalescePartitions.enabled", "true") \
    .getOrCreate()

# Sample data
data = ["Hello World", "Hello Spark", "World of Big Data", "Spark is awesome"]
rdd = spark.sparkContext.parallelize(data)

# Word count
word_counts = rdd.flatMap(lambda line: line.split(" ")) \
                .map(lambda word: (word.lower(), 1)) \
                .reduceByKey(lambda a, b: a + b)

# Convert to DataFrame
df = spark.createDataFrame(word_counts, ["word", "count"])

# Show results
print("Word Count Results:")
df.show()

# Write results to file
df.write.mode("overwrite").parquet("/opt/bitnami/spark/data/wordcount_output")

spark.stop()
