-- QUAD_user_setup_journeys Table
-- User onboarding journeys
-- Part of: QUAD Onboarding | Created: January 2026

CREATE TABLE IF NOT EXISTS QUAD_user_setup_journeys (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES QUAD_users(id) ON DELETE CASCADE,
    bundle_id UUID REFERENCES QUAD_setup_bundles(id) ON DELETE SET NULL,
    status VARCHAR(20) DEFAULT 'in_progress', progress_pct INTEGER DEFAULT 0,
    started_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    completed_at TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);
COMMENT ON TABLE QUAD_user_setup_journeys IS 'User onboarding journeys';
