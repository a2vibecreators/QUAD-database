-- QUAD_fairness_changes Table
-- Audit log for all fairness system changes
-- Provides transparency and history of fairness decisions
--
-- Part of: QUAD Fairness System
-- Created: January 2026

CREATE TABLE IF NOT EXISTS QUAD_fairness_changes (
    id                  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    domain_id           UUID NOT NULL REFERENCES quad_domains(id) ON DELETE CASCADE,

    -- What changed
    change_type         VARCHAR(100) NOT NULL,      -- "attribute_added", "weight_updated", "formula_created", etc.
    entity_type         VARCHAR(100),               -- "attribute", "weight", "formula", "distribution"
    entity_id           UUID,

    -- Details
    change_description  TEXT,
    old_value           JSONB,
    new_value           JSONB,

    -- Who made the change
    changed_by          UUID REFERENCES quad_users(id),
    change_reason       TEXT,

    -- Status
    is_approved         BOOLEAN DEFAULT false,
    approved_by         UUID REFERENCES quad_users(id),
    approval_timestamp  TIMESTAMP,

    -- Immutability marker
    is_locked           BOOLEAN DEFAULT true,       -- Once created, cannot be modified

    -- Timestamps
    created_at          TIMESTAMP DEFAULT NOW(),

    UNIQUE(domain_id, entity_type, entity_id, created_at)
);

CREATE INDEX IF NOT EXISTS idx_fairness_changes_domain ON QUAD_fairness_changes(domain_id);
CREATE INDEX IF NOT EXISTS idx_fairness_changes_type ON QUAD_fairness_changes(change_type);
CREATE INDEX IF NOT EXISTS idx_fairness_changes_entity ON QUAD_fairness_changes(entity_type, entity_id);
CREATE INDEX IF NOT EXISTS idx_fairness_changes_changed_by ON QUAD_fairness_changes(changed_by);
CREATE INDEX IF NOT EXISTS idx_fairness_changes_timestamp ON QUAD_fairness_changes(created_at);

COMMENT ON TABLE QUAD_fairness_changes IS 'Immutable audit log of all fairness system changes';
