-- QUAD_ticket_ai_summary Table
-- Compacted AI usage summary per ticket
--
-- Purpose: Aggregate AI consumption for long-term storage
-- - Created when ticket is DONE or after compaction job runs
-- - Contains totals across ALL sessions for a ticket
-- - Raw requests can be purged after compaction
--
-- Part of: QUAD AI
-- Created: January 2026

CREATE TABLE IF NOT EXISTS QUAD_ticket_ai_summary (
    id                  UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    -- Ticket association
    ticket_id           UUID NOT NULL UNIQUE REFERENCES QUAD_tickets(id) ON DELETE CASCADE,
    domain_id           UUID NOT NULL REFERENCES QUAD_domains(id) ON DELETE CASCADE,
    org_id              UUID NOT NULL REFERENCES QUAD_organizations(id) ON DELETE CASCADE,

    -- Aggregated totals
    total_sessions      INTEGER DEFAULT 0,          -- Number of AI sessions
    total_requests      INTEGER DEFAULT 0,          -- Number of AI requests
    total_input_tokens  BIGINT DEFAULT 0,           -- Sum of all input tokens
    total_output_tokens BIGINT DEFAULT 0,           -- Sum of all output tokens
    total_cost_usd      NUMERIC(12,6) DEFAULT 0,    -- Total cost

    -- Time tracking
    total_ai_time_seconds INTEGER DEFAULT 0,        -- Sum of all AI latencies
    first_session_at    TIMESTAMP WITH TIME ZONE,
    last_session_at     TIMESTAMP WITH TIME ZONE,

    -- Provider breakdown (JSONB for flexibility)
    -- { "claude": { "requests": 50, "tokens": 10000, "cost": 0.50 },
    --   "gemini": { "requests": 10, "tokens": 2000, "cost": 0.05 } }
    provider_breakdown  JSONB DEFAULT '{}',

    -- Tool usage breakdown
    -- { "read_file": 30, "write_file": 10, "bash": 5 }
    tool_usage          JSONB DEFAULT '{}',

    -- Compaction metadata
    compacted_at        TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    sessions_compacted  INTEGER DEFAULT 0,          -- How many sessions were compacted
    raw_data_purged     BOOLEAN DEFAULT false,      -- Whether raw requests were deleted

    created_at          TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at          TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Index for org analytics
CREATE INDEX IF NOT EXISTS idx_ticket_ai_summary_org
    ON QUAD_ticket_ai_summary(org_id);

-- Index for domain analytics
CREATE INDEX IF NOT EXISTS idx_ticket_ai_summary_domain
    ON QUAD_ticket_ai_summary(domain_id);

COMMENT ON TABLE QUAD_ticket_ai_summary IS 'Compacted AI usage summary per ticket';
COMMENT ON COLUMN QUAD_ticket_ai_summary.provider_breakdown IS 'JSON breakdown by provider: { "claude": {...}, "gemini": {...} }';
COMMENT ON COLUMN QUAD_ticket_ai_summary.tool_usage IS 'JSON count of tool usage: { "read_file": 30, "bash": 5 }';
COMMENT ON COLUMN QUAD_ticket_ai_summary.raw_data_purged IS 'True if detailed request data has been deleted after compaction';
