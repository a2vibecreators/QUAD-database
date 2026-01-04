-- ============================================================================
-- QUAD Framework - Initial Data Load (Master Loader)
-- ============================================================================
-- Purpose: Loads all seed data files in correct order for testing
--
-- Usage (PostgreSQL):
--   \i initial-data-load.sql
--
-- Usage (H2 - Tests):
--   Loaded via @Sql annotation in Spring Boot tests
--
-- Order is important! Reference data must be loaded before dependent data.
-- ============================================================================

-- Phase 1: System Configuration (no dependencies)
\i 001_org_tiers.dta.sql

-- Phase 2: Skills & AI Providers (no org dependencies)
\i 002_skills.dta.sql
\i 003_ai_providers.dta.sql

-- Phase 3: Templates & Training (no org dependencies)
\i 004_setup_templates.dta.sql
\i 005_training_content.dta.sql

-- Phase 4: Test Organizations (depends on tiers)
\i 999_test_organizations.dta.sql

-- ============================================================================
-- Verification Queries (uncomment to verify data loaded)
-- ============================================================================
-- SELECT 'Org Tiers: ' || COUNT(*) FROM QUAD_org_tiers;
-- SELECT 'Skills: ' || COUNT(*) FROM QUAD_skills;
-- SELECT 'AI Providers: ' || COUNT(*) FROM QUAD_ai_provider_config;
-- SELECT 'Setup Templates: ' || COUNT(*) FROM QUAD_resource_setup_templates;
-- SELECT 'Training Content: ' || COUNT(*) FROM QUAD_training_content;
-- SELECT 'Organizations: ' || COUNT(*) FROM QUAD_organizations;
-- SELECT 'Users: ' || COUNT(*) FROM QUAD_users;
-- SELECT 'Domains: ' || COUNT(*) FROM QUAD_domains;
-- SELECT 'Tickets: ' || COUNT(*) FROM QUAD_tickets;
