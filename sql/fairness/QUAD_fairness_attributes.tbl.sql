-- QUAD_fairness_attributes Table
-- Defines what attributes contribute to fairness scoring
-- Allows organizations to define custom fairness models
--
-- Part of: QUAD Fairness System
-- Created: January 2026
-- Plugin & Play: New orgs add attributes via INSERT

CREATE TABLE IF NOT EXISTS QUAD_fairness_attributes (
    id                  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    domain_id           UUID NOT NULL REFERENCES quad_domains(id) ON DELETE CASCADE,

    -- Attribute definition
    attribute_name      VARCHAR(255) NOT NULL,      -- e.g., "code_quality", "reliability"
    description         TEXT,
    category            VARCHAR(100),               -- e.g., "technical", "leadership"

    -- Measurement
    measure_type        VARCHAR(100),               -- "numeric", "percentage", "boolean"
    calculation_method  TEXT,                       -- How to calculate (e.g., "PR review count / total PRs")

    -- Status
    is_active           BOOLEAN DEFAULT true,

    -- Metadata
    created_at          TIMESTAMP DEFAULT NOW(),
    updated_at          TIMESTAMP DEFAULT NOW(),

    UNIQUE(domain_id, attribute_name)
);

CREATE INDEX IF NOT EXISTS idx_fairness_attributes_domain ON QUAD_fairness_attributes(domain_id);
CREATE INDEX IF NOT EXISTS idx_fairness_attributes_active ON QUAD_fairness_attributes(is_active);

COMMENT ON TABLE QUAD_fairness_attributes IS 'Defines fairness scoring attributes per organization - plugin & play design';
