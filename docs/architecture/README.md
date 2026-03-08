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
## Phase 1 source of truth for the implemented system

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

CiCwtch is currently a cross-platform Flutter application backed by a Cloudflare Workers API and a Cloudflare D1 database.

Phase 1 implements working operational CRUD for:

- Clients
- Dogs
- Walks
- Walkers
- Invoice headers
- Invoice lines (backend only)

The Flutter application currently surfaces dashboard and CRUD flows for:

- Clients
- Dogs
- Walks
- Walkers
- Invoices

## What is implemented today

### Frontend

- Flutter app with Material 3 theme
- shared navigation shell
- dashboard overview
- list/detail/create/edit/archive flows for core resources
- lightweight client-side search and filtering
- shared error, empty-state, section-heading, and status badge widgets

### Backend

- Cloudflare Worker entrypoint with explicit router
- JSON-only REST endpoints under `/api/v1/`
- D1 prepared statements for all write/read operations
- soft deletion using `archived_at` where the schema supports it
- health endpoints at `/health` and `/api/v1/health`
- backward-compatible invoice header routes plus `/api/v1/invoices` alias paths

### Data layer

The current database schema lives in [`migrations/0001_initial_schema.sql`](../../migrations/0001_initial_schema.sql) and defines:

- addresses
- clients
- client_contacts
- dogs
- dog_notes
- walkers
- walker_compliance_items
- walks
- walk_reports
- invoice_headers
- invoice_lines
- attachments
- audit_log

## Not implemented yet

The following remain planned rather than live:

- authentication and role-based access control
- production retention automation
- DSAR automation across all stores
- attachment upload/download flows backed by R2
- offline sync and local SQLite persistence
- payment processing
- customer portal flows

## Working rule

This document should describe the code that exists, not the code everyone wishes existed after a strong cup of tea.

---
<p align="center">
  Built in Wales ❤️ Designed with Cwtch<br/>
  Adeiladwyd yng Nghymru ❤️ Dyluniwyd gyda Cwtch
</p>
