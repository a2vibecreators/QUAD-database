# Database Deployment

Environment-specific database deployment scripts.

## Purpose

- Deploy schema changes to specific environments
- Run migrations in correct order
- Seed data for dev/qa environments

## Structure

```
deployment/
├── dev/
│   ├── dev-deploy.sh      # Deploy to DEV
│   └── dev-seed.sql       # DEV-specific seed data
├── qa/
│   ├── qa-deploy.sh       # Deploy to QA
│   └── qa-seed.sql        # QA-specific seed data
├── prod/
│   └── prod-deploy.sh     # Deploy to PROD (requires approval)
└── scripts/
    └── deploy.sh          # Main deployment logic
```

## Usage

```bash
# Deploy to DEV
./dev/dev-deploy.sh

# Deploy to QA
./qa/qa-deploy.sh

# Deploy to PROD (requires approval)
./prod/prod-deploy.sh
```

## Deployment Steps

1. **Pre-check**
   - Verify database connectivity
   - Check current schema version
   - Create backup (automatic)

2. **Apply Changes**
   - Run pending migrations in order
   - Apply new tables/functions
   - Update schema version

3. **Post-check**
   - Run sync-db to verify
   - Run health checks
   - Log deployment to audit

## Environment Variables

```bash
# DEV
DB_HOST=localhost
DB_PORT=14201
DB_NAME=quad_dev_db

# QA
DB_HOST=localhost
DB_PORT=15201
DB_NAME=quad_qa_db

# PROD
DB_HOST=cloud-sql
DB_PORT=5432
DB_NAME=quad_prod_db
```

## Safety Rules

| Environment | Approval Required | Auto-Backup |
|-------------|-------------------|-------------|
| DEV | No | Optional |
| QA | No | Yes |
| PROD | Yes (2-person) | Yes |

## Related

- `sync/` - Verify deployment success
- `backup/` - Pre-deployment backups
- `migrations/` - Migration scripts to apply
