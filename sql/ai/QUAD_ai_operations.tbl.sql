-- QUAD_ai_operations Table
-- AI operation audit log
--
-- Part of: QUAD AI
-- Created: January 2026

CREATE TABLE IF NOT EXISTS QUAD_ai_operations (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    org_id          UUID REFERENCES QUAD_organizations(id) ON DELETE SET NULL,
    user_id         UUID REFERENCES QUAD_users(id) ON DELETE SET NULL,

    operation_type  VARCHAR(50) NOT NULL,  -- code_review, estimation, chat, analysis
    provider        VARCHAR(20) NOT NULL,
    model           VARCHAR(100),

    input_tokens    INTEGER DEFAULT 0,
    output_tokens   INTEGER DEFAULT 0,
    latency_ms      INTEGER,
    cost_usd        NUMERIC(10,6),

    status          VARCHAR(20) DEFAULT 'completed',
    error_code      VARCHAR(50),
    error_message   TEXT,

    created_at      TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON TABLE QUAD_ai_operations IS 'AI operation audit log';
