# Architecture — Current State

This folder documents the **actual implemented architecture** of CiCwtch after Phase 1.
It intentionally separates **implemented now** from **planned later**, so the docs do not wander off into science-fiction cosplay.

## Implemented today

- Flutter application in `flutter/`
- Cloudflare Workers TypeScript API in `worker/`
- Cloudflare D1 schema in `migrations/0001_initial_schema.sql`
- CRUD flows implemented for:
  - clients
  - dogs
  - walks
  - walkers
  - invoice headers
  - invoice lines
- Dashboard overview screen
- Shared navigation shell
- Basic client-side search/filtering across core lists
- Shared UI consistency helpers

## Not yet implemented

- authentication and authorisation
- persistent sessions
- client portal / role-based access
- booking slot inventory and approvals
- rewards / vouchers / campaigns
- Stripe integration
- PDF export
- Cloudflare R2 file handling in production code
- DSAR automation / erasure workflow in code
- offline queue / sync engine
- full audit logging in application logic

## Read this next

- [Application structure](application.md)
- [Data architecture](data.md)
- [Infrastructure](infrastructure.md)
- [Security and privacy status](security.md)
- [Diagrams](diagrams.md)
- [Architecture decisions](decisions.md)
