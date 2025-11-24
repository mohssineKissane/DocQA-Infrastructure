# ===========================================
# DocQA-MS Start Script (PowerShell)
# ===========================================
# Starts all services using docker-compose

Write-Host "Starting DocQA-MS services..." -ForegroundColor Cyan
docker-compose up -d

Write-Host ""
Write-Host "✓ Services are starting..." -ForegroundColor Green
Write-Host ""
Write-Host "Check status: docker-compose ps" -ForegroundColor Yellow
Write-Host "View logs: docker-compose logs -f [service-name]" -ForegroundColor Yellow
Write-Host ""
Write-Host "Services will be available at:" -ForegroundColor Cyan
Write-Host "  - DocIngestor API: http://localhost:8001/docs" -ForegroundColor White
Write-Host "  - DeID API: http://localhost:8002/docs" -ForegroundColor White
Write-Host "  - SemanticIndexer API: http://localhost:8003/docs" -ForegroundColor White
Write-Host "  - LLMQA API: http://localhost:8004/docs" -ForegroundColor White
Write-Host "  - RabbitMQ Management: http://localhost:15672 (user: see .env)" -ForegroundColor White
Write-Host "  - MinIO Console: http://localhost:9001 (user: see .env)" -ForegroundColor White
