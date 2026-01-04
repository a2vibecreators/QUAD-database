-- QUAD_ticket_ai_sessions Table
-- AI session tracking per ticket
--
-- Purpose: Track AI consumption for each ticket work session
-- - Debug mode: Store full request/response payloads
-- - Production: Store only token counts and sequence
-- - Compaction: Aggregate for long-term storage
--
-- Part of: QUAD AI
-- Created: January 2026

CREATE TABLE IF NOT EXISTS QUAD_ticket_ai_sessions (
    id                  UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    -- Ticket association
    ticket_id           UUID NOT NULL REFERENCES QUAD_tickets(id) ON DELETE CASCADE,
    domain_id           UUID NOT NULL REFERENCES QUAD_domains(id) ON DELETE CASCADE,
    org_id              UUID NOT NULL REFERENCES QUAD_organizations(id) ON DELETE CASCADE,
    user_id             UUID NOT NULL REFERENCES QUAD_users(id) ON DELETE CASCADE,

    -- Session tracking
    session_number      INTEGER NOT NULL,           -- 1, 2, 3... per ticket
    started_at          TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    ended_at            TIMESTAMP WITH TIME ZONE,
    duration_seconds    INTEGER,

    -- AI Provider
    provider            VARCHAR(20) NOT NULL,       -- claude, gemini, openai
    model               VARCHAR(100) NOT NULL,      -- claude-sonnet-4, gemini-2.0-flash

    -- Token tracking (always stored)
    total_input_tokens  INTEGER DEFAULT 0,
    total_output_tokens INTEGER DEFAULT 0,
    total_requests      INTEGER DEFAULT 0,

    -- Cost tracking
    estimated_cost_usd  NUMERIC(10,6) DEFAULT 0,

    -- Status
    status              VARCHAR(20) DEFAULT 'active',  -- active, completed, failed, compacted

    -- Debug mode flag
    is_debug_mode       BOOLEAN DEFAULT false,

    created_at          TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at          TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Index for ticket lookups
CREATE INDEX IF NOT EXISTS idx_ticket_ai_sessions_ticket
    ON QUAD_ticket_ai_sessions(ticket_id);

-- Index for user lookups
CREATE INDEX IF NOT EXISTS idx_ticket_ai_sessions_user
    ON QUAD_ticket_ai_sessions(user_id);

-- Index for org analytics
CREATE INDEX IF NOT EXISTS idx_ticket_ai_sessions_org_date
    ON QUAD_ticket_ai_sessions(org_id, created_at);

COMMENT ON TABLE QUAD_ticket_ai_sessions IS 'AI session tracking per ticket';
COMMENT ON COLUMN QUAD_ticket_ai_sessions.session_number IS 'Sequential session number within ticket (1, 2, 3...)';
COMMENT ON COLUMN QUAD_ticket_ai_sessions.is_debug_mode IS 'When true, request_payloads are stored in child table';
