-- QUAD_fairness_distribution Table
-- Tracks fairness score distribution and equity allocation
-- Core principle: Immutable distribution (51% founder, 49% public pool)
--
-- Part of: QUAD Fairness System
-- Created: January 2026
-- Plugin & Play: Each organization defines its own distribution

CREATE TABLE IF NOT EXISTS QUAD_fairness_distribution (
    id                  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    domain_id           UUID NOT NULL REFERENCES quad_domains(id) ON DELETE CASCADE,
    user_id             UUID NOT NULL REFERENCES quad_users(id) ON DELETE CASCADE,

    -- Fairness calculation period
    period_start        DATE NOT NULL,
    period_end          DATE NOT NULL,

    -- Raw fairness score (0-100)
    raw_fairness_score  NUMERIC(5, 2),

    -- Distribution breakdown
    founder_pool_share  NUMERIC(5, 2) DEFAULT 51.00,  -- Founder's fixed allocation
    public_pool_share   NUMERIC(5, 2) DEFAULT 49.00,  -- Public pool for distribution

    -- Calculated allocations
    founder_equity      NUMERIC(10, 4),                -- Amount allocated to founder
    public_equity       NUMERIC(10, 4),                -- Amount allocated to public pool

    -- User's share (based on fairness score)
    user_base_share     NUMERIC(10, 4),                -- Base allocation to user

    -- Status and metadata
    status              VARCHAR(100) DEFAULT 'calculated',  -- calculated, locked, distributed
    is_locked           BOOLEAN DEFAULT false,         -- Once locked, cannot recalculate
    calculation_version INTEGER,                       -- Which formula version was used

    -- Timestamps
    calculated_at       TIMESTAMP DEFAULT NOW(),
    locked_at           TIMESTAMP,
    distributed_at      TIMESTAMP,

    created_at          TIMESTAMP DEFAULT NOW(),
    updated_at          TIMESTAMP DEFAULT NOW(),

    UNIQUE(domain_id, user_id, period_start, period_end)
);

CREATE INDEX IF NOT EXISTS idx_fairness_distribution_domain ON QUAD_fairness_distribution(domain_id);
CREATE INDEX IF NOT EXISTS idx_fairness_distribution_user ON QUAD_fairness_distribution(user_id);
CREATE INDEX IF NOT EXISTS idx_fairness_distribution_period ON QUAD_fairness_distribution(period_start, period_end);
CREATE INDEX IF NOT EXISTS idx_fairness_distribution_status ON QUAD_fairness_distribution(status);

COMMENT ON TABLE QUAD_fairness_distribution IS 'Fairness score distribution - immutable 51/49 split';
