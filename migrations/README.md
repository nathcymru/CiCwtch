# migrations

This directory contains Cloudflare D1 SQL migration files for CiCwtch.

## Details

- Migration files are `.sql` files written in SQLite/D1-compatible syntax.
- Naming convention: `NNNN_description.sql` (for example `0001_initial_schema.sql`).
- For this new application, the first migration creates the schema from zero on a clean database.
- Migrations are applied via:

```bash
cd worker
npx wrangler d1 migrations apply cicwtch-db
```

Use the staging or production environment flags when applying against non-local databases.
