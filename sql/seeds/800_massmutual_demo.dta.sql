-- ============================================================================
-- MassMutual Partner Demo Seed Data
-- ============================================================================
-- File: 800_massmutual_demo.dta.sql
-- Purpose: Pre-populated demo data for MassMutual pitch
-- Created: January 2026
--
-- Structure:
-- - MassMutual (Parent Org)
--   ├── Digital Experience (Sub-Org) → Customer Portal (Project)
--   └── Data Engineering (Sub-Org) → Claims Pipeline (Project)
--
-- Password: Ashrith (set in quad-web config, not DB)
--
-- ============================================================================
-- UUID ENCODING CONVENTION:
-- ============================================================================
-- Organization: MASSMUTL-xxxx-xxxx-xxxx-xxxxxxxxxxxx
-- Sub-Orgs:     MASSMUTL-SUB1/SUB2-xxxx-xxxx
-- Domains:      MASSMUTL-DOM1/DOM2-xxxx-xxxx
-- Users:        MASSMUTL-USER-xxxx-xxxx
-- ============================================================================

-- ============================================================================
-- PART 1: ORGANIZATIONS (Parent + 2 Sub-Orgs)
-- ============================================================================

-- MassMutual Parent Organization
INSERT INTO QUAD_organizations (
    id, parent_id, name, slug, admin_email, description,
    size, path, org_type, is_active, is_visible
) VALUES (
    'MASSMUTL-0000-0000-0000-000000000001',
    NULL,
    'MassMutual',
    'massmutual',
    'sarah.chen@massmutual.com',
    'MassMutual - 170+ years of financial services. Customer Portal and Claims Pipeline demo.',
    'enterprise',
    '/massmutual',
    'DEMO',
    true,
    true
) ON CONFLICT (id) DO NOTHING;

-- Sub-Org 1: Digital Experience
INSERT INTO QUAD_organizations (
    id, parent_id, name, slug, admin_email, description,
    size, path, org_type, is_active, is_visible
) VALUES (
    'MASSMUTL-SUB1-0000-0000-000000000001',
    'MASSMUTL-0000-0000-0000-000000000001',
    'Digital Experience',
    'digital-experience',
    'mike.rodriguez@massmutual.com',
    'Customer-facing digital products and mobile apps',
    'large',
    '/massmutual/digital-experience',
    'DEMO',
    true,
    true
) ON CONFLICT (id) DO NOTHING;

-- Sub-Org 2: Data Engineering
INSERT INTO QUAD_organizations (
    id, parent_id, name, slug, admin_email, description,
    size, path, org_type, is_active, is_visible
) VALUES (
    'MASSMUTL-SUB2-0000-0000-000000000001',
    'MASSMUTL-0000-0000-0000-000000000001',
    'Data Engineering',
    'data-engineering',
    'priya.sharma@massmutual.com',
    'Data pipelines, ETL, analytics, and ML infrastructure',
    'medium',
    '/massmutual/data-engineering',
    'DEMO',
    true,
    true
) ON CONFLICT (id) DO NOTHING;


-- ============================================================================
-- PART 2: USERS (6 Demo Users)
-- ============================================================================

-- Sarah Chen - Senior Director (Executive)
INSERT INTO quad_users (
    id, company_id, email, name, avatar_url, department, job_title,
    github_username, slack_user_id, timezone, is_active, is_admin
) VALUES (
    'MASSMUTL-USER-0000-0000-000000000001',
    NULL,
    'sarah.chen@massmutual.com',
    'Sarah Chen',
    'https://api.dicebear.com/7.x/avataaars/svg?seed=sarah',
    'Digital Transformation',
    'Senior Director',
    'sarah-chen',
    'UMMSARAH',
    'America/New_York',
    true,
    true
) ON CONFLICT (id) DO NOTHING;

-- Mike Rodriguez - Team Lead, Customer Portal
INSERT INTO quad_users (
    id, company_id, email, name, avatar_url, department, job_title,
    github_username, slack_user_id, timezone, is_active, is_admin
) VALUES (
    'MASSMUTL-USER-0000-0000-000000000002',
    NULL,
    'mike.rodriguez@massmutual.com',
    'Mike Rodriguez',
    'https://api.dicebear.com/7.x/avataaars/svg?seed=mike',
    'Digital Experience',
    'Team Lead',
    'mike-rodriguez',
    'UMMMIKE',
    'America/New_York',
    true,
    false
) ON CONFLICT (id) DO NOTHING;

-- Priya Sharma - Principal Engineer, Data
INSERT INTO quad_users (
    id, company_id, email, name, avatar_url, department, job_title,
    github_username, slack_user_id, timezone, is_active, is_admin
) VALUES (
    'MASSMUTL-USER-0000-0000-000000000003',
    NULL,
    'priya.sharma@massmutual.com',
    'Priya Sharma',
    'https://api.dicebear.com/7.x/avataaars/svg?seed=priya',
    'Data Engineering',
    'Principal Engineer',
    'priya-sharma',
    'UMMPRIYA',
    'America/New_York',
    true,
    false
) ON CONFLICT (id) DO NOTHING;

-- James Wilson - Senior Developer
INSERT INTO quad_users (
    id, company_id, email, name, avatar_url, department, job_title,
    github_username, slack_user_id, timezone, is_active, is_admin
) VALUES (
    'MASSMUTL-USER-0000-0000-000000000004',
    NULL,
    'james.wilson@massmutual.com',
    'James Wilson',
    'https://api.dicebear.com/7.x/avataaars/svg?seed=james',
    'Digital Experience',
    'Senior Developer',
    'james-wilson',
    'UMMJAMES',
    'America/Los_Angeles',
    true,
    false
) ON CONFLICT (id) DO NOTHING;

-- Emma Thompson - QA Lead
INSERT INTO quad_users (
    id, company_id, email, name, avatar_url, department, job_title,
    github_username, slack_user_id, timezone, is_active, is_admin
) VALUES (
    'MASSMUTL-USER-0000-0000-000000000005',
    NULL,
    'emma.thompson@massmutual.com',
    'Emma Thompson',
    'https://api.dicebear.com/7.x/avataaars/svg?seed=emma',
    'Quality Assurance',
    'QA Lead',
    'emma-thompson',
    'UMMEMMA',
    'America/Chicago',
    true,
    false
) ON CONFLICT (id) DO NOTHING;

-- David Kim - Platform Engineer
INSERT INTO quad_users (
    id, company_id, email, name, avatar_url, department, job_title,
    github_username, slack_user_id, timezone, is_active, is_admin
) VALUES (
    'MASSMUTL-USER-0000-0000-000000000006',
    NULL,
    'david.kim@massmutual.com',
    'David Kim',
    'https://api.dicebear.com/7.x/avataaars/svg?seed=david',
    'Platform Engineering',
    'Platform Engineer',
    'david-kim',
    'UMMDAVID',
    'America/New_York',
    true,
    false
) ON CONFLICT (id) DO NOTHING;


-- ============================================================================
-- PART 3: ORGANIZATION MEMBERS
-- ============================================================================

-- Sarah Chen - Owner of MassMutual (Parent)
INSERT INTO QUAD_org_members (
    id, org_id, user_id, role, status, joined_at
) VALUES (
    'MASSMUTL-MEMB-0000-0000-000000000001',
    'MASSMUTL-0000-0000-0000-000000000001',
    'MASSMUTL-USER-0000-0000-000000000001',
    'owner',
    'active',
    CURRENT_TIMESTAMP - INTERVAL '6 months'
) ON CONFLICT (org_id, user_id) DO NOTHING;

-- Mike Rodriguez - Manager of Digital Experience
INSERT INTO QUAD_org_members (
    id, org_id, user_id, role, status, joined_at
) VALUES (
    'MASSMUTL-MEMB-0000-0000-000000000002',
    'MASSMUTL-SUB1-0000-0000-000000000001',
    'MASSMUTL-USER-0000-0000-000000000002',
    'admin',
    'active',
    CURRENT_TIMESTAMP - INTERVAL '5 months'
) ON CONFLICT (org_id, user_id) DO NOTHING;

-- Priya Sharma - Manager of Data Engineering
INSERT INTO QUAD_org_members (
    id, org_id, user_id, role, status, joined_at
) VALUES (
    'MASSMUTL-MEMB-0000-0000-000000000003',
    'MASSMUTL-SUB2-0000-0000-000000000001',
    'MASSMUTL-USER-0000-0000-000000000003',
    'admin',
    'active',
    CURRENT_TIMESTAMP - INTERVAL '5 months'
) ON CONFLICT (org_id, user_id) DO NOTHING;

-- James, Emma, David as members
INSERT INTO QUAD_org_members (id, org_id, user_id, role, status, joined_at) VALUES
    ('MASSMUTL-MEMB-0000-0000-000000000004', 'MASSMUTL-SUB1-0000-0000-000000000001', 'MASSMUTL-USER-0000-0000-000000000004', 'member', 'active', CURRENT_TIMESTAMP - INTERVAL '4 months'),
    ('MASSMUTL-MEMB-0000-0000-000000000005', 'MASSMUTL-SUB1-0000-0000-000000000001', 'MASSMUTL-USER-0000-0000-000000000005', 'member', 'active', CURRENT_TIMESTAMP - INTERVAL '4 months'),
    ('MASSMUTL-MEMB-0000-0000-000000000006', 'MASSMUTL-SUB1-0000-0000-000000000001', 'MASSMUTL-USER-0000-0000-000000000006', 'member', 'active', CURRENT_TIMESTAMP - INTERVAL '3 months')
ON CONFLICT (org_id, user_id) DO NOTHING;

-- Priya, Emma, David also in Data Engineering
INSERT INTO QUAD_org_members (id, org_id, user_id, role, status, joined_at) VALUES
    ('MASSMUTL-MEMB-0000-0000-000000000007', 'MASSMUTL-SUB2-0000-0000-000000000001', 'MASSMUTL-USER-0000-0000-000000000005', 'member', 'active', CURRENT_TIMESTAMP - INTERVAL '4 months'),
    ('MASSMUTL-MEMB-0000-0000-000000000008', 'MASSMUTL-SUB2-0000-0000-000000000001', 'MASSMUTL-USER-0000-0000-000000000006', 'member', 'active', CURRENT_TIMESTAMP - INTERVAL '3 months')
ON CONFLICT (org_id, user_id) DO NOTHING;


-- ============================================================================
-- PART 4: DOMAINS (Projects)
-- ============================================================================

-- Domain 1: Customer Portal (Digital Experience)
INSERT INTO quad_domains (
    id, company_id, name, slug, description, methodology,
    git_repo_url, git_default_branch, created_by, is_active
) VALUES (
    'MASSMUTL-DOM1-0000-0000-000000000001',
    'MASSMUTL-SUB1-0000-0000-000000000001',
    'Customer Portal',
    'customer-portal',
    'Self-service web portal for policy holders. Next.js 15 + Spring Boot 3.2 + PostgreSQL',
    'quad',
    'https://github.com/massmutual/customer-portal',
    'main',
    'MASSMUTL-USER-0000-0000-000000000002',
    true
) ON CONFLICT (id) DO NOTHING;

-- Domain 2: Claims Pipeline (Data Engineering)
INSERT INTO quad_domains (
    id, company_id, name, slug, description, methodology,
    git_repo_url, git_default_branch, created_by, is_active
) VALUES (
    'MASSMUTL-DOM2-0000-0000-000000000001',
    'MASSMUTL-SUB2-0000-0000-000000000001',
    'Claims Pipeline',
    'claims-pipeline',
    'Automated claims processing with ML-powered fraud detection. Spring Batch + SageMaker + Redshift',
    'quad',
    'https://github.com/massmutual/claims-pipeline',
    'main',
    'MASSMUTL-USER-0000-0000-000000000003',
    true
) ON CONFLICT (id) DO NOTHING;


-- ============================================================================
-- PART 5: DOMAIN MEMBERS (Multi-Project Allocation)
-- ============================================================================

-- Customer Portal Team
INSERT INTO quad_domain_members (id, user_id, domain_id, role, allocation_percentage) VALUES
    -- Mike: 80% Customer Portal, Team Lead
    ('MASSMUTL-DMEM-0000-0000-000000000001', 'MASSMUTL-USER-0000-0000-000000000002', 'MASSMUTL-DOM1-0000-0000-000000000001', 'TEAM_LEAD', 80),
    -- Priya: 30% Customer Portal, Backend Architect
    ('MASSMUTL-DMEM-0000-0000-000000000002', 'MASSMUTL-USER-0000-0000-000000000003', 'MASSMUTL-DOM1-0000-0000-000000000001', 'ARCHITECT', 30),
    -- James: 100% Customer Portal, Developer
    ('MASSMUTL-DMEM-0000-0000-000000000003', 'MASSMUTL-USER-0000-0000-000000000004', 'MASSMUTL-DOM1-0000-0000-000000000001', 'DEVELOPER', 100),
    -- Emma: 60% Customer Portal, QA Lead
    ('MASSMUTL-DMEM-0000-0000-000000000004', 'MASSMUTL-USER-0000-0000-000000000005', 'MASSMUTL-DOM1-0000-0000-000000000001', 'QA_LEAD', 60),
    -- David: 50% Customer Portal, DevOps
    ('MASSMUTL-DMEM-0000-0000-000000000005', 'MASSMUTL-USER-0000-0000-000000000006', 'MASSMUTL-DOM1-0000-0000-000000000001', 'DEVOPS', 50)
ON CONFLICT (user_id, domain_id) DO NOTHING;

-- Claims Pipeline Team
INSERT INTO quad_domain_members (id, user_id, domain_id, role, allocation_percentage) VALUES
    -- Priya: 70% Claims Pipeline, Tech Lead
    ('MASSMUTL-DMEM-0000-0000-000000000006', 'MASSMUTL-USER-0000-0000-000000000003', 'MASSMUTL-DOM2-0000-0000-000000000001', 'TEAM_LEAD', 70),
    -- Mike: 20% Claims Pipeline, Technical Advisor
    ('MASSMUTL-DMEM-0000-0000-000000000007', 'MASSMUTL-USER-0000-0000-000000000002', 'MASSMUTL-DOM2-0000-0000-000000000001', 'ADVISOR', 20),
    -- Emma: 40% Claims Pipeline, QA
    ('MASSMUTL-DMEM-0000-0000-000000000008', 'MASSMUTL-USER-0000-0000-000000000005', 'MASSMUTL-DOM2-0000-0000-000000000001', 'QA', 40),
    -- David: 50% Claims Pipeline, Platform Engineer
    ('MASSMUTL-DMEM-0000-0000-000000000009', 'MASSMUTL-USER-0000-0000-000000000006', 'MASSMUTL-DOM2-0000-0000-000000000001', 'DEVOPS', 50)
ON CONFLICT (user_id, domain_id) DO NOTHING;


-- ============================================================================
-- PART 6: CIRCLES (4 per Domain)
-- ============================================================================

-- Customer Portal Circles
INSERT INTO quad_circles (id, domain_id, name, description, circle_type, lead_user_id, is_active) VALUES
    ('MASSMUTL-CIRC-DOM1-0000-000000000001', 'MASSMUTL-DOM1-0000-0000-000000000001', 'Management Circle', 'Sprint planning, stakeholder alignment, risk management', 'MANAGEMENT', 'MASSMUTL-USER-0000-0000-000000000002', true),
    ('MASSMUTL-CIRC-DOM1-0000-000000000002', 'MASSMUTL-DOM1-0000-0000-000000000001', 'Development Circle', 'Feature development, code reviews, technical debt', 'DEVELOPMENT', 'MASSMUTL-USER-0000-0000-000000000004', true),
    ('MASSMUTL-CIRC-DOM1-0000-000000000003', 'MASSMUTL-DOM1-0000-0000-000000000001', 'QA Circle', 'Test automation, regression testing, performance testing', 'QA', 'MASSMUTL-USER-0000-0000-000000000005', true),
    ('MASSMUTL-CIRC-DOM1-0000-000000000004', 'MASSMUTL-DOM1-0000-0000-000000000001', 'Infrastructure Circle', 'CI/CD pipelines, monitoring, security', 'INFRASTRUCTURE', 'MASSMUTL-USER-0000-0000-000000000006', true)
ON CONFLICT (id) DO NOTHING;

-- Claims Pipeline Circles
INSERT INTO quad_circles (id, domain_id, name, description, circle_type, lead_user_id, is_active) VALUES
    ('MASSMUTL-CIRC-DOM2-0000-000000000001', 'MASSMUTL-DOM2-0000-0000-000000000001', 'Management Circle', 'Pipeline prioritization, SLA monitoring, vendor management', 'MANAGEMENT', 'MASSMUTL-USER-0000-0000-000000000003', true),
    ('MASSMUTL-CIRC-DOM2-0000-000000000002', 'MASSMUTL-DOM2-0000-0000-000000000001', 'Development Circle', 'ETL development, ML integration, data quality', 'DEVELOPMENT', 'MASSMUTL-USER-0000-0000-000000000003', true),
    ('MASSMUTL-CIRC-DOM2-0000-000000000003', 'MASSMUTL-DOM2-0000-0000-000000000001', 'QA Circle', 'Data validation, pipeline testing, reconciliation', 'QA', 'MASSMUTL-USER-0000-0000-000000000005', true),
    ('MASSMUTL-CIRC-DOM2-0000-000000000004', 'MASSMUTL-DOM2-0000-0000-000000000001', 'Infrastructure Circle', 'Pipeline orchestration, cost optimization, disaster recovery', 'INFRASTRUCTURE', 'MASSMUTL-USER-0000-0000-000000000006', true)
ON CONFLICT (id) DO NOTHING;


-- ============================================================================
-- PART 7: CYCLES (Sprints)
-- ============================================================================

-- Customer Portal Cycles
INSERT INTO quad_cycles (id, domain_id, name, cycle_number, goal, status, start_date, end_date, planned_velocity, actual_velocity) VALUES
    ('MASSMUTL-CYCL-DOM1-0000-000000000001', 'MASSMUTL-DOM1-0000-0000-000000000001', 'Sprint 11: Auth & Security', 11, 'Complete MFA and security hardening', 'completed', CURRENT_DATE - 21, CURRENT_DATE - 7, 48, 45),
    ('MASSMUTL-CYCL-DOM1-0000-000000000002', 'MASSMUTL-DOM1-0000-0000-000000000001', 'Sprint 12: Document Upload', 12, 'Policy document upload and storage', 'active', CURRENT_DATE - 7, CURRENT_DATE + 7, 48, NULL)
ON CONFLICT (id) DO NOTHING;

-- Claims Pipeline Cycles
INSERT INTO quad_cycles (id, domain_id, name, cycle_number, goal, status, start_date, end_date, planned_velocity, actual_velocity) VALUES
    ('MASSMUTL-CYCL-DOM2-0000-000000000001', 'MASSMUTL-DOM2-0000-0000-000000000001', 'Sprint 7: Fraud Model v1', 7, 'Initial fraud detection model deployment', 'completed', CURRENT_DATE - 21, CURRENT_DATE - 7, 32, 30),
    ('MASSMUTL-CYCL-DOM2-0000-000000000002', 'MASSMUTL-DOM2-0000-0000-000000000001', 'Sprint 8: ML Improvements', 8, 'Fraud model v2 with 15% accuracy improvement', 'active', CURRENT_DATE - 7, CURRENT_DATE + 7, 32, NULL)
ON CONFLICT (id) DO NOTHING;


-- ============================================================================
-- PART 8: TICKETS (Flows at different QUAD stages)
-- ============================================================================

-- Customer Portal Tickets
INSERT INTO quad_tickets (id, domain_id, cycle_id, ticket_number, title, description, ticket_type, status, priority, story_points, assigned_to, reported_by, started_at) VALUES
    -- Query stage
    ('MASSMUTL-TICK-DOM1-0000-000000000001', 'MASSMUTL-DOM1-0000-0000-000000000001', 'MASSMUTL-CYCL-DOM1-0000-000000000002', 'CP-236', 'Payment History Dashboard Widget', 'New widget showing last 12 months of payment history with charts', 'story', 'todo', 'low', 5, 'MASSMUTL-USER-0000-0000-000000000002', 'MASSMUTL-USER-0000-0000-000000000001', NULL),
    -- Understand stage
    ('MASSMUTL-TICK-DOM1-0000-000000000002', 'MASSMUTL-DOM1-0000-0000-000000000001', 'MASSMUTL-CYCL-DOM1-0000-000000000002', 'CP-235', 'Policy Document Upload & Storage', 'Allow customers to upload policy documents with virus scanning', 'story', 'in_design', 'medium', 13, 'MASSMUTL-USER-0000-0000-000000000004', 'MASSMUTL-USER-0000-0000-000000000001', CURRENT_TIMESTAMP - INTERVAL '2 days'),
    -- Act stage
    ('MASSMUTL-TICK-DOM1-0000-000000000003', 'MASSMUTL-DOM1-0000-0000-000000000001', 'MASSMUTL-CYCL-DOM1-0000-000000000002', 'CP-234', 'Implement MFA with Authenticator Apps', 'Add support for TOTP-based MFA using Google Authenticator, Authy', 'story', 'in_progress', 'high', 8, 'MASSMUTL-USER-0000-0000-000000000003', 'MASSMUTL-USER-0000-0000-000000000001', CURRENT_TIMESTAMP - INTERVAL '4 days'),
    ('MASSMUTL-TICK-DOM1-0000-000000000004', 'MASSMUTL-DOM1-0000-0000-000000000001', 'MASSMUTL-CYCL-DOM1-0000-000000000002', 'CP-240', 'Mobile-Responsive Claims Form', 'Redesign claims form for mobile-first experience', 'story', 'in_progress', 'medium', 8, 'MASSMUTL-USER-0000-0000-000000000004', 'MASSMUTL-USER-0000-0000-000000000001', CURRENT_TIMESTAMP - INTERVAL '3 days'),
    -- Deploy stage
    ('MASSMUTL-TICK-DOM1-0000-000000000005', 'MASSMUTL-DOM1-0000-0000-000000000001', 'MASSMUTL-CYCL-DOM1-0000-000000000002', 'CP-230', 'Beneficiary Management Module', 'Full CRUD for beneficiaries with validation and audit trail', 'story', 'in_testing', 'high', 13, 'MASSMUTL-USER-0000-0000-000000000006', 'MASSMUTL-USER-0000-0000-000000000001', CURRENT_TIMESTAMP - INTERVAL '6 days')
ON CONFLICT (id) DO NOTHING;

-- Claims Pipeline Tickets
INSERT INTO quad_tickets (id, domain_id, cycle_id, ticket_number, title, description, ticket_type, status, priority, story_points, assigned_to, reported_by, started_at) VALUES
    -- Query stage
    ('MASSMUTL-TICK-DOM2-0000-000000000001', 'MASSMUTL-DOM2-0000-0000-000000000001', 'MASSMUTL-CYCL-DOM2-0000-000000000002', 'CLM-095', 'Auto-Adjudication for Simple Claims', 'Implement straight-through processing for claims under $500', 'story', 'todo', 'high', 8, 'MASSMUTL-USER-0000-0000-000000000003', 'MASSMUTL-USER-0000-0000-000000000001', NULL),
    -- Understand stage
    ('MASSMUTL-TICK-DOM2-0000-000000000002', 'MASSMUTL-DOM2-0000-0000-000000000001', 'MASSMUTL-CYCL-DOM2-0000-000000000002', 'CLM-090', 'Claims Data Validation Framework', 'Build reusable validation framework for all incoming claim data', 'story', 'in_design', 'medium', 13, 'MASSMUTL-USER-0000-0000-000000000005', 'MASSMUTL-USER-0000-0000-000000000003', CURRENT_TIMESTAMP - INTERVAL '2 days'),
    -- Act stage
    ('MASSMUTL-TICK-DOM2-0000-000000000003', 'MASSMUTL-DOM2-0000-0000-000000000001', 'MASSMUTL-CYCL-DOM2-0000-000000000002', 'CLM-089', 'Fraud Detection ML Model v2', 'Upgrade fraud detection model with new features and 15% accuracy improvement', 'story', 'in_progress', 'high', 21, 'MASSMUTL-USER-0000-0000-000000000003', 'MASSMUTL-USER-0000-0000-000000000001', CURRENT_TIMESTAMP - INTERVAL '4 days'),
    -- Deploy stage
    ('MASSMUTL-TICK-DOM2-0000-000000000004', 'MASSMUTL-DOM2-0000-0000-000000000001', 'MASSMUTL-CYCL-DOM2-0000-000000000002', 'CLM-088', 'Redshift Query Optimization', 'Optimize top 10 slow queries reducing avg response from 12s to 2s', 'story', 'in_testing', 'medium', 5, 'MASSMUTL-USER-0000-0000-000000000006', 'MASSMUTL-USER-0000-0000-000000000003', CURRENT_TIMESTAMP - INTERVAL '5 days')
ON CONFLICT (id) DO NOTHING;


-- ============================================================================
-- SUMMARY
-- ============================================================================
--
-- MassMutual Demo Data:
--   - 1 Parent Org + 2 Sub-Orgs
--   - 6 Users (with multi-project allocation)
--   - 2 Domains (Customer Portal, Claims Pipeline)
--   - 8 Circles (4 per domain)
--   - 4 Cycles (2 per domain)
--   - 9 Tickets (at various QUAD stages: Query, Understand, Act, Deploy)
--
-- Multi-Project Allocation Examples:
--   - Priya: 70% Claims Pipeline + 30% Customer Portal
--   - Emma: 60% Customer Portal + 40% Claims Pipeline
--   - David: 50% Customer Portal + 50% Claims Pipeline
--   - Mike: 80% Customer Portal + 20% Claims Pipeline
--
-- ============================================================================
