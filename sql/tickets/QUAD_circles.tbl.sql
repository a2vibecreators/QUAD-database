-- QUAD_circles Table
-- The 4 functional circles per domain: Management, Development, QA, Infrastructure
--
-- Part of: QUAD Tickets
-- Created: January 2026

CREATE TABLE IF NOT EXISTS quad_circles (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    domain_id       UUID NOT NULL REFERENCES quad_domains(id) ON DELETE CASCADE,
    name            VARCHAR(255) NOT NULL,
    description     VARCHAR(255),
    circle_type     VARCHAR(255),  -- MANAGEMENT, DEVELOPMENT, QA, INFRASTRUCTURE
    lead_user_id    UUID REFERENCES quad_users(id) ON DELETE SET NULL,
    is_active       BOOLEAN DEFAULT true,
    created_at      TIMESTAMP DEFAULT NOW(),
    updated_at      TIMESTAMP DEFAULT NOW()
);

-- Indexes
CREATE INDEX IF NOT EXISTS idx_quad_circles_domain ON quad_circles(domain_id);
CREATE INDEX IF NOT EXISTS idx_quad_circles_type ON quad_circles(circle_type);
CREATE INDEX IF NOT EXISTS idx_quad_circles_lead ON quad_circles(lead_user_id);

-- Comments
COMMENT ON TABLE quad_circles IS 'The 4 functional circles per domain: Management, Development, QA, Infrastructure.';
