-- QUAD_milestones Table
-- Project milestones for domains
--
-- Part of: QUAD Domains
-- Created: January 2026

CREATE TABLE IF NOT EXISTS QUAD_milestones (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    domain_id       UUID NOT NULL REFERENCES QUAD_domains(id) ON DELETE CASCADE,

    name            VARCHAR(255) NOT NULL,
    description     TEXT,

    target_date     DATE NOT NULL,
    completed_at    TIMESTAMP WITH TIME ZONE,

    status          VARCHAR(20) DEFAULT 'upcoming',  -- upcoming, in_progress, completed, missed

    -- Metrics
    total_tickets   INTEGER DEFAULT 0,
    completed_tickets INTEGER DEFAULT 0,

    created_by      UUID REFERENCES QUAD_users(id) ON DELETE SET NULL,
    created_at      TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at      TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE INDEX IF NOT EXISTS idx_QUAD_milestones_domain ON QUAD_milestones(domain_id);
CREATE INDEX IF NOT EXISTS idx_QUAD_milestones_target ON QUAD_milestones(target_date);
CREATE INDEX IF NOT EXISTS idx_QUAD_milestones_status ON QUAD_milestones(status);

-- Comments
COMMENT ON TABLE QUAD_milestones IS 'Project milestones for domains';
