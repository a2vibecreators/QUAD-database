-- QUAD_org_rules Table
-- Organization-level rules for ticketing, naming, and workflows
--
-- Design Decision (Jan 4, 2026):
-- - One table for all circles (use circle_type filter)
-- - Nullable FKs for hierarchical scope (most specific wins)
-- - is_mandatory for rules that cannot be overridden
--
-- Hierarchy (Resolution Order - most specific wins):
-- 1. user_id + domain_id + circle_type (most specific)
-- 2. domain_id + circle_type
-- 3. org_id + circle_type
-- 4. org_id only (most general)
--
-- Part of: QUAD Core
-- Created: January 2026

CREATE TABLE IF NOT EXISTS QUAD_org_rules (
    id                  UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    -- Scope (hierarchical - nullable FKs)
    org_id              UUID NOT NULL REFERENCES QUAD_organizations(id) ON DELETE CASCADE,
    domain_id           UUID REFERENCES QUAD_domains(id) ON DELETE CASCADE,  -- NULL = org-wide
    user_id             UUID REFERENCES QUAD_users(id) ON DELETE CASCADE,    -- NULL = all users

    -- Circle targeting
    -- NULL = applies to all circles
    -- MANAGEMENT, DEVELOPMENT, QA, INFRASTRUCTURE = specific circle
    circle_type         VARCHAR(50),

    -- Rule definition
    rule_category       VARCHAR(50) NOT NULL,   -- TICKET_NAMING, BRANCH_NAMING, LABELS, GATES, WORKFLOW
    rule_key            VARCHAR(100) NOT NULL,  -- e.g., 'ticket_prefix', 'require_story_points'
    rule_value          JSONB NOT NULL,         -- Flexible value storage

    -- Override control
    is_mandatory        BOOLEAN DEFAULT false,  -- true = cannot override at lower level
    is_active           BOOLEAN DEFAULT true,

    -- Metadata
    description         TEXT,
    created_by          UUID REFERENCES QUAD_users(id),
    updated_by          UUID REFERENCES QUAD_users(id),
    created_at          TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at          TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Unique constraint: one rule per scope + category + key
CREATE UNIQUE INDEX IF NOT EXISTS idx_org_rules_unique
    ON QUAD_org_rules(org_id, COALESCE(domain_id, '00000000-0000-0000-0000-000000000000'),
                      COALESCE(user_id, '00000000-0000-0000-0000-000000000000'),
                      COALESCE(circle_type, 'ALL'), rule_category, rule_key)
    WHERE is_active = true;

-- Index for org-level lookups
CREATE INDEX IF NOT EXISTS idx_org_rules_org
    ON QUAD_org_rules(org_id)
    WHERE is_active = true;

-- Index for domain-level lookups
CREATE INDEX IF NOT EXISTS idx_org_rules_domain
    ON QUAD_org_rules(domain_id)
    WHERE domain_id IS NOT NULL AND is_active = true;

-- Index for circle-specific lookups
CREATE INDEX IF NOT EXISTS idx_org_rules_circle
    ON QUAD_org_rules(circle_type)
    WHERE circle_type IS NOT NULL AND is_active = true;

COMMENT ON TABLE QUAD_org_rules IS 'Organization-level rules for ticketing, naming, and workflows';
COMMENT ON COLUMN QUAD_org_rules.circle_type IS 'NULL = all circles; MANAGEMENT, DEVELOPMENT, QA, INFRASTRUCTURE = specific circle';
COMMENT ON COLUMN QUAD_org_rules.is_mandatory IS 'true = cannot be overridden at domain/user level';
COMMENT ON COLUMN QUAD_org_rules.rule_value IS 'JSONB for flexible values: strings, numbers, arrays, objects';

-- ==============================================================================
-- RULE CATEGORIES AND EXAMPLE VALUES
-- ==============================================================================
--
-- TICKET_NAMING:
--   - ticket_prefix: {"pattern": "QUAD-{sequence}", "sequence_start": 1}
--   - require_prefix: true
--   - allowed_types: ["USER_STORY", "BUG", "TASK", "EPIC"]
--
-- BRANCH_NAMING:
--   - pattern: {"format": "{type}/{ticket_id}-{short_description}"}
--   - type_mapping: {"USER_STORY": "feature", "BUG": "bugfix", "TASK": "chore"}
--
-- LABELS:
--   - required_labels: ["priority", "component"]
--   - allowed_labels: ["frontend", "backend", "database", "api", "mobile"]
--
-- GATES (Preconditions for ticket state transitions):
--   - ready_to_in_progress: {"require": ["assignee", "story_points", "no_blockers"]}
--   - in_progress_to_review: {"require": ["branch_pushed", "tests_pass"]}
--   - review_to_done: {"require": ["approvals>=1", "ci_pass"]}
--
-- WORKFLOW:
--   - auto_assign: {"strategy": "round_robin", "pool": "circle_members"}
--   - require_review: {"min_approvers": 1, "exclude_author": true}
--   - auto_close_on_merge: true
--
-- INFRASTRUCTURE (Circle 4 specific):
--   - require_security_scan: true
--   - require_performance_baseline: true
--   - deployment_windows: {"allowed": ["weekdays_9am_5pm"], "blackout": ["fridays_after_3pm"]}
-- ==============================================================================
