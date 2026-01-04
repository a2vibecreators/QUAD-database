-- QUAD Framework Database Schema
-- Modular SQL Schema Loader (132 tables)
--
-- This file loads all individual table files organized by domain.
-- Run this file to create/update the complete schema.
--
-- Structure:
--   /sql
--   ├── schema.sql (this file - loader)
--   ├── core/           - Organizations, Users, Roles, Rules (14)
--   ├── domains/        - Domains, Resources, Requirements (10)
--   ├── tickets/        - Circles, Tickets, Cycles (8)
--   ├── git/            - Git, PRs, Repositories (6)
--   ├── meetings/       - Meetings, Calendar Integration (4)
--   ├── memory/         - QUAD Memory System (8)
--   ├── ai/             - AI Providers, Configs, Credits, Tracking (19)
--   ├── infrastructure/ - Sandboxes, Cache, Indexing (9)
--   ├── skills/         - Skills, Assignments (3)
--   ├── flows/          - Workflows, Deployments (9)
--   ├── portal/         - Portal Access, Audit (2)
--   ├── other/          - Notifications, Database Ops (16)
--   ├── analytics/      - Metrics, Rankings, DORA (9)
--   ├── security/       - Secrets, Runbooks (4)
--   ├── onboarding/     - Setup, Training (8)
--   └── messenger/      - Messenger Channels Integration (3)
--
-- Total: 132 tables in 16 categories
--
-- Created: January 3, 2026
-- Maintainer: A2Vibe Creators LLC

-- ============================================================================
-- CORE TABLES (Organizations, Users, Roles, Rules) - 14 tables
-- ============================================================================

\echo '[1/16] Loading Core Tables (14)...'
\i core/QUAD_org_tiers.tbl.sql
\i core/QUAD_organizations.tbl.sql
\i core/QUAD_org_settings.tbl.sql
\i core/QUAD_org_setup_status.tbl.sql
\i core/QUAD_sso_configs.tbl.sql
\i core/QUAD_users.tbl.sql
\i core/QUAD_user_sessions.tbl.sql
\i core/QUAD_email_verification_codes.tbl.sql
\i core/QUAD_roles.tbl.sql
\i core/QUAD_core_roles.tbl.sql
\i core/QUAD_org_members.tbl.sql
\i core/QUAD_org_invitations.tbl.sql
\i core/QUAD_config_settings.tbl.sql
\i core/QUAD_org_rules.tbl.sql

-- ============================================================================
-- DOMAINS & PROJECTS - 10 tables
-- ============================================================================

\echo '[2/16] Loading Domain Tables (10)...'
\i domains/QUAD_domains.tbl.sql
\i domains/QUAD_domain_members.tbl.sql
\i domains/QUAD_domain_resources.tbl.sql
\i domains/QUAD_domain_operations.tbl.sql
\i domains/QUAD_resource_attributes.tbl.sql
\i domains/QUAD_resource_attribute_requirements.tbl.sql
\i domains/QUAD_requirements.tbl.sql
\i domains/QUAD_milestones.tbl.sql
\i domains/QUAD_adoption_matrix.tbl.sql
\i domains/QUAD_workload_metrics.tbl.sql

-- ============================================================================
-- CIRCLES & TICKETS - 8 tables
-- ============================================================================

\echo '[3/16] Loading Ticket Tables (8)...'
\i tickets/QUAD_circles.tbl.sql
\i tickets/QUAD_circle_members.tbl.sql
\i tickets/QUAD_cycles.tbl.sql
\i tickets/QUAD_tickets.tbl.sql
\i tickets/QUAD_ticket_comments.tbl.sql
\i tickets/QUAD_ticket_time_logs.tbl.sql
\i tickets/QUAD_ticket_skills.tbl.sql
\i tickets/QUAD_assignment_scores.tbl.sql

-- ============================================================================
-- GIT & PULL REQUESTS - 6 tables
-- ============================================================================

\echo '[4/16] Loading Git Tables (6)...'
\i git/QUAD_git_integrations.tbl.sql
\i git/QUAD_git_repositories.tbl.sql
\i git/QUAD_pull_requests.tbl.sql
\i git/QUAD_pr_reviewers.tbl.sql
\i git/QUAD_pr_approvals.tbl.sql
\i git/QUAD_git_operations.tbl.sql

-- ============================================================================
-- MEETINGS & CALENDAR - 4 tables
-- ============================================================================

\echo '[5/16] Loading Meeting Tables (4)...'
\i meetings/QUAD_meeting_integrations.tbl.sql
\i meetings/QUAD_meetings.tbl.sql
\i meetings/QUAD_meeting_action_items.tbl.sql
\i meetings/QUAD_meeting_follow_ups.tbl.sql

-- ============================================================================
-- QUAD MEMORY SYSTEM - 8 tables
-- ============================================================================

\echo '[6/16] Loading Memory Tables (8)...'
\i memory/QUAD_memory_documents.tbl.sql
\i memory/QUAD_memory_chunks.tbl.sql
\i memory/QUAD_memory_keywords.tbl.sql
\i memory/QUAD_memory_templates.tbl.sql
\i memory/QUAD_context_sessions.tbl.sql
\i memory/QUAD_context_requests.tbl.sql
\i memory/QUAD_context_rules.tbl.sql
\i memory/QUAD_memory_update_queue.tbl.sql

-- ============================================================================
-- AI & PROVIDERS - 19 tables
-- ============================================================================

\echo '[7/16] Loading AI Tables (19)...'
\i ai/QUAD_ai_provider_config.tbl.sql
\i ai/QUAD_ai_configs.tbl.sql
\i ai/QUAD_ai_operations.tbl.sql
\i ai/QUAD_ai_contexts.tbl.sql
\i ai/QUAD_ai_context_relationships.tbl.sql
\i ai/QUAD_ai_code_reviews.tbl.sql
\i ai/QUAD_ai_conversations.tbl.sql
\i ai/QUAD_ai_messages.tbl.sql
\i ai/QUAD_ai_user_memories.tbl.sql
\i ai/QUAD_ai_activity_routing.tbl.sql
\i ai/QUAD_ai_analysis_cache.tbl.sql
\i ai/QUAD_ai_credit_balances.tbl.sql
\i ai/QUAD_ai_credit_transactions.tbl.sql
\i ai/QUAD_platform_credit_pool.tbl.sql
\i ai/QUAD_platform_pool_transactions.tbl.sql
\i ai/QUAD_rag_indexes.tbl.sql
\i ai/QUAD_ticket_ai_sessions.tbl.sql
\i ai/QUAD_ticket_ai_requests.tbl.sql
\i ai/QUAD_ticket_ai_summary.tbl.sql

-- ============================================================================
-- INFRASTRUCTURE (Sandboxes, Cache, Indexing) - 9 tables
-- ============================================================================

\echo '[8/16] Loading Infrastructure Tables (9)...'
\i infrastructure/QUAD_infrastructure_config.tbl.sql
\i infrastructure/QUAD_sandbox_instances.tbl.sql
\i infrastructure/QUAD_sandbox_usage.tbl.sql
\i infrastructure/QUAD_ticket_sandbox_groups.tbl.sql
\i infrastructure/QUAD_codebase_files.tbl.sql
\i infrastructure/QUAD_codebase_indexes.tbl.sql
\i infrastructure/QUAD_code_cache.tbl.sql
\i infrastructure/QUAD_cache_usage.tbl.sql
\i infrastructure/QUAD_indexing_usage.tbl.sql

-- ============================================================================
-- SKILLS & ASSIGNMENTS - 3 tables
-- ============================================================================

\echo '[9/16] Loading Skills Tables (3)...'
\i skills/QUAD_skills.tbl.sql
\i skills/QUAD_user_skills.tbl.sql
\i skills/QUAD_skill_feedback.tbl.sql

-- ============================================================================
-- FLOWS & DEPLOYMENTS - 9 tables
-- ============================================================================

\echo '[10/16] Loading Flow Tables (9)...'
\i flows/QUAD_flows.tbl.sql
\i flows/QUAD_flow_stage_history.tbl.sql
\i flows/QUAD_flow_branches.tbl.sql
\i flows/QUAD_environments.tbl.sql
\i flows/QUAD_deployment_recipes.tbl.sql
\i flows/QUAD_deployments.tbl.sql
\i flows/QUAD_release_notes.tbl.sql
\i flows/QUAD_release_contributors.tbl.sql
\i flows/QUAD_rollback_operations.tbl.sql

-- ============================================================================
-- PORTAL & ACCESS - 2 tables
-- ============================================================================

\echo '[11/16] Loading Portal Tables (2)...'
\i portal/QUAD_portal_access.tbl.sql
\i portal/QUAD_portal_audit_log.tbl.sql

-- ============================================================================
-- OTHER TABLES - 16 tables
-- ============================================================================

\echo '[12/16] Loading Other Tables (16)...'
\i other/QUAD_notifications.tbl.sql
\i other/QUAD_notification_preferences.tbl.sql
\i other/QUAD_user_role_allocations.tbl.sql
\i other/QUAD_approvals.tbl.sql
\i other/QUAD_file_imports.tbl.sql
\i other/QUAD_work_sessions.tbl.sql
\i other/QUAD_user_activity_summaries.tbl.sql
\i other/QUAD_database_connections.tbl.sql
\i other/QUAD_database_operations.tbl.sql
\i other/QUAD_database_approvals.tbl.sql
\i other/QUAD_anonymization_rules.tbl.sql
\i other/QUAD_verification_requests.tbl.sql
\i other/QUAD_validated_credentials.tbl.sql
\i other/QUAD_integration_health_checks.tbl.sql
\i other/QUAD_api_access_config.tbl.sql
\i other/QUAD_api_request_logs.tbl.sql

-- ============================================================================
-- ANALYTICS & METRICS - 9 tables
-- ============================================================================

\echo '[13/16] Loading Analytics Tables (9)...'
\i analytics/QUAD_cycle_risk_predictions.tbl.sql
\i analytics/QUAD_story_point_suggestions.tbl.sql
\i analytics/QUAD_technical_debt_scores.tbl.sql
\i analytics/QUAD_dora_metrics.tbl.sql
\i analytics/QUAD_ranking_configs.tbl.sql
\i analytics/QUAD_user_rankings.tbl.sql
\i analytics/QUAD_kudos.tbl.sql
\i analytics/QUAD_cost_estimates.tbl.sql
\i analytics/QUAD_risk_factors.tbl.sql

-- ============================================================================
-- SECURITY - 4 tables
-- ============================================================================

\echo '[14/16] Loading Security Tables (4)...'
\i security/QUAD_secret_scans.tbl.sql
\i security/QUAD_secret_rotations.tbl.sql
\i security/QUAD_incident_runbooks.tbl.sql
\i security/QUAD_runbook_executions.tbl.sql

-- ============================================================================
-- ONBOARDING & SETUP - 8 tables
-- ============================================================================

\echo '[15/16] Loading Onboarding Tables (8)...'
\i onboarding/QUAD_resource_setup_templates.tbl.sql
\i onboarding/QUAD_user_resource_setups.tbl.sql
\i onboarding/QUAD_setup_bundles.tbl.sql
\i onboarding/QUAD_user_setup_journeys.tbl.sql
\i onboarding/QUAD_developer_onboarding_templates.tbl.sql
\i onboarding/QUAD_developer_onboarding_progress.tbl.sql
\i onboarding/QUAD_training_content.tbl.sql
\i onboarding/QUAD_training_completions.tbl.sql

-- ============================================================================
-- MESSENGER CHANNELS - 3 tables (Slack, Teams, Discord, WhatsApp, Email, SMS)
-- ============================================================================

\echo '[16/16] Loading Messenger Tables (3)...'
\i messenger/QUAD_messenger_channels.tbl.sql
\i messenger/QUAD_messenger_commands.tbl.sql
\i messenger/QUAD_messenger_outbound.tbl.sql

-- ============================================================================
-- DONE
-- ============================================================================

\echo ''
\echo '=============================================='
\echo '✅ QUAD Framework schema loaded successfully!'
\echo '=============================================='
\echo ''
\echo '132 tables created in 16 categories:'
\echo '  [1]  Core         - 14 tables (orgs, users, roles, rules)'
\echo '  [2]  Domains      - 10 tables (projects, resources)'
\echo '  [3]  Tickets      -  8 tables (circles, cycles, tickets)'
\echo '  [4]  Git          -  6 tables (repos, PRs, approvals)'
\echo '  [5]  Meetings     -  4 tables (calendar, actions)'
\echo '  [6]  Memory       -  8 tables (docs, chunks, context)'
\echo '  [7]  AI           - 19 tables (providers, credits, tracking)'
\echo '  [8]  Infra        -  9 tables (sandbox, cache, index)'
\echo '  [9]  Skills       -  3 tables (skills, feedback)'
\echo '  [10] Flows        -  9 tables (deploy, release)'
\echo '  [11] Portal       -  2 tables (access, audit)'
\echo '  [12] Other        - 16 tables (notifications, DB ops)'
\echo '  [13] Analytics    -  9 tables (DORA, rankings)'
\echo '  [14] Security     -  4 tables (secrets, runbooks)'
\echo '  [15] Onboarding   -  8 tables (setup, training)'
\echo '  [16] Messenger    -  3 tables (channels, commands, outbound)'
\echo ''
