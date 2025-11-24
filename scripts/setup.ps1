# ===========================================
# DocQA-MS Setup Script (PowerShell)
# ===========================================
# This script sets up the complete DocQA-MS system
# Run this once when setting up a new development environment

Write-Host "==================================" -ForegroundColor Cyan
Write-Host "DocQA-MS System Setup" -ForegroundColor Cyan
Write-Host "==================================" -ForegroundColor Cyan

# Check if we're in the infrastructure directory
if (-not (Test-Path "docker-compose.yml")) {
    Write-Host "Error: Please run this script from the infrastructure directory" -ForegroundColor Red
    exit 1
}

# Check if .env exists
if (-not (Test-Path ".env")) {
    Write-Host "Creating .env file from .env.example..." -ForegroundColor Yellow
    Copy-Item ".env.example" ".env"
    Write-Host "✓ Created .env file" -ForegroundColor Green
    Write-Host "⚠️  Please edit .env and update passwords before running docker-compose!" -ForegroundColor Yellow
} else {
    Write-Host "✓ .env file already exists" -ForegroundColor Green
}

# Create log directories
Write-Host "Creating log directories..." -ForegroundColor Yellow
New-Item -ItemType Directory -Force -Path "logs/docingestor" | Out-Null
New-Item -ItemType Directory -Force -Path "logs/deid" | Out-Null
New-Item -ItemType Directory -Force -Path "logs/semantic-indexer" | Out-Null
New-Item -ItemType Directory -Force -Path "logs/llmqa" | Out-Null
Write-Host "✓ Log directories created" -ForegroundColor Green

# Check if microservice directories exist
Write-Host ""
Write-Host "Checking microservice repositories..." -ForegroundColor Yellow
Set-Location ..

$services = @("DocIngestor", "DeID", "SemanticIndexer", "LLMQAModule")
$missingServices = @()

foreach ($service in $services) {
    if (-not (Test-Path $service)) {
        Write-Host "✗ $service directory not found" -ForegroundColor Red
        $missingServices += $service
    } else {
        Write-Host "✓ $service found" -ForegroundColor Green
    }
}

if ($missingServices.Count -gt 0) {
    Write-Host ""
    Write-Host "==================================" -ForegroundColor Red
    Write-Host "Missing Microservices" -ForegroundColor Red
    Write-Host "==================================" -ForegroundColor Red
    Write-Host "The following microservice directories are missing:" -ForegroundColor Yellow
    foreach ($service in $missingServices) {
        Write-Host "  - $service" -ForegroundColor Yellow
    }
    Write-Host ""
    Write-Host "Please clone the missing repositories:" -ForegroundColor Yellow
    Write-Host "  git clone <repo-url> $service" -ForegroundColor Cyan
    Write-Host ""
    exit 1
}

Write-Host ""
Write-Host "==================================" -ForegroundColor Green
Write-Host "Setup Complete!" -ForegroundColor Green
Write-Host "==================================" -ForegroundColor Green
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Cyan
Write-Host "1. Edit infrastructure\.env and update passwords" -ForegroundColor White
Write-Host "2. Run: cd infrastructure; docker-compose up -d" -ForegroundColor White
Write-Host "3. Access services:" -ForegroundColor White
Write-Host "   - DocIngestor API: http://localhost:8001" -ForegroundColor Gray
Write-Host "   - DeID API: http://localhost:8002" -ForegroundColor Gray
Write-Host "   - SemanticIndexer API: http://localhost:8003" -ForegroundColor Gray
Write-Host "   - LLMQA API: http://localhost:8004" -ForegroundColor Gray
Write-Host "   - RabbitMQ Management: http://localhost:15672" -ForegroundColor Gray
Write-Host "   - MinIO Console: http://localhost:9001" -ForegroundColor Gray
Write-Host ""
