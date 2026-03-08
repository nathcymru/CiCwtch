# Data Retention Schedule (Proposed)

This is a policy draft aligned to the current schema. It is **not yet enforced in code**.

| Data area | Proposed operational retention | Notes |
|---|---|---|
| active clients | duration of service relationship | review yearly |
| archived clients | 6 years after final invoice or legal obligation end | verify with accounting/legal advice |
| dogs | duration of service relationship | review yearly |
| archived dogs | 3 years after final service unless incident/legal hold applies | |
| walkers | duration of engagement + 6 years for core admin records | local employment/contract rules may extend this |
| walks | 6 years where linked to billing; otherwise 3 years operational minimum | harmonise with invoice retention |
| invoice headers / lines | 6 years minimum | accounting/tax retention needs legal confirmation by jurisdiction |
| free-text operational notes | shortest practical period; review annually | should not become a junk drawer for excessive personal data |
| attachments | type-specific; define before R2 launch | invoices longer, photos shorter |
| audit logs | 12–24 months minimum unless incident/legal hold | refine when auth and actor tracking exist |

## Engineering implication

Retention requires more than documentation. It needs:

- scheduled review/deletion jobs
- legal-hold override capability
- backup handling rules
- DSAR-aware deletion flow
