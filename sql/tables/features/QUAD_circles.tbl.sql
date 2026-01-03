-- Table: QUAD_circles
-- Section: features
-- Purpose: The 4 functional circles per domain

CREATE TABLE QUAD_circles (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    domain_id UUID NOT NULL REFERENCES QUAD_domains(id) ON DELETE CASCADE,

    circle_number INT NOT NULL,
    -- 1 = Management, 2 = Development, 3 = QA, 4 = Infrastructure

    circle_name VARCHAR(100) NOT NULL,
    -- Default names: 'Management', 'Development', 'QA', 'Infrastructure'

    description TEXT,

    -- Circle lead
    lead_user_id UUID REFERENCES QUAD_users(id),

    -- Settings
    is_active BOOLEAN DEFAULT true,

    -- Metadata
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),

    -- Constraints
    UNIQUE(domain_id, circle_number)
);

-- Indexes
CREATE INDEX idx_quad_circles_domain ON QUAD_circles(domain_id);
CREATE INDEX idx_quad_circles_lead ON QUAD_circles(lead_user_id);
CREATE INDEX idx_quad_circles_active ON QUAD_circles(is_active) WHERE is_active = TRUE;

-- Trigger for updated_at
CREATE TRIGGER trg_quad_circles_updated_at
    BEFORE UPDATE ON QUAD_circles
    FOR EACH ROW
    EXECUTE FUNCTION QUAD_update_updated_at_column();

-- Comments
COMMENT ON TABLE QUAD_circles IS 'The 4 functional circles per domain: Management, Development, QA, Infrastructure.';
