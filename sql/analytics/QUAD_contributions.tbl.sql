-- QUAD_contributions Table
-- Tracks all contributions from team members
-- Sources: GitHub (automatic), manual entry, time tracking, etc.
--
-- Part of: QUAD Analytics & Fairness
-- Created: January 2026

CREATE TABLE IF NOT EXISTS QUAD_contributions (
    id                  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    domain_id           UUID NOT NULL REFERENCES quad_domains(id) ON DELETE CASCADE,
    user_id             UUID NOT NULL REFERENCES quad_users(id) ON DELETE CASCADE,

    -- Contribution source
    source_type         VARCHAR(100) NOT NULL,      -- "github", "manual", "time_log", "code_review"
    source_id           VARCHAR(500),               -- e.g., GitHub PR ID, commit hash
    source_url          VARCHAR(1000),

    -- Contribution details
    contribution_type   VARCHAR(100),               -- "commit", "pr", "review", "comment", "task"
    title               VARCHAR(500),
    description         TEXT,

    -- Metrics
    impact_score        NUMERIC(5, 2),              -- 0-100, calculated based on contribution type
    quality_score       NUMERIC(5, 2),              -- Code quality (0-100)
    effort_hours        NUMERIC(8, 2),              -- Hours spent

    -- Linked entities
    ticket_id           UUID REFERENCES QUAD_tickets(id) ON DELETE SET NULL,
    pr_id               UUID REFERENCES QUAD_pull_requests(id) ON DELETE SET NULL,

    -- Status
    status              VARCHAR(100) DEFAULT 'pending',  -- pending, verified, disputed
    is_verified         BOOLEAN DEFAULT false,

    -- Timestamps
    contribution_date   DATE NOT NULL,
    created_at          TIMESTAMP DEFAULT NOW(),
    updated_at          TIMESTAMP DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_contributions_domain ON QUAD_contributions(domain_id);
CREATE INDEX IF NOT EXISTS idx_contributions_user ON QUAD_contributions(user_id);
CREATE INDEX IF NOT EXISTS idx_contributions_source ON QUAD_contributions(source_type, source_id);
CREATE INDEX IF NOT EXISTS idx_contributions_date ON QUAD_contributions(contribution_date);
CREATE INDEX IF NOT EXISTS idx_contributions_status ON QUAD_contributions(status);
CREATE INDEX IF NOT EXISTS idx_contributions_ticket ON QUAD_contributions(ticket_id);

COMMENT ON TABLE QUAD_contributions IS 'All contributions tracked for fairness calculation';
