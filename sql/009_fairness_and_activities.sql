-- ============================================================================
-- Migration 009: Fairness System & Activity Tracking
-- ============================================================================
-- Adds comprehensive fairness scoring and activity tracking tables
-- Foundation for QUAD ticket management system
-- Created: January 2026

-- ============================================================================
-- 1. TIME TRACKING TABLES
-- ============================================================================

-- Track actual hours worked on tickets
CREATE TABLE IF NOT EXISTS QUAD_time_logs (
    id                  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    ticket_id           UUID NOT NULL REFERENCES QUAD_tickets(id) ON DELETE CASCADE,
    user_id             UUID NOT NULL REFERENCES QUAD_users(id) ON DELETE CASCADE,

    -- Time details
    hours_worked        NUMERIC(8, 2) NOT NULL,
    log_date            DATE NOT NULL DEFAULT CURRENT_DATE,
    activity_type       VARCHAR(100),           -- 'coding', 'reviewing', 'discussion', 'planning'
    description         TEXT,

    -- AI assistance tracking
    ai_used             BOOLEAN DEFAULT false,
    ai_tool             VARCHAR(100),           -- 'claude', 'gemini', 'copilot'
    ai_effectiveness    NUMERIC(3, 2),          -- 0-3.0 multiplier

    -- Status
    is_verified         BOOLEAN DEFAULT false,
    verified_by         UUID REFERENCES QUAD_users(id) ON DELETE SET NULL,
    verified_at         TIMESTAMP,

    -- Timestamps
    created_at          TIMESTAMP DEFAULT NOW(),
    updated_at          TIMESTAMP DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_time_logs_ticket ON QUAD_time_logs(ticket_id);
CREATE INDEX IF NOT EXISTS idx_time_logs_user ON QUAD_time_logs(user_id);
CREATE INDEX IF NOT EXISTS idx_time_logs_date ON QUAD_time_logs(log_date);
CREATE INDEX IF NOT EXISTS idx_time_logs_activity ON QUAD_time_logs(activity_type);

COMMENT ON TABLE QUAD_time_logs IS 'Track actual hours worked on tickets with AI assistance tracking';

-- ============================================================================
-- 2. QUALITY TRACKING TABLES
-- ============================================================================

-- Record when a ticket is reopened for rework
CREATE TABLE IF NOT EXISTS QUAD_ticket_reopens (
    id                  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    ticket_id           UUID NOT NULL REFERENCES QUAD_tickets(id) ON DELETE CASCADE,

    -- Reopen details
    reopen_number       INTEGER NOT NULL,      -- 1st, 2nd, 3rd reopen
    reopened_by         UUID NOT NULL REFERENCES QUAD_users(id) ON DELETE CASCADE,
    reopened_reason     TEXT NOT NULL,

    -- Resolution
    resolved_by         UUID REFERENCES QUAD_users(id) ON DELETE SET NULL,
    resolution_notes    TEXT,

    -- Timestamps
    reopened_at         TIMESTAMP DEFAULT NOW(),
    resolved_at         TIMESTAMP,

    UNIQUE(ticket_id, reopen_number)
);

CREATE INDEX IF NOT EXISTS idx_ticket_reopens_ticket ON QUAD_ticket_reopens(ticket_id);
CREATE INDEX IF NOT EXISTS idx_ticket_reopens_reopened_by ON QUAD_ticket_reopens(reopened_by);

COMMENT ON TABLE QUAD_ticket_reopens IS 'Track ticket reopens for quality assessment';

-- Quality ratings for completed tickets
CREATE TABLE IF NOT EXISTS QUAD_ticket_quality_ratings (
    id                  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    ticket_id           UUID NOT NULL UNIQUE REFERENCES QUAD_tickets(id) ON DELETE CASCADE,

    -- Quality assessment
    quality_score       INTEGER NOT NULL CHECK (quality_score >= 1 AND quality_score <= 5),
    -- 1: Unacceptable, 2: Poor, 3: Acceptable, 4: Good, 5: Excellent

    -- Feedback
    rated_by            UUID NOT NULL REFERENCES QUAD_users(id) ON DELETE CASCADE,
    rating_reason       TEXT,

    -- Timestamps
    reviewed_at         TIMESTAMP DEFAULT NOW(),
    created_at          TIMESTAMP DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_quality_ratings_ticket ON QUAD_ticket_quality_ratings(ticket_id);
CREATE INDEX IF NOT EXISTS idx_quality_ratings_score ON QUAD_ticket_quality_ratings(quality_score);

COMMENT ON TABLE QUAD_ticket_quality_ratings IS 'Quality ratings for completed tickets';

-- ============================================================================
-- 3. FAIRNESS SCORING TABLES
-- ============================================================================

-- Calculated fairness scores
CREATE TABLE IF NOT EXISTS QUAD_fairness_scores (
    id                  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    ticket_id           UUID NOT NULL UNIQUE REFERENCES QUAD_tickets(id) ON DELETE CASCADE,
    user_id             UUID NOT NULL REFERENCES QUAD_users(id) ON DELETE CASCADE,

    -- Calculation details
    estimated_hours     NUMERIC(10, 2),
    actual_hours        NUMERIC(10, 2),
    reopens_count       INTEGER DEFAULT 0,
    quality_rating      INTEGER,
    complexity_level    VARCHAR(50),            -- 'easy', 'medium', 'hard'

    -- Score components (each 0-100)
    efficiency_score    NUMERIC(5, 2),          -- estimated ÷ actual
    quality_score       NUMERIC(5, 2),          -- (100 - reopens_penalty) × rating
    complexity_score    NUMERIC(5, 2),          -- easy:1, medium:3, hard:5 (scaled)
    speed_score         NUMERIC(5, 2),          -- vs industry standard
    ai_multiplier       NUMERIC(5, 2),          -- 1.0 to 3.0

    -- Final score
    final_fairness_score NUMERIC(5, 2),         -- weighted average

    -- Weights used in calculation
    weight_efficiency   NUMERIC(3, 2) DEFAULT 0.25,
    weight_quality      NUMERIC(3, 2) DEFAULT 0.30,
    weight_complexity   NUMERIC(3, 2) DEFAULT 0.20,
    weight_speed        NUMERIC(3, 2) DEFAULT 0.15,
    weight_ai           NUMERIC(3, 2) DEFAULT 0.10,

    -- Metadata
    calculation_version INTEGER,
    is_locked           BOOLEAN DEFAULT false,

    -- Timestamps
    calculated_at       TIMESTAMP DEFAULT NOW(),
    locked_at           TIMESTAMP,
    created_at          TIMESTAMP DEFAULT NOW(),
    updated_at          TIMESTAMP DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_fairness_scores_ticket ON QUAD_fairness_scores(ticket_id);
CREATE INDEX IF NOT EXISTS idx_fairness_scores_user ON QUAD_fairness_scores(user_id);
CREATE INDEX IF NOT EXISTS idx_fairness_scores_final ON QUAD_fairness_scores(final_fairness_score);

COMMENT ON TABLE QUAD_fairness_scores IS 'Calculated fairness scores with detailed breakdown';

-- ============================================================================
-- 4. ACTIVITY TRACKING (Everything is Work)
-- ============================================================================

-- Track all activities (tasks, discussions, brainstorms, meetings)
CREATE TABLE IF NOT EXISTS QUAD_activities (
    id                  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id             UUID NOT NULL REFERENCES QUAD_users(id) ON DELETE CASCADE,
    domain_id           UUID REFERENCES quad_domains(id) ON DELETE SET NULL,

    -- Activity classification
    activity_type       VARCHAR(100) NOT NULL,
    -- Types: ticket_work, code_review, discussion, brainstorm, meeting,
    --        documentation, mentoring, system_improvement

    activity_title      VARCHAR(500) NOT NULL,
    description         TEXT,

    -- Time allocation
    time_spent_hours    NUMERIC(8, 2),

    -- Linking
    ticket_id           UUID REFERENCES QUAD_tickets(id) ON DELETE SET NULL,
    pr_id               UUID REFERENCES QUAD_pull_requests(id) ON DELETE SET NULL,
    linked_activity_id  UUID REFERENCES QUAD_activities(id) ON DELETE SET NULL,

    -- Project allocation
    project             VARCHAR(100),           -- 'QUAD', 'SUMA', 'Other'
    domain_area         VARCHAR(100),           -- 'Core', 'UI', 'API', 'Database'

    -- Status
    status              VARCHAR(50) DEFAULT 'logged',
    is_verified         BOOLEAN DEFAULT false,

    -- Timestamps
    activity_date       DATE NOT NULL DEFAULT CURRENT_DATE,
    created_at          TIMESTAMP DEFAULT NOW(),
    updated_at          TIMESTAMP DEFAULT NOW(),

    UNIQUE(user_id, activity_type, activity_title, activity_date)
);

CREATE INDEX IF NOT EXISTS idx_activities_user ON QUAD_activities(user_id);
CREATE INDEX IF NOT EXISTS idx_activities_type ON QUAD_activities(activity_type);
CREATE INDEX IF NOT EXISTS idx_activities_date ON QUAD_activities(activity_date);
CREATE INDEX IF NOT EXISTS idx_activities_ticket ON QUAD_activities(ticket_id);
CREATE INDEX IF NOT EXISTS idx_activities_project ON QUAD_activities(project);

COMMENT ON TABLE QUAD_activities IS 'Track all activities as work - discussions, brainstorms, meetings, coding, etc.';

-- ============================================================================
-- 5. ENHANCE EXISTING TICKETS TABLE
-- ============================================================================

-- Add columns to QUAD_tickets if they don't exist
ALTER TABLE QUAD_tickets ADD COLUMN IF NOT EXISTS estimated_hours NUMERIC(10, 2);
ALTER TABLE QUAD_tickets ADD COLUMN IF NOT EXISTS complexity VARCHAR(50);      -- easy, medium, hard
ALTER TABLE QUAD_tickets ADD COLUMN IF NOT EXISTS reopens_count INTEGER DEFAULT 0;
ALTER TABLE QUAD_tickets ADD COLUMN IF NOT EXISTS final_quality_rating INTEGER;

-- Create index for enhanced queries
CREATE INDEX IF NOT EXISTS idx_tickets_estimated_hours ON QUAD_tickets(estimated_hours);
CREATE INDEX IF NOT EXISTS idx_tickets_complexity ON QUAD_tickets(complexity);

-- ============================================================================
-- 6. GITHUB INTEGRATION TABLES
-- ============================================================================

-- Store GitHub OAuth tokens
CREATE TABLE IF NOT EXISTS QUAD_github_tokens (
    id                  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id             UUID NOT NULL UNIQUE REFERENCES QUAD_users(id) ON DELETE CASCADE,

    -- GitHub identifiers
    github_id           INTEGER NOT NULL UNIQUE,
    github_username     VARCHAR(255) NOT NULL UNIQUE,
    github_avatar_url   VARCHAR(1000),
    github_profile_url  VARCHAR(1000),

    -- OAuth tokens (should be encrypted at rest)
    access_token        TEXT NOT NULL,
    refresh_token       TEXT,
    token_type          VARCHAR(50) DEFAULT 'bearer',

    -- Token metadata
    scopes              VARCHAR(1000),          -- Space-separated OAuth scopes
    expires_at          TIMESTAMP,

    -- Tracking
    last_synced_at      TIMESTAMP,
    sync_enabled        BOOLEAN DEFAULT true,

    -- Status
    is_active           BOOLEAN DEFAULT true,

    -- Timestamps
    created_at          TIMESTAMP DEFAULT NOW(),
    updated_at          TIMESTAMP DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_github_tokens_user ON QUAD_github_tokens(user_id);
CREATE INDEX IF NOT EXISTS idx_github_tokens_username ON QUAD_github_tokens(github_username);

COMMENT ON TABLE QUAD_github_tokens IS 'GitHub OAuth tokens for SSO and contribution tracking';

-- Track contributions from GitHub
CREATE TABLE IF NOT EXISTS QUAD_contributions (
    id                  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id             UUID NOT NULL REFERENCES QUAD_users(id) ON DELETE CASCADE,
    domain_id           UUID REFERENCES quad_domains(id) ON DELETE SET NULL,

    -- Contribution source
    source_type         VARCHAR(100) NOT NULL, -- 'github_commit', 'github_pr', 'github_review'
    source_id           VARCHAR(500),          -- Commit SHA, PR ID, etc.
    source_url          VARCHAR(1000),

    -- Details
    contribution_type   VARCHAR(100),
    title               VARCHAR(500),
    description         TEXT,

    -- Metrics
    impact_score        NUMERIC(5, 2),
    quality_score       NUMERIC(5, 2),

    -- Linking
    ticket_id           UUID REFERENCES QUAD_tickets(id) ON DELETE SET NULL,

    -- Status
    status              VARCHAR(50) DEFAULT 'pending',

    -- Timestamps
    contribution_date   DATE NOT NULL,
    created_at          TIMESTAMP DEFAULT NOW(),
    updated_at          TIMESTAMP DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_contributions_user ON QUAD_contributions(user_id);
CREATE INDEX IF NOT EXISTS idx_contributions_source ON QUAD_contributions(source_type);
CREATE INDEX IF NOT EXISTS idx_contributions_date ON QUAD_contributions(contribution_date);

COMMENT ON TABLE QUAD_contributions IS 'Contributions tracked from GitHub and other sources';

-- ============================================================================
-- 7. GEMINI/CLAUDE AI ANALYSIS
-- ============================================================================

-- Store AI analysis results
CREATE TABLE IF NOT EXISTS QUAD_ai_ticket_analysis (
    id                  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    ticket_id           UUID NOT NULL UNIQUE REFERENCES QUAD_tickets(id) ON DELETE CASCADE,

    -- Input to AI
    title               VARCHAR(500),
    description         TEXT,

    -- AI Analysis Output
    suggested_complexity VARCHAR(50),
    suggested_hours     NUMERIC(10, 2),
    suggested_priority  VARCHAR(50),
    identified_skills   JSONB,
    identified_blockers TEXT,
    proposed_solution   TEXT,

    -- AI metadata
    ai_model            VARCHAR(100) DEFAULT 'gemini-2.0',
    analysis_prompt     TEXT,
    analysis_confidence NUMERIC(3, 2),          -- 0-1.0

    -- User feedback
    user_accepted       BOOLEAN,
    user_feedback       TEXT,

    -- Timestamps
    analyzed_at         TIMESTAMP DEFAULT NOW(),
    created_at          TIMESTAMP DEFAULT NOW(),
    updated_at          TIMESTAMP DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_ai_analysis_ticket ON QUAD_ai_ticket_analysis(ticket_id);
CREATE INDEX IF NOT EXISTS idx_ai_analysis_analyzed_at ON QUAD_ai_ticket_analysis(analyzed_at);

COMMENT ON TABLE QUAD_ai_ticket_analysis IS 'AI-powered ticket analysis using Gemini/Claude API';

-- ============================================================================
-- 8. FAIRNESS CONFIGURATION (Plugin & Play)
-- ============================================================================

-- Define fairness attributes per organization/domain
CREATE TABLE IF NOT EXISTS QUAD_fairness_attributes (
    id                  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    domain_id           UUID NOT NULL REFERENCES quad_domains(id) ON DELETE CASCADE,

    -- Attribute definition
    attribute_name      VARCHAR(255) NOT NULL,
    description         TEXT,
    category            VARCHAR(100),           -- 'technical', 'leadership', 'collaboration'

    -- Calculation method
    measure_type        VARCHAR(100),           -- 'numeric', 'percentage', 'boolean'

    -- Status
    is_active           BOOLEAN DEFAULT true,

    -- Timestamps
    created_at          TIMESTAMP DEFAULT NOW(),
    updated_at          TIMESTAMP DEFAULT NOW(),

    UNIQUE(domain_id, attribute_name)
);

CREATE INDEX IF NOT EXISTS idx_fairness_attributes_domain ON QUAD_fairness_attributes(domain_id);

COMMENT ON TABLE QUAD_fairness_attributes IS 'Configurable fairness attributes (plugin & play design)';

-- ============================================================================
-- 9. INDEXES FOR PERFORMANCE
-- ============================================================================

-- Create composite indexes for common queries
CREATE INDEX IF NOT EXISTS idx_time_logs_ticket_user ON QUAD_time_logs(ticket_id, user_id);
CREATE INDEX IF NOT EXISTS idx_time_logs_ticket_date ON QUAD_time_logs(ticket_id, log_date);
CREATE INDEX IF NOT EXISTS idx_fairness_scores_user_created ON QUAD_fairness_scores(user_id, created_at);
CREATE INDEX IF NOT EXISTS idx_activities_user_date ON QUAD_activities(user_id, activity_date);

-- ============================================================================
-- Migration Complete
-- ============================================================================

COMMENT ON SCHEMA public IS 'QUAD fairness and activity tracking system - Jan 2026';
