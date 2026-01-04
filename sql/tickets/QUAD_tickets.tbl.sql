-- QUAD_tickets Table
-- Work items (stories, tasks, bugs)
--
-- Part of: QUAD Tickets
-- Created: January 2026

CREATE TABLE IF NOT EXISTS quad_tickets (
    id                  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    domain_id           UUID NOT NULL REFERENCES quad_domains(id) ON DELETE CASCADE,
    cycle_id            UUID REFERENCES quad_cycles(id) ON DELETE SET NULL,
    flow_id             UUID,  -- References quad_flows
    parent_ticket_id    UUID REFERENCES quad_tickets(id) ON DELETE SET NULL,
    ticket_number       VARCHAR(255),
    title               VARCHAR(255) NOT NULL,
    description         TEXT,
    ticket_type         VARCHAR(255),  -- story, task, bug, epic
    status              VARCHAR(255) DEFAULT 'backlog',
    priority            VARCHAR(255) DEFAULT 'medium',
    story_points        INTEGER,
    assigned_to         UUID REFERENCES quad_users(id) ON DELETE SET NULL,
    reported_by         UUID REFERENCES quad_users(id) ON DELETE SET NULL,
    due_date            TIMESTAMP,
    started_at          TIMESTAMP,
    completed_at        TIMESTAMP,
    created_at          TIMESTAMP DEFAULT NOW(),
    updated_at          TIMESTAMP DEFAULT NOW()
);

-- Indexes
CREATE INDEX IF NOT EXISTS idx_quad_tickets_domain ON quad_tickets(domain_id);
CREATE INDEX IF NOT EXISTS idx_quad_tickets_cycle ON quad_tickets(cycle_id);
CREATE INDEX IF NOT EXISTS idx_quad_tickets_status ON quad_tickets(status);
CREATE INDEX IF NOT EXISTS idx_quad_tickets_assigned ON quad_tickets(assigned_to);
CREATE INDEX IF NOT EXISTS idx_quad_tickets_number ON quad_tickets(ticket_number);
CREATE INDEX IF NOT EXISTS idx_quad_tickets_parent ON quad_tickets(parent_ticket_id);

-- Comments
COMMENT ON TABLE quad_tickets IS 'Work items (stories, tasks, bugs)';
