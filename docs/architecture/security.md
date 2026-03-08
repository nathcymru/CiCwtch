# Security and Privacy Status

## Current security posture

Implemented now:

- parameterised SQL in Worker handlers
- typed JSON error responses
- soft delete for most core entities
- CI guardrails for docs and basic code health

Not yet implemented:

- authentication
- authorisation / RBAC
- session management
- secure password storage
- token rotation
- request correlation IDs
- R2 signed URL strategy
- DSAR export/erasure logic
- retention enforcement
- webhook idempotency

## Practical interpretation

The repo is at a **Phase 1 internal CRUD prototype** stage, not a production-ready privacy or security posture.

Any documentation claiming completed auth, RBAC, session handling, right-to-erasure automation, or live R2 access would currently be ahead of the code and therefore a fib in a nice jacket.
