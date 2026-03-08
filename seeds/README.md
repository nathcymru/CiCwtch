<img src="../brand/app_icon_base.svg" alt="CiCwtch Logo" align="left" height="60" />
<!-- HEADER BADGES -->
<p align="right">
<a href="https://github.com/nathcymru/CiCwtch/actions/workflows/ci.yml"><img src="https://img.shields.io/github/actions/workflow/status/nathcymru/CiCwtch/ci.yml?branch=main&style=for-the-badge" alt="Build Status" /></a>
&nbsp;
<a href="https://github.com/nathcymru/CiCwtch/releases"><img src="https://img.shields.io/github/v/tag/nathcymru/CiCwtch?sort=semver&style=for-the-badge&label=Release" alt="Release" /></a>
&nbsp;
  <a href="https://github.com/nathcymru/CiCwtch/commits/main"><img src="https://img.shields.io/github/last-commit/nathcymru/CiCwtch?style=for-the-badge" alt="Last Commit" /></a>
</p clear="right">

# CiCwtch - seeds
## Development Seed Data

<p align="left">
  <a href="https://developers.cloudflare.com/d1/"><img src="https://img.shields.io/badge/Cloudflare%20D1-F38020?style=for-the-badge&logo=cloudflare&logoColor=white" alt="Cloudflare D1" /></a>
  &nbsp;
  <a href="https://www.sqlite.org/"><img src="https://img.shields.io/badge/SQLite-003B57?style=for-the-badge&logo=sqlite&logoColor=white" alt="SQLite" /></a>
</p>

Development and demo seed data for CiCwtch.

## Files

| File            | Description                                      |
|-----------------|--------------------------------------------------|
| `seed_dev.sql`  | Realistic sample data for local development/demos |

## How to apply

Make sure the schema migration has been applied first, then run the seed file against the local D1 database:

```bash
cd worker
npx wrangler d1 migrations apply cicwtch-db --local
npx wrangler d1 execute cicwtch-db --local --file=../seeds/seed_dev.sql
```

The seed file uses `INSERT OR IGNORE` with deterministic IDs, so it is safe to re-run without creating duplicates.

## What is included

The seed file populates the following tables with fictional but realistic data:

- **addresses** — 5 Welsh addresses used by clients
- **clients** — 4 clients with contact details and emergency contacts
- **client_contacts** — 1 primary contact per client
- **dogs** — 6 dogs across the 4 clients (mix of breeds, ages, notes)
- **dog_notes** — 4 notes (medical, dietary, behavioural, general)
- **walkers** — 3 walkers with varying roles and availability
- **walker_compliance_items** — 6 compliance records (DBS, first aid, insurance)
- **walks** — 11 walks (5 completed, 5 planned, 1 cancelled)
- **walk_reports** — 5 reports for the completed walks (including one minor incident)
- **audit_log** — 3 sample audit entries

All foreign-key relationships are valid. Names and places are Welsh-themed to match the product name.

## Important

This data is for **local development only**. Do not apply seed data to staging or production environments.

---
<p align="center">
  Built in Wales ❤️ Designed with Cwtch<br/>
  Adeiladwyd yng Nghymru ❤️ Dyluniwyd gyda Cwtch
</p>
