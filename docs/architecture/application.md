# Application Architecture

## Current Flutter structure

```text
flutter/lib/
  app/
    routing/
  features/
    auth/      (placeholder only)
    clients/   (implemented)
  shared/
    data/
    domain/models/
```

### Observed implementation notes

- Routing is handled centrally in `app_router.dart`.
- The app currently uses a simple service/repository arrangement rather than a full clean-architecture use-case stack.
- The `auth` feature directories exist only as placeholders.
- The home screen is still a starter-style launch point rather than a full application shell.

## Current Worker structure

```text
worker/src/
  index.ts
  router.ts
  response.ts
  errors.ts
  handlers/
    clients.ts
```

### Observed implementation notes

- The Worker is intentionally lightweight.
- Only the Clients resource is implemented.
- JSON responses are returned directly, without a `data` wrapper.
- Known-route unsupported methods now return `405 Method Not Allowed`.

## URS alignment summary

The URS target architecture is broader than the current implementation.
At present the repository is best described as:

- a real project scaffold
- a complete domain-model layer for the initial schema
- an implemented Clients vertical slice
- a partial foundation for future feature expansion

It is **not yet** a full clean-architecture, offline-first, multi-role production application.
