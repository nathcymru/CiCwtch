# DSAR / Right-to-Erasure Playbook

## Current status

A complete right-to-erasure flow is **not yet implemented**.

Current blockers:

- no authentication / identity proofing flow
- no subject-centric export endpoint
- no subject-centric delete orchestration
- no R2 deletion logic because R2 integration is not yet implemented
- no backup erasure handling policy in code or operations

## Current data graph to consider

A client request could touch:

- clients
- client_contacts
- dogs
- dog_notes
- walks
- walk_reports
- invoice_headers
- invoice_lines
- attachments (future R2 objects)
- audit_log (where legally permissible)

## Target design

1. verify requester identity
2. locate all rows related to the subject
3. export machine-readable bundle where required
4. apply deletion/anonymisation rules by table
5. delete linked R2 objects when attachments launch
6. record completion in audit trail
7. ensure deleted data is not restored from backup into active processing

## Minimum implementation requirement for next phase

Before public rollout, create Worker-admin capability to:

- export client-linked data graph as JSON
- erase or anonymise client-linked data graph from D1
- queue future R2 object deletion by `attachments.object_key`
