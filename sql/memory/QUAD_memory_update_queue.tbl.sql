-- QUAD_memory_update_queue Table
-- Queue for async memory document updates
--
-- Part of: QUAD Memory
-- Created: January 2026

CREATE TABLE IF NOT EXISTS QUAD_memory_update_queue (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    document_id     UUID NOT NULL REFERENCES QUAD_memory_documents(id) ON DELETE CASCADE,

    operation       VARCHAR(20) NOT NULL,  -- create, update, reindex, delete
    priority        INTEGER DEFAULT 50,

    status          VARCHAR(20) DEFAULT 'pending',  -- pending, processing, completed, failed
    retry_count     INTEGER DEFAULT 0,
    max_retries     INTEGER DEFAULT 3,

    error_message   TEXT,

    scheduled_at    TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    started_at      TIMESTAMP WITH TIME ZONE,
    completed_at    TIMESTAMP WITH TIME ZONE,

    created_at      TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON TABLE QUAD_memory_update_queue IS 'Queue for async memory document updates';
