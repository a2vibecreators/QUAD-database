-- QUAD_fairness_formulas Table
-- Defines the formula for calculating fairness scores
-- Supports multiple formulas per organization for different roles/tracks
--
-- Part of: QUAD Fairness System
-- Created: January 2026
-- Plugin & Play: Organizations define their own formulas

CREATE TABLE IF NOT EXISTS QUAD_fairness_formulas (
    id                  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    domain_id           UUID NOT NULL REFERENCES quad_domains(id) ON DELETE CASCADE,

    -- Formula definition
    formula_name        VARCHAR(255) NOT NULL,      -- e.g., "Engineering Fairness v1"
    description         TEXT,
    formula_type        VARCHAR(100),               -- "weighted_average", "custom"
    career_track        VARCHAR(100),               -- "Technical", "Leadership", "Domain Expert", "Entrepreneur", "Research"

    -- Formula calculation
    formula_expression  TEXT NOT NULL,              -- JSON or custom expression defining calculation
    -- Example: {"type": "weighted_average", "weights": {...}, "thresholds": {...}}

    -- Versioning (immutable)
    version             INTEGER DEFAULT 1,
    is_locked           BOOLEAN DEFAULT true,      -- Once locked, cannot be modified

    -- Status
    is_active           BOOLEAN DEFAULT true,
    is_default          BOOLEAN DEFAULT false,     -- If true, used for new users in this org

    -- Range definitions
    min_score           NUMERIC(5, 2) DEFAULT 0.00,
    max_score           NUMERIC(5, 2) DEFAULT 100.00,

    -- Audit
    created_by          UUID REFERENCES quad_users(id),
    created_at          TIMESTAMP DEFAULT NOW(),
    updated_at          TIMESTAMP DEFAULT NOW(),

    UNIQUE(domain_id, formula_name, version)
);

CREATE INDEX IF NOT EXISTS idx_fairness_formulas_domain ON QUAD_fairness_formulas(domain_id);
CREATE INDEX IF NOT EXISTS idx_fairness_formulas_active ON QUAD_fairness_formulas(is_active);
CREATE INDEX IF NOT EXISTS idx_fairness_formulas_track ON QUAD_fairness_formulas(career_track);

COMMENT ON TABLE QUAD_fairness_formulas IS 'Fairness scoring formulas - versioned & locked for immutability';
