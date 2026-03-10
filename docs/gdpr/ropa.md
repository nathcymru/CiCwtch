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
## Phase 1 RoPA draft derived from the implemented schema

<p align="left">
  <a href="https://flutter.dev/"><img src="https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white" alt="Flutter" /></a>
  &nbsp;
  <a href="https://developers.cloudflare.com/workers/"><img src="https://img.shields.io/badge/Cloudflare%20Workers-F38020?style=for-the-badge&logo=cloudflare&logoColor=white" alt="Cloudflare Workers" /></a>
  &nbsp;
  <a href="https://developers.cloudflare.com/d1/"><img src="https://img.shields.io/badge/Cloudflare%20D1-F38020?style=for-the-badge&logo=cloudflare&logoColor=white" alt="Cloudflare D1" /></a>
  &nbsp;
  <a href="https://developers.cloudflare.com/r2/"><img src="https://img.shields.io/badge/Cloudflare%20R2-F38020?style=for-the-badge&logo=cloudflare&logoColor=white" alt="Cloudflare R2" /></a>
</p>

<p align="left">
<a href="https://github.com/nathcymru/CiCwtch/blob/main/docs/gdpr/readme.md"><img src="https://img.shields.io/badge/DPIA-In%20Progress-FFA500?style=for-the-badge" alt="GDPR DPIA: In Progress" /></a>
&nbsp;
<a href="https://github.com/nathcymru/CiCwtch/security"><img src="https://img.shields.io/badge/GitHub%20Security-Open%20Dashboard-181717?style=for-the-badge&logo=github&logoColor=white" alt="GitHub Security" /></a>
&nbsp;
<a href="https://scorecard.dev/viewer/?uri=github.com/nathcymru/CiCwtch"><img src="https://api.scorecard.dev/projects/github.com/nathcymru/CiCwtch/badge?style=for-the-badge" alt="OpenSSF Scorecard" /></a>
</p>

## Controller context

CiCwtch is currently a founder-led software project intended for dog-walking operations management.

## Main processing activities

### Client management
- **Purpose:** maintain client records for service delivery.
- **Data subjects:** clients, emergency contacts.
- **Categories of data:** names, phones, emails, addresses, operational notes.
- **Storage:** D1 `clients`, `addresses`, `client_contacts`.

### Dog management
- **Purpose:** maintain dog care and operational safety information.
- **Data subjects:** clients indirectly; dog records are not personal data themselves, but notes may contain owner-related or veterinary contact information.
- **Storage:** D1 `dogs`, `dog_notes`, `breeds` (lookup).
- **Media references:** The `dogs` table stores nullable R2 object-key pointers (`avatar_object_key`, `profile_photo_object_key`, `nose_print_object_key`). Actual media files will be stored in Cloudflare R2, not in D1. No binary media is stored in the relational database.
- **Note:** The `breeds` table contains only breed names, which are non-personal, non-sensitive reference data. No GDPR risk is introduced by this table.

### Walk scheduling and delivery
- **Purpose:** plan and record services.
- **Data subjects:** clients, walkers.
- **Storage:** D1 `walks`, `walk_reports`.

### Walker management
- **Purpose:** maintain workforce and compliance records.
- **Data subjects:** walkers.
- **Storage:** D1 `walkers`, `walker_compliance_items`.

### Invoicing
- **Purpose:** issue and manage invoices.
- **Data subjects:** clients.
- **Storage:** D1 `invoice_headers`, `invoice_lines`.

### Attachment handling
- **Purpose:** store and retrieve operational files (e.g. photos, documents) linked to business entities such as dogs, clients, or walks.
- **Data subjects:** clients, walkers, dogs (indirectly — attachments may contain user-related or pet-related records).
- **Categories of data:** original filenames, MIME types, file content.
- **Storage:** D1 `attachments` (metadata), R2 `CICWTCH_ATTACHMENTS` (file objects).
- **Processing flow:** upload stores metadata in D1 and object in R2; retrieval resolves attachment ID → D1 metadata → R2 object and returns file content.
- **Access:** currently unauthenticated; authentication must be added before production use.

### Dashboard aggregation
- **Purpose:** provide summary-level operational counts for the dashboard screen.
- **Data subjects:** none directly — the endpoint returns only aggregate counts, not individual records.
- **Categories of data:** numeric totals derived from clients, dogs, walks, walkers, and invoice_headers tables.
- **Storage:** no additional storage; reads existing D1 tables.
- **Processing flow:** `GET /api/v1/dashboard` executes `COUNT(*)` queries against existing tables, excluding archived records, and returns a JSON object of totals.
- **Access:** currently unauthenticated; authentication must be added before production use.
- **Retention:** no data is stored by this endpoint; it is read-only.

## International transfer and hosting note

The project uses Cloudflare services. Deployment geography, transfer tooling, and any future R2 object storage usage must be reviewed before production processing of live customer data.

---
<p align="center">
  Built in Wales ❤️ Designed with Cwtch<br/>
  Adeiladwyd yng Nghymru ❤️ Dyluniwyd gyda Cwtch
</p>
