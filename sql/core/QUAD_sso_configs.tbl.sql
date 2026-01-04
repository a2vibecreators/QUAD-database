-- QUAD_sso_configs Table (formerly company_sso_configs)
-- Per-company SSO provider configurations
--
-- Part of: QUAD Core
-- Created: January 2026

CREATE TABLE IF NOT EXISTS quad_sso_configs (
    id                          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    company_id                  UUID NOT NULL REFERENCES quad_companies(id) ON DELETE CASCADE,
    provider                    VARCHAR(50) NOT NULL,  -- google, okta, azure_ad, saml
    provider_name               VARCHAR(100),
    client_id                   VARCHAR(255) NOT NULL,
    client_secret_vault_path    VARCHAR(255),  -- Path in Vaultwarden
    issuer_url                  VARCHAR(500),
    authorization_url           VARCHAR(500),
    token_url                   VARCHAR(500),
    userinfo_url                VARCHAR(500),
    saml_entity_id              VARCHAR(500),
    saml_sso_url                VARCHAR(500),
    saml_certificate_vault_path VARCHAR(255),
    enabled                     BOOLEAN DEFAULT true,
    auto_provision_users        BOOLEAN DEFAULT true,
    default_role                VARCHAR(50) DEFAULT 'DEVELOPER',
    created_at                  TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at                  TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Indexes
CREATE INDEX IF NOT EXISTS idx_quad_sso_configs_company ON quad_sso_configs(company_id);
CREATE INDEX IF NOT EXISTS idx_quad_sso_configs_provider ON quad_sso_configs(provider);

-- Comments
COMMENT ON TABLE quad_sso_configs IS 'Per-company SSO provider configurations';
COMMENT ON COLUMN quad_sso_configs.client_secret_vault_path IS 'Path in Vaultwarden: company/{company_id}/sso/{provider}';
COMMENT ON COLUMN quad_sso_configs.auto_provision_users IS 'Create user on first SSO login if they match company email domain';
