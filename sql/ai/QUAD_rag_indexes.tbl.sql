-- QUAD_rag_indexes Table
-- RAG index metadata for vector search
--
-- Part of: QUAD AI
-- Created: January 2026

CREATE TABLE IF NOT EXISTS QUAD_rag_indexes (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    domain_id       UUID NOT NULL REFERENCES QUAD_domains(id) ON DELETE CASCADE,

    index_name      VARCHAR(100) NOT NULL,
    index_type      VARCHAR(50) DEFAULT 'codebase',  -- codebase, documentation, memory

    -- Stats
    document_count  INTEGER DEFAULT 0,
    chunk_count     INTEGER DEFAULT 0,
    total_tokens    INTEGER DEFAULT 0,

    -- Status
    status          VARCHAR(20) DEFAULT 'pending',  -- pending, indexing, ready, failed
    last_indexed_at TIMESTAMP WITH TIME ZONE,
    error_message   TEXT,

    created_at      TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at      TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,

    UNIQUE(domain_id, index_name)
);

COMMENT ON TABLE QUAD_rag_indexes IS 'RAG index metadata for vector search';
