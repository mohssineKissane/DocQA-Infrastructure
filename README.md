# DocQA-MS Infrastructure

Infrastructure repository for the DocQA Medical Document QA System. This repository contains orchestration files, configuration, and scripts to deploy and manage all microservices.

## 🏗️ System Overview

DocQA-MS is a microservices-based medical document processing and question-answering system consisting of:

- **DocIngestor** - Document upload and text extraction
- **DeID** - Patient information anonymization
- **SemanticIndexer** - Vector embeddings and semantic search
- **LLMQAModule** - Question answering with local LLM

## 📋 Prerequisites

- Docker Desktop (Windows/Mac) or Docker Engine (Linux)
- Docker Compose v2.0+
- Git
- 16GB+ RAM recommended
- GPU with NVIDIA drivers (optional, for LLM acceleration)

## 🚀 Quick Start

### 1. Clone This Repository

```bash
git clone <infrastructure-repo-url> infrastructure
cd infrastructure
```

### 2. Run Setup Script

**Windows (PowerShell):**
```powershell
.\scripts\setup.ps1
```

**Linux/Mac:**
```bash
chmod +x scripts/setup.sh
./scripts/setup.sh
```

### 3. Configure Environment

Edit the generated `.env` file:

```bash
notepad .env  # Windows
nano .env     # Linux/Mac
```

Update passwords and credentials (never use defaults in production!).

### 4. Clone Microservices

Clone each microservice repository in the parent directory:

```bash
cd ..
git clone <docingestor-repo-url> DocIngestor
git clone <deid-repo-url> DeID
git clone <semantic-indexer-repo-url> SemanticIndexer
git clone <llmqa-repo-url> LLMQAModule
```

Your structure should be:
```
DocQA-MS/
├── infrastructure/     (this repo)
├── DocIngestor/
├── DeID/
├── SemanticIndexer/
└── LLMQAModule/
```

### 5. Start All Services

```bash
cd infrastructure
docker-compose up -d
```

Or use the start script:
```bash
.\scripts\start.ps1  # Windows
./scripts/start.sh   # Linux/Mac
```

### 6. Access Services

- **DocIngestor API**: http://localhost:8001/docs
- **DeID API**: http://localhost:8002/docs
- **SemanticIndexer API**: http://localhost:8003/docs
- **LLMQAModule API**: http://localhost:8004/docs
- **RabbitMQ Management**: http://localhost:15672
- **MinIO Console**: http://localhost:9001

## 📁 Repository Structure

```
infrastructure/
├── docker-compose.yml          # Main orchestration file
├── .env.example                # Environment variables template
├── .gitignore                  # Git ignore patterns
├── README.md                   # This file
├── scripts/
│   ├── setup.sh/.ps1          # Initial setup script
│   ├── start.sh/.ps1          # Start all services
│   ├── stop.sh/.ps1           # Stop all services
│   └── init-db.sql            # Database initialization
└── docs/
    ├── architecture.md        # System architecture
    ├── deployment.md          # Deployment guide
    └── development.md         # Development guide
```

## 🛠️ Common Operations

### View Logs

```bash
# All services
docker-compose logs -f

# Specific service
docker-compose logs -f docingestor
```

### Restart a Service

```bash
docker-compose restart docingestor
```

### Stop All Services

```bash
docker-compose down

# Or use script
.\scripts\stop.ps1  # Windows
./scripts/stop.sh   # Linux/Mac
```

### Rebuild After Code Changes

```bash
docker-compose up -d --build docingestor
```

### Reset Everything (Delete All Data)

**⚠️ WARNING: This deletes all databases and uploaded files!**

```bash
docker-compose down -v
```

## 🔧 Configuration

### Environment Variables

Key variables in `.env`:

| Variable | Description | Default |
|----------|-------------|---------|
| `POSTGRES_USER` | PostgreSQL username | docqa_admin |
| `POSTGRES_PASSWORD` | PostgreSQL password | change_this |
| `RABBITMQ_USER` | RabbitMQ username | docqa_rabbit |
| `RABBITMQ_PASSWORD` | RabbitMQ password | change_this |
| `MINIO_ROOT_USER` | MinIO access key | docqa_minio |
| `MINIO_ROOT_PASSWORD` | MinIO secret key | change_this |
| `EMBEDDING_MODEL` | Embedding model | all-MiniLM-L6-v2 |
| `LLM_MODEL` | LLM model file | llama-2-7b-chat.gguf |

### Service Ports

| Service | Port | Description |
|---------|------|-------------|
| DocIngestor | 8001 | Document ingestion API |
| DeID | 8002 | Anonymization API |
| SemanticIndexer | 8003 | Vector search API |
| LLMQAModule | 8004 | Q&A API |
| PostgreSQL | 5432 | Database |
| RabbitMQ | 5672 | Message queue |
| RabbitMQ Mgmt | 15672 | Web UI |
| MinIO | 9000 | Object storage |
| MinIO Console | 9001 | Web UI |

## 📚 Documentation

- **[Architecture Guide](docs/architecture.md)** - System design and data flow
- **[Deployment Guide](docs/deployment.md)** - Detailed deployment instructions
- **[Development Guide](docs/development.md)** - Local development setup

## 🔍 Troubleshooting

### Services Won't Start

1. Check logs: `docker-compose logs [service-name]`
2. Verify ports aren't in use: `netstat -ano | findstr :8001`
3. Ensure Docker has enough resources (RAM, CPU)

### Database Connection Issues

1. Check PostgreSQL is running: `docker-compose ps postgres`
2. Verify credentials in `.env`
3. Check database was initialized: `docker exec -it docqa-postgres psql -U docqa_admin -l`

### Out of Memory

1. Increase Docker Desktop memory (Settings → Resources)
2. Use smaller LLM model
3. Reduce number of concurrent services

## 🏥 Production Deployment

For production deployment:

1. ✅ Use strong passwords in `.env`
2. ✅ Enable SSL/TLS with reverse proxy
3. ✅ Use managed database services
4. ✅ Implement proper authentication (Auth0)
5. ✅ Add monitoring (Prometheus, Grafana)
6. ✅ Configure backups
7. ✅ Use Kubernetes for orchestration

See [deployment.md](docs/deployment.md) for detailed production setup.

## 🤝 Contributing

Each microservice is in a separate repository. See individual service READMEs for contribution guidelines.

For infrastructure changes:
1. Create a feature branch
2. Make changes
3. Test with `docker-compose up --build`
4. Submit pull request

## 📝 License

[Your License Here]

## 🆘 Support

- **Documentation**: See `docs/` directory
- **Issues**: Create issue in relevant repository
- **Architecture Questions**: See `docs/architecture.md`

## 🔗 Related Repositories

- [DocIngestor](link) - Document ingestion service
- [DeID](link) - Anonymization service
- [SemanticIndexer](link) - Vector indexing service
- [LLMQAModule](link) - Q&A service

---

**Built for medical document processing with privacy and compliance in mind.**
