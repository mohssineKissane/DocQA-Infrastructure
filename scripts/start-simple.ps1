# DocQA-MS Start Script (PowerShell)
# Starts all services using docker-compose

Write-Host "================================================" -ForegroundColor Cyan
Write-Host "  Starting DocQA-MS Microservices Stack" -ForegroundColor Cyan
Write-Host "================================================" -ForegroundColor Cyan
Write-Host ""

# Check if Docker is running
Write-Host "[1/4] Checking Docker..." -ForegroundColor Yellow
try {
    docker info | Out-Null
    Write-Host "  [OK] Docker is running" -ForegroundColor Green
} catch {
    Write-Host "  [ERROR] Docker is not running. Please start Docker Desktop first." -ForegroundColor Red
    exit 1
}

# Navigate to infrastructure directory
$scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location (Split-Path -Parent $scriptPath)

# Check if .env file exists
Write-Host "[2/4] Checking configuration..." -ForegroundColor Yellow
if (-not (Test-Path ".env")) {
    Write-Host "  [ERROR] .env file not found. Copying from .env.example..." -ForegroundColor Yellow
    Copy-Item ".env.example" ".env"
    Write-Host "  [WARNING] Please edit .env file with your configuration!" -ForegroundColor Red
    exit 1
}
Write-Host "  [OK] Configuration found" -ForegroundColor Green

# Pull latest images (optional, comment out if not needed)
Write-Host "[3/4] Pulling Docker images..." -ForegroundColor Yellow
docker-compose pull

# Start services
Write-Host "[4/4] Starting services..." -ForegroundColor Yellow
docker-compose up -d

Write-Host ""
Write-Host "================================================" -ForegroundColor Cyan
Write-Host "  Waiting for services to become healthy..." -ForegroundColor Cyan
Write-Host "================================================" -ForegroundColor Cyan
Start-Sleep -Seconds 5

# Check service status
Write-Host ""
docker-compose ps

Write-Host ""
Write-Host "================================================" -ForegroundColor Green
Write-Host "  [SUCCESS] DocQA-MS Services Started!" -ForegroundColor Green
Write-Host "================================================" -ForegroundColor Green
Write-Host ""
Write-Host "Services are available at:" -ForegroundColor Cyan
Write-Host ""
Write-Host "  Frontend API Gateway (NGINX):" -ForegroundColor Yellow
Write-Host "  - http://localhost/api/ingestor/   - Document Upload" -ForegroundColor White
Write-Host "  - http://localhost/api/deid/       - De-identification" -ForegroundColor White
Write-Host "  - http://localhost/api/indexer/    - Semantic Search" -ForegroundColor White
Write-Host "  - http://localhost/api/qa/         - Question Answering" -ForegroundColor White
Write-Host ""
Write-Host "  Direct Service Access:" -ForegroundColor Yellow
Write-Host "  - http://localhost:8001/docs       - DocIngestor API" -ForegroundColor White
Write-Host "  - http://localhost:8002/docs       - DeID API" -ForegroundColor White
Write-Host "  - http://localhost:8003/docs       - SemanticIndexer API" -ForegroundColor White
Write-Host "  - http://localhost:8004/docs       - LLMQA API" -ForegroundColor White
Write-Host ""
Write-Host "  Management Interfaces:" -ForegroundColor Yellow
Write-Host "  - http://localhost:15672           - RabbitMQ (user: see .env)" -ForegroundColor White
Write-Host "  - http://localhost:9001            - MinIO Console (user: see .env)" -ForegroundColor White
Write-Host "  - http://localhost:8080            - Adminer (DB Management)" -ForegroundColor White
Write-Host ""
Write-Host "Useful Commands:" -ForegroundColor Cyan
Write-Host "  - View logs:      docker-compose logs -f [service-name]" -ForegroundColor Gray
Write-Host "  - Stop services:  docker-compose stop" -ForegroundColor Gray
Write-Host "  - Restart:        docker-compose restart [service-name]" -ForegroundColor Gray
Write-Host "  - Check status:   docker-compose ps" -ForegroundColor Gray
Write-Host ""
