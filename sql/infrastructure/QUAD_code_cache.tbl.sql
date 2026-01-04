-- QUAD_code_cache Table
-- Cached code analysis results
--
-- Part of: QUAD Infrastructure
-- Created: January 2026

CREATE TABLE IF NOT EXISTS QUAD_code_cache (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    domain_id       UUID NOT NULL REFERENCES QUAD_domains(id) ON DELETE CASCADE,

    cache_key       VARCHAR(255) NOT NULL,
    cache_type      VARCHAR(50) NOT NULL,  -- analysis, dependencies, imports

    content         JSONB NOT NULL,
    content_hash    VARCHAR(64),

    hit_count       INTEGER DEFAULT 0,
    size_bytes      INTEGER,

    expires_at      TIMESTAMP WITH TIME ZONE,

    created_at      TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at      TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,

    UNIQUE(domain_id, cache_key)
);

COMMENT ON TABLE QUAD_code_cache IS 'Cached code analysis results';
