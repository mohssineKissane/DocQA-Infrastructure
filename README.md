# DocQA-MS Infrastructure

Infrastructure repository for the DocQA Medical Document QA System. This repository contains orchestration files, configuration, and scripts to deploy and manage all microservices.

## 🏗️ System Overview

DocQA-MS is a microservices-based medical document processing and question-answering system consisting of:

- **NGINX Gateway** - Unified API gateway with CORS support
- **DocIngestor** - Document upload and text extraction
- **DeID** - Patient information anonymization
- **SemanticIndexer** - Vector embeddings and semantic search
- **LLMQAModule** - Question answering with Groq LLM

### Infrastructure Components

- **PostgreSQL** - Shared database for all services
- **RabbitMQ** - Message queue for async processing
- **MinIO** - S3-compatible object storage
- **Apache Tika** - Document text extraction
- **Adminer** - Database management UI

## 📋 Prerequisites

- Docker Desktop (Windows/Mac) or Docker Engine (Linux)
- Docker Compose v2.0+
- Git
- 16GB+ RAM recommended
- GPU with NVIDIA drivers (optional, for LLM acceleration)

## 🚀 Quick Start

### 1. Clone All Repositories

Create a parent directory and clone all repositories:

```bash
mkdir DocQA-MS
cd DocQA-MS
git clone <infrastructure-repo-url> DocQA-infrastructure
git clone <docingestor-repo-url> DocQA-DocIngestor
git clone <deid-repo-url> DocQA-DeID
git clone <semantic-indexer-repo-url> DocQA-SemanticIndexer
git clone <llmqa-repo-url> DocQA-LLMQAModule
```

Your structure should be:
```
DocQA-MS/
├── DocQA-infrastructure/   (this repo)
├── DocQA-DocIngestor/
├── DocQA-DeID/
├── DocQA-SemanticIndexer/
└── DocQA-LLMQAModule/
```

### 2. Configure Environment

Create `.env` file from template:

```bash
cd DocQA-infrastructure
copy .env.example .env     # Windows
cp .env.example .env       # Linux/Mac
```

Edit the `.env` file and update:
- **LLM_API_KEY**: Your Groq API key (required)
- **POSTGRES_PASSWORD**: Strong password for database
- **RABBITMQ_PASSWORD**: Strong password for message queue
- **MINIO_ROOT_PASSWORD**: Strong password for object storage

```bash
notepad .env  # Windows
nano .env     # Linux/Mac
```

### 3. Start All Services

From the `DocQA-infrastructure` directory:

```bash
docker-compose up -d
```

This single command will:
- Build all microservice Docker images
- Start PostgreSQL, RabbitMQ, MinIO, Tika, NGINX
- Start all 4 microservices (DocIngestor, DeID, SemanticIndexer, LLMQAModule)
- Initialize databases automatically
- Configure networking between services

**Note**: First-time startup takes 5-10 minutes to build images.

### 6. Access Services

#### Through NGINX Gateway (Recommended)

All microservices are accessible through NGINX reverse proxy on port 80:

- **Unified API Gateway**: http://localhost/
- **DocIngestor API**: http://localhost/api/ingestor/
- **DeID API**: http://localhost/api/deid/
- **SemanticIndexer API**: http://localhost/api/indexer/
- **LLM QA API**: http://localhost/api/qa/
- **Health Check**: http://localhost/health

#### Direct Service Access

For development or debugging, access services directly:

- **DocIngestor**: http://localhost:8001/docs
- **DeID**: http://localhost:8002/docs
- **SemanticIndexer**: http://localhost:8003/docs
- **LLMQAModule**: http://localhost:8004/docs

#### Management Interfaces

- **RabbitMQ Management**: http://localhost:15672 (user: docqa_rabbit)
- **MinIO Console**: http://localhost:9001 (user: docqa_minio)
- **Adminer (Database)**: http://localhost:8080

### 7. Verify Services

Check all containers are running:

```bash
docker-compose ps
```

All services should show status "Up" or "healthy".

## 📁 Repository Structure

```
infrastructure/
├── docker-compose.yml          # Main orchestration file
├── nginx.conf                  # NGINX gateway configuration
├── .env.example                # Environment variables template
├── .env                        # Environment variables (create from .env.example)
├── .gitignore                  # Git ignore patterns
├── README.md                   # This file
├── scripts/
│   └── init-db.sql            # Database initialization
├── logs/                       # Service logs directory
└── docs/
    ├── architecture.md        # System architecture
    ├── deployment.md          # Deployment guide
    └── development.md         # Development guide
```

## 🛠️ Common Operations

### Using the API Gateway

All API requests should go through NGINX at http://localhost:

Upload a document:
```bash
curl -X POST http://localhost/api/ingestor/documents \
  -F "file=@document.pdf" \
  -F "metadata={\"category\":\"medical\"}"
```

Search documents:
```bash
curl -X POST http://localhost/api/indexer/search \
  -H "Content-Type: application/json" \
  -d '{"query":"diabetes treatment","top_k":5}'
```

Ask a question:
```bash
curl -X POST http://localhost/api/qa/query \
  -H "Content-Type: application/json" \
  -d '{"question":"What is the treatment for diabetes?"}'
```

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
```

To also remove all data (databases, files):

**⚠️ WARNING: This deletes everything!**

```bash
docker-compose down -v
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
| `LLM_API_KEY` | Groq API key | your_groq_key |
| `LLM_API_MODEL` | Groq model | llama-3.3-70b-versatile |
| `LLM_API_BASE_URL` | Groq API base URL | https://api.groq.com/openai/v1 |

### Service Ports

| Service | Port | Description |
|---------|------|-------------|
| NGINX Gateway | 80/443 | Unified API gateway (recommended) |
| DocIngestor | 8001 | Document ingestion API (direct) |
| DeID | 8002 | Anonymization API (direct) |
| SemanticIndexer | 8003 | Vector search API (direct) |
| LLMQAModule | 8004 | Q&A API (direct) |
| PostgreSQL | 5432 | Database |
| RabbitMQ | 5672 | Message queue |
| RabbitMQ Mgmt | 15672 | Web UI |
| MinIO | 9000 | Object storage |
| MinIO Console | 9001 | Web UI |
| Adminer | 8080 | Database admin UI |
| Tika | 9998 | Document text extraction |

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
