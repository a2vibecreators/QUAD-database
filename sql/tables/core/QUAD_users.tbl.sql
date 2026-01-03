-- Table: QUAD_users
-- Section: core
-- Purpose: User accounts within companies

CREATE TABLE QUAD_users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    company_id UUID NOT NULL REFERENCES QUAD_companies(id) ON DELETE CASCADE,

    -- Authentication
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,

    -- Profile
    full_name VARCHAR(255),

    -- Role (references QUAD_roles)
    role_id UUID REFERENCES QUAD_roles(id) ON DELETE SET NULL,
    role VARCHAR(50) DEFAULT 'DEVELOPER',
    -- Kept for backward compatibility, will be deprecated

    -- Status
    is_active BOOLEAN DEFAULT TRUE,
    email_verified BOOLEAN DEFAULT FALSE,

    -- Metadata
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

-- Indexes
CREATE INDEX idx_quad_users_company ON QUAD_users(company_id);
CREATE INDEX idx_quad_users_email ON QUAD_users(email);
CREATE INDEX idx_quad_users_role_id ON QUAD_users(role_id);
CREATE INDEX idx_quad_users_role ON QUAD_users(role);
CREATE INDEX idx_quad_users_active ON QUAD_users(is_active) WHERE is_active = TRUE;

-- Trigger for updated_at
CREATE TRIGGER trg_quad_users_updated_at
    BEFORE UPDATE ON QUAD_users
    FOR EACH ROW
    EXECUTE FUNCTION QUAD_update_updated_at_column();

-- Comments
COMMENT ON TABLE QUAD_users IS 'User accounts. Each user belongs to one company.';
COMMENT ON COLUMN QUAD_users.role_id IS 'References QUAD_roles for dynamic role assignment.';
COMMENT ON COLUMN QUAD_users.role IS 'Legacy role field. Will be deprecated in favor of role_id.';
