-- QUAD_fairness_weights Table
-- Stores weight configurations for fairness attributes
-- Supports versioning for immutability (v1, v2, etc.)
--
-- Part of: QUAD Fairness System
-- Created: January 2026
-- Plugin & Play: Each organization has its own versions, completely isolated

CREATE TABLE IF NOT EXISTS QUAD_fairness_weights (
    id                  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    domain_id           UUID NOT NULL REFERENCES quad_domains(id) ON DELETE CASCADE,
    attribute_id        UUID NOT NULL REFERENCES QUAD_fairness_attributes(id) ON DELETE CASCADE,

    -- Versioning (immutable after creation)
    version             INTEGER DEFAULT 1,         -- v1, v2, v3 (once created, locked)
    weight_percentage   NUMERIC(5, 2) NOT NULL,    -- 0.00 to 100.00
    is_locked           BOOLEAN DEFAULT true,      -- Once locked, cannot be modified

    -- Description of why this weight
    notes               TEXT,

    -- Status
    is_active           BOOLEAN DEFAULT true,

    -- Audit
    created_by          UUID REFERENCES quad_users(id),
    created_at          TIMESTAMP DEFAULT NOW(),
    updated_at          TIMESTAMP DEFAULT NOW(),

    UNIQUE(domain_id, attribute_id, version)
);

CREATE INDEX IF NOT EXISTS idx_fairness_weights_domain ON QUAD_fairness_weights(domain_id);
CREATE INDEX IF NOT EXISTS idx_fairness_weights_attribute ON QUAD_fairness_weights(attribute_id);
CREATE INDEX IF NOT EXISTS idx_fairness_weights_active ON QUAD_fairness_weights(is_active);

COMMENT ON TABLE QUAD_fairness_weights IS 'Weight configurations - versioned & immutable for fairness system';
