-- ============================================================================
-- QUAD Framework - Training Content Seed Data
-- ============================================================================
-- File: 005_training_content.dta.sql
-- Purpose: Core training content for developer onboarding
--
-- Training content includes videos, documents, and interactive courses
-- that help new team members get up to speed with:
--   - QUAD Framework methodology
--   - Development tools and best practices
--   - Technology stack fundamentals
--
-- Content Types:
--   - video: Video tutorial/course
--   - document: Written documentation
--   - interactive: Hands-on lab or exercise
--   - quiz: Knowledge assessment
--
-- Note: skill_ids can reference QUAD_skills table for skill tracking
-- Using NULL for skill_ids in seed data (link to actual skills post-setup)
-- ============================================================================

-- Clear existing training content before inserting
DELETE FROM QUAD_training_content WHERE id LIKE '00000000-0000-0000-0005-%';

-- QUAD Framework Overview
INSERT INTO QUAD_training_content (
    id, title, description, content_type, content_url,
    duration_minutes, skill_ids, is_required, is_active, created_at, updated_at
) VALUES (
    '00000000-0000-0000-0005-000000000001',
    'QUAD Framework Overview',
    'Introduction to the QUAD Framework methodology. Learn about the four pillars: Quality, Understanding, Automation, and Delivery. This video covers the core concepts, workflow principles, and how QUAD integrates with your development process.',
    'video',
    'https://training.quadframe.work/courses/quad-overview',
    15,
    NULL,  -- Link to skills after skills table is seeded
    true,  -- Required for all new team members
    true,
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP
);

-- Git Basics for Developers
INSERT INTO QUAD_training_content (
    id, title, description, content_type, content_url,
    duration_minutes, skill_ids, is_required, is_active, created_at, updated_at
) VALUES (
    '00000000-0000-0000-0005-000000000002',
    'Git Basics for Developers',
    'Comprehensive Git training covering version control fundamentals. Topics include: repository management, branching strategies, merge vs rebase, conflict resolution, Git hooks, and team collaboration workflows. Includes hands-on exercises.',
    'video',
    'https://training.quadframe.work/courses/git-basics',
    30,
    NULL,
    true,  -- Required for developers
    true,
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP
);

-- Docker Fundamentals
INSERT INTO QUAD_training_content (
    id, title, description, content_type, content_url,
    duration_minutes, skill_ids, is_required, is_active, created_at, updated_at
) VALUES (
    '00000000-0000-0000-0005-000000000003',
    'Docker Fundamentals',
    'Learn containerization with Docker from the ground up. Covers Docker architecture, Dockerfile best practices, image building, container networking, volumes, Docker Compose for multi-container applications, and debugging containers.',
    'video',
    'https://training.quadframe.work/courses/docker-fundamentals',
    45,
    NULL,
    true,  -- Required for backend developers
    true,
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP
);

-- Spring Boot Quick Start
INSERT INTO QUAD_training_content (
    id, title, description, content_type, content_url,
    duration_minutes, skill_ids, is_required, is_active, created_at, updated_at
) VALUES (
    '00000000-0000-0000-0005-000000000004',
    'Spring Boot Quick Start',
    'Fast-track your Spring Boot development skills. This course covers Spring Boot 3.x fundamentals including: auto-configuration, REST API development, dependency injection, data access with Spring Data JPA, security basics, and testing strategies.',
    'video',
    'https://training.quadframe.work/courses/spring-boot-quickstart',
    60,
    NULL,
    false,  -- Required for Java developers
    true,
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP
);

-- React Fundamentals
INSERT INTO QUAD_training_content (
    id, title, description, content_type, content_url,
    duration_minutes, skill_ids, is_required, is_active, created_at, updated_at
) VALUES (
    '00000000-0000-0000-0005-000000000005',
    'React Fundamentals',
    'Master React for modern frontend development. Topics include: component architecture, hooks (useState, useEffect, useContext), state management, routing with React Router, API integration, performance optimization, and testing with React Testing Library.',
    'video',
    'https://training.quadframe.work/courses/react-fundamentals',
    60,
    NULL,
    false,  -- Required for frontend developers
    true,
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP
);

-- ============================================================================
-- Additional Training Content (Optional/Supplementary)
-- ============================================================================

-- PostgreSQL for Developers
INSERT INTO QUAD_training_content (
    id, title, description, content_type, content_url,
    duration_minutes, skill_ids, is_required, is_active, created_at, updated_at
) VALUES (
    '00000000-0000-0000-0005-000000000006',
    'PostgreSQL for Developers',
    'Deep dive into PostgreSQL for application developers. Covers advanced queries, indexes, JSON/JSONB, full-text search, performance tuning, and database design patterns.',
    'video',
    'https://training.quadframe.work/courses/postgresql-developers',
    45,
    NULL,
    false,
    true,
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP
);

-- API Design Best Practices
INSERT INTO QUAD_training_content (
    id, title, description, content_type, content_url,
    duration_minutes, skill_ids, is_required, is_active, created_at, updated_at
) VALUES (
    '00000000-0000-0000-0005-000000000007',
    'API Design Best Practices',
    'Learn to design clean, consistent, and developer-friendly REST APIs. Covers resource naming, HTTP methods, status codes, pagination, filtering, error handling, versioning, and documentation with OpenAPI.',
    'video',
    'https://training.quadframe.work/courses/api-design',
    30,
    NULL,
    false,
    true,
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP
);

-- Code Review Excellence
INSERT INTO QUAD_training_content (
    id, title, description, content_type, content_url,
    duration_minutes, skill_ids, is_required, is_active, created_at, updated_at
) VALUES (
    '00000000-0000-0000-0005-000000000008',
    'Code Review Excellence',
    'Become an effective code reviewer. Learn what to look for, how to give constructive feedback, common anti-patterns, security considerations, and how to use code reviews for knowledge sharing.',
    'video',
    'https://training.quadframe.work/courses/code-review',
    20,
    NULL,
    false,
    true,
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP
);

-- ============================================================================
-- End of Training Content Seed Data
-- ============================================================================
