# DocQA-MS Docker Deployment - Quick Reference

## 🚀 Quick Start Commands

### Start All Services
```powershell
cd DocQA-infrastructure
.\scripts\start.ps1
```

### Stop All Services
```powershell
cd DocQA-infrastructure
.\scripts\stop.ps1
```

### View Logs
```powershell
# All services
.\scripts\logs.ps1

# Specific service
.\scripts\logs.ps1 -Service llmqa
.\scripts\logs.ps1 -Service docingestor
```

## 📡 Service Endpoints

### Via NGINX Gateway (Recommended for Frontend)
- **DocIngestor**: `http://localhost/api/ingestor/`
- **DeID**: `http://localhost/api/deid/`
- **SemanticIndexer**: `http://localhost/api/indexer/`
- **LLMQA**: `http://localhost/api/qa/`

### Direct Access (for debugging)
- **DocIngestor**: `http://localhost:8001/docs`
- **DeID**: `http://localhost:8002/docs`
- **SemanticIndexer**: `http://localhost:8003/docs`
- **LLMQA**: `http://localhost:8004/docs`

### Management UIs
- **RabbitMQ**: `http://localhost:15672` (check `.env` for credentials)
- **MinIO**: `http://localhost:9001` (check `.env` for credentials)
- **Adminer**: `http://localhost:8080` (PostgreSQL management)

## 🔧 Useful Commands

```powershell
# Check service status
docker-compose ps

# View logs for specific service
docker-compose logs -f llmqa

# Restart a specific service
docker-compose restart llmqa

# Rebuild a service after code changes
docker-compose up -d --build llmqa

# Stop services but keep volumes
docker-compose down

# Stop and remove all data (⚠️ WARNING: deletes databases!)
docker-compose down -v

# Enter a running container
docker exec -it docqa-llmqa bash
```

## 📝 Frontend Integration

Update your frontend to use the NGINX gateway:

```javascript
// Before (local development)
const API_BASE = 'http://localhost:8004'

// After (Docker with NGINX)
const API_BASE = 'http://localhost'

// API calls
fetch(`${API_BASE}/api/qa/query`, {...})
fetch(`${API_BASE}/api/ingestor/upload`, {...})
```

## 🐛 Troubleshooting

### Services not starting?
```powershell
# Check Docker is running
docker info

# Check logs for errors
docker-compose logs

# Restart specific service
docker-compose restart [service-name]
```

### Database connection errors?
```powershell
# Ensure PostgreSQL is healthy
docker-compose ps postgres

# Check PostgreSQL logs
docker-compose logs postgres
```

### Out of disk space?
```powershell
# Clean up unused Docker resources
docker system prune -a

# Remove old volumes (⚠️ WARNING: deletes data!)
docker volume prune
```

## 🔄 Update After Code Changes

```powershell
# Stop services
docker-compose down

# Rebuild specific service
docker-compose build llmqa

# Restart all services
docker-compose up -d
```

## 📊 Service Dependencies

```
┌─────────────┐
│   NGINX     │ ← Frontend calls this
└─────┬───────┘
      │
      ├──→ DocIngestor (8001)
      │      ├──→ PostgreSQL
      │      ├──→ RabbitMQ → DeID
      │      ├──→ MinIO
      │      └──→ Tika
      │
      ├──→ DeID (8002)
      │      ├──→ PostgreSQL
      │      └──→ RabbitMQ → SemanticIndexer
      │
      ├──→ SemanticIndexer (8003)
      │      ├──→ PostgreSQL
      │      ├──→ RabbitMQ
      │      └──→ FAISS Index
      │
      └──→ LLMQA (8004)
             ├──→ PostgreSQL
             ├──→ SemanticIndexer
             ├──→ DeID (for name resolution)
             └──→ Groq API
```

## ✅ Health Checks

All services expose `/health` endpoints:
- `http://localhost/api/ingestor/health`
- `http://localhost/api/deid/health`
- `http://localhost/api/indexer/health`
- `http://localhost/api/qa/health`
