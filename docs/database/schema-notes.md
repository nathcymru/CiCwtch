<img src="../../brand/app_icon_base.svg" alt="CiCwtch Logo" align="left" height="60" />
<!-- HEADER BADGES -->
<p align="right">
<a href="https://github.com/nathcymru/CiCwtch/actions/workflows/ci.yml"><img src="https://img.shields.io/github/actions/workflow/status/nathcymru/CiCwtch/ci.yml?branch=main&style=for-the-badge" alt="Build Status" /></a>
&nbsp;
<a href="https://github.com/nathcymru/CiCwtch/releases"><img src="https://img.shields.io/github/v/tag/nathcymru/CiCwtch?sort=semver&style=for-the-badge&label=Release" alt="Release" /></a>
&nbsp;
  <a href="https://github.com/nathcymru/CiCwtch/commits/main"><img src="https://img.shields.io/github/last-commit/nathcymru/CiCwtch?style=for-the-badge" alt="Last Commit" /></a>
</p clear="right">

# CiCwtch - Schema Notes and Constraints
## Rationale for tenant scoping, uniqueness, indexes, and delete behaviour

<p align="left">
  <a href="https://developers.cloudflare.com/d1/"><img src="https://img.shields.io/badge/Cloudflare%20D1-F38020?style=for-the-badge&logo=cloudflare&logoColor=white" alt="Cloudflare D1" /></a>
  &nbsp;
  <a href="https://www.sqlite.org/index.html"><img src="https://img.shields.io/badge/SQLite-003B57?style=for-the-badge&logo=sqlite&logoColor=white" alt="SQLite" /></a>
  &nbsp;
  <a href="https://mermaid.js.org/"><img src="https://img.shields.io/badge/Mermaid-FF3670?style=for-the-badge&logo=mermaid&logoColor=white" alt="Mermaid" /></a>
</p>
## Core rules

1. **Tenant isolation is mandatory.** All tenant-owned tables carry `organisation_id`.
2. **Global reference tables are limited.** `breeds` and `vets` are global lookup datasets.
3. **SQLite-safe SQL only.** The schema must remain compatible with Cloudflare D1 limits and behaviour.
4. **No decorative duplication.** Architectural pages link here rather than re-documenting every table.

## Tenant-owned vs global tables

### Tenant-owned

Examples include `clients`, `addresses`, `dogs`, `walkers`, `walks`, `invoice_headers`, `client_contacts`, `client_documents`, `dog_medical_records`, `compliance_templates`, `walker_compliance_records`, `weather_snapshots`, `route_snapshots`, `device_registrations`, and `calendar_sync_links`.

### Global reference

- `breeds`
- `vets`

These tables intentionally do not carry `organisation_id`.

## Uniqueness

### Invoice numbering

The invoice baseline uses tenant-scoped uniqueness:

- `UNIQUE (organisation_id, invoice_number)`

This allows the same invoice number format to be reused by different organisations without cross-tenant collisions.

### Device identifiers

`device_registrations` uses:

- `UNIQUE (organisation_id, device_identifier)`

### Calendar links

`calendar_sync_links` uses:

- `UNIQUE (organisation_id, provider, external_calendar_id)`

## Foreign-key intent

Where FKs are declared, use them to reflect genuine ownership or dependency:

- `client_documents.client_id -> clients.id`
- `client_documents.organisation_id -> organisations.id`
- `behavior_snapshots.dog_id -> dogs.id`
- `vaccinations.dog_id -> dogs.id`
- `walk_reports.walk_id -> walks.id`
- `walk_reports.walker_id -> walkers.id`
- `compliance_templates.organisation_id -> organisations.id`

FKs should be corrected immediately when table names change. A temporary alias like `clients_v2` should not persist in FK definitions or index names once the table has been normalised back to `clients`.

## Delete and archive behaviour

### Soft delete

The preferred operational pattern for top-level business entities is `archived_at` rather than hard deletion. This supports auditability, restores, and safer GDPR review.

### Hard delete

Child or supporting rows may still be hard-deleted where appropriate, especially for rebuildable metadata or where the parent-child lifecycle is tightly bound.

### Cascade intent

Use `ON DELETE CASCADE` only where the child record is meaningless without the parent and no retention rule requires independent preservation. Use `ON DELETE SET NULL` where preserving the child record remains operationally useful.

## Indexing guidance

At minimum, tenant-owned tables should be indexed for common filters:

- `organisation_id`
- `archived_at` when soft delete is used
- composite business filters such as `(organisation_id, issue_date)` for invoices

Known invoice header indexes include:

- `idx_invoice_headers_organisation_id`
- `idx_invoice_headers_client_id`
- `idx_invoice_headers_status`
- `idx_invoice_headers_issue_date`
- `idx_invoice_headers_org_issue_date`

## JSON storage guidance

D1 stores JSON payloads as `TEXT`. Use `_json` suffixes consistently for raw payloads, provider responses, settings blobs, or tag arrays.

## Naming conventions

- Tables: plural `snake_case`
- IDs: `<entity>_id` for FKs, plain `id` for PK
- Timestamps: `_at` suffix
- JSON text payloads: `_json` suffix
- External code values: `_code` suffix

## Demo-data rules

Development and QA seed data should populate:

- all canonical operational tables,
- all required provider fields used by UI or validation logic, and
- representative global lookups (`breeds`, `vets`, `tax_rates`).

That includes API-oriented fields such as `place_id`, formatted address values, and raw provider payload text on validated address rows.

---
<p align="center">
  Built in Wales ❤️ Designed with Cwtch<br/>
  Adeiladwyd yng Nghymru ❤️ Dyluniwyd gyda Cwtch
</p>
