-- QUAD_training_content Table
-- Training content/courses
-- Part of: QUAD Onboarding | Created: January 2026

CREATE TABLE IF NOT EXISTS QUAD_training_content (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    title VARCHAR(255) NOT NULL, description TEXT,
    content_type VARCHAR(50) NOT NULL, content_url TEXT,
    duration_minutes INTEGER, skill_ids UUID[],
    is_required BOOLEAN DEFAULT false, is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);
COMMENT ON TABLE QUAD_training_content IS 'Training content/courses';
