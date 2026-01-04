-- QUAD_developer_onboarding_progress Table
-- Developer onboarding progress
-- Part of: QUAD Onboarding | Created: January 2026

CREATE TABLE IF NOT EXISTS QUAD_developer_onboarding_progress (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES QUAD_users(id) ON DELETE CASCADE,
    template_id UUID NOT NULL REFERENCES QUAD_developer_onboarding_templates(id) ON DELETE CASCADE,
    status VARCHAR(20) DEFAULT 'in_progress', steps_completed JSONB,
    mentor_id UUID REFERENCES QUAD_users(id) ON DELETE SET NULL,
    started_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    completed_at TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(user_id, template_id)
);
COMMENT ON TABLE QUAD_developer_onboarding_progress IS 'Developer onboarding progress';
