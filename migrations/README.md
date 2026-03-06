# migrations

This directory contains Cloudflare D1 SQL migration files for CiCwtch.

## Details

- Migration files are `.sql` files written in SQLite/D1-compatible syntax.
- Naming convention: `NNNN_description.sql` (e.g. `0001_create_users.sql`).
- Migrations are applied via:

```bash
wrangler d1 migrations apply <DATABASE_NAME>
```
