# DocQA-MS Deployment Guide

## Prerequisites

- Docker Desktop (Windows/Mac) or Docker Engine (Linux)
- Docker Compose v2.0+
- Git
- 16GB+ RAM recommended
- GPU with NVIDIA drivers (optional, for LLM acceleration)

## Quick Start

### 1. Clone Infrastructure Repository

```bash
git clone <infrastructure-repo-url> infrastructure
cd infrastructure
```

### 2. Run Setup Script

**On Windows (PowerShell):**
```powershell
.\scripts\setup.ps1
```

**On Linux/Mac:**
```bash
chmod +x scripts/setup.sh
./scripts/setup.sh
```

### 3. Configure Environment

Edit the `.env` file and update:
- Database passwords
- RabbitMQ credentials
- MinIO access keys
- Service ports (if needed)

```bash
# Edit .env file
notepad .env  # Windows
nano .env     # Linux/Mac
```

### 4. Clone Microservices

Navigate to parent directory and clone each service:

```bash
cd ..
git clone <docingestor-repo-url> DocIngestor
git clone <deid-repo-url> DeID
git clone <semantic-indexer-repo-url> SemanticIndexer
git clone <llmqa-repo-url> LLMQAModule
```

Your directory structure should look like:
```
DocQA-MS/
├── infrastructure/
├── DocIngestor/
├── DeID/
├── SemanticIndexer/
└── LLMQAModule/
```

### 5. Start Services

```bash
cd infrastructure

# Start all services
docker-compose up -d

# Or use the start script
.\scripts\start.ps1  # Windows
./scripts/start.sh   # Linux/Mac
```

### 6. Verify Services

Check that all services are running:

```bash
docker-compose ps
```

All services should show status as "Up" or "healthy".

## Accessing Services

### API Endpoints

- **DocIngestor**: http://localhost:8001/docs
- **DeID**: http://localhost:8002/docs
- **SemanticIndexer**: http://localhost:8003/docs
- **LLMQAModule**: http://localhost:8004/docs

Each service provides an interactive Swagger UI at the `/docs` endpoint.

### Management Interfaces

- **RabbitMQ Management**: http://localhost:15672
  - Username: See `RABBITMQ_USER` in `.env`
  - Password: See `RABBITMQ_PASSWORD` in `.env`

- **MinIO Console**: http://localhost:9001
  - Username: See `MINIO_ROOT_USER` in `.env`
  - Password: See `MINIO_ROOT_PASSWORD` in `.env`

### Database Access

Connect to PostgreSQL:

```bash
# Using docker exec
docker exec -it docqa-postgres psql -U docqa_admin -d docingestor_db

# Or from host (if psql client installed)
psql -h localhost -p 5432 -U docqa_admin -d docingestor_db
```

## Common Operations

### View Logs

```bash
# All services
docker-compose logs -f

# Specific service
docker-compose logs -f docingestor
docker-compose logs -f deid
```

### Restart a Service

```bash
docker-compose restart docingestor
```

### Rebuild a Service

After code changes:

```bash
docker-compose up -d --build docingestor
```

### Stop All Services

```bash
docker-compose down

# Or use stop script
.\scripts\stop.ps1  # Windows
./scripts/stop.sh   # Linux/Mac
```

### Remove All Data (Reset)

**WARNING**: This deletes all databases, uploaded documents, and indexes!

```bash
docker-compose down -v
```

## Troubleshooting

### Service Won't Start

1. Check logs:
   ```bash
   docker-compose logs [service-name]
   ```

2. Verify dependencies are healthy:
   ```bash
   docker-compose ps
   ```

3. Check if ports are already in use:
   ```bash
   netstat -ano | findstr :8001  # Windows
   lsof -i :8001                 # Linux/Mac
   ```

### Database Connection Issues

1. Verify PostgreSQL is running:
   ```bash
   docker-compose ps postgres
   ```

2. Check database was initialized:
   ```bash
   docker exec -it docqa-postgres psql -U docqa_admin -l
   ```

3. Verify credentials in `.env` match service configuration

### RabbitMQ Connection Issues

1. Check RabbitMQ is healthy:
   ```bash
   docker-compose ps rabbitmq
   ```

2. Access management UI and verify queues are created:
   http://localhost:15672

### Out of Memory

If services crash with OOM errors:

1. Increase Docker Desktop memory allocation (Settings → Resources)
2. Reduce number of running services
3. For LLM service, use a smaller model

## Production Deployment

For production deployments:

1. **Use Environment-Specific Configs**
   - Create `.env.production` with strong passwords
   - Use secrets management (AWS Secrets Manager, HashiCorp Vault)

2. **Enable SSL/TLS**
   - Add reverse proxy (nginx) with SSL certificates
   - Configure PostgreSQL SSL connections

3. **Use Managed Services**
   - AWS RDS or Cloud SQL for PostgreSQL
   - AWS ElastiCache or Cloud Memorystore for RabbitMQ
   - AWS S3 or Cloud Storage instead of MinIO

4. **Add Monitoring**
   - Prometheus for metrics
   - Grafana for dashboards
   - ELK stack for centralized logging

5. **Implement Authentication**
   - Add Auth0 or Keycloak
   - Enable JWT token validation
   - Configure CORS properly

6. **Scale Services**
   - Use Kubernetes for orchestration
   - Deploy services to multiple nodes
   - Add load balancers

## Kubernetes Deployment

For Kubernetes deployment, see `k8s-deployment.md` (coming soon).

## Backup and Recovery

### Backup Database

```bash
docker exec docqa-postgres pg_dumpall -U docqa_admin > backup.sql
```

### Restore Database

```bash
cat backup.sql | docker exec -i docqa-postgres psql -U docqa_admin
```

### Backup MinIO Data

```bash
docker exec docqa-minio mc mirror /data /backup
```

### Backup FAISS Index

The FAISS index is stored in a Docker volume. To backup:

```bash
docker run --rm -v docqa-faiss-index:/data -v ${PWD}:/backup alpine tar czf /backup/faiss-backup.tar.gz -C /data .
```

## Support

For issues and questions:
- Check documentation in `docs/` directory
- Review service-specific README files
- Check container logs for errors
- Verify environment configuration
