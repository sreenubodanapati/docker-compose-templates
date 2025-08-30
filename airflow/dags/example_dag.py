from datetime import datetime, timedelta
from airflow import DAG
from airflow.operators.bash import BashOperator
from airflow.operators.python import PythonOperator

# Default arguments
default_args = {
    'owner': 'airflow',
    'depends_on_past': False,
    'start_date': datetime(2024, 1, 1),
    'email_on_failure': False,
    'email_on_retry': False,
    'retries': 1,
    'retry_delay': timedelta(minutes=5),
}

# Define DAG
dag = DAG(
    'example_dag',
    default_args=default_args,
    description='A simple example DAG',
    schedule=timedelta(days=1),
    catchup=False,
    tags=['example'],
)

def print_hello():
    print("Hello from Airflow!")
    return "Hello from Airflow!"

# Tasks
hello_task = PythonOperator(
    task_id='hello_task',
    python_callable=print_hello,
    dag=dag,
)

bash_task = BashOperator(
    task_id='bash_task',
    bash_command='echo "Hello from Bash!" && date',
    dag=dag,
)

# Set task dependencies
hello_task >> bash_task
