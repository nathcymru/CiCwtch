# DPIA Draft — CiCwtch Phase 1 / Next-Step Architecture

## Why a DPIA is relevant

The platform is intended to process household contact data, scheduling data, staff data, potentially sensitive free-text notes, and later attachments/photos. That combination gives this project enough privacy teeth to justify structured DPIA work before production.

## Current architecture assessed

- Flutter client application
- Cloudflare Worker API
- Cloudflare D1 relational data store
- planned future R2 object storage for attachments

## Primary risks identified

1. **No authentication or RBAC yet implemented**
   - Current app/API are not ready for live personal-data exposure.
2. **Free-text note fields may collect excess or sensitive data**
   - medical, behavioural, and access notes can expand unpredictably.
3. **No DSAR erasure/export automation**
   - rights handling cannot yet be executed reliably end-to-end.
4. **No retention enforcement mechanism**
   - soft delete is not the same thing as compliant retention management.
5. **Future attachment handling will amplify risk**
   - pet photos, invoices, and incident media need strict access control and expiry.
6. **Cloud / edge deployment clarity is incomplete**
   - region, residency, and transfer controls need documenting before production.

## Required controls before production

- authenticated API access
- role-based authorisation
- minimum-necessary logging with no sensitive payload dumping
- DSAR export path
- DSAR erasure path for D1 and future R2
- retention schedule with operational deletion jobs
- secure attachment design using private buckets and time-limited access
- documented legal basis and privacy notice
- audit trail for privileged actions
