-- ===========================================
-- DocQA-MS Database Initialization
-- ===========================================
-- This script creates separate databases for each microservice
-- Executed automatically when PostgreSQL container starts

-- Create databases
CREATE DATABASE docingestor_db;
CREATE DATABASE deid_db;
CREATE DATABASE semantic_indexer_db;
CREATE DATABASE llmqa_db;

-- Grant privileges to the main user
GRANT ALL PRIVILEGES ON DATABASE docingestor_db TO docqa_admin;
GRANT ALL PRIVILEGES ON DATABASE deid_db TO docqa_admin;
GRANT ALL PRIVILEGES ON DATABASE semantic_indexer_db TO docqa_admin;
GRANT ALL PRIVILEGES ON DATABASE llmqa_db TO docqa_admin;

-- Connect to docingestor_db and create extensions if needed
\c docingestor_db;
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

\c deid_db;
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

\c semantic_indexer_db;
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

\c llmqa_db;
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
