-- QUAD_requirements Table
-- High-level requirements/epics for domains
--
-- Part of: QUAD Domains
-- Created: January 2026

CREATE TABLE IF NOT EXISTS QUAD_requirements (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    domain_id       UUID NOT NULL REFERENCES QUAD_domains(id) ON DELETE CASCADE,

    title           VARCHAR(500) NOT NULL,
    description     TEXT,
    requirement_type VARCHAR(50) DEFAULT 'feature',  -- feature, epic, initiative

    status          VARCHAR(50) DEFAULT 'draft',  -- draft, approved, in_progress, completed, cancelled
    priority        VARCHAR(20) DEFAULT 'medium',

    -- Tracking
    owner_id        UUID REFERENCES QUAD_users(id) ON DELETE SET NULL,
    target_date     DATE,
    completed_at    TIMESTAMP WITH TIME ZONE,

    -- External tracking
    external_id     VARCHAR(100),
    external_url    TEXT,

    created_by      UUID REFERENCES QUAD_users(id) ON DELETE SET NULL,
    created_at      TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at      TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE INDEX IF NOT EXISTS idx_QUAD_requirements_domain ON QUAD_requirements(domain_id);
CREATE INDEX IF NOT EXISTS idx_QUAD_requirements_status ON QUAD_requirements(status);

-- Comments
COMMENT ON TABLE QUAD_requirements IS 'High-level requirements/epics for domains';
