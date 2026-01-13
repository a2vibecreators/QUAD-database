-- asksuma.ai - User App Catalog
-- Purpose: Track user-generated apps with deployment status
-- Created: January 10, 2026

CREATE TABLE IF NOT EXISTS QUAD_suma_apps (
    -- Primary key
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    -- Foreign keys
    org_id UUID NOT NULL REFERENCES QUAD_organizations(id) ON DELETE CASCADE,
    template_id UUID REFERENCES QUAD_suma_templates(id), -- NULL if custom app
    created_by UUID REFERENCES QUAD_users(id),

    -- App details
    app_name VARCHAR(200) NOT NULL, -- "MyHealthApp", "ShopEasy"
    category VARCHAR(50) NOT NULL, -- "ecommerce", "healthcare", etc.

    -- User-provided inspiration
    reference_url TEXT, -- Optional: "shopify.com", "amazon.com" (design inspiration)
    reference_screenshot_url TEXT, -- Auto-captured screenshot if reference_url provided

    -- Domain configuration
    subdomain VARCHAR(100) UNIQUE, -- "abc" in beta-abc.suma.ai and abc.suma.ai
    custom_domain VARCHAR(255), -- Optional: "myapp.com" (via Cloudflare)
    cloudflare_zone_id VARCHAR(100), -- Cloudflare zone ID if custom domain

    -- Deployment URLs
    beta_url TEXT, -- "beta-abc.suma.ai"
    prod_url TEXT, -- "abc.suma.ai" or "myapp.com"

    -- Repository details
    git_repo_url TEXT, -- "https://github.com/user/myapp"
    git_branch VARCHAR(100) DEFAULT 'main',
    git_token_hash VARCHAR(128), -- bcrypt hashed Git token

    -- Deployment status
    status VARCHAR(50) DEFAULT 'generating' CHECK (status IN ('generating', 'deploying', 'deployed', 'failed', 'updating')),
    last_deployment_at TIMESTAMP,
    deployment_error TEXT,

    -- Generation metadata
    tech_stack JSONB, -- Generated stack (may differ from template)
    generation_log TEXT, -- Gemini AI generation log

    -- Timestamps
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

-- Indexes
CREATE INDEX idx_suma_apps_org ON QUAD_suma_apps(org_id);
CREATE INDEX idx_suma_apps_status ON QUAD_suma_apps(status);
CREATE INDEX idx_suma_apps_subdomain ON QUAD_suma_apps(subdomain) WHERE subdomain IS NOT NULL;
CREATE INDEX idx_suma_apps_created_by ON QUAD_suma_apps(created_by);

-- Trigger to update updated_at timestamp
CREATE OR REPLACE FUNCTION update_suma_apps_timestamp()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_suma_apps_updated_at
    BEFORE UPDATE ON QUAD_suma_apps
    FOR EACH ROW
    EXECUTE FUNCTION update_suma_apps_timestamp();

-- Comments
COMMENT ON TABLE QUAD_suma_apps IS 'User app catalog for asksuma.ai (generated apps with deployment tracking)';
COMMENT ON COLUMN QUAD_suma_apps.reference_url IS 'Optional sample website URL provided by user (e.g., shopify.com)';
COMMENT ON COLUMN QUAD_suma_apps.subdomain IS 'Subdomain for beta-{subdomain}.suma.ai and {subdomain}.suma.ai';
COMMENT ON COLUMN QUAD_suma_apps.custom_domain IS 'Optional custom domain if user brings their own (via Cloudflare)';
COMMENT ON COLUMN QUAD_suma_apps.status IS 'Deployment status (generating, deploying, deployed, failed, updating)';
COMMENT ON COLUMN QUAD_suma_apps.git_repo_url IS 'GitHub/GitLab repo URL where code is pushed';
