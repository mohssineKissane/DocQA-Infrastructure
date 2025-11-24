#!/bin/bash

# ===========================================
# DocQA-MS Setup Script
# ===========================================
# This script sets up the complete DocQA-MS system
# Run this once when setting up a new development environment

set -e

echo "=================================="
echo "DocQA-MS System Setup"
echo "=================================="

# Check if we're in the infrastructure directory
if [ ! -f "docker-compose.yml" ]; then
    echo "Error: Please run this script from the infrastructure directory"
    exit 1
fi

# Check if .env exists
if [ ! -f ".env" ]; then
    echo "Creating .env file from .env.example..."
    cp .env.example .env
    echo "✓ Created .env file"
    echo "⚠️  Please edit .env and update passwords before running docker-compose!"
else
    echo "✓ .env file already exists"
fi

# Create log directories
echo "Creating log directories..."
mkdir -p logs/docingestor
mkdir -p logs/deid
mkdir -p logs/semantic-indexer
mkdir -p logs/llmqa
echo "✓ Log directories created"

# Check if microservice directories exist
echo ""
echo "Checking microservice repositories..."
cd ..

services=("DocIngestor" "DeID" "SemanticIndexer" "LLMQAModule")
missing_services=()

for service in "${services[@]}"; do
    if [ ! -d "$service" ]; then
        echo "✗ $service directory not found"
        missing_services+=("$service")
    else
        echo "✓ $service found"
    fi
done

if [ ${#missing_services[@]} -gt 0 ]; then
    echo ""
    echo "=================================="
    echo "Missing Microservices"
    echo "=================================="
    echo "The following microservice directories are missing:"
    for service in "${missing_services[@]}"; do
        echo "  - $service"
    done
    echo ""
    echo "Please clone the missing repositories:"
    echo "  git clone <repo-url> $service"
    echo ""
    exit 1
fi

echo ""
echo "=================================="
echo "Setup Complete!"
echo "=================================="
echo ""
echo "Next steps:"
echo "1. Edit infrastructure/.env and update passwords"
echo "2. Run: cd infrastructure && docker-compose up -d"
echo "3. Access services:"
echo "   - DocIngestor API: http://localhost:8001"
echo "   - DeID API: http://localhost:8002"
echo "   - SemanticIndexer API: http://localhost:8003"
echo "   - LLMQA API: http://localhost:8004"
echo "   - RabbitMQ Management: http://localhost:15672"
echo "   - MinIO Console: http://localhost:9001"
echo ""
