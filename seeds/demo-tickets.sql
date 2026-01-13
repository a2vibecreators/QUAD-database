-- Demo Tickets for QUAD Demo
-- Run: psql -h localhost -p 14201 -U postgres -d quad_dev_db -f seeds/demo-tickets.sql

-- First, ensure we have a demo domain
INSERT INTO quad_domains (id, name, slug)
VALUES ('a0000000-0000-0000-0000-000000000001', 'QUAD Demo', 'quad-demo')
ON CONFLICT DO NOTHING;

-- Demo tickets
INSERT INTO quad_tickets (domain_id, ticket_number, title, description, ticket_type, status, priority, story_points)
VALUES
  -- High priority
  ('a0000000-0000-0000-0000-000000000001', 'QUAD-101', 'Add user authentication',
   'Implement login/logout with email and password. Use JWT for session management.',
   'story', 'backlog', 'high', 8),

  ('a0000000-0000-0000-0000-000000000001', 'QUAD-102', 'Fix login redirect bug',
   'Users are not redirected to dashboard after successful login.',
   'bug', 'backlog', 'high', 2),

  -- Medium priority
  ('a0000000-0000-0000-0000-000000000001', 'QUAD-103', 'Create user dashboard',
   'Build main dashboard showing user stats and recent activity.',
   'story', 'backlog', 'medium', 5),

  ('a0000000-0000-0000-0000-000000000001', 'QUAD-104', 'Add email notifications',
   'Send email when user completes signup and on password reset.',
   'story', 'backlog', 'medium', 3),

  ('a0000000-0000-0000-0000-000000000001', 'QUAD-105', 'Implement API rate limiting',
   'Add rate limiting to prevent abuse. 100 requests per minute per user.',
   'task', 'backlog', 'medium', 3),

  -- Low priority
  ('a0000000-0000-0000-0000-000000000001', 'QUAD-106', 'Update documentation',
   'Update API docs with new authentication endpoints.',
   'task', 'backlog', 'low', 1),

  ('a0000000-0000-0000-0000-000000000001', 'QUAD-107', 'Add dark mode toggle',
   'Allow users to switch between light and dark themes.',
   'story', 'backlog', 'low', 2)

ON CONFLICT DO NOTHING;

-- Show created tickets
SELECT ticket_number, title, status, priority, story_points
FROM quad_tickets
WHERE domain_id = 'a0000000-0000-0000-0000-000000000001'
ORDER BY
  CASE priority WHEN 'high' THEN 1 WHEN 'medium' THEN 2 ELSE 3 END,
  ticket_number;
