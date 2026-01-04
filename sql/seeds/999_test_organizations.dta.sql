-- ============================================================================
-- QUAD Framework - Test Organizations Seed Data
-- ============================================================================
-- File: 999_test_organizations.dta.sql
-- Purpose: Create 2 complete test organizations with FULL relationship depth
-- Created: January 2026
--
-- This is the MOST IMPORTANT seed file for testing. It creates:
--   - 2 Test Organizations (Acme Corp full setup, Beta Inc minimal setup)
--   - Users, Domains, Circles, Cycles, Tickets with realistic data
--   - Full foreign key relationships for integration testing
--
-- ============================================================================
-- UUID ENCODING CONVENTION (for easy debugging):
-- ============================================================================
--
-- Organization 1 (Acme Corp):  11111111-xxxx-xxxx-xxxx-xxxxxxxxxxxx
-- Organization 2 (Beta Inc):   22222222-xxxx-xxxx-xxxx-xxxxxxxxxxxx
--
-- Entity Type Encoding (4th segment):
--   1111 = Organization
--   2222 = Domain
--   3333 = Circle
--   4444 = Cycle
--   5555 = Ticket
--   6666 = Role
--
-- Sequential ID (last segment):
--   000000000001 = First entity of type
--   000000000002 = Second entity, etc.
--
-- Example: 11111111-1111-1111-2222-000000000001
--          ^^^^^^^  ^^^^      ^^^^  ^^^^^^^^^^^^
--          Org 1    Version   Domain  First domain
--
-- ============================================================================
-- DATA STRUCTURE OVERVIEW:
-- ============================================================================
--
-- ORGANIZATION 1: Acme Corp (Full Setup)
-- +-- 3 Users: admin, developer, qa
-- +-- 2 Domains: backend-api, frontend-web
-- |   +-- backend-api
-- |   |   +-- 2 Circles: Development, QA
-- |   |   +-- 2 Cycles: Sprint 1 (completed), Sprint 2 (active)
-- |   |   +-- 10 Tickets (5 per cycle)
-- |   +-- frontend-web
-- |       +-- 2 Circles: Development, QA
-- |       +-- 2 Cycles: Sprint 1 (completed), Sprint 2 (active)
-- |       +-- 10 Tickets (5 per cycle)
-- +-- 4 Domain Roles per domain
--
-- ORGANIZATION 2: Beta Inc (Minimal Setup)
-- +-- 1 User: admin
-- +-- 1 Domain: main-product
-- |   +-- 1 Cycle: Sprint 1 (active)
-- |   +-- 2 Tickets
--
-- ============================================================================

-- ----------------------------------------------------------------------------
-- IMPORTANT: Schema Compatibility Note
-- ----------------------------------------------------------------------------
-- Some tables (quad_users, quad_domains) reference quad_companies(id),
-- but the actual organization table is QUAD_organizations.
--
-- For H2 compatibility, we create a view/alias if needed, or we insert
-- directly into the properly named table.
--
-- This seed assumes:
-- 1. QUAD_organizations is the primary org table
-- 2. If quad_companies exists as alias/view, it points to QUAD_organizations
-- 3. Users are linked to orgs via QUAD_org_members table
-- ----------------------------------------------------------------------------

-- ============================================================================
-- PART 1: ORGANIZATIONS
-- ============================================================================

-- Organization 1: Acme Corp (Full Setup - TEST type)
INSERT INTO QUAD_organizations (
    id, parent_id, name, slug, admin_email, description,
    size, path, org_type, is_active, is_visible
) VALUES (
    '11111111-1111-1111-1111-111111111111',
    NULL,
    'Acme Corp',
    'acme-corp',
    'admin@acme.test',
    'Full-featured test organization with complete relationship depth for integration testing',
    'large',
    '/acme-corp',
    'TEST',
    true,
    true
) ON CONFLICT (id) DO NOTHING;

-- Organization 2: Beta Inc (Minimal Setup - TEST type)
INSERT INTO QUAD_organizations (
    id, parent_id, name, slug, admin_email, description,
    size, path, org_type, is_active, is_visible
) VALUES (
    '22222222-2222-2222-2222-222222222222',
    NULL,
    'Beta Inc',
    'beta-inc',
    'admin@beta.test',
    'Minimal test organization for basic functionality testing',
    'small',
    '/beta-inc',
    'TEST',
    true,
    true
) ON CONFLICT (id) DO NOTHING;


-- ============================================================================
-- PART 2: USERS
-- ============================================================================
-- Note: quad_users.company_id may reference a quad_companies table.
-- We set company_id to NULL and rely on QUAD_org_members for org association.

-- --------------------------------------
-- Acme Corp Users (3 users)
-- --------------------------------------

-- Acme Admin User
INSERT INTO quad_users (
    id, company_id, email, name, avatar_url, department, job_title,
    github_username, slack_user_id, timezone, is_active, is_admin
) VALUES (
    '11111111-1111-1111-1111-000000000001',
    NULL,
    'admin@acme.test',
    'Alice Admin',
    'https://api.dicebear.com/7.x/avataaars/svg?seed=alice',
    'Engineering',
    'Engineering Manager',
    'alice-admin',
    'U001ACME',
    'America/New_York',
    true,
    true
) ON CONFLICT (id) DO NOTHING;

-- Acme Developer User
INSERT INTO quad_users (
    id, company_id, email, name, avatar_url, department, job_title,
    github_username, slack_user_id, timezone, is_active, is_admin
) VALUES (
    '11111111-1111-1111-1111-000000000002',
    NULL,
    'dev@acme.test',
    'David Developer',
    'https://api.dicebear.com/7.x/avataaars/svg?seed=david',
    'Engineering',
    'Senior Software Engineer',
    'david-dev',
    'U002ACME',
    'America/Los_Angeles',
    true,
    false
) ON CONFLICT (id) DO NOTHING;

-- Acme QA User
INSERT INTO quad_users (
    id, company_id, email, name, avatar_url, department, job_title,
    github_username, slack_user_id, timezone, is_active, is_admin
) VALUES (
    '11111111-1111-1111-1111-000000000003',
    NULL,
    'qa@acme.test',
    'Quinn QA',
    'https://api.dicebear.com/7.x/avataaars/svg?seed=quinn',
    'Quality Assurance',
    'QA Lead',
    'quinn-qa',
    'U003ACME',
    'America/Chicago',
    true,
    false
) ON CONFLICT (id) DO NOTHING;

-- --------------------------------------
-- Beta Inc Users (1 user)
-- --------------------------------------

-- Beta Admin User
INSERT INTO quad_users (
    id, company_id, email, name, avatar_url, department, job_title,
    github_username, slack_user_id, timezone, is_active, is_admin
) VALUES (
    '22222222-2222-2222-2222-000000000001',
    NULL,
    'admin@beta.test',
    'Bob Beta',
    'https://api.dicebear.com/7.x/avataaars/svg?seed=bob',
    'Product',
    'Product Owner',
    'bob-beta',
    'U001BETA',
    'Europe/London',
    true,
    true
) ON CONFLICT (id) DO NOTHING;


-- ============================================================================
-- PART 3: ORGANIZATION MEMBERS (Link users to orgs)
-- ============================================================================

-- --------------------------------------
-- Acme Corp Members
-- --------------------------------------

INSERT INTO QUAD_org_members (
    id, org_id, user_id, role, status, joined_at
) VALUES (
    '11111111-1111-1111-0001-000000000001',
    '11111111-1111-1111-1111-111111111111',
    '11111111-1111-1111-1111-000000000001',
    'owner',
    'active',
    CURRENT_TIMESTAMP
) ON CONFLICT (org_id, user_id) DO NOTHING;

INSERT INTO QUAD_org_members (
    id, org_id, user_id, role, status, joined_at
) VALUES (
    '11111111-1111-1111-0001-000000000002',
    '11111111-1111-1111-1111-111111111111',
    '11111111-1111-1111-1111-000000000002',
    'member',
    'active',
    CURRENT_TIMESTAMP
) ON CONFLICT (org_id, user_id) DO NOTHING;

INSERT INTO QUAD_org_members (
    id, org_id, user_id, role, status, joined_at
) VALUES (
    '11111111-1111-1111-0001-000000000003',
    '11111111-1111-1111-1111-111111111111',
    '11111111-1111-1111-1111-000000000003',
    'member',
    'active',
    CURRENT_TIMESTAMP
) ON CONFLICT (org_id, user_id) DO NOTHING;

-- --------------------------------------
-- Beta Inc Members
-- --------------------------------------

INSERT INTO QUAD_org_members (
    id, org_id, user_id, role, status, joined_at
) VALUES (
    '22222222-2222-2222-0001-000000000001',
    '22222222-2222-2222-2222-222222222222',
    '22222222-2222-2222-2222-000000000001',
    'owner',
    'active',
    CURRENT_TIMESTAMP
) ON CONFLICT (org_id, user_id) DO NOTHING;


-- ============================================================================
-- PART 4: DOMAINS
-- ============================================================================
-- Note: quad_domains.company_id references quad_companies.
-- Using organization ID as company_id for compatibility.

-- --------------------------------------
-- Acme Corp Domains (2 domains)
-- --------------------------------------

-- Acme Backend API Domain
INSERT INTO quad_domains (
    id, company_id, name, slug, description, methodology,
    git_repo_url, git_default_branch, created_by, is_active
) VALUES (
    '11111111-1111-1111-2222-000000000001',
    '11111111-1111-1111-1111-111111111111',
    'Backend API',
    'backend-api',
    'Core REST API services built with Spring Boot',
    'quad',
    'https://github.com/acme-corp/backend-api',
    'main',
    '11111111-1111-1111-1111-000000000001',
    true
) ON CONFLICT (id) DO NOTHING;

-- Acme Frontend Web Domain
INSERT INTO quad_domains (
    id, company_id, name, slug, description, methodology,
    git_repo_url, git_default_branch, created_by, is_active
) VALUES (
    '11111111-1111-1111-2222-000000000002',
    '11111111-1111-1111-1111-111111111111',
    'Frontend Web',
    'frontend-web',
    'React-based web application for end users',
    'quad',
    'https://github.com/acme-corp/frontend-web',
    'main',
    '11111111-1111-1111-1111-000000000001',
    true
) ON CONFLICT (id) DO NOTHING;

-- --------------------------------------
-- Beta Inc Domains (1 domain)
-- --------------------------------------

-- Beta Main Product Domain
INSERT INTO quad_domains (
    id, company_id, name, slug, description, methodology,
    git_repo_url, git_default_branch, created_by, is_active
) VALUES (
    '22222222-2222-2222-3333-000000000001',
    '22222222-2222-2222-2222-222222222222',
    'Main Product',
    'main-product',
    'Beta Inc primary product application',
    'scrum',
    'https://github.com/beta-inc/main-product',
    'main',
    '22222222-2222-2222-2222-000000000001',
    true
) ON CONFLICT (id) DO NOTHING;


-- ============================================================================
-- PART 5: DOMAIN MEMBERS
-- ============================================================================

-- --------------------------------------
-- Acme Backend API Domain Members
-- --------------------------------------

INSERT INTO quad_domain_members (
    id, user_id, domain_id, role, allocation_percentage
) VALUES (
    '11111111-1111-1111-0002-000000000001',
    '11111111-1111-1111-1111-000000000001',
    '11111111-1111-1111-2222-000000000001',
    'MANAGER',
    50
) ON CONFLICT (user_id, domain_id) DO NOTHING;

INSERT INTO quad_domain_members (
    id, user_id, domain_id, role, allocation_percentage
) VALUES (
    '11111111-1111-1111-0002-000000000002',
    '11111111-1111-1111-1111-000000000002',
    '11111111-1111-1111-2222-000000000001',
    'DEVELOPER',
    80
) ON CONFLICT (user_id, domain_id) DO NOTHING;

INSERT INTO quad_domain_members (
    id, user_id, domain_id, role, allocation_percentage
) VALUES (
    '11111111-1111-1111-0002-000000000003',
    '11111111-1111-1111-1111-000000000003',
    '11111111-1111-1111-2222-000000000001',
    'QA',
    50
) ON CONFLICT (user_id, domain_id) DO NOTHING;

-- --------------------------------------
-- Acme Frontend Web Domain Members
-- --------------------------------------

INSERT INTO quad_domain_members (
    id, user_id, domain_id, role, allocation_percentage
) VALUES (
    '11111111-1111-1111-0002-000000000004',
    '11111111-1111-1111-1111-000000000001',
    '11111111-1111-1111-2222-000000000002',
    'MANAGER',
    50
) ON CONFLICT (user_id, domain_id) DO NOTHING;

INSERT INTO quad_domain_members (
    id, user_id, domain_id, role, allocation_percentage
) VALUES (
    '11111111-1111-1111-0002-000000000005',
    '11111111-1111-1111-1111-000000000002',
    '11111111-1111-1111-2222-000000000002',
    'DEVELOPER',
    20
) ON CONFLICT (user_id, domain_id) DO NOTHING;

INSERT INTO quad_domain_members (
    id, user_id, domain_id, role, allocation_percentage
) VALUES (
    '11111111-1111-1111-0002-000000000006',
    '11111111-1111-1111-1111-000000000003',
    '11111111-1111-1111-2222-000000000002',
    'QA',
    50
) ON CONFLICT (user_id, domain_id) DO NOTHING;

-- --------------------------------------
-- Beta Inc Domain Members
-- --------------------------------------

INSERT INTO quad_domain_members (
    id, user_id, domain_id, role, allocation_percentage
) VALUES (
    '22222222-2222-2222-0002-000000000001',
    '22222222-2222-2222-2222-000000000001',
    '22222222-2222-2222-3333-000000000001',
    'MANAGER',
    100
) ON CONFLICT (user_id, domain_id) DO NOTHING;


-- ============================================================================
-- PART 6: CIRCLES (4 per domain in QUAD methodology)
-- ============================================================================

-- --------------------------------------
-- Acme Backend API Circles
-- --------------------------------------

INSERT INTO quad_circles (
    id, domain_id, name, description, circle_type, lead_user_id, is_active
) VALUES (
    '11111111-1111-1111-3333-000000000001',
    '11111111-1111-1111-2222-000000000001',
    'Backend Development',
    'Core API development team',
    'DEVELOPMENT',
    '11111111-1111-1111-1111-000000000002',
    true
) ON CONFLICT (id) DO NOTHING;

INSERT INTO quad_circles (
    id, domain_id, name, description, circle_type, lead_user_id, is_active
) VALUES (
    '11111111-1111-1111-3333-000000000002',
    '11111111-1111-1111-2222-000000000001',
    'Backend QA',
    'API testing and quality assurance',
    'QA',
    '11111111-1111-1111-1111-000000000003',
    true
) ON CONFLICT (id) DO NOTHING;

-- --------------------------------------
-- Acme Frontend Web Circles
-- --------------------------------------

INSERT INTO quad_circles (
    id, domain_id, name, description, circle_type, lead_user_id, is_active
) VALUES (
    '11111111-1111-1111-3333-000000000003',
    '11111111-1111-1111-2222-000000000002',
    'Frontend Development',
    'React web application development',
    'DEVELOPMENT',
    '11111111-1111-1111-1111-000000000002',
    true
) ON CONFLICT (id) DO NOTHING;

INSERT INTO quad_circles (
    id, domain_id, name, description, circle_type, lead_user_id, is_active
) VALUES (
    '11111111-1111-1111-3333-000000000004',
    '11111111-1111-1111-2222-000000000002',
    'Frontend QA',
    'UI testing and quality assurance',
    'QA',
    '11111111-1111-1111-1111-000000000003',
    true
) ON CONFLICT (id) DO NOTHING;


-- ============================================================================
-- PART 7: CIRCLE MEMBERS
-- ============================================================================

-- --------------------------------------
-- Backend Development Circle Members
-- --------------------------------------

INSERT INTO quad_circle_members (
    id, circle_id, user_id, role, allocation_pct
) VALUES (
    '11111111-1111-1111-0003-000000000001',
    '11111111-1111-1111-3333-000000000001',
    '11111111-1111-1111-1111-000000000002',
    'lead',
    100
) ON CONFLICT (circle_id, user_id) DO NOTHING;

-- --------------------------------------
-- Backend QA Circle Members
-- --------------------------------------

INSERT INTO quad_circle_members (
    id, circle_id, user_id, role, allocation_pct
) VALUES (
    '11111111-1111-1111-0003-000000000002',
    '11111111-1111-1111-3333-000000000002',
    '11111111-1111-1111-1111-000000000003',
    'lead',
    100
) ON CONFLICT (circle_id, user_id) DO NOTHING;

-- --------------------------------------
-- Frontend Development Circle Members
-- --------------------------------------

INSERT INTO quad_circle_members (
    id, circle_id, user_id, role, allocation_pct
) VALUES (
    '11111111-1111-1111-0003-000000000003',
    '11111111-1111-1111-3333-000000000003',
    '11111111-1111-1111-1111-000000000002',
    'lead',
    100
) ON CONFLICT (circle_id, user_id) DO NOTHING;

-- --------------------------------------
-- Frontend QA Circle Members
-- --------------------------------------

INSERT INTO quad_circle_members (
    id, circle_id, user_id, role, allocation_pct
) VALUES (
    '11111111-1111-1111-0003-000000000004',
    '11111111-1111-1111-3333-000000000004',
    '11111111-1111-1111-1111-000000000003',
    'lead',
    100
) ON CONFLICT (circle_id, user_id) DO NOTHING;


-- ============================================================================
-- PART 8: CYCLES (Sprints)
-- ============================================================================

-- --------------------------------------
-- Acme Backend API Cycles
-- --------------------------------------

-- Sprint 1 (Completed)
INSERT INTO quad_cycles (
    id, domain_id, name, cycle_number, goal, status,
    start_date, end_date, planned_velocity, actual_velocity
) VALUES (
    '11111111-1111-1111-4444-000000000001',
    '11111111-1111-1111-2222-000000000001',
    'Sprint 1: Foundation',
    1,
    'Establish core API endpoints and authentication',
    'completed',
    CURRENT_DATE - 28,
    CURRENT_DATE - 14,
    21,
    19
) ON CONFLICT (id) DO NOTHING;

-- Sprint 2 (Active)
INSERT INTO quad_cycles (
    id, domain_id, name, cycle_number, goal, status,
    start_date, end_date, planned_velocity, actual_velocity
) VALUES (
    '11111111-1111-1111-4444-000000000002',
    '11111111-1111-1111-2222-000000000001',
    'Sprint 2: User Management',
    2,
    'Complete user management and permissions system',
    'active',
    CURRENT_DATE - 7,
    CURRENT_DATE + 7,
    24,
    NULL
) ON CONFLICT (id) DO NOTHING;

-- --------------------------------------
-- Acme Frontend Web Cycles
-- --------------------------------------

-- Sprint 1 (Completed)
INSERT INTO quad_cycles (
    id, domain_id, name, cycle_number, goal, status,
    start_date, end_date, planned_velocity, actual_velocity
) VALUES (
    '11111111-1111-1111-4444-000000000003',
    '11111111-1111-1111-2222-000000000002',
    'Sprint 1: UI Framework',
    1,
    'Set up React with component library and routing',
    'completed',
    CURRENT_DATE - 28,
    CURRENT_DATE - 14,
    18,
    20
) ON CONFLICT (id) DO NOTHING;

-- Sprint 2 (Active)
INSERT INTO quad_cycles (
    id, domain_id, name, cycle_number, goal, status,
    start_date, end_date, planned_velocity, actual_velocity
) VALUES (
    '11111111-1111-1111-4444-000000000004',
    '11111111-1111-1111-2222-000000000002',
    'Sprint 2: Dashboard',
    2,
    'Build main dashboard with widgets',
    'active',
    CURRENT_DATE - 7,
    CURRENT_DATE + 7,
    21,
    NULL
) ON CONFLICT (id) DO NOTHING;

-- --------------------------------------
-- Beta Inc Main Product Cycle
-- --------------------------------------

-- Sprint 1 (Active)
INSERT INTO quad_cycles (
    id, domain_id, name, cycle_number, goal, status,
    start_date, end_date, planned_velocity, actual_velocity
) VALUES (
    '22222222-2222-2222-4444-000000000001',
    '22222222-2222-2222-3333-000000000001',
    'Sprint 1: MVP',
    1,
    'Deliver minimum viable product',
    'active',
    CURRENT_DATE - 3,
    CURRENT_DATE + 11,
    15,
    NULL
) ON CONFLICT (id) DO NOTHING;


-- ============================================================================
-- PART 9: DOMAIN ROLES
-- ============================================================================

-- --------------------------------------
-- Acme Backend API Roles
-- --------------------------------------

INSERT INTO quad_roles (
    id, domain_id, name, description, responsibilities_text, is_custom, is_active
) VALUES (
    '11111111-1111-1111-6666-000000000001',
    '11111111-1111-1111-2222-000000000001',
    'Admin',
    'Full administrative access to backend domain',
    'Manage users, configure settings, approve deployments, review code',
    false,
    true
) ON CONFLICT (id) DO NOTHING;

INSERT INTO quad_roles (
    id, domain_id, name, description, responsibilities_text, is_custom, is_active
) VALUES (
    '11111111-1111-1111-6666-000000000002',
    '11111111-1111-1111-2222-000000000001',
    'Developer',
    'Backend development role',
    'Write code, create pull requests, fix bugs, participate in code review',
    false,
    true
) ON CONFLICT (id) DO NOTHING;

INSERT INTO quad_roles (
    id, domain_id, name, description, responsibilities_text, is_custom, is_active
) VALUES (
    '11111111-1111-1111-6666-000000000003',
    '11111111-1111-1111-2222-000000000001',
    'QA',
    'Quality assurance role',
    'Write tests, perform testing, report bugs, verify fixes',
    false,
    true
) ON CONFLICT (id) DO NOTHING;

INSERT INTO quad_roles (
    id, domain_id, name, description, responsibilities_text, is_custom, is_active
) VALUES (
    '11111111-1111-1111-6666-000000000004',
    '11111111-1111-1111-2222-000000000001',
    'Viewer',
    'Read-only access',
    'View tickets, read documentation, observe progress',
    false,
    true
) ON CONFLICT (id) DO NOTHING;

-- --------------------------------------
-- Acme Frontend Web Roles
-- --------------------------------------

INSERT INTO quad_roles (
    id, domain_id, name, description, responsibilities_text, is_custom, is_active
) VALUES (
    '11111111-1111-1111-6666-000000000005',
    '11111111-1111-1111-2222-000000000002',
    'Admin',
    'Full administrative access to frontend domain',
    'Manage users, configure settings, approve deployments',
    false,
    true
) ON CONFLICT (id) DO NOTHING;

INSERT INTO quad_roles (
    id, domain_id, name, description, responsibilities_text, is_custom, is_active
) VALUES (
    '11111111-1111-1111-6666-000000000006',
    '11111111-1111-1111-2222-000000000002',
    'Developer',
    'Frontend development role',
    'Build UI components, implement features, fix bugs',
    false,
    true
) ON CONFLICT (id) DO NOTHING;

INSERT INTO quad_roles (
    id, domain_id, name, description, responsibilities_text, is_custom, is_active
) VALUES (
    '11111111-1111-1111-6666-000000000007',
    '11111111-1111-1111-2222-000000000002',
    'QA',
    'Quality assurance role',
    'Test UI, verify user flows, report visual bugs',
    false,
    true
) ON CONFLICT (id) DO NOTHING;

INSERT INTO quad_roles (
    id, domain_id, name, description, responsibilities_text, is_custom, is_active
) VALUES (
    '11111111-1111-1111-6666-000000000008',
    '11111111-1111-1111-2222-000000000002',
    'Viewer',
    'Read-only access',
    'View tickets and progress',
    false,
    true
) ON CONFLICT (id) DO NOTHING;


-- ============================================================================
-- PART 10: TICKETS
-- ============================================================================

-- --------------------------------------
-- Acme Backend API - Sprint 1 Tickets (Completed)
-- --------------------------------------

INSERT INTO quad_tickets (
    id, domain_id, cycle_id, ticket_number, title, description,
    ticket_type, status, priority, story_points,
    assigned_to, reported_by, completed_at
) VALUES (
    '11111111-1111-1111-5555-000000000001',
    '11111111-1111-1111-2222-000000000001',
    '11111111-1111-1111-4444-000000000001',
    'BE-001',
    'Set up Spring Boot project structure',
    'Initialize Spring Boot 3.2 project with proper package structure, dependencies, and configuration',
    'task',
    'done',
    'high',
    3,
    '11111111-1111-1111-1111-000000000002',
    '11111111-1111-1111-1111-000000000001',
    CURRENT_TIMESTAMP - INTERVAL '20 days'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO quad_tickets (
    id, domain_id, cycle_id, ticket_number, title, description,
    ticket_type, status, priority, story_points,
    assigned_to, reported_by, completed_at
) VALUES (
    '11111111-1111-1111-5555-000000000002',
    '11111111-1111-1111-2222-000000000001',
    '11111111-1111-1111-4444-000000000001',
    'BE-002',
    'Implement JWT authentication',
    'Add JWT-based authentication with login, logout, and token refresh endpoints',
    'story',
    'done',
    'critical',
    8,
    '11111111-1111-1111-1111-000000000002',
    '11111111-1111-1111-1111-000000000001',
    CURRENT_TIMESTAMP - INTERVAL '18 days'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO quad_tickets (
    id, domain_id, cycle_id, ticket_number, title, description,
    ticket_type, status, priority, story_points,
    assigned_to, reported_by, completed_at
) VALUES (
    '11111111-1111-1111-5555-000000000003',
    '11111111-1111-1111-2222-000000000001',
    '11111111-1111-1111-4444-000000000001',
    'BE-003',
    'Create user CRUD endpoints',
    'REST endpoints for user create, read, update, delete operations',
    'story',
    'done',
    'high',
    5,
    '11111111-1111-1111-1111-000000000002',
    '11111111-1111-1111-1111-000000000001',
    CURRENT_TIMESTAMP - INTERVAL '16 days'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO quad_tickets (
    id, domain_id, cycle_id, ticket_number, title, description,
    ticket_type, status, priority, story_points,
    assigned_to, reported_by, completed_at
) VALUES (
    '11111111-1111-1111-5555-000000000004',
    '11111111-1111-1111-2222-000000000001',
    '11111111-1111-1111-4444-000000000001',
    'BE-004',
    'Write unit tests for auth service',
    'Comprehensive unit tests for authentication service layer',
    'task',
    'done',
    'medium',
    3,
    '11111111-1111-1111-1111-000000000003',
    '11111111-1111-1111-1111-000000000002',
    CURRENT_TIMESTAMP - INTERVAL '15 days'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO quad_tickets (
    id, domain_id, cycle_id, ticket_number, title, description,
    ticket_type, status, priority, story_points,
    assigned_to, reported_by
) VALUES (
    '11111111-1111-1111-5555-000000000005',
    '11111111-1111-1111-2222-000000000001',
    '11111111-1111-1111-4444-000000000001',
    'BE-005',
    'Fix token expiry not handled correctly',
    'Token expiry edge case causes 500 error instead of 401',
    'bug',
    'done',
    'high',
    2,
    '11111111-1111-1111-1111-000000000002',
    '11111111-1111-1111-1111-000000000003'
) ON CONFLICT (id) DO NOTHING;

-- --------------------------------------
-- Acme Backend API - Sprint 2 Tickets (Active)
-- --------------------------------------

INSERT INTO quad_tickets (
    id, domain_id, cycle_id, ticket_number, title, description,
    ticket_type, status, priority, story_points,
    assigned_to, reported_by, started_at
) VALUES (
    '11111111-1111-1111-5555-000000000006',
    '11111111-1111-1111-2222-000000000001',
    '11111111-1111-1111-4444-000000000002',
    'BE-006',
    'Implement role-based access control',
    'Add RBAC with Admin, Developer, QA, Viewer roles',
    'story',
    'in_progress',
    'critical',
    8,
    '11111111-1111-1111-1111-000000000002',
    '11111111-1111-1111-1111-000000000001',
    CURRENT_TIMESTAMP - INTERVAL '3 days'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO quad_tickets (
    id, domain_id, cycle_id, ticket_number, title, description,
    ticket_type, status, priority, story_points,
    assigned_to, reported_by
) VALUES (
    '11111111-1111-1111-5555-000000000007',
    '11111111-1111-1111-2222-000000000001',
    '11111111-1111-1111-4444-000000000002',
    'BE-007',
    'Create organization management API',
    'Endpoints for org CRUD, member management, settings',
    'story',
    'todo',
    'high',
    5,
    '11111111-1111-1111-1111-000000000002',
    '11111111-1111-1111-1111-000000000001'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO quad_tickets (
    id, domain_id, cycle_id, ticket_number, title, description,
    ticket_type, status, priority, story_points,
    assigned_to, reported_by
) VALUES (
    '11111111-1111-1111-5555-000000000008',
    '11111111-1111-1111-2222-000000000001',
    '11111111-1111-1111-4444-000000000002',
    'BE-008',
    'Add invitation system',
    'Email-based invitation flow for adding team members',
    'story',
    'todo',
    'medium',
    5,
    NULL,
    '11111111-1111-1111-1111-000000000001'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO quad_tickets (
    id, domain_id, cycle_id, ticket_number, title, description,
    ticket_type, status, priority, story_points,
    assigned_to, reported_by, started_at
) VALUES (
    '11111111-1111-1111-5555-000000000009',
    '11111111-1111-1111-2222-000000000001',
    '11111111-1111-1111-4444-000000000002',
    'BE-009',
    'Write integration tests for RBAC',
    'Integration tests covering all role permission scenarios',
    'task',
    'in_progress',
    'medium',
    3,
    '11111111-1111-1111-1111-000000000003',
    '11111111-1111-1111-1111-000000000002',
    CURRENT_TIMESTAMP - INTERVAL '1 day'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO quad_tickets (
    id, domain_id, cycle_id, ticket_number, title, description,
    ticket_type, status, priority, story_points,
    assigned_to, reported_by
) VALUES (
    '11111111-1111-1111-5555-000000000010',
    '11111111-1111-1111-2222-000000000001',
    '11111111-1111-1111-4444-000000000002',
    'BE-010',
    'Audit logging for permission changes',
    'Log all RBAC changes for compliance',
    'task',
    'backlog',
    'low',
    3,
    NULL,
    '11111111-1111-1111-1111-000000000001'
) ON CONFLICT (id) DO NOTHING;

-- --------------------------------------
-- Acme Frontend Web - Sprint 1 Tickets (Completed)
-- --------------------------------------

INSERT INTO quad_tickets (
    id, domain_id, cycle_id, ticket_number, title, description,
    ticket_type, status, priority, story_points,
    assigned_to, reported_by, completed_at
) VALUES (
    '11111111-1111-1111-5555-000000000011',
    '11111111-1111-1111-2222-000000000002',
    '11111111-1111-1111-4444-000000000003',
    'FE-001',
    'Initialize React project with Vite',
    'Set up React 18 with Vite, TypeScript, and Tailwind CSS',
    'task',
    'done',
    'high',
    3,
    '11111111-1111-1111-1111-000000000002',
    '11111111-1111-1111-1111-000000000001',
    CURRENT_TIMESTAMP - INTERVAL '22 days'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO quad_tickets (
    id, domain_id, cycle_id, ticket_number, title, description,
    ticket_type, status, priority, story_points,
    assigned_to, reported_by, completed_at
) VALUES (
    '11111111-1111-1111-5555-000000000012',
    '11111111-1111-1111-2222-000000000002',
    '11111111-1111-1111-4444-000000000003',
    'FE-002',
    'Create login and registration pages',
    'User authentication UI with form validation',
    'story',
    'done',
    'critical',
    8,
    '11111111-1111-1111-1111-000000000002',
    '11111111-1111-1111-1111-000000000001',
    CURRENT_TIMESTAMP - INTERVAL '19 days'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO quad_tickets (
    id, domain_id, cycle_id, ticket_number, title, description,
    ticket_type, status, priority, story_points,
    assigned_to, reported_by, completed_at
) VALUES (
    '11111111-1111-1111-5555-000000000013',
    '11111111-1111-1111-2222-000000000002',
    '11111111-1111-1111-4444-000000000003',
    'FE-003',
    'Implement React Router navigation',
    'Set up routing with protected routes and lazy loading',
    'story',
    'done',
    'high',
    5,
    '11111111-1111-1111-1111-000000000002',
    '11111111-1111-1111-1111-000000000001',
    CURRENT_TIMESTAMP - INTERVAL '17 days'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO quad_tickets (
    id, domain_id, cycle_id, ticket_number, title, description,
    ticket_type, status, priority, story_points,
    assigned_to, reported_by, completed_at
) VALUES (
    '11111111-1111-1111-5555-000000000014',
    '11111111-1111-1111-2222-000000000002',
    '11111111-1111-1111-4444-000000000003',
    'FE-004',
    'Create reusable component library',
    'Button, Input, Card, Modal, Table components',
    'story',
    'done',
    'medium',
    5,
    '11111111-1111-1111-1111-000000000002',
    '11111111-1111-1111-1111-000000000001',
    CURRENT_TIMESTAMP - INTERVAL '15 days'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO quad_tickets (
    id, domain_id, cycle_id, ticket_number, title, description,
    ticket_type, status, priority, story_points,
    assigned_to, reported_by, completed_at
) VALUES (
    '11111111-1111-1111-5555-000000000015',
    '11111111-1111-1111-2222-000000000002',
    '11111111-1111-1111-4444-000000000003',
    'FE-005',
    'Fix mobile responsiveness issues',
    'Login page breaks on screens < 375px',
    'bug',
    'done',
    'medium',
    2,
    '11111111-1111-1111-1111-000000000002',
    '11111111-1111-1111-1111-000000000003',
    CURRENT_TIMESTAMP - INTERVAL '14 days'
) ON CONFLICT (id) DO NOTHING;

-- --------------------------------------
-- Acme Frontend Web - Sprint 2 Tickets (Active)
-- --------------------------------------

INSERT INTO quad_tickets (
    id, domain_id, cycle_id, ticket_number, title, description,
    ticket_type, status, priority, story_points,
    assigned_to, reported_by, started_at
) VALUES (
    '11111111-1111-1111-5555-000000000016',
    '11111111-1111-1111-2222-000000000002',
    '11111111-1111-1111-4444-000000000004',
    'FE-006',
    'Build main dashboard layout',
    'Responsive dashboard with sidebar, header, and main content area',
    'story',
    'in_progress',
    'critical',
    8,
    '11111111-1111-1111-1111-000000000002',
    '11111111-1111-1111-1111-000000000001',
    CURRENT_TIMESTAMP - INTERVAL '4 days'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO quad_tickets (
    id, domain_id, cycle_id, ticket_number, title, description,
    ticket_type, status, priority, story_points,
    assigned_to, reported_by
) VALUES (
    '11111111-1111-1111-5555-000000000017',
    '11111111-1111-1111-2222-000000000002',
    '11111111-1111-1111-4444-000000000004',
    'FE-007',
    'Create ticket list component',
    'Filterable, sortable ticket list with pagination',
    'story',
    'todo',
    'high',
    5,
    '11111111-1111-1111-1111-000000000002',
    '11111111-1111-1111-1111-000000000001'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO quad_tickets (
    id, domain_id, cycle_id, ticket_number, title, description,
    ticket_type, status, priority, story_points,
    assigned_to, reported_by
) VALUES (
    '11111111-1111-1111-5555-000000000018',
    '11111111-1111-1111-2222-000000000002',
    '11111111-1111-1111-4444-000000000004',
    'FE-008',
    'Implement drag-and-drop kanban board',
    'Kanban view for tickets with drag-and-drop status updates',
    'story',
    'todo',
    'medium',
    8,
    NULL,
    '11111111-1111-1111-1111-000000000001'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO quad_tickets (
    id, domain_id, cycle_id, ticket_number, title, description,
    ticket_type, status, priority, story_points,
    assigned_to, reported_by, started_at
) VALUES (
    '11111111-1111-1111-5555-000000000019',
    '11111111-1111-1111-2222-000000000002',
    '11111111-1111-1111-4444-000000000004',
    'FE-009',
    'E2E tests for login flow',
    'Playwright tests for complete login/logout flow',
    'task',
    'in_progress',
    'medium',
    3,
    '11111111-1111-1111-1111-000000000003',
    '11111111-1111-1111-1111-000000000002',
    CURRENT_TIMESTAMP - INTERVAL '2 days'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO quad_tickets (
    id, domain_id, cycle_id, ticket_number, title, description,
    ticket_type, status, priority, story_points,
    assigned_to, reported_by
) VALUES (
    '11111111-1111-1111-5555-000000000020',
    '11111111-1111-1111-2222-000000000002',
    '11111111-1111-1111-4444-000000000004',
    'FE-010',
    'Dark mode support',
    'Toggle between light and dark themes',
    'story',
    'backlog',
    'low',
    3,
    NULL,
    '11111111-1111-1111-1111-000000000001'
) ON CONFLICT (id) DO NOTHING;

-- --------------------------------------
-- Beta Inc Main Product - Sprint 1 Tickets
-- --------------------------------------

INSERT INTO quad_tickets (
    id, domain_id, cycle_id, ticket_number, title, description,
    ticket_type, status, priority, story_points,
    assigned_to, reported_by, started_at
) VALUES (
    '22222222-2222-2222-5555-000000000001',
    '22222222-2222-2222-3333-000000000001',
    '22222222-2222-2222-4444-000000000001',
    'MP-001',
    'Set up project infrastructure',
    'Initialize project with CI/CD pipeline and deployment',
    'task',
    'in_progress',
    'critical',
    5,
    '22222222-2222-2222-2222-000000000001',
    '22222222-2222-2222-2222-000000000001',
    CURRENT_TIMESTAMP - INTERVAL '2 days'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO quad_tickets (
    id, domain_id, cycle_id, ticket_number, title, description,
    ticket_type, status, priority, story_points,
    assigned_to, reported_by
) VALUES (
    '22222222-2222-2222-5555-000000000002',
    '22222222-2222-2222-3333-000000000001',
    '22222222-2222-2222-4444-000000000001',
    'MP-002',
    'Create landing page',
    'Product landing page with feature highlights and signup',
    'story',
    'todo',
    'high',
    8,
    '22222222-2222-2222-2222-000000000001',
    '22222222-2222-2222-2222-000000000001'
) ON CONFLICT (id) DO NOTHING;


-- ============================================================================
-- SUMMARY STATISTICS
-- ============================================================================
--
-- Organization 1 (Acme Corp):
--   - 3 Users
--   - 2 Domains (backend-api, frontend-web)
--   - 4 Circles (2 per domain)
--   - 4 Cycles (2 per domain)
--   - 20 Tickets (5 per cycle)
--   - 8 Domain Roles (4 per domain)
--
-- Organization 2 (Beta Inc):
--   - 1 User
--   - 1 Domain (main-product)
--   - 0 Circles (minimal setup)
--   - 1 Cycle
--   - 2 Tickets
--
-- Total: 2 Organizations, 4 Users, 3 Domains, 4 Circles, 5 Cycles, 22 Tickets
--
-- ============================================================================
