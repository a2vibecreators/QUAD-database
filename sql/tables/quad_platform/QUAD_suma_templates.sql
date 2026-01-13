-- asksuma.ai - Template Gallery
-- Purpose: Store template metadata for web app generation (shown for preview only)
-- Created: January 10, 2026

CREATE TABLE IF NOT EXISTS QUAD_suma_templates (
    -- Primary key
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    -- Template details
    name VARCHAR(200) NOT NULL, -- "E-commerce Store", "Healthcare Portal", "SaaS Dashboard"
    category VARCHAR(50) NOT NULL, -- "ecommerce", "healthcare", "saas", "realestate", "education"
    description TEXT NOT NULL,

    -- Preview assets
    preview_image_url TEXT, -- Screenshot of template
    demo_url TEXT, -- Live demo URL

    -- Technical details
    tech_stack JSONB NOT NULL, -- {"frontend": "Next.js 15", "backend": "Node.js", "database": "PostgreSQL", "ui": "Tailwind CSS"}
    features TEXT[], -- ["User authentication", "Payment processing", "Admin dashboard"]

    -- Generation hints (used by Gemini AI)
    generation_prompt TEXT, -- Base prompt for this template category
    required_env_vars TEXT[], -- ["STRIPE_KEY", "DATABASE_URL"]

    -- Template type (FREE vs PAID)
    is_starter BOOLEAN DEFAULT false, -- true = fixed starter template (FREE)
    tier VARCHAR(20) DEFAULT 'free' CHECK (tier IN ('free', 'paid')),
    created_by UUID REFERENCES QUAD_users(id), -- NULL for starters, user_id for custom

    -- Visibility
    is_public BOOLEAN DEFAULT true, -- false for user's private templates
    is_active BOOLEAN DEFAULT true,
    sort_order INT DEFAULT 0, -- Display order in gallery

    -- Timestamps
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

-- Indexes
CREATE INDEX idx_suma_templates_category ON QUAD_suma_templates(category) WHERE is_active = true;
CREATE INDEX idx_suma_templates_sort ON QUAD_suma_templates(sort_order);

-- Trigger to update updated_at timestamp
CREATE OR REPLACE FUNCTION update_suma_templates_timestamp()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_suma_templates_updated_at
    BEFORE UPDATE ON QUAD_suma_templates
    FOR EACH ROW
    EXECUTE FUNCTION update_suma_templates_timestamp();

-- Comments
COMMENT ON TABLE QUAD_suma_templates IS 'Template gallery for asksuma.ai (FREE starters + PAID custom templates)';
COMMENT ON COLUMN QUAD_suma_templates.category IS 'Template category (ecommerce, healthcare, saas, realestate, education)';
COMMENT ON COLUMN QUAD_suma_templates.tech_stack IS 'JSON object with framework details';
COMMENT ON COLUMN QUAD_suma_templates.generation_prompt IS 'Base prompt used by Gemini AI for code generation';
COMMENT ON COLUMN QUAD_suma_templates.preview_image_url IS 'Screenshot shown in template gallery';
COMMENT ON COLUMN QUAD_suma_templates.is_starter IS 'TRUE = fixed starter template (FREE), FALSE = user-generated (PAID)';
COMMENT ON COLUMN QUAD_suma_templates.tier IS 'free = available to all users, paid = requires payment to generate';
COMMENT ON COLUMN QUAD_suma_templates.created_by IS 'NULL for starter templates, user_id for custom paid templates';
