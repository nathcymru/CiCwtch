# Privacy-first checklist for future features

For every new feature PR, check:

1. Does it add or change personal data fields?
2. Does it introduce a new processor, SDK, or storage location?
3. Does it require a retention rule change?
4. Does it affect access, export, rectification, or erasure handling?
5. Does it need RBAC?
6. Does it expose location, media, health-adjacent notes, or finance data?
7. Has `.fides/` been updated?
8. Has `docs/gdpr/` been updated?
9. Has at least one architecture doc been updated if the system design changed?
