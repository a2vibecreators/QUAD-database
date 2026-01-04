-- QUAD_context_requests Table
-- Individual AI requests within a session
--
-- Part of: QUAD Memory
-- Created: January 2026

CREATE TABLE IF NOT EXISTS QUAD_context_requests (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    session_id      UUID NOT NULL REFERENCES QUAD_context_sessions(id) ON DELETE CASCADE,

    request_text    TEXT NOT NULL,
    response_text   TEXT,

    ai_provider     VARCHAR(20),
    ai_model        VARCHAR(50),

    input_tokens    INTEGER DEFAULT 0,
    output_tokens   INTEGER DEFAULT 0,
    latency_ms      INTEGER,

    status          VARCHAR(20) DEFAULT 'pending',  -- pending, completed, failed
    error_message   TEXT,

    created_at      TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON TABLE QUAD_context_requests IS 'Individual AI requests within a session';
