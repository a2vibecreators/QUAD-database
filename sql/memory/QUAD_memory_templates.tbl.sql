-- QUAD_memory_templates Table
-- Templates for creating memory documents
--
-- Part of: QUAD Memory
-- Created: January 2026

CREATE TABLE IF NOT EXISTS QUAD_memory_templates (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    name            VARCHAR(255) NOT NULL,
    document_type   VARCHAR(50) NOT NULL,
    template_content TEXT NOT NULL,

    description     TEXT,
    placeholders    JSONB,  -- { "project_name": "string", "tech_stack": "array" }

    is_system       BOOLEAN DEFAULT false,
    is_active       BOOLEAN DEFAULT true,

    created_at      TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at      TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON TABLE QUAD_memory_templates IS 'Templates for creating memory documents';
