-- QUAD_ai_analysis_cache Table
-- Cached AI analysis results
--
-- Part of: QUAD AI
-- Created: January 2026

CREATE TABLE IF NOT EXISTS QUAD_ai_analysis_cache (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    cache_key       VARCHAR(255) NOT NULL UNIQUE,
    analysis_type   VARCHAR(50) NOT NULL,

    input_hash      VARCHAR(64),  -- SHA256 of input
    result          JSONB NOT NULL,

    provider        VARCHAR(20),
    model           VARCHAR(100),

    hit_count       INTEGER DEFAULT 0,
    expires_at      TIMESTAMP WITH TIME ZONE,

    created_at      TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON TABLE QUAD_ai_analysis_cache IS 'Cached AI analysis results';
