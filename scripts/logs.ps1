# ===========================================
# DocQA-MS Logs Script (PowerShell)
# ===========================================
# View logs for all or specific services

param(
    [string]$Service = ""
)

# Navigate to infrastructure directory
$scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location (Split-Path -Parent $scriptPath)

Write-Host "================================================" -ForegroundColor Cyan
Write-Host "  DocQA-MS Service Logs" -ForegroundColor Cyan
Write-Host "================================================" -ForegroundColor Cyan
Write-Host ""

if ($Service -eq "") {
    Write-Host "Showing logs for all services (press Ctrl+C to exit)..." -ForegroundColor Yellow
    Write-Host ""
    docker-compose logs -f
} else {
    Write-Host "Showing logs for: $Service (press Ctrl+C to exit)..." -ForegroundColor Yellow
    Write-Host ""
    docker-compose logs -f $Service
}
