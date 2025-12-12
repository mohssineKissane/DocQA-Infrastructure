# 🎉 Docker Deployment Setup - COMPLETE!

## ✅ All Changes Applied Successfully

### 1. **docker-compose.yml** - Fixed & Enhanced
- ✅ Fixed folder paths:
  - `../DocIngestor` → `../DocQA-DocIngestor`
  - `../DeID` → `../DocQA-DeID`
  - `../SemanticIndexer` → `../DocQA-SemanticIndexer`
  - `../LLMQAModule` → `../DocQA-LLMQAModule`
- ✅ Added NGINX reverse proxy service
- ✅ Updated LLM service to use Groq API (removed GPU requirement)
- ✅ Added DeID service URL for name resolution
- ✅ Removed unused `llm_models` volume

### 2. **.env** - Updated with Groq Configuration
- ✅ Added Groq API key from your LLMQAModule .env
- ✅ Added Groq API model configuration
- ✅ Added Groq API base URL
- ✅ Removed old local LLM configuration

### 3. **Scripts** - Improved & Created
- ✅ Enhanced `start.ps1` with health checks and better output
- ✅ Updated `stop.ps1` with better formatting
- ✅ Created `logs.ps1` for easy log viewing

### 4. **Documentation**
- ✅ Created `DOCKER_GUIDE.md` with complete reference

---

## 🚀 How to Start Everything

### **Step 1: Navigate to Infrastructure**
```powershell
cd c:\Users\kissa\OneDrive\Desktop\DocQA-MS\DocQA-infrastructure
```

### **Step 2: Start All Services**
```powershell
.\scripts\start.ps1
```

This will:
1. Check if Docker is running
2. Verify .env configuration exists
3. Pull Docker images
4. Start all services (Postgres, RabbitMQ, MinIO, Tika, NGINX, + 4 microservices)
5. Display all available endpoints

### **Step 3: Wait ~30-60 seconds**
Services need time to initialize. You can check status:
```powershell
docker-compose ps
```

### **Step 4: Test the Services**
Open in browser:
- **API Gateway**: http://localhost/api/qa/docs
- **DocIngestor**: http://localhost:8001/docs
- **RabbitMQ**: http://localhost:15672

---

## 🌐 Frontend Configuration

Your frontend should now call the **NGINX gateway** instead of individual ports:

### **Old Configuration (Local Development)**
```javascript
const DOCINGESTOR_API = 'http://localhost:8001'
const DEID_API = 'http://localhost:8002'
const INDEXER_API = 'http://localhost:8003'
const QA_API = 'http://localhost:8004'
```

### **New Configuration (Docker with NGINX)**
```javascript
const API_BASE = 'http://localhost'

// Then use:
// ${API_BASE}/api/ingestor/upload
// ${API_BASE}/api/deid/anonymize
// ${API_BASE}/api/indexer/search
// ${API_BASE}/api/qa/query
```

**OR** Keep using individual ports (they're still exposed):
```javascript
// Works the same as before!
const QA_API = 'http://localhost:8004'
```

---

## 📊 What's Running?

After starting, you'll have **9 containers**:

| Service | Container Name | Port | Purpose |
|---------|---------------|------|---------|
| PostgreSQL | docqa-postgres | 5432 | Database |
| RabbitMQ | docqa-rabbitmq | 5672, 15672 | Message Queue |
| MinIO | docqa-minio | 9000, 9001 | File Storage |
| Tika | docqa-tika | 9998 | Text Extraction |
| Adminer | docqa-adminer | 8080 | DB Management |
| **DocIngestor** | docqa-docingestor | 8001 | Document Upload |
| **DeID** | docqa-deid | 8002 | Anonymization |
| **SemanticIndexer** | docqa-semantic-indexer | 8003 | Vector Search |
| **LLMQA** | docqa-llmqa | 8004 | Question Answering |
| **NGINX** | docqa-nginx | 80, 443 | API Gateway |

---

## 🔍 Verify Everything Works

### **Test 1: Check All Services Running**
```powershell
docker-compose ps
```
All should show "Up" and "healthy"

### **Test 2: Test API Gateway**
```powershell
# Test QA service through NGINX
curl http://localhost/api/qa/health

# Test direct access
curl http://localhost:8004/health
```

### **Test 3: View Logs**
```powershell
# All services
.\scripts\logs.ps1

# Specific service
.\scripts\logs.ps1 -Service llmqa
```

---

## 🛠️ Common Operations

### View Logs
```powershell
docker-compose logs -f llmqa          # QA module
docker-compose logs -f docingestor    # Document ingestor
docker-compose logs -f                # All services
```

### Restart a Service
```powershell
docker-compose restart llmqa
```

### Rebuild After Code Changes
```powershell
docker-compose up -d --build llmqa
```

### Stop Everything
```powershell
.\scripts\stop.ps1
```

### Stop and Remove All Data (⚠️ WARNING)
```powershell
docker-compose down -v
```

---

## 🎯 Next Steps

1. **Start the services**: Run `.\scripts\start.ps1`
2. **Update frontend**: Change API endpoints to use NGINX gateway
3. **Test the flow**: Upload a document, ask questions
4. **Monitor**: Check logs if anything goes wrong

---

## 📞 Troubleshooting

### Problem: Services won't start
**Solution**: Check Docker is running:
```powershell
docker info
```

### Problem: Port already in use
**Solution**: Stop other services using these ports or change ports in `.env`

### Problem: "context path not found"
**Solution**: Verify you're running from `DocQA-infrastructure` folder

### Problem: Database connection errors
**Solution**: Wait 30 seconds for Postgres to initialize, or check logs:
```powershell
docker-compose logs postgres
```

---

## ✨ What Changed vs Local Development

| Aspect | Before (Local) | After (Docker) |
|--------|----------------|----------------|
| **Startup** | Run 4 terminals, start each service | One command: `.\scripts\start.ps1` |
| **Dependencies** | Install Python, Postgres, RabbitMQ, MinIO manually | All in Docker containers |
| **Configuration** | 4 separate .env files | One centralized .env |
| **API Access** | 4 different ports | Unified via NGINX or individual ports |
| **Database** | Local Postgres setup | Docker container with auto-init |
| **Logs** | Check 4 terminal windows | `docker-compose logs` |
| **Cleanup** | Stop 4 processes | `.\scripts\stop.ps1` |

---

## 🎊 You're All Set!

Everything is configured and ready to go. Just run:

```powershell
cd c:\Users\kissa\OneDrive\Desktop\DocQA-MS\DocQA-infrastructure
.\scripts\start.ps1
```

And you'll have all 4 microservices running in Docker! 🚀
