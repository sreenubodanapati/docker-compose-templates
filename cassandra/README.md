# Cassandra Docker Compose Setup

This directory contains a complete Apache Cassandra cluster setup with Docker Compose, configured as a 3-node cluster for high availability and distributed data storage.

## Features

- **Apache Cassandra 4.1**: Latest stable version
- **3-Node Cluster**: High availability and fault tolerance
- **Auto-scaling**: Easy to add more nodes
- **Persistent Storage**: Data persists in Docker volumes
- **Health Checks**: Built-in cluster health monitoring
- **Sample Data**: Pre-configured keyspace and tables

## Quick Start

1. **Start the cluster:**
   ```bash
   docker-compose up -d
   ```

2. **Wait for cluster to be ready (this may take a few minutes):**
   ```bash
   docker-compose logs -f cassandra-node1
   ```

3. **Connect to Cassandra:**
   ```bash
   docker exec -it cassandra-node1 cqlsh
   ```

4. **Check cluster status:**
   ```cql
   DESCRIBE KEYSPACES;
   USE app_data;
   SELECT * FROM users;
   ```

5. **Stop the cluster:**
   ```bash
   docker-compose down
   ```

## Configuration

### Cluster Settings

- **Cluster Name**: MyCluster
- **Datacenter**: datacenter1
- **Replication Factor**: 3 (one copy on each node)
- **Consistency Level**: Configurable per query

### Node Configuration

Each node is configured with:
- **Memory**: 2GB heap size, 400MB new generation
- **Tokens**: 128 virtual nodes per physical node
- **Snitch**: GossipingPropertyFileSnitch for multi-datacenter awareness

## File Structure

```
cassandra/
├── docker-compose.yml        # Main compose file
├── README.md                 # This file
├── config/
│   └── cassandra.yaml       # Cassandra configuration
└── init-scripts/
    └── init.cql             # Database initialization script
```

## Services

### Cassandra Node 1 (Primary)
- **Ports**: 9042 (CQL), 7000 (Inter-node), 7199 (JMX)
- **Role**: Seed node, first to start

### Cassandra Node 2
- **Port**: 9043 (CQL mapped to external)
- **Role**: Secondary node

### Cassandra Node 3
- **Port**: 9044 (CQL mapped to external)
- **Role**: Secondary node

## Volumes

- `cassandra_data_1`: Data for node 1
- `cassandra_data_2`: Data for node 2
- `cassandra_data_3`: Data for node 3

## Networking

- Network: `cassandra_network` (bridge driver)
- Internal communication on ports 7000-7001
- Client connections on port 9042

## Sample Schema

The initialization script creates:

### Keyspace: `app_data`
```cql
CREATE KEYSPACE app_data 
WITH REPLICATION = {
    'class': 'NetworkTopologyStrategy',
    'datacenter1': 3
};
```

### Tables:
- **users**: User information with UUID primary key
- **logs**: Time-series logging data
- **metrics**: Counter-based metrics

## Common Operations

### 1. Check Cluster Status
```bash
docker exec -it cassandra-node1 nodetool status
```

### 2. Connect to CQL Shell
```bash
docker exec -it cassandra-node1 cqlsh
```

### 3. View Keyspaces
```cql
DESCRIBE KEYSPACES;
```

### 4. Check Ring Status
```bash
docker exec -it cassandra-node1 nodetool ring
```

### 5. Repair a Node
```bash
docker exec -it cassandra-node1 nodetool repair
```

### 6. View Node Info
```bash
docker exec -it cassandra-node1 nodetool info
```

## Scaling

### Adding More Nodes

1. Add a new service to `docker-compose.yml`:
```yaml
cassandra-node4:
  image: cassandra:4.1
  container_name: cassandra-node4
  environment:
    - CASSANDRA_SEEDS=cassandra-node1
    - CASSANDRA_CLUSTER_NAME=MyCluster
    - CASSANDRA_DC=datacenter1
    - CASSANDRA_RACK=rack4
  # ... other configurations
```

2. Start the new node:
```bash
docker-compose up -d cassandra-node4
```

### Removing Nodes

1. Decommission the node:
```bash
docker exec -it cassandra-node3 nodetool decommission
```

2. Remove from compose file and restart

## Production Considerations

1. **Security**:
   - Enable authentication (`PasswordAuthenticator`)
   - Configure SSL/TLS encryption
   - Set up proper network security

2. **Performance**:
   - Adjust memory settings based on available resources
   - Configure appropriate compaction strategies
   - Monitor GC performance

3. **Backup**:
   - Set up regular snapshot schedules
   - Configure incremental backups
   - Test restore procedures

4. **Monitoring**:
   - Use JMX metrics for monitoring
   - Set up alerting for cluster health
   - Monitor disk space and performance

## Troubleshooting

- **Nodes Not Joining**: Check network connectivity and seed configuration
- **Memory Issues**: Adjust heap sizes in environment variables
- **Startup Delays**: Cassandra can take several minutes to fully start
- **Split Brain**: Ensure odd number of nodes and proper seed configuration
- **Performance Issues**: Check compaction settings and GC tuning

## Best Practices

1. **Always use odd number of nodes** (3, 5, 7) for better quorum decisions
2. **Set appropriate replication factor** based on cluster size
3. **Use NetworkTopologyStrategy** for production deployments
4. **Monitor cluster health** regularly
5. **Plan for capacity** and scale before reaching limits
6. **Regular maintenance** including repairs and compaction
