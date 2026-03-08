# CNIL Gap Audit — Repo and Architecture Review

This file translates CNIL-style developer/privacy expectations into the current repo reality.

## Current pass / partial-pass items

- parameterised SQL in Worker handlers
- documentation guardrails in CI
- explicit schema and model mapping
- clear distinction between implemented and future privacy work in this updated docs pack

## Current fail / gap items

### Authentication and session governance
Not implemented yet.

Implication:
- no password policy
- no hashing strategy in code
- no MFA option
- no session timeout rules
- no token revocation

### Data subject rights execution
Not implemented yet.

Implication:
- no production-ready export or erasure flow
- no processor notification flow
- no backup suppression strategy

### Retention governance
Not implemented yet.

Implication:
- soft delete exists, but retention enforcement does not

### Consent / trackers
No tracker/cookie consent layer is currently implemented in app code.

Implication:
- this is acceptable for the current state only because there is no consent-requiring analytics/tracking implementation in the repo today
- if analytics SDKs or marketing trackers are added later, consent governance must land at the same time

### Mobile privacy posture
The Flutter app currently uses a Material app shell only. The repo does not yet demonstrate the full iOS-adaptive and mobile-privacy posture described in the long-term vision.

## Required next privacy milestones

1. auth + RBAC design
2. DSAR export/erasure implementation
3. retention job design
4. R2 attachment controls
5. privacy notice + lawful basis register
6. production logging policy
