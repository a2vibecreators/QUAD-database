-- ============================================================================
-- QUAD Framework - Organization Tiers Seed Data
-- ============================================================================
-- File: 001_org_tiers.dta.sql
-- Purpose: Seed data for QUAD_org_tiers table
-- Compatibility: H2 Database (standard INSERT statements)
--
-- This file creates the 4 subscription tiers for QUAD Framework:
--   - free: Basic tier for individuals and small teams
--   - starter: Entry-level paid tier for growing teams
--   - professional: Mid-tier for established organizations
--   - enterprise: Full-featured tier for large organizations
--
-- UUID Pattern: 00000000-0000-0000-0000-00000000000X (tiers 1-4)
-- ============================================================================

-- Free Tier
INSERT INTO QUAD_org_tiers (
    id, name, display_name, description,
    max_users, max_domains, max_ai_requests_month, max_storage_gb,
    features, price_monthly, price_yearly, is_active, created_at, updated_at
) VALUES (
    '00000000-0000-0000-0000-000000000001',
    'free',
    'Free',
    'Perfect for individuals and small teams getting started with QUAD Framework. Includes essential features for basic project management and AI assistance.',
    5,
    1,
    100,
    1,
    '{"tickets": true, "domains": true, "ai_chat": true, "basic_reports": true, "email_support": false, "priority_support": false, "custom_integrations": false, "sso": false, "audit_logs": false, "api_access": false}',
    0.00,
    0.00,
    true,
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP
);

-- Starter Tier
INSERT INTO QUAD_org_tiers (
    id, name, display_name, description,
    max_users, max_domains, max_ai_requests_month, max_storage_gb,
    features, price_monthly, price_yearly, is_active, created_at, updated_at
) VALUES (
    '00000000-0000-0000-0000-000000000002',
    'starter',
    'Starter',
    'Ideal for growing teams that need more capacity and features. Includes email support and expanded AI capabilities.',
    25,
    5,
    1000,
    10,
    '{"tickets": true, "domains": true, "ai_chat": true, "basic_reports": true, "advanced_reports": true, "email_support": true, "priority_support": false, "custom_integrations": false, "sso": false, "audit_logs": false, "api_access": true}',
    29.00,
    290.00,
    true,
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP
);

-- Professional Tier
INSERT INTO QUAD_org_tiers (
    id, name, display_name, description,
    max_users, max_domains, max_ai_requests_month, max_storage_gb,
    features, price_monthly, price_yearly, is_active, created_at, updated_at
) VALUES (
    '00000000-0000-0000-0000-000000000003',
    'professional',
    'Professional',
    'Built for established organizations requiring advanced features, priority support, and extensive AI usage. Includes SSO and audit logging.',
    100,
    20,
    10000,
    100,
    '{"tickets": true, "domains": true, "ai_chat": true, "basic_reports": true, "advanced_reports": true, "email_support": true, "priority_support": true, "custom_integrations": true, "sso": true, "audit_logs": true, "api_access": true, "webhooks": true}',
    99.00,
    990.00,
    true,
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP
);

-- Enterprise Tier
INSERT INTO QUAD_org_tiers (
    id, name, display_name, description,
    max_users, max_domains, max_ai_requests_month, max_storage_gb,
    features, price_monthly, price_yearly, is_active, created_at, updated_at
) VALUES (
    '00000000-0000-0000-0000-000000000004',
    'enterprise',
    'Enterprise',
    'Full-featured tier for large organizations with unlimited resources, dedicated support, custom integrations, and enterprise-grade security features.',
    NULL,
    NULL,
    NULL,
    NULL,
    '{"tickets": true, "domains": true, "ai_chat": true, "basic_reports": true, "advanced_reports": true, "email_support": true, "priority_support": true, "dedicated_support": true, "custom_integrations": true, "sso": true, "audit_logs": true, "api_access": true, "webhooks": true, "custom_branding": true, "data_export": true, "sla_guarantee": true}',
    499.00,
    4990.00,
    true,
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP
);

-- ============================================================================
-- End of seed data
-- ============================================================================
