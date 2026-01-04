-- QUAD_memory_keywords Table
-- Keywords extracted from memory documents
--
-- Part of: QUAD Memory
-- Created: January 2026

CREATE TABLE IF NOT EXISTS QUAD_memory_keywords (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    document_id     UUID NOT NULL REFERENCES QUAD_memory_documents(id) ON DELETE CASCADE,

    keyword         VARCHAR(100) NOT NULL,
    relevance_score NUMERIC(3,2) DEFAULT 1.0,  -- 0.0 to 1.0

    created_at      TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,

    UNIQUE(document_id, keyword)
);

CREATE INDEX IF NOT EXISTS idx_QUAD_memory_keywords_document ON QUAD_memory_keywords(document_id);
CREATE INDEX IF NOT EXISTS idx_QUAD_memory_keywords_keyword ON QUAD_memory_keywords(keyword);

COMMENT ON TABLE QUAD_memory_keywords IS 'Keywords extracted from memory documents';
