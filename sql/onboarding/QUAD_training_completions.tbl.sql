-- QUAD_training_completions Table
-- Training completion records
-- Part of: QUAD Onboarding | Created: January 2026

CREATE TABLE IF NOT EXISTS QUAD_training_completions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES QUAD_users(id) ON DELETE CASCADE,
    content_id UUID NOT NULL REFERENCES QUAD_training_content(id) ON DELETE CASCADE,
    status VARCHAR(20) DEFAULT 'completed', score INTEGER,
    time_spent_minutes INTEGER,
    completed_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(user_id, content_id)
);
COMMENT ON TABLE QUAD_training_completions IS 'Training completion records';
