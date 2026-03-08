# CiCwtch

CiCwtch is a Flutter + Cloudflare project for dog-walking and pet-care operations.

## Current repository status

This repository currently contains:
- a Flutter starter application with a **Clients** feature slice
- a Cloudflare Worker with **Clients CRUD** and health endpoints
- a wider D1 schema representing the intended domain model
- architecture, GDPR, and Fides documentation kept in-repo

The full URS describes a larger target product than is presently implemented in code.

## Key locations

- `flutter/` — Flutter app
- `worker/` — Cloudflare Worker API
- `migrations/` — D1 schema
- `docs/architecture/` — current architecture docs
- `docs/gdpr/` — privacy pack
- `.fides/` — Fides manifests

## Current release framing

`v0.2.0` is appropriate as a **foundation milestone** if you describe it honestly:
- real project scaffold in place
- current Clients vertical slice working
- privacy/documentation scaffolding added
- broader URS features still to be implemented
