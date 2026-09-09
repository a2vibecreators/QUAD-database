-- QUAD_fairness_scores Table
-- Stores calculated fairness scores for users over time
-- Allows historical tracking and trend analysis
--
-- Part of: QUAD Fairness System
-- Created: January 2026

CREATE TABLE IF NOT EXISTS QUAD_fairness_scores (
    id                  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    domain_id           UUID NOT NULL REFERENCES quad_domains(id) ON DELETE CASCADE,
    user_id             UUID NOT NULL REFERENCES quad_users(id) ON DELETE CASCADE,

    -- Scoring period
    period_start        DATE NOT NULL,
    period_end          DATE NOT NULL,

    -- Core scores (0-100)
    overall_score       NUMERIC(5, 2),              -- Final fairness score

    -- Attribute scores
    code_quality_score  NUMERIC(5, 2),
    reliability_score   NUMERIC(5, 2),
    impact_score        NUMERIC(5, 2),
    leadership_score    NUMERIC(5, 2),
    collaboration_score NUMERIC(5, 2),

    -- Contribution metrics
    total_contributions INTEGER DEFAULT 0,
    commits_count       INTEGER DEFAULT 0,
    prs_count           INTEGER DEFAULT 0,
    code_reviews_count  INTEGER DEFAULT 0,
    hours_worked        NUMERIC(10, 2),

    -- QPI (Promotion Readiness Index)
    qpi_score           NUMERIC(5, 2),

    -- Percentile and ranking
    percentile_rank     NUMERIC(5, 2),              -- 0-100, where 100 is top performer
    rank_in_domain      INTEGER,

    -- Formula used for calculation
    formula_version     INTEGER,

    -- Status
    is_locked           BOOLEAN DEFAULT false,      -- Once finalized, cannot recalculate
    is_verified         BOOLEAN DEFAULT false,

    -- Timestamps
    calculated_at       TIMESTAMP DEFAULT NOW(),
    locked_at           TIMESTAMP,

    created_at          TIMESTAMP DEFAULT NOW(),
    updated_at          TIMESTAMP DEFAULT NOW(),

    UNIQUE(domain_id, user_id, period_start, period_end)
);

CREATE INDEX IF NOT EXISTS idx_fairness_scores_domain ON QUAD_fairness_scores(domain_id);
CREATE INDEX IF NOT EXISTS idx_fairness_scores_user ON QUAD_fairness_scores(user_id);
CREATE INDEX IF NOT EXISTS idx_fairness_scores_period ON QUAD_fairness_scores(period_start, period_end);
CREATE INDEX IF NOT EXISTS idx_fairness_scores_overall ON QUAD_fairness_scores(overall_score);
CREATE INDEX IF NOT EXISTS idx_fairness_scores_qpi ON QUAD_fairness_scores(qpi_score);

COMMENT ON TABLE QUAD_fairness_scores IS 'Calculated fairness scores for users - historical tracking';
