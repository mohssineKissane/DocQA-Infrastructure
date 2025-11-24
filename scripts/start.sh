#!/bin/bash

# ===========================================
# DocQA-MS Start Script
# ===========================================
# Starts all services using docker-compose

set -e

echo "Starting DocQA-MS services..."
docker-compose up -d

echo ""
echo "✓ Services are starting..."
echo ""
echo "Check status: docker-compose ps"
echo "View logs: docker-compose logs -f [service-name]"
echo ""
echo "Services will be available at:"
echo "  - DocIngestor API: http://localhost:8001/docs"
echo "  - DeID API: http://localhost:8002/docs"
echo "  - SemanticIndexer API: http://localhost:8003/docs"
echo "  - LLMQA API: http://localhost:8004/docs"
echo "  - RabbitMQ Management: http://localhost:15672 (user: see .env)"
echo "  - MinIO Console: http://localhost:9001 (user: see .env)"
