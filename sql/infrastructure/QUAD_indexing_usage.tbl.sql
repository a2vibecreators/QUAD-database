-- QUAD_indexing_usage Table
-- Codebase indexing usage metrics
--
-- Part of: QUAD Infrastructure
-- Created: January 2026

CREATE TABLE IF NOT EXISTS QUAD_indexing_usage (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    org_id          UUID NOT NULL REFERENCES QUAD_organizations(id) ON DELETE CASCADE,

    recorded_at     TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    period_type     VARCHAR(20) DEFAULT 'daily',  -- hourly, daily, monthly

    files_indexed   INTEGER DEFAULT 0,
    lines_indexed   INTEGER DEFAULT 0,
    tokens_indexed  INTEGER DEFAULT 0,

    indexing_time_ms INTEGER DEFAULT 0,
    storage_used_mb NUMERIC(10,2),

    created_at      TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON TABLE QUAD_indexing_usage IS 'Codebase indexing usage metrics';
