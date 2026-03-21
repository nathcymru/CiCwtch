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
## Tenant isolation rules for D1 tables and queries

<p align="left">
  <a href="https://flutter.dev/"><img src="https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white" alt="Flutter" /></a>
  &nbsp;
  <a href="https://developers.cloudflare.com/workers/"><img src="https://img.shields.io/badge/Cloudflare%20Workers-F38020?style=for-the-badge&logo=cloudflare&logoColor=white" alt="Cloudflare Workers" /></a>
  &nbsp;
  <a href="https://developers.cloudflare.com/d1/"><img src="https://img.shields.io/badge/Cloudflare%20D1-F38020?style=for-the-badge&logo=cloudflare&logoColor=white" alt="Cloudflare D1" /></a>
  &nbsp;
  <a href="https://developers.cloudflare.com/r2/"><img src="https://img.shields.io/badge/Cloudflare%20R2-F38020?style=for-the-badge&logo=cloudflare&logoColor=white" alt="Cloudflare R2" /></a>
</p>
## Principle

Each dog-walking business using CiCwtch is a separate tenant. Tenant isolation is a hard platform rule, not an optional convention.

## Tenant anchor

Each tenant is represented by a record in the `organisations` table. The `organisations` table is global and does not itself carry `organisation_id`.

## Mandatory table pattern

Tenant-owned tables should follow this shape:

```sql
id TEXT PRIMARY KEY,
organisation_id TEXT NOT NULL
```

Add table-specific fields after that baseline and index `organisation_id` for filtering.

## Tenant-owned tables

Examples in the current documented baseline include:

- `addresses`
- `clients`
- `client_contacts`
- `client_documents`
- `dogs`
- `dog_medical_records`
- `walkers`
- `walker_compliance_records`
- `compliance_templates`
- `walks`
- `invoice_headers`
- `invoice_lines`
- `invoice_sequences`
- `invoice_branding_profiles`
- `invoice_line_item_templates`
- `invoice_line_items_catalog`
- `weather_snapshots`
- `route_snapshots`
- `device_registrations`
- `calendar_sync_links`

## Global/reference tables

The documented global lookup/reference tables are:

- `breeds`
- `vets`

## Query rule

All reads, updates, archives, and deletes for tenant-owned data must filter by `organisation_id`.

```sql
SELECT * FROM clients
WHERE organisation_id = ?
  AND archived_at IS NULL;
```

```sql
UPDATE clients
SET archived_at = CURRENT_TIMESTAMP
WHERE id = ?
  AND organisation_id = ?;
```

Never query a tenant-owned business table without a tenant filter.

## Naming hygiene

Temporary repair suffixes such as `_v2` should be removed once the canonical table is restored. Tenant rules apply to the canonical table names only.

---
<p align="center">
  Built in Wales ❤️ Designed with Cwtch<br/>
  Adeiladwyd yng Nghymru ❤️ Dyluniwyd gyda Cwtch
</p>
