# Database Sync Tools

Compare database state against SQL schema files and detect drift.

## Purpose

Ensure database schema matches the source-of-truth SQL files in `sql/` folder.

## Tools

| Script | Purpose |
|--------|---------|
| `sync-db.sh` | Compare DB against SQL files, report differences |
| `diff-report.sh` | Generate detailed diff report (TODO) |

## Usage

```bash
# Check DEV database against SQL files
./sync-db.sh dev

# Check QA database
./sync-db.sh qa

# Generate fix script (doesn't apply)
./sync-db.sh dev --fix

# Check tables only
./sync-db.sh dev --tables-only
```

## Output

```
==========================================
QUAD Database Sync Tool
==========================================
Environment: dev
Database:    quad_dev_db @ localhost:14201
==========================================

Checking Tables...
-------------------------------------------
[OK] All SQL tables exist in database

Checking Functions...
-------------------------------------------
[MISSING] Functions in SQL but not in DB:
  - check_sandbox_idle_status
```

## When to Use

- Before deployment: Verify target DB has all required schema
- After migration: Confirm migration applied correctly
- CI/CD: Automated schema validation
- Debugging: Find schema drift between environments

## Related

- `sql/` - Source of truth for schema
- `migrations/` - Version-to-version migration scripts
