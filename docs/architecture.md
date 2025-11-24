# DocQA-MS System Architecture

## Overview

DocQA-MS is a medical document question-answering system built with a microservices architecture. The system processes clinical documents, anonymizes patient information, creates semantic indexes, and provides intelligent Q&A capabilities using local LLMs.

## Architecture Diagram

```
[Clinical Documents] 
       ↓
[1. DocIngestor] → RabbitMQ → [2. DeID] 
       ↓                           ↓
   PostgreSQL              Anonymized Docs
                                   ↓
                          [3. SemanticIndexer]
                                   ↓
                            FAISS Vector DB
                                   ↓
                    [User Query] → [4. LLMQAModule]
                                   ↓
                              [Answer + Citations]
```

## Microservices

### 1. DocIngestor Service (Port 8001)
- **Purpose**: Entry point for document ingestion
- **Responsibilities**:
  - Accept document uploads (PDF, DOCX, TXT, HL7, FHIR, DICOM)
  - Extract text using Apache Tika and OCR
  - Store documents in MinIO object storage
  - Save metadata in PostgreSQL
  - Publish to RabbitMQ for processing

### 2. DeID Service (Port 8002)
- **Purpose**: Anonymize patient information
- **Responsibilities**:
  - Consume documents from RabbitMQ
  - Detect PII using Presidio and spaCy
  - Apply anonymization strategies
  - Store anonymized text
  - Publish to SemanticIndexer queue

### 3. SemanticIndexer Service (Port 8003)
- **Purpose**: Create searchable vector embeddings
- **Responsibilities**:
  - Consume anonymized documents
  - Chunk text into semantic units
  - Generate embeddings using SentenceTransformers
  - Store vectors in FAISS index
  - Provide semantic search API

### 4. LLMQAModule Service (Port 8004)
- **Purpose**: Answer questions using RAG pipeline
- **Responsibilities**:
  - Accept natural language queries
  - Retrieve relevant document chunks
  - Generate answers using local LLM
  - Provide citations and sources
  - Log interactions for audit

## Infrastructure Components

### PostgreSQL (Port 5432)
- **Databases**:
  - `docingestor_db` - Document metadata
  - `deid_db` - Anonymization records
  - `semantic_indexer_db` - Chunk metadata
  - `llmqa_db` - Query history

### RabbitMQ (Port 5672, Management: 15672)
- **Queues**:
  - `documents.raw` - Raw documents from DocIngestor
  - `documents.anonymized` - Anonymized documents to SemanticIndexer

### MinIO (Port 9000, Console: 9001)
- **Purpose**: S3-compatible object storage for original documents

### FAISS
- **Purpose**: Vector database for semantic search
- **Storage**: Persistent volume

## Data Flow

1. **Ingestion**: Document → DocIngestor → Extract → Store → Queue
2. **Anonymization**: DeID consumes → Detect PII → Anonymize → Queue
3. **Indexing**: SemanticIndexer consumes → Chunk → Embed → FAISS
4. **Query**: User question → Embed → Search FAISS → Retrieve → LLM → Answer

## Communication Patterns

### Asynchronous (RabbitMQ)
- DocIngestor → DeID
- DeID → SemanticIndexer

### Synchronous (REST API)
- LLMQAModule → SemanticIndexer (vector search)
- All services expose FastAPI endpoints

## Security Considerations

- All services communicate over internal Docker network
- PostgreSQL uses encrypted connections
- RabbitMQ requires authentication
- MinIO stores documents with encryption
- DeID service ensures HIPAA/GDPR compliance
- API authentication ready for Auth0 integration

## Scalability

- Each microservice can be scaled independently
- PostgreSQL can be replaced with managed database
- FAISS index can be distributed
- LLM inference can use GPU acceleration
- Message queue handles backpressure automatically

## Development vs Production

### Development
- Single docker-compose deployment
- All services on one machine
- Shared PostgreSQL instance
- File-based FAISS index

### Production
- Kubernetes orchestration
- Separate service deployments
- Managed PostgreSQL (RDS, Cloud SQL)
- Distributed FAISS or vector database
- Load balancers and auto-scaling
- Comprehensive monitoring and logging
