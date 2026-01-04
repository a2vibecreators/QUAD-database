-- QUAD_ticket_sandbox_groups Table
-- Groups of tickets sharing a sandbox
--
-- Part of: QUAD Infrastructure
-- Created: January 2026

CREATE TABLE IF NOT EXISTS QUAD_ticket_sandbox_groups (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    sandbox_id      UUID NOT NULL REFERENCES QUAD_sandbox_instances(id) ON DELETE CASCADE,
    ticket_id       UUID NOT NULL REFERENCES QUAD_tickets(id) ON DELETE CASCADE,

    is_primary      BOOLEAN DEFAULT false,

    created_at      TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,

    UNIQUE(sandbox_id, ticket_id)
);

COMMENT ON TABLE QUAD_ticket_sandbox_groups IS 'Groups of tickets sharing a sandbox';
