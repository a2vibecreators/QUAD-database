# Data Anonymization

Scripts to mask PII (Personally Identifiable Information) when copying production data to lower environments.

## Purpose

- Copy production data to DEV/QA for testing
- Mask sensitive fields (emails, names, phone numbers)
- Comply with data privacy regulations (GDPR, HIPAA)

## Files

| File | Purpose |
|------|---------|
| `anonymize.sql` | SQL script to mask PII fields (TODO) |
| `rules.yaml` | Anonymization rules configuration (TODO) |
| `verify.sh` | Verify no PII leaked after anonymization (TODO) |

## Anonymization Rules (Planned)

```yaml
# rules.yaml
tables:
  QUAD_users:
    email: "user_{{id}}@example.com"
    name: "User {{id}}"
    phone: "555-0000"

  QUAD_organizations:
    contact_email: "org_{{id}}@example.com"
    billing_email: null  # Remove completely
```

## Usage (Planned)

```bash
# Anonymize DEV database
./anonymize.sh dev

# Copy PROD to DEV with anonymization
../backup/copy-to-dev.sh --anonymize

# Verify no PII leaked
./verify.sh dev
```

## What Gets Anonymized

| Data Type | Method |
|-----------|--------|
| Emails | Replace with `user_N@example.com` |
| Names | Replace with `User N` |
| Phone numbers | Replace with `555-0000` |
| Addresses | Replace with generic address |
| API keys | Hash or remove |
| Passwords | Already hashed, keep as-is |

## Safety

- NEVER run anonymization scripts on PROD
- Scripts check environment before running
- Audit log of all anonymization runs

## Related

- `backup/copy-to-dev.sh` - Uses anonymization during copy
- `sql/` - Schema reference for PII fields
