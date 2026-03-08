# Architecture Decisions

## Accepted and reflected in code

1. Use Flutter as the single app codebase.
2. Use Cloudflare Workers + D1 for the first backend slice.
3. Keep Worker routing framework-free for now.
4. Keep Flutter feature code explicit rather than heavily abstracted.
5. Use soft delete via `archived_at` for most core entities.
6. Keep the repo documentation-guarded so architecture-sensitive changes must update docs.

## Deferred / not yet accepted into implementation

1. Authentication design
2. Authorisation model and tenancy rules
3. R2 object storage patterns
4. Retention job strategy
5. DSAR automation strategy
6. Production audit logging strategy
