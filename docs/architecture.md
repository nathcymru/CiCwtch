# CiCwtch Architecture Overview

This file is a **high-level index only**.

The authoritative architecture documentation for CiCwtch is maintained in:

- [docs/architecture/README.md](architecture/README.md)
- [docs/architecture/application.md](architecture/application.md)
- [docs/architecture/data.md](architecture/data.md)
- [docs/architecture/infrastructure.md](architecture/infrastructure.md)
- [docs/architecture/security.md](architecture/security.md)
- [docs/architecture/decisions.md](architecture/decisions.md)
- [docs/architecture/diagrams.md](architecture/diagrams.md)

## Platform direction

CiCwtch is being built as a **Flutter application for Web, iOS, and Android**, with a backend platform centred on:

- **Cloudflare Workers** for server-side runtime and APIs
- **Cloudflare D1** for relational data storage
- **Cloudflare R2** for object and media storage
- **SQLite** for lightweight local persistence and offline-first behaviour inside the app where required

## Documentation rule

If this overview and the detailed architecture documents ever disagree, treat the files under `docs/architecture/` as the source of truth and update this page immediately.
