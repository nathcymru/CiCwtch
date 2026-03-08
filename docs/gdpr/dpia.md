# DPIA draft

## Why a DPIA is relevant

CiCwtch processes personal data including contact data, home-address-linked operational data, emergency contacts, financial records, and potentially special-category-adjacent free text such as medical notes for pets that may still indirectly identify households.

## Key risk themes

1. **Home and schedule visibility**
   - addresses and scheduling data can expose when households are occupied or unattended.
2. **Free-text operational notes**
   - notes fields can accumulate excessive or sensitive content.
3. **Future mobile app expansion**
   - mobile builds raise tracker, device-permission, and local-storage risks.
4. **Future object storage**
   - attachments in R2 could introduce image/document leakage risks.
5. **Role separation not yet implemented**
   - current repo has no production auth/RBAC enforcement.

## Required mitigations before production use

- implement authentication and RBAC
- implement DSAR/erasure workflows across D1 and R2
- implement retention automation
- constrain and review free-text fields
- document Cloudflare region/jurisdiction choices and subprocessors
- introduce privileged-action audit logging
