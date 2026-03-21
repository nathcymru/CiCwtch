<img src="../../brand/app_icon_base.svg" alt="CiCwtch Logo" align="left" height="60" />
<!-- HEADER BADGES -->
<p align="right">
<a href="https://github.com/nathcymru/CiCwtch/actions/workflows/ci.yml"><img src="https://img.shields.io/github/actions/workflow/status/nathcymru/CiCwtch/ci.yml?branch=main&style=for-the-badge" alt="Build Status" /></a>
&nbsp;
<a href="https://github.com/nathcymru/CiCwtch/releases"><img src="https://img.shields.io/github/v/tag/nathcymru/CiCwtch?sort=semver&style=for-the-badge&label=Release" alt="Release" /></a>
&nbsp;
  <a href="https://github.com/nathcymru/CiCwtch/commits/main"><img src="https://img.shields.io/github/last-commit/nathcymru/CiCwtch?style=for-the-badge" alt="Last Commit" /></a>
</p clear="right">

# CiCwtch - Database Maintenance SOPs
## Operational procedures, naming standards, and safe working rules

<p align="left">
  <a href="https://developers.cloudflare.com/d1/"><img src="https://img.shields.io/badge/Cloudflare%20D1-F38020?style=for-the-badge&logo=cloudflare&logoColor=white" alt="Cloudflare D1" /></a>
  &nbsp;
  <a href="https://www.sqlite.org/index.html"><img src="https://img.shields.io/badge/SQLite-003B57?style=for-the-badge&logo=sqlite&logoColor=white" alt="SQLite" /></a>
  &nbsp;
  <a href="https://mermaid.js.org/"><img src="https://img.shields.io/badge/Mermaid-FF3670?style=for-the-badge&logo=mermaid&logoColor=white" alt="Mermaid" /></a>
</p>
## Operational posture

CiCwtch runs on Cloudflare D1 and therefore inherits SQLite-style behaviour and limits. Maintenance work should be cautious, incremental, and fully validated.

## Standard operating procedures

### 1. Validate before change

Always inspect the current table SQL, indexes, and row counts before rebuilding or reseeding anything.

### 2. Work in small statements

Prefer small `SELECT`, `INSERT`, and DDL statements. Avoid giant query blocks that are likely to hit D1 length or compound-select limits.

### 3. Rebuild instead of patch-stacking drift

Where a table has obvious schema drift from repeated ad hoc alteration, rebuild it cleanly and revalidate.

### 4. Keep naming tidy

If a temporary suffix such as `_v2` is introduced during repair work, remove it once the canonical table is restored. Index names and FK definitions should be cleaned at the same time.

### 5. Preserve tenant safety

Never add a tenant-owned table without `organisation_id`. Never remove tenant scoping from an operational table.

## Backup and restore

The repository should document and automate D1 export/import procedures separately from this folder when those scripts are added. At minimum, a safe operator flow should be:

1. export the current D1 state,
2. validate the exported artifact,
3. apply the corrected schema or seed set, and
4. run post-change integrity checks.

## Naming conventions

- Table names: plural, `snake_case`
- Primary key: `id`
- Foreign keys: `<parent>_id`
- Timestamp columns: `_at`
- JSON text columns: `_json`
- Minor-unit money fields: `_minor`

## Scaling notes

Current priority is correctness, tenant isolation, and operational clarity. Do not introduce partitioning, sharding, or additional storage engines until there is a demonstrated need and the architecture docs are updated in the same pull request.

---
<p align="center">
  Built in Wales ❤️ Designed with Cwtch<br/>
  Adeiladwyd yng Nghymru ❤️ Dyluniwyd gyda Cwtch
</p>
