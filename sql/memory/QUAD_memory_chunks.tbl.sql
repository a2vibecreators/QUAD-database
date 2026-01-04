-- QUAD_memory_chunks Table
-- Chunked segments of memory documents for RAG
--
-- Part of: QUAD Memory
-- Created: January 2026

CREATE TABLE IF NOT EXISTS QUAD_memory_chunks (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    document_id     UUID NOT NULL REFERENCES QUAD_memory_documents(id) ON DELETE CASCADE,

    chunk_index     INTEGER NOT NULL,
    content         TEXT NOT NULL,
    token_count     INTEGER DEFAULT 0,

    -- Embedding vector (for vector search)
    embedding       VECTOR(1536),  -- OpenAI embedding dimension

    created_at      TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_QUAD_memory_chunks_document ON QUAD_memory_chunks(document_id);

COMMENT ON TABLE QUAD_memory_chunks IS 'Chunked segments of memory documents for RAG';
