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
- A dog may optionally reference one breed from the `breeds` lookup table via `breed_id`.
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

## Breeds lookup

The `breeds` table is a global/reference lookup table. It normalises breed data so that dogs reference a `breed_id` instead of storing free-text breed values. The existing free-text `breed` column on `dogs` is retained for backward compatibility. Breed data (breed names) is non-personal, non-sensitive operational reference data and carries no GDPR implications.

## Dog media (R2 pointer pattern)

Dog media (avatar, profile photo, nose print) is stored in Cloudflare R2, not in D1. The `dogs` table holds only nullable R2 object-key pointers:

- `avatar_object_key`
- `profile_photo_object_key`
- `nose_print_object_key`

These columns store path-style object keys (e.g. `dogs/{dog_id}/avatar/original.jpg`). No binary data or base64 blobs are stored in D1. Media delivery and upload workflows will be handled separately from persistence.

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
