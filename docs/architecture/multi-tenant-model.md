<img src="../../brand/app_icon_base.svg" alt="CiCwtch Logo" align="left" height="60" />
<!-- HEADER BADGES -->
<p align="right">
<a href="https://github.com/nathcymru/CiCwtch/actions/workflows/ci.yml"><img src="https://img.shields.io/github/actions/workflow/status/nathcymru/CiCwtch/ci.yml?branch=main&style=for-the-badge" alt="Build Status" /></a>
&nbsp;
<a href="https://github.com/nathcymru/CiCwtch/releases"><img src="https://img.shields.io/github/v/tag/nathcymru/CiCwtch?sort=semver&style=for-the-badge&label=Release" alt="Release" /></a>
&nbsp;
  <a href="https://github.com/nathcymru/CiCwtch/commits/main"><img src="https://img.shields.io/github/last-commit/nathcymru/CiCwtch?style=for-the-badge" alt="Last Commit" /></a>
</p clear="right">

# CiCwtch - Multi-Tenant Data Model
## Organisation scoping rules, schema patterns, and query guidance

<p align="left">
  <a href="https://developers.cloudflare.com/workers/"><img src="https://img.shields.io/badge/Cloudflare%20Workers-F38020?style=for-the-badge&logo=cloudflare&logoColor=white" alt="Cloudflare Workers" /></a>
  &nbsp;
  <a href="https://developers.cloudflare.com/d1/"><img src="https://img.shields.io/badge/Cloudflare%20D1-F38020?style=for-the-badge&logo=cloudflare&logoColor=white" alt="Cloudflare D1" /></a>
  &nbsp;
  <a href="https://www.sqlite.org/index.html"><img src="https://img.shields.io/badge/SQLite-003B57?style=for-the-badge&logo=sqlite&logoColor=white" alt="SQLite" /></a>
</p>

## Platform rule

CiCwtch is a multi-tenant SaaS platform. Each tenant is an independent dog-walking business. Every tenant's data must be fully isolated from every other tenant's data. This is a core platform rule, not an optional feature.

## Organisation record

Each tenant is represented by a record in the `organisations` table. The `organisations` table is a global/platform-level table and does not itself carry `organisation_id`.

## Tenant-owned table schema pattern

Every core business table that belongs to a tenant must follow this column pattern:

```sql
id              TEXT NOT NULL PRIMARY KEY,
organisation_id TEXT NOT NULL,
-- ... domain-specific columns ...
created_at      TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
updated_at      TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
archived_at     TEXT          -- nullable; present where soft-delete applies
```

Rules:

- `organisation_id` is `NOT NULL` on all tenant-owned tables.
- `organisation_id` references the `organisations` table.
- An index on `organisation_id` must be created for all tenant-owned tables.
- `archived_at` is included on top-level operational entities where soft-delete is required.

## Tenant-owned tables

The following tables are tenant-owned and must carry `organisation_id`:

- `addresses`
- `clients`
- `client_contacts`
- `dogs`
- `dog_notes`
- `walkers`
- `walker_compliance_items`
- `walks`
- `walk_reports` / `visit_records`
- `invoices` / `invoice_headers`
- `invoice_lines`
- `payments`
- `bookings` / `walk_slots` (where applicable)
- `attachments`
- `audit_log`
- `rewards` / `reward_campaigns`
- `vouchers`

## Global/reference tables

The following are platform-level or reference tables and do **not** carry `organisation_id`:

- `organisations` (the tenant record itself)
- Any future static lookup/reference tables (e.g., VAT codes, system config templates)

These tables are shared across all tenants and must not be confused with tenant-owned tables.

## Query pattern

All reads, updates, archives, and deletes for tenant-owned data **must** filter by `organisation_id`:

```sql
-- List (active records only)
SELECT * FROM clients
WHERE organisation_id = ?
  AND archived_at IS NULL;

-- Get single record
SELECT * FROM clients
WHERE id = ?
  AND organisation_id = ?;

-- Archive (soft delete)
UPDATE clients
SET archived_at = CURRENT_TIMESTAMP,
    updated_at  = CURRENT_TIMESTAMP
WHERE id = ?
  AND organisation_id = ?;
```

Never query a tenant-owned table without a `WHERE organisation_id = ?` clause.

## Migration guidance

- All future migrations for tenant-owned entities must include `organisation_id` in the initial `CREATE TABLE` statement.
- Do not create a tenant table without `organisation_id` and then add it later — it must be present from day one.
- All future migrations must also add the corresponding index:

```sql
CREATE INDEX IF NOT EXISTS idx_<table>_org ON <table>(organisation_id);
```

---
<p align="center">
  Built in Wales ❤️ Designed with Cwtch<br/>
  Adeiladwyd yng Nghymru ❤️ Dyluniwyd gyda Cwtch
</p>
