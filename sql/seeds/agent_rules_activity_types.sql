-- Seed Data: QUAD Activity Types
-- Initial set of 6 development activity types
--
-- Integration with QUAD Sync (Top 5 Tools):
-- 1. Jira - Ticket management
-- 2. GitHub - Version control
-- 3. Slack - Communication
-- 4. Zoom - Meetings (AI summaries)
-- 5. Email - Notifications
--
-- Part of: QUAD AI Agent Rules System
-- Created: January 2026

-- Clear existing data (dev/qa only, not production)
TRUNCATE TABLE quad_activity_types CASCADE;

-- Activity Type 1: Add API Endpoint (Backend)
INSERT INTO quad_activity_types (
    activity_code,
    display_name,
    description,
    category,
    integrations,
    icon_emoji,
    color_code
) VALUES (
    'add_api_endpoint',
    'Add API Endpoint',
    'Create a new REST API endpoint (Controller + Service + Repository). Includes request/response DTOs, validation, error handling, and unit tests.',
    'backend',
    '["jira", "github", "slack"]'::jsonb,
    '🔌',
    'blue'
);

-- Activity Type 2: Create UI Screen (Frontend)
INSERT INTO quad_activity_types (
    activity_code,
    display_name,
    description,
    category,
    integrations,
    icon_emoji,
    color_code
) VALUES (
    'create_ui_screen',
    'Create UI Screen',
    'Create a new web page or mobile screen. Includes components, routing, state management, and responsive design.',
    'frontend',
    '["jira", "github", "slack"]'::jsonb,
    '🖥️',
    'purple'
);

-- Activity Type 3: Add Database Table (Database)
INSERT INTO quad_activity_types (
    activity_code,
    display_name,
    description,
    category,
    integrations,
    icon_emoji,
    color_code
) VALUES (
    'add_database_table',
    'Add Database Table',
    'Create a new database table with migration script. Includes schema design, indexes, constraints, and JPA entity.',
    'database',
    '["jira", "github", "slack"]'::jsonb,
    '🗄️',
    'green'
);

-- Activity Type 4: Add Payment Processing (Integration)
INSERT INTO quad_activity_types (
    activity_code,
    display_name,
    description,
    category,
    integrations,
    icon_emoji,
    color_code
) VALUES (
    'add_payment_processing',
    'Add Payment Processing',
    'Integrate payment gateway (Stripe, PayPal, Square, etc.). Includes webhook handling, refunds, subscriptions.',
    'integration',
    '["jira", "github", "slack", "email"]'::jsonb,
    '💳',
    'yellow'
);

-- Activity Type 5: Add Authentication (Infrastructure)
INSERT INTO quad_activity_types (
    activity_code,
    display_name,
    description,
    category,
    integrations,
    icon_emoji,
    color_code
) VALUES (
    'add_authentication',
    'Add Authentication',
    'Add login/signup functionality. Includes OAuth 2.0, JWT tokens, password hashing, session management.',
    'infrastructure',
    '["jira", "github", "slack"]'::jsonb,
    '🔐',
    'red'
);

-- Activity Type 6: Add File Upload (Integration)
INSERT INTO quad_activity_types (
    activity_code,
    display_name,
    description,
    category,
    integrations,
    icon_emoji,
    color_code
) VALUES (
    'add_file_upload',
    'Add File Upload',
    'Handle file uploads to cloud storage (AWS S3, Google Cloud Storage, Azure Blob). Includes pre-signed URLs, file validation, virus scanning.',
    'integration',
    '["jira", "github", "slack"]'::jsonb,
    '📁',
    'indigo'
);

-- Verification
SELECT
    activity_code,
    display_name,
    category,
    integrations,
    icon_emoji
FROM quad_activity_types
ORDER BY category, activity_code;
