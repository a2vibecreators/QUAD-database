-- QUAD_anonymization_rules Table
-- Data anonymization rules for sandboxes
--
-- Part of: QUAD Other
-- Created: January 2026

CREATE TABLE IF NOT EXISTS QUAD_anonymization_rules (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    org_id          UUID NOT NULL REFERENCES QUAD_organizations(id) ON DELETE CASCADE,

    table_name      VARCHAR(100) NOT NULL,
    column_name     VARCHAR(100) NOT NULL,
    rule_type       VARCHAR(50) NOT NULL,  -- mask, hash, fake, null, preserve

    rule_config     JSONB,

    is_active       BOOLEAN DEFAULT true,

    created_at      TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at      TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,

    UNIQUE(org_id, table_name, column_name)
);

COMMENT ON TABLE QUAD_anonymization_rules IS 'Data anonymization rules for sandboxes';
