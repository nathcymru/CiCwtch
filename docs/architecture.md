# CiCwtch Architecture Overview

This file is a high-level index.

The detailed architecture documents live in `docs/architecture/` and are written to reflect the **current repository reality first**, with planned target direction called out explicitly.

## Current implementation snapshot

- Flutter app starter with a Clients feature slice
- Cloudflare Worker with Clients CRUD and health endpoints
- D1 schema covering a wider planned domain model than is currently implemented in runtime code
- in-repo privacy documentation and Fides manifests

## Detailed documents

- [docs/architecture/README.md](architecture/README.md)
- [docs/architecture/application.md](architecture/application.md)
- [docs/architecture/data.md](architecture/data.md)
- [docs/architecture/infrastructure.md](architecture/infrastructure.md)
- [docs/architecture/security.md](architecture/security.md)
- [docs/architecture/decisions.md](architecture/decisions.md)
- [docs/architecture/diagrams.md](architecture/diagrams.md)
