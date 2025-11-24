# ===========================================
# DocQA-MS Stop Script (PowerShell)
# ===========================================
# Stops all services

Write-Host "Stopping DocQA-MS services..." -ForegroundColor Cyan
docker-compose down

Write-Host ""
Write-Host "✓ All services stopped" -ForegroundColor Green
Write-Host ""
Write-Host "To remove volumes as well (WARNING: deletes all data):" -ForegroundColor Yellow
Write-Host "  docker-compose down -v" -ForegroundColor White
