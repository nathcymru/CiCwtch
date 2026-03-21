<img src="../../brand/app_icon_base.svg" alt="CiCwtch Logo" align="left" height="60" />
<!-- HEADER BADGES -->
<p align="right">
<a href="https://github.com/nathcymru/CiCwtch/actions/workflows/ci.yml"><img src="https://img.shields.io/github/actions/workflow/status/nathcymru/CiCwtch/ci.yml?branch=main&style=for-the-badge" alt="Build Status" /></a>
&nbsp;
<a href="https://github.com/nathcymru/CiCwtch/releases"><img src="https://img.shields.io/github/v/tag/nathcymru/CiCwtch?sort=semver&style=for-the-badge&label=Release" alt="Release" /></a>
&nbsp;
  <a href="https://github.com/nathcymru/CiCwtch/commits/main"><img src="https://img.shields.io/github/last-commit/nathcymru/CiCwtch?style=for-the-badge" alt="Last Commit" /></a>
</p clear="right">

# CiCwtch - Architecture
## Current repository architecture and how it links to the database baseline

<p align="left">
  <a href="https://flutter.dev/"><img src="https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white" alt="Flutter" /></a>
  &nbsp;
  <a href="https://developers.cloudflare.com/workers/"><img src="https://img.shields.io/badge/Cloudflare%20Workers-F38020?style=for-the-badge&logo=cloudflare&logoColor=white" alt="Cloudflare Workers" /></a>
  &nbsp;
  <a href="https://developers.cloudflare.com/d1/"><img src="https://img.shields.io/badge/Cloudflare%20D1-F38020?style=for-the-badge&logo=cloudflare&logoColor=white" alt="Cloudflare D1" /></a>
  &nbsp;
  <a href="https://developers.cloudflare.com/r2/"><img src="https://img.shields.io/badge/Cloudflare%20R2-F38020?style=for-the-badge&logo=cloudflare&logoColor=white" alt="Cloudflare R2" /></a>
</p>
## Current implemented scope

CiCwtch is a cross-platform Flutter application backed by a Cloudflare Workers API, a Cloudflare D1 relational database, and Cloudflare R2 for object storage.

The current documented operational baseline includes working application support for:

- clients
- dogs
- walks
- walkers
- invoices
- dashboard summaries
- dog media stored in R2 with D1 metadata pointers

## Database documentation rule

This folder explains how the application is shaped. It does **not** duplicate the database source of truth. For current tables, relationships, constraints, seed strategy, and operating rules, use [`docs/database/`](../database/README.md).

## Database baseline summary

The current documented D1 baseline includes tenant-owned operational tables such as:

- `organisations`
- `addresses`
- `clients`
- `client_contacts`
- `client_documents`
- `dogs`
- `dog_notes`
- `dog_medical_records`
- `vaccinations`
- `behavior_snapshots`
- `walkers`
- `walker_compliance_records`
- `compliance_templates`
- `walks`
- `walk_reports`
- `invoice_headers`
- `invoice_lines`
- `invoice_sequences`
- `invoice_branding_profiles`
- `invoice_line_item_templates`
- `invoice_line_items_catalog`
- `attachments`
- `weather_snapshots`
- `route_snapshots`
- `device_registrations`
- `calendar_sync_links`

Global/reference datasets include:

- `breeds`
- `vets`
- `tax_rates`
- `service_templates`

## Read this section-by-section

- [Application architecture](application.md)
- [Data architecture](data.md)
- [Infrastructure architecture](infrastructure.md)
- [Security architecture](security.md)
- [Architecture decisions](decisions.md)
- [Architecture diagrams](diagrams.md)
- [Multi-tenant data model](multi-tenant-model.md)

## Working rule

This document should describe the code and database that exist now, not an aspirational future version.

---
<p align="center">
  Built in Wales ❤️ Designed with Cwtch<br/>
  Adeiladwyd yng Nghymru ❤️ Dyluniwyd gyda Cwtch
</p>
