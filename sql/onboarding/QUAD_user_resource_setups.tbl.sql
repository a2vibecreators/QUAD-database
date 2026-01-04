-- QUAD_user_resource_setups Table
-- User resource setup progress
-- Part of: QUAD Onboarding | Created: January 2026

CREATE TABLE IF NOT EXISTS QUAD_user_resource_setups (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES QUAD_users(id) ON DELETE CASCADE,
    template_id UUID NOT NULL REFERENCES QUAD_resource_setup_templates(id) ON DELETE CASCADE,
    status VARCHAR(20) DEFAULT 'pending', steps_completed JSONB,
    started_at TIMESTAMP WITH TIME ZONE, completed_at TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(user_id, template_id)
);
COMMENT ON TABLE QUAD_user_resource_setups IS 'User resource setup progress';
