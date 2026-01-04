-- QUAD_cache_usage Table
-- Cache usage metrics
--
-- Part of: QUAD Infrastructure
-- Created: January 2026

CREATE TABLE IF NOT EXISTS QUAD_cache_usage (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    org_id          UUID NOT NULL REFERENCES QUAD_organizations(id) ON DELETE CASCADE,

    recorded_at     TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    period_minutes  INTEGER DEFAULT 5,

    total_size_mb   NUMERIC(10,2),
    used_size_mb    NUMERIC(10,2),
    hit_rate        NUMERIC(5,2),  -- Percentage

    entries_count   INTEGER DEFAULT 0,
    evictions_count INTEGER DEFAULT 0,

    created_at      TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON TABLE QUAD_cache_usage IS 'Cache usage metrics';
