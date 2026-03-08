# Privacy-First Checklist for Every New Feature

Use this checklist in every Copilot task, PR, and architecture-sensitive change.

## Data mapping
- What personal data is added, changed, or newly inferred?
- Does the schema need new Fides annotations?
- Does the RoPA need updating?

## Purpose and minimisation
- Is each field necessary?
- Can any free-text field be replaced with a bounded option?
- Is any sensitive field being added without a compelling reason?

## Security
- Does the feature require authentication?
- Does it require role-based access checks?
- Are object/file accesses private and time-limited?
- Are writes parameterised and validated?

## Rights handling
- Can the new data be exported for access/portability?
- Can it be erased or anonymised?
- Are linked processors/stores covered, including future R2 objects?

## Retention
- What is the retention period?
- What job or workflow will enforce it?
- What happens in backups?

## Documentation
- Update API docs
- Update architecture docs if the design changed
- Update GDPR docs if personal data scope changed
- Update `.fides/` manifests when fields or tables change
