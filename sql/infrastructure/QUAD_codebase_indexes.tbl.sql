-- QUAD_codebase_indexes Table
-- Codebase index metadata
--
-- Part of: QUAD Infrastructure
-- Created: January 2026

CREATE TABLE IF NOT EXISTS QUAD_codebase_indexes (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    domain_id       UUID NOT NULL REFERENCES QUAD_domains(id) ON DELETE CASCADE,

    index_type      VARCHAR(50) DEFAULT 'full',  -- full, incremental
    status          VARCHAR(20) DEFAULT 'pending',  -- pending, indexing, ready, failed

    file_count      INTEGER DEFAULT 0,
    total_lines     INTEGER DEFAULT 0,
    total_tokens    INTEGER DEFAULT 0,

    started_at      TIMESTAMP WITH TIME ZONE,
    completed_at    TIMESTAMP WITH TIME ZONE,
    error_message   TEXT,

    created_at      TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at      TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON TABLE QUAD_codebase_indexes IS 'Codebase index metadata';
