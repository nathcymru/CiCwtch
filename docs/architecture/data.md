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
## Current D1 schema rules, data boundaries, and where to find detailed database docs

<p align="left">
  <a href="https://flutter.dev/"><img src="https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white" alt="Flutter" /></a>
  &nbsp;
  <a href="https://developers.cloudflare.com/workers/"><img src="https://img.shields.io/badge/Cloudflare%20Workers-F38020?style=for-the-badge&logo=cloudflare&logoColor=white" alt="Cloudflare Workers" /></a>
  &nbsp;
  <a href="https://developers.cloudflare.com/d1/"><img src="https://img.shields.io/badge/Cloudflare%20D1-F38020?style=for-the-badge&logo=cloudflare&logoColor=white" alt="Cloudflare D1" /></a>
  &nbsp;
  <a href="https://developers.cloudflare.com/r2/"><img src="https://img.shields.io/badge/Cloudflare%20R2-F38020?style=for-the-badge&logo=cloudflare&logoColor=white" alt="Cloudflare R2" /></a>
</p>
## Primary data stores

CiCwtch uses:

- **Cloudflare D1** for relational operational data
- **Cloudflare R2** for binary file storage such as dog media and attached documents

## Source of truth

This page is a summary. The detailed database source of truth sits under [`docs/database/`](../database/README.md).

## Core relationship summary

- An organisation owns tenant-scoped operational data.
- A client belongs to one organisation and may link to operational addresses, contacts, documents, dogs, walks, and invoices.
- A dog belongs to one organisation and one client.
- A dog may carry notes, medical records, vaccinations, and behaviour snapshots.
- A walk belongs to one organisation and links a client, dog, and optionally a walker.
- A walk may produce a walk report and may capture route and weather snapshots.
- A walker belongs to one organisation and may hold many compliance records.
- An invoice header belongs to one organisation and one client; invoice lines belong to invoice headers.

## Tenant rule

CiCwtch is multi-tenant. Tenant-owned business tables must include `organisation_id`. The current documented exceptions are global lookup/reference tables such as `breeds` and `vets`. See [multi-tenant-model.md](multi-tenant-model.md) and [`docs/database/schema-notes.md`](../database/schema-notes.md).

## Invoice rule

Invoice numbers are unique per organisation, not globally. The database baseline uses `UNIQUE (organisation_id, invoice_number)`.

## Address and provider fields

Addresses are operational records with validation and geocoding metadata. Provider-oriented fields such as `place_id`, `formatted_address`, payload JSON, and verification timestamps are part of the documented baseline and should be populated in demo data where validation flows are being exercised.

## Attachments and media

Binary files are not stored in D1. D1 stores metadata and object keys; R2 stores the file bodies.

- Dog avatar, nose-print, and walking-gear media are stored in R2.
- `attachments` stores generic file metadata and object keys.
- `client_documents` can link to attachments.

## Do not duplicate table-by-table schema here

Use these instead:

- [ERD](../database/erd.md)
- [Data dictionary](../database/data-dictionary.md)
- [Schema notes and constraints](../database/schema-notes.md)
- [Build and seed strategy](../database/migrations-and-seeding.md)
- [Maintenance SOPs](../database/maintenance.md)

---
<p align="center">
  Built in Wales ❤️ Designed with Cwtch<br/>
  Adeiladwyd yng Nghymru ❤️ Dyluniwyd gyda Cwtch
</p>
