-- QUAD_context_rules Table
-- Rules for automatic context inclusion
--
-- Part of: QUAD Memory
-- Created: January 2026

CREATE TABLE IF NOT EXISTS QUAD_context_rules (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    org_id          UUID REFERENCES QUAD_organizations(id) ON DELETE CASCADE,
    domain_id       UUID REFERENCES QUAD_domains(id) ON DELETE CASCADE,

    rule_name       VARCHAR(100) NOT NULL,
    description     TEXT,

    -- Conditions
    trigger_keywords TEXT[],  -- Keywords that trigger this rule
    trigger_file_patterns TEXT[],  -- File patterns like "*.ts", "src/**"

    -- Actions
    include_documents UUID[],  -- Document IDs to include
    include_tags    TEXT[],  -- Document tags to include

    priority        INTEGER DEFAULT 50,  -- Higher = more important
    is_active       BOOLEAN DEFAULT true,

    created_at      TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at      TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON TABLE QUAD_context_rules IS 'Rules for automatic context inclusion';
