# DocQA-MS Development Guide

## Local Development Setup

### Prerequisites

- Docker Desktop with Docker Compose
- Python 3.10+
- Git
- Code editor (VS Code recommended)

### Initial Setup

1. **Clone all repositories** (see deployment.md for details)

2. **Set up Python virtual environment for each service**

```bash
# For DocIngestor
cd DocIngestor
python -m venv venv
source venv/bin/activate  # Linux/Mac
venv\Scripts\activate     # Windows
pip install -r requirements.txt
```

Repeat for each microservice.

3. **Configure infrastructure**

```bash
cd infrastructure
cp .env.example .env
# Edit .env with development settings
```

4. **Start infrastructure services only**

```bash
# Start only database, RabbitMQ, MinIO
docker-compose up -d postgres rabbitmq minio
```

## Development Workflow

### Option 1: Hybrid Development (Recommended)

Run infrastructure in Docker, microservices locally:

```bash
# Terminal 1: Start infrastructure
cd infrastructure
docker-compose up -d postgres rabbitmq minio

# Terminal 2: Run DocIngestor locally
cd DocIngestor
source venv/bin/activate
python -m uvicorn app.main:app --reload --port 8001

# Terminal 3: Run DeID locally
cd DeID
source venv/bin/activate
python -m uvicorn app.main:app --reload --port 8002

# etc.
```

**Benefits**:
- Fast code changes (no rebuild)
- Easy debugging with breakpoints
- Live reload on file changes
- Full IDE integration

### Option 2: Full Docker Development

Run everything in Docker:

```bash
cd infrastructure
docker-compose up --build
```

After code changes:
```bash
docker-compose up -d --build [service-name]
```

## Working on a Microservice

### 1. Create a Feature Branch

```bash
cd DocIngestor
git checkout -b feature/add-pdf-support
```

### 2. Make Changes

Edit code in your preferred editor.

### 3. Test Locally

```bash
# Run service
uvicorn app.main:app --reload --port 8001

# In another terminal, run tests
pytest tests/
```

### 4. Commit Changes

```bash
git add .
git commit -m "Add PDF extraction support"
git push origin feature/add-pdf-support
```

### 5. Create Pull Request

Open PR in the service's repository.

## Testing

### Unit Tests

Each service should have unit tests:

```bash
cd DocIngestor
pytest tests/unit/
```

### Integration Tests

Test service interactions:

```bash
cd DocIngestor
pytest tests/integration/
```

### End-to-End Tests

Test the complete flow:

```bash
cd infrastructure
pytest tests/e2e/
```

## Debugging

### Python Debugger

Add breakpoint in code:

```python
import pdb; pdb.set_trace()
```

Or use VS Code debugger with launch.json:

```json
{
  "version": "0.2.0",
  "configurations": [
    {
      "name": "DocIngestor",
      "type": "python",
      "request": "launch",
      "module": "uvicorn",
      "args": [
        "app.main:app",
        "--reload",
        "--port",
        "8001"
      ],
      "env": {
        "POSTGRES_HOST": "localhost"
      }
    }
  ]
}
```

### Docker Logs

```bash
docker-compose logs -f [service-name]
```

### Database Queries

```bash
# Connect to database
docker exec -it docqa-postgres psql -U docqa_admin -d docingestor_db

# Run queries
SELECT * FROM documents LIMIT 10;
```

### RabbitMQ Inspection

Access management UI: http://localhost:15672

Or use CLI:

```bash
docker exec docqa-rabbitmq rabbitmqctl list_queues
```

## Code Style

### Python

Use Black for formatting:

```bash
pip install black
black app/
```

Use pylint for linting:

```bash
pip install pylint
pylint app/
```

### Pre-commit Hooks

Install pre-commit:

```bash
pip install pre-commit
pre-commit install
```

## API Development

### FastAPI Development

1. Define endpoint in `app/api/routes/`
2. Create Pydantic models in `app/models/`
3. Implement business logic in `app/services/`
4. Test endpoint at http://localhost:8001/docs

### Adding New Endpoint

```python
# app/api/routes/documents.py
from fastapi import APIRouter, UploadFile

router = APIRouter()

@router.post("/upload")
async def upload_document(file: UploadFile):
    # Implementation
    return {"status": "success"}
```

## Database Migrations

Using Alembic:

```bash
# Create migration
alembic revision --autogenerate -m "Add new column"

# Apply migration
alembic upgrade head

# Rollback
alembic downgrade -1
```

## Environment Variables

Each service reads from environment variables:

```python
import os
from pydantic_settings import BaseSettings

class Settings(BaseSettings):
    postgres_host: str = "localhost"
    postgres_port: int = 5432
    
    class Config:
        env_file = ".env"

settings = Settings()
```

## Hot Reload

FastAPI supports hot reload:

```bash
uvicorn app.main:app --reload
```

Changes to Python files trigger automatic restart.

## Common Issues

### Port Already in Use

```bash
# Windows
netstat -ano | findstr :8001
taskkill /PID <pid> /F

# Linux/Mac
lsof -i :8001
kill -9 <pid>
```

### Import Errors

Ensure virtual environment is activated and dependencies installed:

```bash
source venv/bin/activate
pip install -r requirements.txt
```

### Database Connection Refused

If running services locally but database in Docker:

```python
# Use localhost, not postgres
POSTGRES_HOST=localhost
```

## Performance Profiling

### Python Profiling

```python
import cProfile
cProfile.run('your_function()')
```

### Memory Profiling

```bash
pip install memory_profiler
python -m memory_profiler app/main.py
```

## Documentation

### API Documentation

FastAPI auto-generates docs at `/docs` and `/redoc`.

### Code Documentation

Use docstrings:

```python
def process_document(file: UploadFile) -> dict:
    """
    Process an uploaded document.
    
    Args:
        file: The uploaded file
        
    Returns:
        dict: Processing result with document_id
        
    Raises:
        ValueError: If file format is unsupported
    """
    pass
```

## Git Workflow

### Branch Naming

- `feature/description` - New features
- `fix/description` - Bug fixes
- `refactor/description` - Code refactoring
- `docs/description` - Documentation updates

### Commit Messages

Follow conventional commits:

```
feat: add PDF extraction support
fix: resolve memory leak in OCR
docs: update API documentation
refactor: simplify text extraction logic
```

## Collaboration

### Code Reviews

- All changes require PR review
- Run tests before requesting review
- Address reviewer comments
- Squash commits before merge

### Communication

- Use service-specific repos for service issues
- Use infrastructure repo for system-wide issues
- Document decisions in code comments or docs/

## Next Steps

- See `architecture.md` for system design
- See `deployment.md` for production deployment
- Check service-specific READMEs for detailed info
