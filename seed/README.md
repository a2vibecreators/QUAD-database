# Seed Data

Test and sample data for development and QA environments.

## Purpose

- Bootstrap dev/qa environments with test data
- Consistent data for testing
- Demo data for presentations

## Files

| File | Purpose |
|------|---------|
| `dev-seed.sql` | Development environment seed data (TODO) |
| `qa-seed.sql` | QA environment seed data (TODO) |
| `demo-seed.sql` | Demo/presentation data (TODO) |

## Usage (Planned)

```bash
# Seed DEV database
./seed.sh dev

# Seed QA database
./seed.sh qa

# Seed with demo data
./seed.sh dev --demo
```

## Seed Data Categories

| Category | Description |
|----------|-------------|
| Organizations | Sample orgs (Acme Corp, Test Inc) |
| Users | Test users with various roles |
| Domains | Sample project domains |
| Tickets | Sample tickets in various states |
| Cycles | Sample sprint cycles |

## Sample Users (DEV)

| Email | Role | Password |
|-------|------|----------|
| admin@test.com | Admin | test123 |
| dev@test.com | Developer | test123 |
| pm@test.com | Product Manager | test123 |
| qa@test.com | QA Engineer | test123 |

## Safety

- NEVER run seed scripts on PROD
- Scripts check environment before running
- Seed data uses `@test.com` emails only

## Related

- `anonymization/` - Creates seed-like data from prod
- `sql/` - Schema required before seeding
