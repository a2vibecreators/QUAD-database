-- QUAD_ai_code_reviews Table
-- AI-generated code reviews
--
-- Part of: QUAD AI
-- Created: January 2026

CREATE TABLE IF NOT EXISTS QUAD_ai_code_reviews (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    pr_id           UUID REFERENCES QUAD_pull_requests(id) ON DELETE CASCADE,

    provider        VARCHAR(20) NOT NULL,
    model           VARCHAR(100),

    -- Review content
    summary         TEXT,
    issues          JSONB,  -- Array of { file, line, severity, message }
    suggestions     JSONB,  -- Array of { file, line, suggestion }

    overall_score   INTEGER,  -- 1-10

    tokens_used     INTEGER DEFAULT 0,
    latency_ms      INTEGER,

    created_at      TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON TABLE QUAD_ai_code_reviews IS 'AI-generated code reviews';
