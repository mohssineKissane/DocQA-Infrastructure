#!/bin/bash

# ===========================================
# DocQA-MS Stop Script
# ===========================================
# Stops all services

set -e

echo "Stopping DocQA-MS services..."
docker-compose down

echo ""
echo "✓ All services stopped"
echo ""
echo "To remove volumes as well (WARNING: deletes all data):"
echo "  docker-compose down -v"
