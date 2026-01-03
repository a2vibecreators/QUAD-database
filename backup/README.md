# Database Backup & Restore

Scripts for database backup, restore, and environment copying.

## Purpose

- Backup databases before migrations
- Restore from backups after failures
- Copy production data to DEV/QA (with anonymization)

## Files

| File | Purpose |
|------|---------|
| `backup.sh` | Create database backup (TODO) |
| `restore.sh` | Restore from backup (TODO) |
| `copy-to-dev.sh` | Copy PROD → DEV with anonymization (TODO) |
| `copy-to-qa.sh` | Copy PROD → QA with anonymization (TODO) |

## Usage (Planned)

```bash
# Backup DEV database
./backup.sh dev

# Backup with timestamp
./backup.sh qa --timestamp

# Restore DEV from backup
./restore.sh dev backup-20260103-120000.sql

# Copy PROD to DEV (includes anonymization)
./copy-to-dev.sh --from prod --anonymize
```

## Backup Location

```
/backups/quad/
├── dev/
│   └── backup-20260103-120000.sql.gz
├── qa/
│   └── backup-20260103-120000.sql.gz
└── prod/
    └── backup-20260103-120000.sql.gz
```

## Copy Flow (PROD → DEV)

```
1. Backup PROD database
2. Restore to temporary location
3. Run anonymization scripts
4. Verify no PII leaked
5. Restore anonymized data to DEV
6. Log operation in audit table
```

## Safety Rules

- PROD restore requires 2-person approval
- All operations logged to audit trail
- Backups encrypted at rest
- Automatic backup before any migration

## Retention Policy

| Environment | Retention |
|-------------|-----------|
| DEV | 7 days |
| QA | 30 days |
| PROD | 90 days + monthly archives |

## Related

- `anonymization/` - PII masking scripts
- `migrations/` - Migration scripts (backup before running)
