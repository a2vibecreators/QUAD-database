# Database Migrations

Version-to-version migration scripts for breaking schema changes.

## Purpose

- Upgrade database schema between versions
- Track schema version history
- Rollback support for failed migrations

## When to Use Migrations

| Change Type | Use Migration? |
|-------------|----------------|
| New table | No - just add to `sql/tables/` |
| New column (nullable) | No - just add to `sql/tables/` |
| New function | No - just add to `sql/functions/` |
| Rename column | **YES** - requires migration |
| Change column type | **YES** - requires migration |
| Remove column | **YES** - requires migration |
| Data transformation | **YES** - requires migration |

## Migration Naming

```
v{from}_to_v{to}_{description}.sql

Examples:
- v1.0.0_to_v1.1.0_add_sandbox_mode.sql
- v1.1.0_to_v1.2.0_rename_company_to_org.sql
```

## Migration Structure

```sql
-- Migration: v1.0.0 to v1.1.0
-- Description: Add sandbox mode column
-- Author: Claude
-- Date: 2026-01-03

-- Pre-check
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM schema_version WHERE version = '1.0.0') THEN
        RAISE EXCEPTION 'Database not at version 1.0.0';
    END IF;
END $$;

-- Migration
ALTER TABLE QUAD_sandbox_instances ADD COLUMN mode VARCHAR(20);

-- Post-update
UPDATE schema_version SET version = '1.1.0', updated_at = NOW();
```

## Usage (Planned)

```bash
# Check current version
./check-version.sh dev

# Apply next migration
./migrate.sh dev

# Rollback last migration
./rollback.sh dev
```

## Related

- `sql/` - Schema definitions (non-breaking changes go here)
- `deployment/` - Applies migrations during deploy
