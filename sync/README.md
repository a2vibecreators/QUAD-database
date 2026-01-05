# QUAD Database Sync Tool

## Philosophy: Schema-as-Code with migra

**Source of Truth**: CREATE TABLE scripts in `sql/**/*.tbl.sql`

### Why migra with Git (NO Flyway)?

We use **pure separation** approach:
- **migra**: Generates ALTER statements by comparing .tbl.sql to actual database
- **Git**: Tracks migration history (no flyway_schema_history table)
- **No Java/Spring Boot**: Database operations are 100% independent

**Benefits:**
- ✅ Edit CREATE TABLE scripts directly (single source of truth)
- ✅ migra auto-generates ALTER statements (no manual SQL writing)
- ✅ Manual control over when changes apply
- ✅ Git tracks version history (no Java dependency)
- ✅ Migration files linked to Jira tickets and releases
- ✅ Database developer needs ZERO Java knowledge

---

## Installation

```bash
brew install pipx
pipx install 'migra[pg]'
pipx inject migra setuptools
```

**Verify installation:**
```bash
migra --version
```

---

## Usage

### Check for missing tables (existing functionality)

```bash
./sync-db.sh dev
```

This compares SQL files to the database and reports missing tables.

### Detect schema changes and generate ALTER statements

```bash
./sync-db.sh dev --schema-diff
```

**Workflow:**
1. Edit `sql/core/QUAD_users.tbl.sql` (add column)
2. Run `./sync-db.sh dev --schema-diff`
3. migra compares .tbl.sql to database
4. Script shows ALTER statements
5. Enter Jira ticket, release version, description
6. Script creates `migrations/V4__QUAD-123_description.sql`
7. Approve to apply (or cancel to apply later)

### Apply missing tables

```bash
./sync-db.sh dev --apply
```

### Apply full schema (127 tables)

```bash
./sync-db.sh dev --full
```

---

## Migration File Format

**Filename**: `V4__QUAD-123_add_user_phone.sql`
- `V4`: Version number (auto-incremented)
- `QUAD-123`: Jira ticket ID
- `add_user_phone`: Description (kebab-case)

**Header**: Includes metadata for audit trail
```sql
-- Migration Version: 4
-- Jira Ticket: https://jira.company.com/browse/QUAD-123
-- Release: v1.3.0
-- Author: sumanaddanki
-- Generated Date: 2026-01-05 16:45:00
```

---

## Example Workflow

```bash
# 1. Edit schema
vim sql/core/QUAD_users.tbl.sql
# Add: phone VARCHAR(20)

# 2. Run diff
./sync-db.sh dev --schema-diff

# Output:
# [3/6] Running migra schema comparison...
# [4/6] Schema differences detected:
# ────────────────────────────────────────
# ALTER TABLE QUAD_users ADD COLUMN phone VARCHAR(20);
# ────────────────────────────────────────
#
# [5/6] Migration metadata:
#   Jira ticket: QUAD-456
#   Release version: v1.3.0
#   Description: Add user phone for 2FA
#
# [6/6] Creating migration file...
# ✓ Created: migrations/V4__QUAD-456_add_user_phone_for_2fa.sql
#
# Apply migration now? [y/N] y
# ✓ Migration applied successfully
```

---

## Migration History (Git Only - No Flyway)

**Migration history** is tracked via Git log:

```bash
# View migration history
cd quad-database
git log --oneline migrations/

# View specific migration
git show migrations/V4__QUAD-456_add_user_phone.sql

# See who applied what when
git log --pretty=format:"%h %an %ad %s" -- migrations/
```

**Benefits over flyway_schema_history table:**
- ✅ No Java dependency (pure Git + SQL)
- ✅ Full audit trail (who, when, why)
- ✅ Easy rollback (git revert)
- ✅ Works across all environments (Git is universal)

---

## What migra Detects

**Supported:**
- ✅ Added/removed columns
- ✅ Column type changes
- ✅ NULL/NOT NULL changes
- ✅ Default value changes
- ✅ Constraints (PRIMARY KEY, UNIQUE, CHECK, FOREIGN KEY)
- ✅ Indexes
- ✅ Sequences

**Limitations:**
- ❌ Column renames (sees as DROP + ADD)
- ❌ Table renames (sees as DROP + CREATE)

**Workaround for renames**: Add hint comment in .tbl.sql file, then manually edit generated ALTER.
```sql
-- RENAME: old_column_name → new_column_name
new_column_name VARCHAR(255)
```

---

## Rollback

Rollback is **manual** (no automatic undo):
1. Look at migration file header for rollback instructions
2. Write reverse ALTER statements
3. Apply manually or create new migration

**Example:**
```sql
-- Original migration (V4):
ALTER TABLE QUAD_users ADD COLUMN phone VARCHAR(20);

-- Rollback (manual):
ALTER TABLE QUAD_users DROP COLUMN phone;
```

---

## Benefits Summary

### For Developers
- ✅ Edit CREATE TABLE scripts (no ALTER statements to write)
- ✅ migra auto-generates ALTER statements (no SQL parsing bugs)
- ✅ Manual control (review before applying)
- ✅ Metadata links migrations to Jira tickets and releases

### For Audit/Compliance
- ✅ Full migration history in Git log (better than flyway_schema_history)
- ✅ Migration files include Jira ticket URLs
- ✅ Know which release introduced each change
- ✅ Know who applied each migration (git log)
- ✅ Can review changes before deploy (git diff)

### For Operations
- ✅ Can apply migrations manually
- ✅ Can review changes before deployment
- ✅ Rollback instructions in migration file header
- ✅ No surprises on application startup (no Flyway at all)
- ✅ Database developer = NO Java knowledge required
- ✅ Java developer = NO database migration knowledge required

---

## Troubleshooting

### "migra: command not found"

Install migra:
```bash
brew install pipx
pipx install 'migra[pg]'
pipx inject migra setuptools
```

### "Cannot connect to database"

Check if PostgreSQL container is running:
```bash
docker ps | grep postgres-quad-dev
```

If not running, deploy it:
```bash
cd /Users/semostudio/git/a2vibes/QUAD
./deployment/scripts/deploy-studio.sh dev
```

### "Permission denied" when creating temp database

Ensure `quad_user` has CREATEDB privilege:
```bash
docker exec postgres-quad-dev psql -U postgres -c "ALTER USER quad_user CREATEDB;"
```

---

**Last Updated:** January 5, 2026
**Author:** Suman Addanki (via Claude Code)
**Version:** 1.0 (Pure Separation with migra)
