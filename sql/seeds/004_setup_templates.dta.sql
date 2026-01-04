-- ============================================================================
-- QUAD Framework - Resource Setup Templates Seed Data
-- ============================================================================
-- File: 004_setup_templates.dta.sql
-- Purpose: Standard setup templates for onboarding new developers
--
-- These templates define step-by-step instructions for setting up
-- development resources. Each template includes:
--   - name: Display name for the template
--   - resource_type: Category (git, docker, ide, database, etc.)
--   - steps: JSONB array of setup steps with instructions
--   - estimated_minutes: Time estimate for completion
--   - is_system: true = system-provided template (not editable by orgs)
--
-- Step Structure:
--   { "order": 1, "title": "Step Title", "instructions": "...",
--     "verification": "command or check", "optional": false }
-- ============================================================================

-- Clear existing system templates before inserting
DELETE FROM QUAD_resource_setup_templates WHERE is_system = true;

-- Git Setup Template
INSERT INTO QUAD_resource_setup_templates (
    id, name, resource_type, description, steps,
    estimated_minutes, is_system, is_active, created_at, updated_at
) VALUES (
    '00000000-0000-0000-0004-000000000001',
    'Git Setup',
    'git',
    'Complete Git installation and configuration for development workflow',
    '[
        {
            "order": 1,
            "title": "Install Git",
            "instructions": "Download and install Git from https://git-scm.com/downloads. For macOS, you can also use: brew install git",
            "verification": "git --version",
            "optional": false
        },
        {
            "order": 2,
            "title": "Configure User Identity",
            "instructions": "Set your name and email for commits:\ngit config --global user.name \"Your Name\"\ngit config --global user.email \"your.email@company.com\"",
            "verification": "git config --global --list",
            "optional": false
        },
        {
            "order": 3,
            "title": "Generate SSH Key",
            "instructions": "Generate an SSH key for GitHub/GitLab authentication:\nssh-keygen -t ed25519 -C \"your.email@company.com\"\nThen add the public key to your Git hosting provider.",
            "verification": "ls ~/.ssh/id_ed25519.pub",
            "optional": false
        },
        {
            "order": 4,
            "title": "Configure Default Branch",
            "instructions": "Set the default branch name to main:\ngit config --global init.defaultBranch main",
            "verification": "git config --global init.defaultBranch",
            "optional": true
        },
        {
            "order": 5,
            "title": "Test Connection",
            "instructions": "Verify SSH connection to GitHub:\nssh -T git@github.com",
            "verification": "ssh -T git@github.com",
            "optional": false
        }
    ]',
    15,
    true,
    true,
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP
);

-- Docker Setup Template
INSERT INTO QUAD_resource_setup_templates (
    id, name, resource_type, description, steps,
    estimated_minutes, is_system, is_active, created_at, updated_at
) VALUES (
    '00000000-0000-0000-0004-000000000002',
    'Docker Setup',
    'docker',
    'Docker Desktop installation and configuration for containerized development',
    '[
        {
            "order": 1,
            "title": "Install Docker Desktop",
            "instructions": "Download Docker Desktop from https://www.docker.com/products/docker-desktop/\nFor macOS: Also available via brew install --cask docker\nFor Windows: Ensure WSL2 is enabled first.",
            "verification": "docker --version",
            "optional": false
        },
        {
            "order": 2,
            "title": "Start Docker Desktop",
            "instructions": "Launch Docker Desktop application. Wait for the whale icon to stop animating (indicates Docker is ready).",
            "verification": "docker info",
            "optional": false
        },
        {
            "order": 3,
            "title": "Configure Resources",
            "instructions": "Open Docker Desktop Settings > Resources. Recommended settings:\n- CPUs: At least 4\n- Memory: At least 8GB\n- Disk: At least 64GB",
            "verification": "docker system info | grep -E \"CPUs|Memory\"",
            "optional": true
        },
        {
            "order": 4,
            "title": "Install Docker Compose",
            "instructions": "Docker Compose is included with Docker Desktop. Verify installation.",
            "verification": "docker compose version",
            "optional": false
        },
        {
            "order": 5,
            "title": "Test with Hello World",
            "instructions": "Run the hello-world container to verify Docker is working:\ndocker run hello-world",
            "verification": "docker run hello-world",
            "optional": false
        },
        {
            "order": 6,
            "title": "Login to Container Registry",
            "instructions": "Login to Docker Hub or your organization container registry:\ndocker login",
            "verification": "docker login --help",
            "optional": true
        }
    ]',
    20,
    true,
    true,
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP
);

-- IDE Setup Template (VS Code)
INSERT INTO QUAD_resource_setup_templates (
    id, name, resource_type, description, steps,
    estimated_minutes, is_system, is_active, created_at, updated_at
) VALUES (
    '00000000-0000-0000-0004-000000000003',
    'IDE Setup (VS Code)',
    'ide',
    'Visual Studio Code setup with recommended extensions for full-stack development',
    '[
        {
            "order": 1,
            "title": "Install VS Code",
            "instructions": "Download VS Code from https://code.visualstudio.com/\nFor macOS: Also available via brew install --cask visual-studio-code",
            "verification": "code --version",
            "optional": false
        },
        {
            "order": 2,
            "title": "Install Essential Extensions",
            "instructions": "Install these core extensions:\n- ESLint (dbaeumer.vscode-eslint)\n- Prettier (esbenp.prettier-vscode)\n- GitLens (eamodio.gitlens)\n- Docker (ms-azuretools.vscode-docker)",
            "verification": "code --list-extensions | grep eslint",
            "optional": false
        },
        {
            "order": 3,
            "title": "Install Language Extensions",
            "instructions": "Install language-specific extensions:\n- Java Extension Pack (vscjava.vscode-java-pack)\n- Spring Boot Extension Pack (vmware.vscode-boot-dev-pack)\n- ES7+ React Snippets (dsznajder.es7-react-js-snippets)",
            "verification": "code --list-extensions | grep java",
            "optional": true
        },
        {
            "order": 4,
            "title": "Configure Settings Sync",
            "instructions": "Enable Settings Sync to backup your configuration:\n1. Click the gear icon (bottom left)\n2. Select Turn on Settings Sync\n3. Sign in with GitHub or Microsoft account",
            "verification": "Check Settings Sync status in VS Code",
            "optional": true
        },
        {
            "order": 5,
            "title": "Configure Terminal",
            "instructions": "Set your preferred terminal:\nSettings > Terminal > Integrated > Default Profile\nRecommended: zsh (macOS), PowerShell (Windows), bash (Linux)",
            "verification": "Open integrated terminal with Ctrl+`",
            "optional": true
        }
    ]',
    25,
    true,
    true,
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP
);

-- IDE Setup Template (IntelliJ)
INSERT INTO QUAD_resource_setup_templates (
    id, name, resource_type, description, steps,
    estimated_minutes, is_system, is_active, created_at, updated_at
) VALUES (
    '00000000-0000-0000-0004-000000000004',
    'IDE Setup (IntelliJ IDEA)',
    'ide',
    'IntelliJ IDEA setup for Java/Spring Boot development',
    '[
        {
            "order": 1,
            "title": "Install IntelliJ IDEA",
            "instructions": "Download IntelliJ IDEA from https://www.jetbrains.com/idea/download/\nCommunity Edition is free; Ultimate requires license.\nFor macOS: Also available via brew install --cask intellij-idea",
            "verification": "Open IntelliJ IDEA application",
            "optional": false
        },
        {
            "order": 2,
            "title": "Configure JDK",
            "instructions": "Set up Java Development Kit:\n1. File > Project Structure > SDKs\n2. Add SDK > Download JDK\n3. Select version 17 or 21 (LTS recommended)\n4. Set as Project SDK",
            "verification": "java -version",
            "optional": false
        },
        {
            "order": 3,
            "title": "Install Essential Plugins",
            "instructions": "Install recommended plugins:\n- Lombok (if using Lombok)\n- Spring Boot Assistant\n- Docker\n- Database Tools (Ultimate only)\nSettings > Plugins > Marketplace",
            "verification": "Check Settings > Plugins > Installed",
            "optional": false
        },
        {
            "order": 4,
            "title": "Configure Maven/Gradle",
            "instructions": "Set build tool home directories:\nSettings > Build Tools > Maven/Gradle\nEnsure Maven uses bundled or installed version 3.8+",
            "verification": "mvn --version OR gradle --version",
            "optional": false
        },
        {
            "order": 5,
            "title": "Enable Annotation Processing",
            "instructions": "Required for Lombok and MapStruct:\nSettings > Build > Compiler > Annotation Processors\nCheck Enable annotation processing",
            "verification": "Verify in Settings > Annotation Processors",
            "optional": true
        }
    ]',
    30,
    true,
    true,
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP
);

-- Database Setup Template (PostgreSQL)
INSERT INTO QUAD_resource_setup_templates (
    id, name, resource_type, description, steps,
    estimated_minutes, is_system, is_active, created_at, updated_at
) VALUES (
    '00000000-0000-0000-0004-000000000005',
    'Database Setup (PostgreSQL)',
    'database',
    'PostgreSQL local installation and configuration for development',
    '[
        {
            "order": 1,
            "title": "Install PostgreSQL",
            "instructions": "Install PostgreSQL 15 or later:\nmacOS: brew install postgresql@15\nWindows: Download from https://www.postgresql.org/download/windows/\nLinux: sudo apt install postgresql postgresql-contrib",
            "verification": "psql --version",
            "optional": false
        },
        {
            "order": 2,
            "title": "Start PostgreSQL Service",
            "instructions": "Start the PostgreSQL service:\nmacOS: brew services start postgresql@15\nLinux: sudo systemctl start postgresql\nWindows: Services panel or pg_ctl start",
            "verification": "pg_isready",
            "optional": false
        },
        {
            "order": 3,
            "title": "Create Development Database",
            "instructions": "Create the development database and user:\npsql postgres\nCREATE USER dev_user WITH PASSWORD ''dev_password'';\nCREATE DATABASE dev_db OWNER dev_user;\nGRANT ALL PRIVILEGES ON DATABASE dev_db TO dev_user;",
            "verification": "psql -U dev_user -d dev_db -c \"SELECT 1\"",
            "optional": false
        },
        {
            "order": 4,
            "title": "Install Database Client",
            "instructions": "Install a GUI client for database management:\n- DBeaver (free): https://dbeaver.io/download/\n- pgAdmin: https://www.pgadmin.org/download/\n- TablePlus (macOS): https://tableplus.com/",
            "verification": "Open your chosen database client",
            "optional": true
        },
        {
            "order": 5,
            "title": "Test Connection",
            "instructions": "Connect to the database using your client:\nHost: localhost\nPort: 5432\nDatabase: dev_db\nUser: dev_user\nPassword: dev_password",
            "verification": "Successfully connect and run: SELECT version();",
            "optional": false
        }
    ]',
    20,
    true,
    true,
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP
);

-- ============================================================================
-- End of Resource Setup Templates Seed Data
-- ============================================================================
