-- QUAD_kudos Table
-- Peer recognition/kudos
-- Part of: QUAD Analytics | Created: January 2026

CREATE TABLE IF NOT EXISTS QUAD_kudos (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    from_user_id UUID NOT NULL REFERENCES QUAD_users(id) ON DELETE CASCADE,
    to_user_id UUID NOT NULL REFERENCES QUAD_users(id) ON DELETE CASCADE,
    message TEXT, kudos_type VARCHAR(50) DEFAULT 'general',
    ticket_id UUID REFERENCES QUAD_tickets(id) ON DELETE SET NULL,
    is_public BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);
COMMENT ON TABLE QUAD_kudos IS 'Peer recognition/kudos';
