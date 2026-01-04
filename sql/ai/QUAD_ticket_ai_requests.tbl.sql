-- QUAD_ticket_ai_requests Table
-- Individual AI requests within ticket sessions
--
-- Purpose: Store each AI request for a ticket
-- - Debug mode: Store full request/response payloads (JSONB)
-- - Production: Payloads are NULL, only store metadata
-- - Sequence number tracks order within session
--
-- Part of: QUAD AI
-- Created: January 2026

CREATE TABLE IF NOT EXISTS QUAD_ticket_ai_requests (
    id                  UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    -- Parent session
    session_id          UUID NOT NULL REFERENCES QUAD_ticket_ai_sessions(id) ON DELETE CASCADE,
    ticket_id           UUID NOT NULL REFERENCES QUAD_tickets(id) ON DELETE CASCADE,

    -- Sequence within session (1, 2, 3, ...)
    sequence_number     INTEGER NOT NULL,

    -- Request metadata
    request_type        VARCHAR(50) NOT NULL,       -- chat, code_review, analysis, tool_call
    tool_name           VARCHAR(100),               -- If tool call: read_file, create_ticket, etc.

    -- Token counts (always stored)
    input_tokens        INTEGER DEFAULT 0,
    output_tokens       INTEGER DEFAULT 0,
    latency_ms          INTEGER,

    -- Cost for this request
    cost_usd            NUMERIC(10,6) DEFAULT 0,

    -- Status
    status              VARCHAR(20) DEFAULT 'completed',  -- pending, completed, failed
    error_code          VARCHAR(50),
    error_message       TEXT,

    -- Debug payloads (NULL in production mode)
    request_payload     JSONB,                      -- Full request (debug only)
    response_payload    JSONB,                      -- Full response (debug only)
    tool_input          JSONB,                      -- Tool call arguments (debug only)
    tool_output         JSONB,                      -- Tool call result (debug only)

    created_at          TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Index for session lookups (get all requests in order)
CREATE INDEX IF NOT EXISTS idx_ticket_ai_requests_session_seq
    ON QUAD_ticket_ai_requests(session_id, sequence_number);

-- Index for ticket lookups
CREATE INDEX IF NOT EXISTS idx_ticket_ai_requests_ticket
    ON QUAD_ticket_ai_requests(ticket_id);

-- Index for tool analysis
CREATE INDEX IF NOT EXISTS idx_ticket_ai_requests_tool
    ON QUAD_ticket_ai_requests(tool_name)
    WHERE tool_name IS NOT NULL;

COMMENT ON TABLE QUAD_ticket_ai_requests IS 'Individual AI requests within ticket sessions';
COMMENT ON COLUMN QUAD_ticket_ai_requests.sequence_number IS 'Order within session (1, 2, 3...)';
COMMENT ON COLUMN QUAD_ticket_ai_requests.request_payload IS 'Full request JSON (only stored in debug mode)';
COMMENT ON COLUMN QUAD_ticket_ai_requests.response_payload IS 'Full response JSON (only stored in debug mode)';
