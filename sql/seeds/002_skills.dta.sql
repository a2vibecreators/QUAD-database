-- ============================================================================
-- QUAD Framework - System Skills Seed Data
-- ============================================================================
-- File: 002_skills.dta.sql
-- Purpose: Seed data for QUAD_skills table (system-level skills)
-- Compatibility: H2 Database (standard INSERT statements)
--
-- This file creates 40 system skills across 4 categories:
--   - Languages (10): Programming languages
--   - Frameworks (10): Development frameworks and libraries
--   - Tools (10): DevOps, cloud, and development tools
--   - Domains (10): Technical domain expertise areas
--
-- UUID Pattern:
--   Languages:  00000000-0000-0000-0001-00000000000X (1-10)
--   Frameworks: 00000000-0000-0000-0002-00000000000X (1-10)
--   Tools:      00000000-0000-0000-0003-00000000000X (1-10)
--   Domains:    00000000-0000-0000-0004-00000000000X (1-10)
--
-- All system skills have:
--   - org_id = NULL (not organization-specific)
--   - is_system = true (system-defined, not user-created)
--   - is_active = true
-- ============================================================================

-- ============================================================================
-- CATEGORY: Languages (10 skills)
-- ============================================================================

INSERT INTO QUAD_skills (
    id, org_id, name, category, description, is_system, is_active, created_at, updated_at
) VALUES (
    '00000000-0000-0000-0001-000000000001',
    NULL,
    'Java',
    'language',
    'Object-oriented programming language widely used for enterprise applications, Android development, and backend services. Known for platform independence and strong typing.',
    true,
    true,
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP
);

INSERT INTO QUAD_skills (
    id, org_id, name, category, description, is_system, is_active, created_at, updated_at
) VALUES (
    '00000000-0000-0000-0001-000000000002',
    NULL,
    'Python',
    'language',
    'High-level programming language known for readability and versatility. Popular for AI/ML, data science, web development, and automation scripting.',
    true,
    true,
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP
);

INSERT INTO QUAD_skills (
    id, org_id, name, category, description, is_system, is_active, created_at, updated_at
) VALUES (
    '00000000-0000-0000-0001-000000000003',
    NULL,
    'JavaScript',
    'language',
    'Dynamic programming language essential for web development. Runs in browsers and on servers (Node.js). Powers interactive web applications and modern frontends.',
    true,
    true,
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP
);

INSERT INTO QUAD_skills (
    id, org_id, name, category, description, is_system, is_active, created_at, updated_at
) VALUES (
    '00000000-0000-0000-0001-000000000004',
    NULL,
    'TypeScript',
    'language',
    'Typed superset of JavaScript that compiles to plain JavaScript. Provides static type checking, enhanced IDE support, and better code maintainability.',
    true,
    true,
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP
);

INSERT INTO QUAD_skills (
    id, org_id, name, category, description, is_system, is_active, created_at, updated_at
) VALUES (
    '00000000-0000-0000-0001-000000000005',
    NULL,
    'Go',
    'language',
    'Statically typed, compiled language designed at Google. Known for simplicity, concurrency support, and efficient performance. Popular for cloud infrastructure and microservices.',
    true,
    true,
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP
);

INSERT INTO QUAD_skills (
    id, org_id, name, category, description, is_system, is_active, created_at, updated_at
) VALUES (
    '00000000-0000-0000-0001-000000000006',
    NULL,
    'Rust',
    'language',
    'Systems programming language focused on safety, concurrency, and performance. Prevents memory errors at compile time. Growing adoption for systems and WebAssembly.',
    true,
    true,
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP
);

INSERT INTO QUAD_skills (
    id, org_id, name, category, description, is_system, is_active, created_at, updated_at
) VALUES (
    '00000000-0000-0000-0001-000000000007',
    NULL,
    'C++',
    'language',
    'High-performance compiled language with low-level memory control. Used for game engines, operating systems, embedded systems, and performance-critical applications.',
    true,
    true,
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP
);

INSERT INTO QUAD_skills (
    id, org_id, name, category, description, is_system, is_active, created_at, updated_at
) VALUES (
    '00000000-0000-0000-0001-000000000008',
    NULL,
    'C#',
    'language',
    'Modern object-oriented language developed by Microsoft. Primary language for .NET development, Unity game development, and Windows applications.',
    true,
    true,
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP
);

INSERT INTO QUAD_skills (
    id, org_id, name, category, description, is_system, is_active, created_at, updated_at
) VALUES (
    '00000000-0000-0000-0001-000000000009',
    NULL,
    'Ruby',
    'language',
    'Dynamic, interpreted language focused on simplicity and productivity. Famous for Ruby on Rails framework. Popular for web development and scripting.',
    true,
    true,
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP
);

INSERT INTO QUAD_skills (
    id, org_id, name, category, description, is_system, is_active, created_at, updated_at
) VALUES (
    '00000000-0000-0000-0001-000000000010',
    NULL,
    'Kotlin',
    'language',
    'Modern JVM language that is fully interoperable with Java. Official language for Android development. Concise syntax with null safety built-in.',
    true,
    true,
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP
);

-- ============================================================================
-- CATEGORY: Frameworks (10 skills)
-- ============================================================================

INSERT INTO QUAD_skills (
    id, org_id, name, category, description, is_system, is_active, created_at, updated_at
) VALUES (
    '00000000-0000-0000-0002-000000000001',
    NULL,
    'Spring Boot',
    'framework',
    'Java-based framework for building production-ready applications. Provides auto-configuration, embedded servers, and comprehensive enterprise features.',
    true,
    true,
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP
);

INSERT INTO QUAD_skills (
    id, org_id, name, category, description, is_system, is_active, created_at, updated_at
) VALUES (
    '00000000-0000-0000-0002-000000000002',
    NULL,
    'React',
    'framework',
    'JavaScript library for building user interfaces. Component-based architecture with virtual DOM. Developed by Meta, widely used for single-page applications.',
    true,
    true,
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP
);

INSERT INTO QUAD_skills (
    id, org_id, name, category, description, is_system, is_active, created_at, updated_at
) VALUES (
    '00000000-0000-0000-0002-000000000003',
    NULL,
    'Angular',
    'framework',
    'TypeScript-based web application framework by Google. Full-featured platform with dependency injection, routing, and comprehensive tooling.',
    true,
    true,
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP
);

INSERT INTO QUAD_skills (
    id, org_id, name, category, description, is_system, is_active, created_at, updated_at
) VALUES (
    '00000000-0000-0000-0002-000000000004',
    NULL,
    'Vue',
    'framework',
    'Progressive JavaScript framework for building UIs. Approachable, performant, and versatile. Great for both simple and complex applications.',
    true,
    true,
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP
);

INSERT INTO QUAD_skills (
    id, org_id, name, category, description, is_system, is_active, created_at, updated_at
) VALUES (
    '00000000-0000-0000-0002-000000000005',
    NULL,
    'Django',
    'framework',
    'High-level Python web framework encouraging rapid development. Includes ORM, admin interface, authentication, and follows batteries-included philosophy.',
    true,
    true,
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP
);

INSERT INTO QUAD_skills (
    id, org_id, name, category, description, is_system, is_active, created_at, updated_at
) VALUES (
    '00000000-0000-0000-0002-000000000006',
    NULL,
    'FastAPI',
    'framework',
    'Modern Python web framework for building APIs. High performance, automatic OpenAPI documentation, and native async support.',
    true,
    true,
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP
);

INSERT INTO QUAD_skills (
    id, org_id, name, category, description, is_system, is_active, created_at, updated_at
) VALUES (
    '00000000-0000-0000-0002-000000000007',
    NULL,
    'Express',
    'framework',
    'Minimal and flexible Node.js web application framework. Provides robust features for web and mobile applications. Foundation for many Node.js frameworks.',
    true,
    true,
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP
);

INSERT INTO QUAD_skills (
    id, org_id, name, category, description, is_system, is_active, created_at, updated_at
) VALUES (
    '00000000-0000-0000-0002-000000000008',
    NULL,
    'Next.js',
    'framework',
    'React framework for production with hybrid static and server rendering, TypeScript support, smart bundling, and route pre-fetching.',
    true,
    true,
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP
);

INSERT INTO QUAD_skills (
    id, org_id, name, category, description, is_system, is_active, created_at, updated_at
) VALUES (
    '00000000-0000-0000-0002-000000000009',
    NULL,
    'Flutter',
    'framework',
    'UI toolkit by Google for building natively compiled applications for mobile, web, and desktop from a single codebase using Dart.',
    true,
    true,
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP
);

INSERT INTO QUAD_skills (
    id, org_id, name, category, description, is_system, is_active, created_at, updated_at
) VALUES (
    '00000000-0000-0000-0002-000000000010',
    NULL,
    'SwiftUI',
    'framework',
    'Declarative UI framework by Apple for building interfaces across all Apple platforms. Modern Swift-based approach with live previews and native performance.',
    true,
    true,
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP
);

-- ============================================================================
-- CATEGORY: Tools (10 skills)
-- ============================================================================

INSERT INTO QUAD_skills (
    id, org_id, name, category, description, is_system, is_active, created_at, updated_at
) VALUES (
    '00000000-0000-0000-0003-000000000001',
    NULL,
    'Docker',
    'tool',
    'Container platform for developing, shipping, and running applications. Enables consistent environments across development, testing, and production.',
    true,
    true,
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP
);

INSERT INTO QUAD_skills (
    id, org_id, name, category, description, is_system, is_active, created_at, updated_at
) VALUES (
    '00000000-0000-0000-0003-000000000002',
    NULL,
    'Kubernetes',
    'tool',
    'Container orchestration platform for automating deployment, scaling, and management of containerized applications. Industry standard for cloud-native apps.',
    true,
    true,
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP
);

INSERT INTO QUAD_skills (
    id, org_id, name, category, description, is_system, is_active, created_at, updated_at
) VALUES (
    '00000000-0000-0000-0003-000000000003',
    NULL,
    'Git',
    'tool',
    'Distributed version control system for tracking changes in source code. Essential for collaboration, branching, and code history management.',
    true,
    true,
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP
);

INSERT INTO QUAD_skills (
    id, org_id, name, category, description, is_system, is_active, created_at, updated_at
) VALUES (
    '00000000-0000-0000-0003-000000000004',
    NULL,
    'AWS',
    'tool',
    'Amazon Web Services cloud computing platform. Comprehensive suite of cloud services including compute, storage, database, AI/ML, and networking.',
    true,
    true,
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP
);

INSERT INTO QUAD_skills (
    id, org_id, name, category, description, is_system, is_active, created_at, updated_at
) VALUES (
    '00000000-0000-0000-0003-000000000005',
    NULL,
    'GCP',
    'tool',
    'Google Cloud Platform for cloud computing services. Strong in data analytics, machine learning, and Kubernetes. Powers many Google-scale applications.',
    true,
    true,
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP
);

INSERT INTO QUAD_skills (
    id, org_id, name, category, description, is_system, is_active, created_at, updated_at
) VALUES (
    '00000000-0000-0000-0003-000000000006',
    NULL,
    'Azure',
    'tool',
    'Microsoft Azure cloud computing platform. Strong enterprise integration, hybrid cloud capabilities, and comprehensive service offerings.',
    true,
    true,
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP
);

INSERT INTO QUAD_skills (
    id, org_id, name, category, description, is_system, is_active, created_at, updated_at
) VALUES (
    '00000000-0000-0000-0003-000000000007',
    NULL,
    'Terraform',
    'tool',
    'Infrastructure as Code tool for building, changing, and versioning infrastructure safely and efficiently. Supports multiple cloud providers.',
    true,
    true,
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP
);

INSERT INTO QUAD_skills (
    id, org_id, name, category, description, is_system, is_active, created_at, updated_at
) VALUES (
    '00000000-0000-0000-0003-000000000008',
    NULL,
    'Jenkins',
    'tool',
    'Open-source automation server for building, testing, and deploying software. Extensible with plugins for CI/CD pipelines.',
    true,
    true,
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP
);

INSERT INTO QUAD_skills (
    id, org_id, name, category, description, is_system, is_active, created_at, updated_at
) VALUES (
    '00000000-0000-0000-0003-000000000009',
    NULL,
    'GitHub Actions',
    'tool',
    'CI/CD platform integrated with GitHub. Automate workflows for building, testing, and deploying directly from repositories.',
    true,
    true,
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP
);

INSERT INTO QUAD_skills (
    id, org_id, name, category, description, is_system, is_active, created_at, updated_at
) VALUES (
    '00000000-0000-0000-0003-000000000010',
    NULL,
    'PostgreSQL',
    'tool',
    'Advanced open-source relational database. Robust, extensible, and standards-compliant with excellent performance and reliability.',
    true,
    true,
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP
);

-- ============================================================================
-- CATEGORY: Domains (10 skills)
-- ============================================================================

INSERT INTO QUAD_skills (
    id, org_id, name, category, description, is_system, is_active, created_at, updated_at
) VALUES (
    '00000000-0000-0000-0004-000000000001',
    NULL,
    'AI/ML',
    'domain',
    'Artificial Intelligence and Machine Learning expertise. Includes neural networks, deep learning, NLP, computer vision, and model deployment.',
    true,
    true,
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP
);

INSERT INTO QUAD_skills (
    id, org_id, name, category, description, is_system, is_active, created_at, updated_at
) VALUES (
    '00000000-0000-0000-0004-000000000002',
    NULL,
    'DevOps',
    'domain',
    'Development and Operations practices combining software development and IT operations. CI/CD, automation, monitoring, and infrastructure management.',
    true,
    true,
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP
);

INSERT INTO QUAD_skills (
    id, org_id, name, category, description, is_system, is_active, created_at, updated_at
) VALUES (
    '00000000-0000-0000-0004-000000000003',
    NULL,
    'Backend',
    'domain',
    'Server-side development expertise. APIs, databases, business logic, authentication, and system architecture for web and mobile applications.',
    true,
    true,
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP
);

INSERT INTO QUAD_skills (
    id, org_id, name, category, description, is_system, is_active, created_at, updated_at
) VALUES (
    '00000000-0000-0000-0004-000000000004',
    NULL,
    'Frontend',
    'domain',
    'Client-side development expertise. User interfaces, responsive design, accessibility, state management, and browser technologies.',
    true,
    true,
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP
);

INSERT INTO QUAD_skills (
    id, org_id, name, category, description, is_system, is_active, created_at, updated_at
) VALUES (
    '00000000-0000-0000-0004-000000000005',
    NULL,
    'Mobile',
    'domain',
    'Mobile application development for iOS and Android. Native development, cross-platform frameworks, app store deployment, and mobile UX.',
    true,
    true,
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP
);

INSERT INTO QUAD_skills (
    id, org_id, name, category, description, is_system, is_active, created_at, updated_at
) VALUES (
    '00000000-0000-0000-0004-000000000006',
    NULL,
    'Security',
    'domain',
    'Application and infrastructure security expertise. Authentication, authorization, encryption, vulnerability assessment, and security best practices.',
    true,
    true,
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP
);

INSERT INTO QUAD_skills (
    id, org_id, name, category, description, is_system, is_active, created_at, updated_at
) VALUES (
    '00000000-0000-0000-0004-000000000007',
    NULL,
    'Data Engineering',
    'domain',
    'Building and maintaining data pipelines and infrastructure. ETL processes, data warehousing, streaming data, and analytics platforms.',
    true,
    true,
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP
);

INSERT INTO QUAD_skills (
    id, org_id, name, category, description, is_system, is_active, created_at, updated_at
) VALUES (
    '00000000-0000-0000-0004-000000000008',
    NULL,
    'Cloud Architecture',
    'domain',
    'Designing scalable, resilient cloud infrastructure. Multi-cloud strategies, serverless architecture, cost optimization, and high availability.',
    true,
    true,
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP
);

INSERT INTO QUAD_skills (
    id, org_id, name, category, description, is_system, is_active, created_at, updated_at
) VALUES (
    '00000000-0000-0000-0004-000000000009',
    NULL,
    'Testing',
    'domain',
    'Software testing and quality assurance expertise. Unit testing, integration testing, E2E testing, test automation, and quality metrics.',
    true,
    true,
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP
);

INSERT INTO QUAD_skills (
    id, org_id, name, category, description, is_system, is_active, created_at, updated_at
) VALUES (
    '00000000-0000-0000-0004-000000000010',
    NULL,
    'Database',
    'domain',
    'Database design and administration expertise. SQL and NoSQL databases, query optimization, data modeling, replication, and backup strategies.',
    true,
    true,
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP
);

-- ============================================================================
-- End of seed data
-- Summary: 40 system skills across 4 categories
--   - Languages: 10 skills
--   - Frameworks: 10 skills
--   - Tools: 10 skills
--   - Domains: 10 skills
-- ============================================================================
