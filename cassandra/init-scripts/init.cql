-- Cassandra initialization script
-- This script creates a sample keyspace and table with some data

-- Create keyspace
CREATE KEYSPACE IF NOT EXISTS app_data 
WITH REPLICATION = {
    'class': 'NetworkTopologyStrategy',
    'datacenter1': 3
};

-- Use the keyspace
USE app_data;

-- Create users table
CREATE TABLE IF NOT EXISTS users (
    user_id UUID PRIMARY KEY,
    username TEXT,
    email TEXT,
    first_name TEXT,
    last_name TEXT,
    created_at TIMESTAMP,
    updated_at TIMESTAMP
);

-- Create secondary index on email
CREATE INDEX IF NOT EXISTS ON users (email);

-- Insert sample data
INSERT INTO users (user_id, username, email, first_name, last_name, created_at, updated_at)
VALUES (uuid(), 'john.doe', 'john.doe@example.com', 'John', 'Doe', toTimestamp(now()), toTimestamp(now()));

INSERT INTO users (user_id, username, email, first_name, last_name, created_at, updated_at)
VALUES (uuid(), 'jane.smith', 'jane.smith@example.com', 'Jane', 'Smith', toTimestamp(now()), toTimestamp(now()));

-- Create logs table for time-series data
CREATE TABLE IF NOT EXISTS logs (
    log_id TIMEUUID,
    application TEXT,
    level TEXT,
    message TEXT,
    timestamp TIMESTAMP,
    PRIMARY KEY (application, log_id)
) WITH CLUSTERING ORDER BY (log_id DESC);

-- Insert sample log data
INSERT INTO logs (log_id, application, level, message, timestamp)
VALUES (now(), 'webapp', 'INFO', 'Application started successfully', toTimestamp(now()));

INSERT INTO logs (log_id, application, level, message, timestamp)
VALUES (now(), 'webapp', 'ERROR', 'Failed to connect to database', toTimestamp(now()));

-- Create counter table for metrics
CREATE TABLE IF NOT EXISTS metrics (
    metric_name TEXT,
    date DATE,
    value COUNTER,
    PRIMARY KEY (metric_name, date)
);

-- Update counter values
UPDATE metrics SET value = value + 1 WHERE metric_name = 'page_views' AND date = '2024-01-01';
UPDATE metrics SET value = value + 5 WHERE metric_name = 'user_registrations' AND date = '2024-01-01';
