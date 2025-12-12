# ===========================================
# DocQA-MS Stop Script (PowerShell)
# ===========================================
# Stops all services using docker-compose

Write-Host "================================================" -ForegroundColor Cyan
Write-Host "  Stopping DocQA-MS Microservices Stack" -ForegroundColor Cyan
Write-Host "================================================" -ForegroundColor Cyan
Write-Host ""

# Navigate to infrastructure directory
$scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location (Split-Path -Parent $scriptPath)

Write-Host "Stopping all services..." -ForegroundColor Yellow
docker-compose down

Write-Host ""
Write-Host "✓ All services stopped!" -ForegroundColor Green
Write-Host ""
Write-Host "To remove volumes (data will be lost):" -ForegroundColor Yellow
Write-Host "  docker-compose down -v" -ForegroundColor Gray
Write-Host ""
