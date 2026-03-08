# Audit & Integration Report — 2026-03-08

## Executive summary

The repository is in a credible **Phase 1 CRUD** state. The Worker typecheck passes, the schema is coherent, and the Flutter app implements a substantial set of CRUD flows. However, the codebase is **not yet production-ready** for privacy, security, or full URS compliance.

The main documentation issue before this patch was drift: several architecture/privacy statements described future-state capabilities as though they already existed.

## What the audit confirmed

### Implemented and broadly coherent
- Worker routing and CRUD handlers for clients, dogs, walks, walkers, invoice headers, and invoice lines
- D1 schema is explicit and relationally coherent
- Flutter app includes CRUD screens, dashboard, shell, and shared UI helpers
- Docs guardrail workflow is operating

### Key gaps / discrepancies
1. **Authentication and RBAC are not implemented** despite being present in the URS vision.
2. **Cupertino/iOS-adaptive theming is not implemented**; the app currently uses a `MaterialApp` shell only.
3. **R2 is not implemented in production code** despite being mentioned in high-level docs.
4. **DSAR export/erasure is not implemented**.
5. **Retention is documented here as policy draft only, not enforced in code**.
6. **API docs were incomplete** and did not fully reflect the actual implemented routes.
7. **Primary invoices navigation is still weaker than the other core entities**; the shell focuses on Dashboard, Clients, Dogs, Walks, and Walkers.

## Specific code observations

### Good
- Worker handlers use prepared/bound statements.
- Foreign key validation is performed in several CRUD handlers.
- Error response shape is consistent.

### Caution / follow-up
- Worker handlers currently have no auth guards, rate limiting, or audit-log writes.
- Invoice semantics in product language (“invoices”) are implemented as `invoice_headers` plus `invoice_lines`; docs must keep that explicit.
- Some architecture docs previously implied `/ready`, auth, sessions, and R2 flows that are not present.

## URS reconciliation

The current repo matches only the **early operational CRUD/dashboard slice** of the URS. It does **not** yet match the URS for:

- secure login/logout and persistent sessions
- password reset
- role-based access
- booking slot inventory and approval workflows
- GPS route tracking
- client self-service portal
- rewards / vouchers / campaigns
- payments and PDF export
- notifications
- offline write queue

That is not a failure of the code; it is a reminder that the URS is broader than the completed Phase 1 task set.

## Files added / updated by this patch

- `docs/api/README.md`
- `docs/api/health.md`
- `docs/api/clients.md`
- `docs/api/dogs.md`
- `docs/api/walks.md`
- `docs/api/walkers.md`
- `docs/api/invoice_headers.md`
- `docs/api/invoice_lines.md`
- `docs/architecture/README.md`
- `docs/architecture/application.md`
- `docs/architecture/data.md`
- `docs/architecture/infrastructure.md`
- `docs/architecture/security.md`
- `docs/architecture/diagrams.md`
- `docs/architecture/decisions.md`
- `docs/gdpr/readme.md`
- `docs/gdpr/ropa.md`
- `docs/gdpr/dpia.md`
- `docs/gdpr/data-retention-schedule.md`
- `docs/gdpr/dsar-erasure-playbook.md`
- `docs/gdpr/cnil-gap-audit.md`
- `docs/gdpr/privacy-first-checklist.md`
- `.fides/README.md`
- `.fides/fides.toml`
- `.fides/systems.yml`
- `.fides/dataset.yml`
- `.github/workflows/privacy_compliance.yml`

## Recommended next engineering tasks

1. Implement authentication and RBAC.
2. Add DSAR export + erasure orchestration for D1.
3. Design R2 attachment model with signed access.
4. Add retention enforcement jobs.
5. Add Worker tests.
6. Decide whether invoices should be first-class in the shell navigation.
