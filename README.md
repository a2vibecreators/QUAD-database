# QUAD Database

Database schema, migrations, and management tools for QUAD Framework.

## Architecture

```
quad-database/
├── sql/                  # Schema (Source of Truth)
│   ├── tables/           # Table definitions
│   ├── functions/        # Stored procedures
│   ├── triggers/         # Database triggers
│   ├── views/            # Database views
│   └── schema.sql        # Master schema loader
├── sync/                 # Schema Sync Tools
│   ├── sync-db.sh        # Compare DB vs SQL files
│   └── README.md
├── migrations/           # Version Migrations
│   └── README.md
├── seed/                 # Seed Data
│   └── README.md
├── anonymization/        # PII Masking
│   └── README.md
├── backup/               # Backup & Restore
│   └── README.md
└── deployment/           # Environment Deployment
    ├── dev/
    ├── qa/
    ├── prod/
    └── README.md
```

## Environments

| Environment | Host | Port | Database | Container |
|-------------|------|------|----------|-----------|
| DEV | localhost | 14201 | quad_dev_db | postgres-quad-dev |
| QA | localhost | 15201 | quad_qa_db | postgres-quad-qa |
| PROD | cloud-sql | 5432 | quad_prod_db | - |

## Quick Start

```bash
# Check database sync status
./sync/sync-db.sh dev

# Deploy schema to DEV
./deployment/dev/dev-deploy.sh

# Copy PROD to DEV (with anonymization)
./backup/copy-to-dev.sh --anonymize
```

## Folder Reference

| Folder | Purpose | When to Use |
|--------|---------|-------------|
| `sql/` | Schema definitions | Adding new tables, functions |
| `sync/` | Schema validation | Before/after deployments |
| `migrations/` | Version upgrades | Breaking schema changes |
| `seed/` | Test data | Setting up dev/qa environments |
| `anonymization/` | PII masking | Copying prod data to dev |
| `backup/` | Backup/restore | Before migrations, disaster recovery |
| `deployment/` | Deploy scripts | Applying schema to environments |

## Key Principles

1. **SQL files are source of truth** - Database should match `sql/` folder
2. **sync-db before deploy** - Always check drift before changes
3. **Anonymize PII** - Never copy raw prod data to dev
4. **Backup before migrate** - Automatic backup on prod deployments

## Related

- [quad-services](../quad-services/) - Java Spring Boot (uses JPA with this schema)
- [quad-web](../quad-web/) - Next.js (calls quad-services API)

## Naming Conventions

| Type | Pattern | Example |
|------|---------|---------|
| Tables | `QUAD_{domain}_{name}` | `QUAD_sandbox_instances` |
| Functions | `{action}_{domain}_{name}` | `check_sandbox_idle_status` |
| Triggers | `trg_{table}_{action}` | `trg_users_updated_at` |
| Files | `{TABLE_NAME}.tbl.sql` | `QUAD_sandbox_instances.tbl.sql` |
