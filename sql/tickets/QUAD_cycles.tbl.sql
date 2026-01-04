-- QUAD_cycles Table
-- Sprint/iteration cycles for domains
--
-- Part of: QUAD Tickets
-- Created: January 2026

CREATE TABLE IF NOT EXISTS quad_cycles (
    id                  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    domain_id           UUID NOT NULL REFERENCES quad_domains(id) ON DELETE CASCADE,
    name                VARCHAR(255) NOT NULL,
    cycle_number        INTEGER,
    goal                VARCHAR(255),
    status              VARCHAR(255) DEFAULT 'planning',  -- planning, active, completed
    start_date          DATE,
    end_date            DATE,
    planned_velocity    INTEGER,
    actual_velocity     INTEGER,
    created_at          TIMESTAMP DEFAULT NOW(),
    updated_at          TIMESTAMP DEFAULT NOW()
);

-- Indexes
CREATE INDEX IF NOT EXISTS idx_quad_cycles_domain ON quad_cycles(domain_id);
CREATE INDEX IF NOT EXISTS idx_quad_cycles_status ON quad_cycles(status);
CREATE INDEX IF NOT EXISTS idx_quad_cycles_dates ON quad_cycles(start_date, end_date);

-- Comments
COMMENT ON TABLE quad_cycles IS 'Sprint/iteration cycles for domains';
