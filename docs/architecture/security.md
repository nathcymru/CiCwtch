# Security and Privacy Architecture

## Current controls in code

Implemented today:
- JSON-only API responses
- typed API error handling
- prepared SQL statements in the Worker
- soft deletion for clients via `archived_at`
- CI checks for Flutter analysis/tests and Worker typecheck
- privacy documentation + Fides manifest scaffolding in-repo

## Current gaps

Not yet fully implemented in code:
- end-user authentication
- role-based authorization enforcement
- secure session lifecycle
- DSAR automation
- hard deletion / erasure workflows across all stores
- automated retention enforcement
- R2 object access controls and signed URL lifecycle
- attachment malware/content scanning
- audit logging of privileged actions

## CNIL / GDPR direction for this repo

This project should continue to follow privacy-by-design principles:
- data minimisation
- purpose limitation
- explicit retention rules
- rights handling for access, export, rectification, and erasure
- no analytics/tracking SDKs without a documented legal basis and consent flow where required

Refer to `docs/gdpr/` for the operational privacy pack.
