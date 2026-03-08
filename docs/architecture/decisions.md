# Architectural Decisions

## Accepted

### ADR-001 — Flutter is the only UI stack
The application uses Flutter widgets only. No HTML/CSS UI framework wrappers are permitted.

### ADR-002 — Cloudflare Worker + D1 for the first backend slice
The backend begins as a simple Worker with D1 prepared statements and minimal dependencies.

### ADR-003 — Domain models are explicit plain Dart
No model code generation is used. JSON mapping stays visible and reviewable.

### ADR-004 — Documentation guardrails are mandatory
Architecture-sensitive code changes must update docs in the same PR.

### ADR-005 — Privacy inventory lives in the repo
Fides manifests and GDPR documents live close to the code so schema changes can be reviewed together with privacy changes.

## Deferred

### ADR-D01 — Authentication and RBAC
Required by the URS but not yet implemented.

### ADR-D02 — Offline sync and outbox
Planned architecture only; not yet in runtime code.

### ADR-D03 — R2 attachments lifecycle
Schema support exists via `attachments`; runtime attachment flows do not yet exist.

### ADR-D04 — DSAR and retention automation
Documented as compliance requirements; not yet automated in code.
