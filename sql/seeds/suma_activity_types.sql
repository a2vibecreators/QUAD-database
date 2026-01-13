/**
 * asksuma.ai - Activity Types Seed Data (Pre/Post Hooks System)
 *
 * Creates activity types with pre/post hook configurations for SUMA AI
 *
 * Activity Categories:
 * 1. Development (deploy_app, generate_code, review_code)
 * 2. Education (interview_prep, quiz_me, learn_topic)
 * 3. Utility (set_alarm, send_email, set_reminder)
 * 4. Communication (chat, voice_call, video_call)
 *
 * @author Gopi Addanke
 * @since January 10, 2026
 */

-- ==============================================================================
-- 1. Deploy App (Development Activity)
-- ==============================================================================

INSERT INTO QUAD_suma_activity_types (
    code, name, category, description,
    pre_hook_enabled, pre_hook_type, pre_hook_config,
    post_hook_enabled, post_hook_type, post_hook_config,
    icon, requires_auth, is_active, sort_order
) VALUES (
    'deploy_app',
    'Deploy App',
    'development',
    'Deploy web application to Google Cloud Run with database provisioning',
    true,  -- Pre-hook enabled
    'check_quotas',
    '{"check_gcp_quotas": true, "check_database_limits": true, "min_cpu": 1, "min_memory_mb": 512}'::jsonb,
    true,  -- Post-hook enabled
    'send_notification',
    '{"email": true, "sms": false, "notification_template": "deployment_success", "include_urls": true}'::jsonb,
    '🚀',
    true,
    true,
    1
) ON CONFLICT (code) DO NOTHING;

-- ==============================================================================
-- 2. Generate Code (Development Activity)
-- ==============================================================================

INSERT INTO QUAD_suma_activity_types (
    code, name, category, description,
    pre_hook_enabled, pre_hook_type, pre_hook_config,
    post_hook_enabled, post_hook_type, post_hook_config,
    icon, requires_auth, is_active, sort_order
) VALUES (
    'generate_code',
    'Generate Code',
    'development',
    'AI-powered code generation based on user requirements',
    true,
    'load_preferences',
    '{"load_tech_stack": true, "load_past_templates": true, "load_reference_urls": true}'::jsonb,
    true,
    'save_feedback',
    '{"ask_rating": true, "save_to_context": true, "learn_preferences": true}'::jsonb,
    '💻',
    true,
    true,
    2
) ON CONFLICT (code) DO NOTHING;

-- ==============================================================================
-- 3. Set Alarm (Utility Activity)
-- ==============================================================================

INSERT INTO QUAD_suma_activity_types (
    code, name, category, description,
    pre_hook_enabled, pre_hook_type, pre_hook_config,
    post_hook_enabled, post_hook_type, post_hook_config,
    icon, requires_auth, is_active, sort_order
) VALUES (
    'set_alarm',
    'Set Alarm',
    'utility',
    'Set alarm/reminder with context-aware enhancements (weather, traffic, etc.)',
    true,
    'check_weather',
    '{"weather_api": "openweathermap", "check_traffic": true, "suggest_early_alert": true, "api_key_env": "WEATHER_API_KEY"}'::jsonb,
    true,
    'send_email',
    '{"email_template": "alarm_confirmation", "include_weather": true, "include_traffic": true, "send_sms_backup": false}'::jsonb,
    '⏰',
    true,
    true,
    3
) ON CONFLICT (code) DO NOTHING;

-- ==============================================================================
-- 4. Interview Prep (Education Activity)
-- ==============================================================================

INSERT INTO QUAD_suma_activity_types (
    code, name, category, description,
    pre_hook_enabled, pre_hook_type, pre_hook_config,
    post_hook_enabled, post_hook_type, post_hook_config,
    icon, requires_auth, is_active, sort_order
) VALUES (
    'interview_prep',
    'Interview Prep',
    'education',
    'Personalized interview practice questions based on job role and experience',
    true,
    'load_history',
    '{"load_past_sessions": true, "load_job_profile": true, "difficulty_level": "adaptive"}'::jsonb,
    true,
    'save_results',
    '{"save_performance": true, "suggest_improvements": true, "schedule_next_session": true}'::jsonb,
    '🎓',
    true,
    true,
    4
) ON CONFLICT (code) DO NOTHING;

-- ==============================================================================
-- 5. Send Email (Communication Activity)
-- ==============================================================================

INSERT INTO QUAD_suma_activity_types (
    code, name, category, description,
    pre_hook_enabled, pre_hook_type, pre_hook_config,
    post_hook_enabled, post_hook_type, post_hook_config,
    icon, requires_auth, is_active, sort_order
) VALUES (
    'send_email',
    'Send Email',
    'communication',
    'Send email with conversation summary or custom content',
    true,
    'validate_recipient',
    '{"check_email_format": true, "verify_domain": false, "check_spam_score": true}'::jsonb,
    true,
    'confirm_sent',
    '{"email_confirmation": true, "save_to_sent_items": true, "track_delivery": false}'::jsonb,
    '📧',
    true,
    true,
    5
) ON CONFLICT (code) DO NOTHING;

-- ==============================================================================
-- 6. Quiz Me (Education Activity)
-- ==============================================================================

INSERT INTO QUAD_suma_activity_types (
    code, name, category, description,
    pre_hook_enabled, pre_hook_type, pre_hook_config,
    post_hook_enabled, post_hook_type, post_hook_config,
    icon, requires_auth, is_active, sort_order
) VALUES (
    'quiz_me',
    'Quiz Me',
    'education',
    'Interactive quiz on any topic with adaptive difficulty',
    true,
    'load_progress',
    '{"load_topic_history": true, "set_difficulty": "adaptive", "question_count": 10}'::jsonb,
    true,
    'save_score',
    '{"save_quiz_results": true, "update_progress": true, "suggest_topics": true}'::jsonb,
    '📝',
    true,
    true,
    6
) ON CONFLICT (code) DO NOTHING;

-- ==============================================================================
-- 7. Set Reminder (Utility Activity)
-- ==============================================================================

INSERT INTO QUAD_suma_activity_types (
    code, name, category, description,
    pre_hook_enabled, pre_hook_type, pre_hook_config,
    post_hook_enabled, post_hook_type, post_hook_config,
    icon, requires_auth, is_active, sort_order
) VALUES (
    'set_reminder',
    'Set Reminder',
    'utility',
    'Set custom reminder with context (location, time, notes)',
    true,
    'check_context',
    '{"check_calendar": true, "check_location": true, "suggest_time": true}'::jsonb,
    true,
    'send_notification',
    '{"email": true, "sms": true, "push_notification": true, "early_alert_minutes": 30}'::jsonb,
    '🔔',
    true,
    true,
    7
) ON CONFLICT (code) DO NOTHING;

-- ==============================================================================
-- 8. Voice Chat (Communication Activity)
-- ==============================================================================

INSERT INTO QUAD_suma_activity_types (
    code, name, category, description,
    pre_hook_enabled, pre_hook_type, pre_hook_config,
    post_hook_enabled, post_hook_type, post_hook_config,
    icon, requires_auth, is_active, sort_order
) VALUES (
    'voice_chat',
    'Voice Chat',
    'communication',
    'Voice-enabled conversation with SUMA (Sarvam AI speech-to-text)',
    true,
    'check_language',
    '{"detect_language": true, "supported_languages": ["en", "hi", "te", "ta"], "translation_enabled": true}'::jsonb,
    true,
    'save_transcript',
    '{"save_conversation": true, "generate_summary": true, "send_transcript": false}'::jsonb,
    '🎤',
    true,
    true,
    8
) ON CONFLICT (code) DO NOTHING;

-- ==============================================================================
-- Verification Query
-- ==============================================================================

-- Show all activity types with hooks
SELECT
    name,
    category,
    icon,
    CASE WHEN pre_hook_enabled THEN pre_hook_type ELSE NULL END as pre_hook,
    CASE WHEN post_hook_enabled THEN post_hook_type ELSE NULL END as post_hook,
    sort_order
FROM QUAD_suma_activity_types
WHERE is_active = true
ORDER BY sort_order;

/**
 * Usage Instructions:
 *
 * 1. Deploy to DEV database:
 *    docker cp quad-database/sql/seeds/suma_activity_types.sql postgres-quad-dev:/tmp/
 *    docker exec postgres-quad-dev psql -U quad_user -d quad_dev_db -f /tmp/suma_activity_types.sql
 *
 * 2. Verify activities:
 *    SELECT name, category, pre_hook_type, post_hook_type FROM QUAD_suma_activity_types;
 *
 * 3. Example Pre-Hook Flow (Set Alarm):
 *    User: "SUMA, remind me to go to Jersey City tomorrow 3pm"
 *    → Pre-hook: Check weather API → "It's going to rain"
 *    → Post-hook: Send email → "Alarm set. Don't forget umbrella! ☔"
 *
 * 4. Example Pre-Hook Flow (Deploy App):
 *    User: "SUMA, deploy my app to production"
 *    → Pre-hook: Check GCP quotas → "You have 80% quota remaining"
 *    → Post-hook: Send notification → "App deployed! https://myapp.suma.ai 🚀"
 */
