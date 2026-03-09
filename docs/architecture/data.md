<img src="../../brand/app_icon_base.svg" alt="CiCwtch Logo" align="left" height="60" />
<!-- HEADER BADGES -->
<p align="right">
<a href="https://github.com/nathcymru/CiCwtch/actions/workflows/ci.yml"><img src="https://img.shields.io/github/actions/workflow/status/nathcymru/CiCwtch/ci.yml?branch=main&style=for-the-badge" alt="Build Status" /></a>
&nbsp;
<a href="https://github.com/nathcymru/CiCwtch/releases"><img src="https://img.shields.io/github/v/tag/nathcymru/CiCwtch?sort=semver&style=for-the-badge&label=Release" alt="Release" /></a>
&nbsp;
  <a href="https://github.com/nathcymru/CiCwtch/commits/main"><img src="https://img.shields.io/github/last-commit/nathcymru/CiCwtch?style=for-the-badge" alt="Last Commit" /></a>
</p clear="right">

# CiCwtch - Data Architecture
## Current D1 schema, relationships, and data handling rules

<p align="left">
  <a href="https://developers.cloudflare.com/workers/"><img src="https://img.shields.io/badge/Cloudflare%20Workers-F38020?style=for-the-badge&logo=cloudflare&logoColor=white" alt="Cloudflare Workers" /></a>
  &nbsp;
  <a href="https://developers.cloudflare.com/d1/"><img src="https://img.shields.io/badge/Cloudflare%20D1-F38020?style=for-the-badge&logo=cloudflare&logoColor=white" alt="Cloudflare D1" /></a>
  &nbsp;
  <a href="https://www.sqlite.org/index.html"><img src="https://img.shields.io/badge/SQLite-003B57?style=for-the-badge&logo=sqlite&logoColor=white" alt="SQLite" /></a>
</p>

## Primary data store

CiCwtch currently uses **Cloudflare D1** as the source of truth for operational data.

## Core entity relationships

- A client may have one linked address and many dogs.
- A dog belongs to one client.
- A walk belongs to one client and one dog, and may optionally reference one walker.
- A walker may hold many compliance items.
- An invoice header belongs to one client.
- An invoice line belongs to one invoice header and may optionally reference one walk.

## Deletion model

Operational top-level entities generally use `archived_at` for soft deletion:

- clients
- dogs
- walkers
- walks
- invoice_headers

Invoice lines do not currently use soft deletion and are hard-deleted.

## Attachments and audit log

The schema already includes `attachments` and `audit_log` tables, but Phase 1 does not yet expose full attachment handling or systematic audit-log writing from the Worker.

## Multi-tenancy

CiCwtch is a multi-tenant platform. Every core business table must include `organisation_id`. See [multi-tenant-model.md](multi-tenant-model.md) for the full schema pattern, query rules, and migration guidance.

The current Phase 1 schema in `migrations/0001_initial_schema.sql` predates the formal multi-tenant rule and does not yet include `organisation_id` on existing tables. A future migration will add `organisation_id` to existing tables as part of the multi-tenant onboarding work.

## Privacy note

The schema already stores personal data such as names, phones, emails, addresses, notes, and operational care notes. That is why `docs/gdpr/` and `.fides/` now exist and must be kept current when the schema changes.

---
<p align="center">
  Built in Wales ❤️ Designed with Cwtch<br/>
  Adeiladwyd yng Nghymru ❤️ Dyluniwyd gyda Cwtch
</p>
