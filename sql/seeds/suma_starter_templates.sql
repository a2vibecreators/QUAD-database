/**
 * asksuma.ai - FREE Starter Templates Seed Data
 *
 * Creates 8 basic FREE templates shown to all users after login
 *
 * Template Categories:
 * 1. E-commerce Store
 * 2. Healthcare Portal
 * 3. SaaS Dashboard
 * 4. Real Estate Platform
 * 5. Education LMS
 * 6. Restaurant/Food Delivery
 * 7. Fitness/Wellness App
 * 8. Financial Services Portal
 *
 * @author Gopi Addanke
 * @since January 10, 2026
 */

-- ==============================================================================
-- 1. E-commerce Store (Shopify-style)
-- ==============================================================================

INSERT INTO QUAD_suma_templates (
    id, name, category, description,
    preview_image_url, demo_url,
    tech_stack, features,
    generation_prompt, required_env_vars,
    is_starter, tier, created_by, is_public, is_active, sort_order
) VALUES (
    gen_random_uuid(),
    'E-commerce Store',
    'ecommerce',
    'Full-featured online store with product catalog, shopping cart, checkout, and admin dashboard',
    'https://cdn.asksuma.ai/templates/ecommerce.png',
    'https://demo.asksuma.ai/ecommerce',
    '{"frontend": "Next.js 15", "backend": "Node.js + Express", "database": "PostgreSQL", "ui": "Tailwind CSS", "payments": "Stripe", "auth": "NextAuth.js"}'::jsonb,
    ARRAY['Product catalog with search/filters', 'Shopping cart', 'Stripe checkout', 'User authentication', 'Order management', 'Admin dashboard', 'Inventory tracking'],
    'Create a modern e-commerce store with product catalog, shopping cart, Stripe payments, user authentication, and admin dashboard. Use Next.js 15 with App Router, Tailwind CSS, PostgreSQL database, and Stripe for payments.',
    ARRAY['STRIPE_SECRET_KEY', 'DATABASE_URL', 'NEXTAUTH_SECRET'],
    true,  -- is_starter (FREE template)
    'free',
    NULL,  -- created_by (NULL for starters)
    true,  -- is_public
    true,  -- is_active
    1      -- sort_order
) ON CONFLICT (id) DO NOTHING;

-- ==============================================================================
-- 2. Healthcare Portal (Epic-style)
-- ==============================================================================

INSERT INTO QUAD_suma_templates (
    id, name, category, description,
    preview_image_url, demo_url,
    tech_stack, features,
    generation_prompt, required_env_vars,
    is_starter, tier, created_by, is_public, is_active, sort_order
) VALUES (
    gen_random_uuid(),
    'Healthcare Portal',
    'healthcare',
    'Patient portal with appointments, medical records, prescriptions, and telemedicine',
    'https://cdn.asksuma.ai/templates/healthcare.png',
    'https://demo.asksuma.ai/healthcare',
    '{"frontend": "Next.js 15", "backend": "Node.js + Express", "database": "PostgreSQL", "ui": "Tailwind CSS", "video": "Twilio", "auth": "NextAuth.js", "compliance": "HIPAA"}'::jsonb,
    ARRAY['Patient records (HIPAA compliant)', 'Appointment scheduling', 'Prescription management', 'Telemedicine video calls', 'Medical documents', 'Billing integration', 'Doctor dashboard'],
    'Create a HIPAA-compliant healthcare portal with patient records, appointment scheduling, telemedicine video calls, prescription management, and doctor dashboard. Use Next.js 15, PostgreSQL, Twilio for video, and ensure HIPAA compliance.',
    ARRAY['TWILIO_ACCOUNT_SID', 'TWILIO_AUTH_TOKEN', 'DATABASE_URL', 'NEXTAUTH_SECRET', 'ENCRYPTION_KEY'],
    true,
    'free',
    NULL,
    true,
    true,
    2
) ON CONFLICT (id) DO NOTHING;

-- ==============================================================================
-- 3. SaaS Dashboard (Stripe-style)
-- ==============================================================================

INSERT INTO QUAD_suma_templates (
    id, name, category, description,
    preview_image_url, demo_url,
    tech_stack, features,
    generation_prompt, required_env_vars,
    is_starter, tier, created_by, is_public, is_active, sort_order
) VALUES (
    gen_random_uuid(),
    'SaaS Dashboard',
    'saas',
    'Analytics dashboard with charts, user management, subscription billing, and API access',
    'https://cdn.asksuma.ai/templates/saas.png',
    'https://demo.asksuma.ai/saas',
    '{"frontend": "Next.js 15", "backend": "Node.js + Express", "database": "PostgreSQL", "ui": "Tailwind CSS + shadcn/ui", "charts": "Recharts", "payments": "Stripe", "auth": "NextAuth.js"}'::jsonb,
    ARRAY['Analytics dashboard with charts', 'User management', 'Subscription billing (Stripe)', 'API key management', 'Usage tracking', 'Team collaboration', 'Webhooks'],
    'Create a SaaS analytics dashboard with charts, user management, Stripe subscription billing, API key management, usage tracking, and team collaboration. Use Next.js 15, Recharts, shadcn/ui, and PostgreSQL.',
    ARRAY['STRIPE_SECRET_KEY', 'DATABASE_URL', 'NEXTAUTH_SECRET'],
    true,
    'free',
    NULL,
    true,
    true,
    3
) ON CONFLICT (id) DO NOTHING;

-- ==============================================================================
-- 4. Real Estate Platform (Zillow-style)
-- ==============================================================================

INSERT INTO QUAD_suma_templates (
    id, name, category, description,
    preview_image_url, demo_url,
    tech_stack, features,
    generation_prompt, required_env_vars,
    is_starter, tier, created_by, is_public, is_active, sort_order
) VALUES (
    gen_random_uuid(),
    'Real Estate Platform',
    'realestate',
    'Property listing platform with search, map view, virtual tours, and agent dashboard',
    'https://cdn.asksuma.ai/templates/realestate.png',
    'https://demo.asksuma.ai/realestate',
    '{"frontend": "Next.js 15", "backend": "Node.js + Express", "database": "PostgreSQL", "ui": "Tailwind CSS", "maps": "Google Maps API", "images": "Cloudinary", "auth": "NextAuth.js"}'::jsonb,
    ARRAY['Property search with filters', 'Interactive map view', 'Virtual tours (360° photos)', 'Agent dashboard', 'Lead management', 'Mortgage calculator', 'Contact forms'],
    'Create a real estate platform with property search, interactive Google Maps, virtual tours, agent dashboard, lead management, and mortgage calculator. Use Next.js 15, Google Maps API, Cloudinary for images, and PostgreSQL.',
    ARRAY['GOOGLE_MAPS_API_KEY', 'CLOUDINARY_API_KEY', 'DATABASE_URL', 'NEXTAUTH_SECRET'],
    true,
    'free',
    NULL,
    true,
    true,
    4
) ON CONFLICT (id) DO NOTHING;

-- ==============================================================================
-- 5. Education LMS (Canvas-style)
-- ==============================================================================

INSERT INTO QUAD_suma_templates (
    id, name, category, description,
    preview_image_url, demo_url,
    tech_stack, features,
    generation_prompt, required_env_vars,
    is_starter, tier, created_by, is_public, is_active, sort_order
) VALUES (
    gen_random_uuid(),
    'Education LMS',
    'education',
    'Learning management system with courses, quizzes, assignments, and grading',
    'https://cdn.asksuma.ai/templates/education.png',
    'https://demo.asksuma.ai/education',
    '{"frontend": "Next.js 15", "backend": "Node.js + Express", "database": "PostgreSQL", "ui": "Tailwind CSS", "video": "Vimeo", "auth": "NextAuth.js", "pdf": "PDF.js"}'::jsonb,
    ARRAY['Course management', 'Video lessons (Vimeo)', 'Quizzes and assignments', 'Grading system', 'Student progress tracking', 'Discussion forums', 'Certificate generation'],
    'Create a learning management system with course management, video lessons, quizzes, assignments, grading, student progress tracking, and certificate generation. Use Next.js 15, Vimeo for video, PDF.js, and PostgreSQL.',
    ARRAY['VIMEO_API_KEY', 'DATABASE_URL', 'NEXTAUTH_SECRET'],
    true,
    'free',
    NULL,
    true,
    true,
    5
) ON CONFLICT (id) DO NOTHING;

-- ==============================================================================
-- 6. Restaurant/Food Delivery (DoorDash-style)
-- ==============================================================================

INSERT INTO QUAD_suma_templates (
    id, name, category, description,
    preview_image_url, demo_url,
    tech_stack, features,
    generation_prompt, required_env_vars,
    is_starter, tier, created_by, is_public, is_active, sort_order
) VALUES (
    gen_random_uuid(),
    'Food Delivery App',
    'food',
    'Restaurant ordering platform with menu, cart, delivery tracking, and restaurant dashboard',
    'https://cdn.asksuma.ai/templates/food.png',
    'https://demo.asksuma.ai/food',
    '{"frontend": "Next.js 15", "backend": "Node.js + Express", "database": "PostgreSQL", "ui": "Tailwind CSS", "maps": "Google Maps API", "payments": "Stripe", "auth": "NextAuth.js"}'::jsonb,
    ARRAY['Restaurant menu management', 'Shopping cart', 'Real-time delivery tracking', 'Stripe payments', 'Driver dashboard', 'Order management', 'Reviews and ratings'],
    'Create a food delivery platform with restaurant menus, shopping cart, real-time delivery tracking, Stripe payments, driver dashboard, and reviews. Use Next.js 15, Google Maps, Stripe, and PostgreSQL.',
    ARRAY['GOOGLE_MAPS_API_KEY', 'STRIPE_SECRET_KEY', 'DATABASE_URL', 'NEXTAUTH_SECRET'],
    true,
    'free',
    NULL,
    true,
    true,
    6
) ON CONFLICT (id) DO NOTHING;

-- ==============================================================================
-- 7. Fitness/Wellness App (Peloton-style)
-- ==============================================================================

INSERT INTO QUAD_suma_templates (
    id, name, category, description,
    preview_image_url, demo_url,
    tech_stack, features,
    generation_prompt, required_env_vars,
    is_starter, tier, created_by, is_public, is_active, sort_order
) VALUES (
    gen_random_uuid(),
    'Fitness & Wellness App',
    'fitness',
    'Workout tracking app with exercise library, progress charts, meal plans, and trainer dashboard',
    'https://cdn.asksuma.ai/templates/fitness.png',
    'https://demo.asksuma.ai/fitness',
    '{"frontend": "Next.js 15", "backend": "Node.js + Express", "database": "PostgreSQL", "ui": "Tailwind CSS", "charts": "Recharts", "video": "Vimeo", "auth": "NextAuth.js"}'::jsonb,
    ARRAY['Exercise library with videos', 'Workout tracking', 'Progress charts', 'Meal planning', 'Nutrition tracking', 'Trainer dashboard', 'Social features'],
    'Create a fitness and wellness app with exercise library, workout tracking, progress charts, meal planning, nutrition tracking, and trainer dashboard. Use Next.js 15, Recharts, Vimeo for videos, and PostgreSQL.',
    ARRAY['VIMEO_API_KEY', 'DATABASE_URL', 'NEXTAUTH_SECRET'],
    true,
    'free',
    NULL,
    true,
    true,
    7
) ON CONFLICT (id) DO NOTHING;

-- ==============================================================================
-- 8. Financial Services Portal (Robinhood-style)
-- ==============================================================================

INSERT INTO QUAD_suma_templates (
    id, name, category, description,
    preview_image_url, demo_url,
    tech_stack, features,
    generation_prompt, required_env_vars,
    is_starter, tier, created_by, is_public, is_active, sort_order
) VALUES (
    gen_random_uuid(),
    'Financial Services Portal',
    'finance',
    'Investment platform with portfolio tracking, stock charts, transactions, and account management',
    'https://cdn.asksuma.ai/templates/finance.png',
    'https://demo.asksuma.ai/finance',
    '{"frontend": "Next.js 15", "backend": "Node.js + Express", "database": "PostgreSQL", "ui": "Tailwind CSS", "charts": "Recharts", "api": "Alpha Vantage", "auth": "NextAuth.js + 2FA"}'::jsonb,
    ARRAY['Portfolio tracking', 'Real-time stock charts', 'Transaction history', 'Account management', 'Watchlists', 'Financial news', 'Two-factor authentication'],
    'Create a financial services portal with portfolio tracking, real-time stock charts, transaction history, account management, watchlists, and 2FA. Use Next.js 15, Recharts, Alpha Vantage API, and PostgreSQL.',
    ARRAY['ALPHA_VANTAGE_API_KEY', 'DATABASE_URL', 'NEXTAUTH_SECRET', 'TWILIO_2FA_SID'],
    true,
    'free',
    NULL,
    true,
    true,
    8
) ON CONFLICT (id) DO NOTHING;

-- ==============================================================================
-- Verification Query
-- ==============================================================================

-- Show all FREE starter templates
SELECT
    name,
    category,
    is_starter,
    tier,
    sort_order,
    array_length(features, 1) as feature_count,
    CASE
        WHEN created_by IS NULL THEN 'System Template'
        ELSE 'User Template'
    END as template_type
FROM QUAD_suma_templates
WHERE is_starter = true
ORDER BY sort_order;

/**
 * Usage Instructions:
 *
 * 1. Deploy to DEV database:
 *    docker cp quad-database/sql/seeds/suma_starter_templates.sql postgres-quad-dev:/tmp/
 *    docker exec postgres-quad-dev psql -U quad_user -d quad_dev_db -f /tmp/suma_starter_templates.sql
 *
 * 2. Verify templates:
 *    SELECT name, category, tier FROM QUAD_suma_templates WHERE is_starter = true;
 *
 * 3. User Flow:
 *    - User logs in → Sees 8 FREE templates
 *    - Clicks template → Chat opens with generation_prompt pre-filled
 *    - User can edit prompt or send as-is
 *    - AI generates app from chat
 */
