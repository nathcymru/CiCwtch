<img src="../../brand/app_icon_base.svg" alt="CiCwtch Logo" align="left" height="60" />
<!-- HEADER BADGES -->
<p align="right">
<a href="https://github.com/nathcymru/CiCwtch/actions/workflows/ci.yml"><img src="https://img.shields.io/github/actions/workflow/status/nathcymru/CiCwtch/ci.yml?branch=main&style=for-the-badge" alt="Build Status" /></a>
&nbsp;
<a href="https://github.com/nathcymru/CiCwtch/releases"><img src="https://img.shields.io/github/v/tag/nathcymru/CiCwtch?sort=semver&style=for-the-badge&label=Release" alt="Release" /></a>
&nbsp;
  <a href="https://github.com/nathcymru/CiCwtch/commits/main"><img src="https://img.shields.io/github/last-commit/nathcymru/CiCwtch?style=for-the-badge" alt="Last Commit" /></a>
</p clear="right">

# CiCwtch - Record of Processing Activities
## Operational processing summary for the documented current baseline

<p align="left">
  <a href="https://developers.cloudflare.com/d1/"><img src="https://img.shields.io/badge/Cloudflare%20D1-F38020?style=for-the-badge&logo=cloudflare&logoColor=white" alt="Cloudflare D1" /></a>
  &nbsp;
  <a href="https://docs.ethyca.com/"><img src="https://img.shields.io/badge/Fides-6E56CF?style=for-the-badge" alt="Fides" /></a>
  &nbsp;
  <a href="https://ico.org.uk/"><img src="https://img.shields.io/badge/UK%20GDPR-0A7CFF?style=for-the-badge" alt="UK GDPR" /></a>
</p>
## Core processing areas

### Clients and households

- **Data subjects:** clients, household contacts, emergency contacts.
- **Storage:** D1 `clients`, `addresses`, `client_contacts`, `client_documents`.
- **Notes:** key-safe and access details require careful access control because they are operationally sensitive.

### Dogs and care records

- **Data subjects:** clients indirectly; dog records may contain owner-related operational information.
- **Storage:** D1 `dogs`, `dog_notes`, `dog_medical_records`, `vaccinations`, `behavior_snapshots`, `breeds`, `vets`.
- **Media:** dog avatar, nose-print, and walking-gear files are stored in R2; D1 stores only object keys or attachment metadata.

### Walk delivery

- **Data subjects:** clients, walkers.
- **Storage:** D1 `walks`, `walk_reports`, `weather_snapshots`, `route_snapshots`.

### Workforce compliance

- **Data subjects:** walkers.
- **Storage:** D1 `walkers`, `walker_compliance_records`, `compliance_templates`.

### Billing and finance

- **Data subjects:** clients.
- **Storage:** D1 `invoice_headers`, `invoice_lines`, `invoice_sequences`, `invoice_branding_profiles`, `invoice_line_item_templates`, `invoice_line_items_catalog`, `tax_rates`.

### Attachments and documents

- **Purpose:** store and retrieve operational files linked to business entities.
- **Storage:** D1 `attachments` plus Cloudflare R2 object storage.

### Trust Centre case management

- **Data subjects:** public users, clients, official authorities (police, regulators, legal representatives).
- **Storage:** D1 `trust_reports`, `trust_report_events`, `trust_report_sequence`; R2 for official documents uploaded via police/regulatory routes.
- **Notes:**
  - Only official routes (police/emergency and regulator/legal) allow document uploads; files are stored in R2 under the `trust-reports/` prefix.
  - Public and client routes store only descriptive text and supporting links — no file uploads.
  - Each report is assigned a unique human-readable public reference number (format: `TCR-YYYY-NNNNN`).
  - Attachment metadata (filename, content type, R2 key) is stored in D1; file content lives in R2 only.

### Contact Us enquiries

- **Data subjects:** general public, prospective clients.
- **Storage:** D1 `trust_reports` (role_type = `contact`).
- **Notes:** Contact form submissions are stored as trust report records for traceability and response tracking.



- **Data subjects:** system operators (owners, admins, dispatchers, walkers, read-only users).
- **Storage:** D1 `users` (hashed credentials, role, tenant scope, activity flags) and `user_sessions` (session tokens with expiry).
- **Notes:**
  - Passwords are stored as PBKDF2-SHA256 hashes only — no plaintext credentials are stored or logged.
  - Session tokens are random UUIDs stored in D1 with a 30-day expiry and deleted on logout.
  - Each user record carries `organisation_id` for tenant-level data segregation.
  - `last_login_at` is updated on successful authentication.
  - Inactive (`is_active = 0`) and archived (`archived_at IS NOT NULL`) users cannot authenticate.

## Rule

Where a GDPR page needs table-level accuracy, link to the database docs rather than duplicating field-by-field schema.

---
<p align="center">
  Built in Wales ❤️ Designed with Cwtch<br/>
  Adeiladwyd yng Nghymru ❤️ Dyluniwyd gyda Cwtch
</p>
