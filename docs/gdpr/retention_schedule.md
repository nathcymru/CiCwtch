<img src="../../brand/app_icon_base.svg" alt="CiCwtch Logo" align="left" height="60" />
<!-- HEADER BADGES -->
<p align="right">
<a href="https://github.com/nathcymru/CiCwtch/actions/workflows/ci.yml"><img src="https://img.shields.io/github/actions/workflow/status/nathcymru/CiCwtch/ci.yml?branch=main&style=for-the-badge" alt="Build Status" /></a>
&nbsp;
<a href="https://github.com/nathcymru/CiCwtch/releases"><img src="https://img.shields.io/github/v/tag/nathcymru/CiCwtch?sort=semver&style=for-the-badge&label=Release" alt="Release" /></a>
&nbsp;
  <a href="https://github.com/nathcymru/CiCwtch/commits/main"><img src="https://img.shields.io/github/last-commit/nathcymru/CiCwtch?style=for-the-badge" alt="Last Commit" /></a>
</p clear="right">

# CiCwtch - Retention Schedule
## Current retention-oriented view of CiCwtch operational data

<p align="left">
  <a href="https://developers.cloudflare.com/d1/"><img src="https://img.shields.io/badge/Cloudflare%20D1-F38020?style=for-the-badge&logo=cloudflare&logoColor=white" alt="Cloudflare D1" /></a>
  &nbsp;
  <a href="https://docs.ethyca.com/"><img src="https://img.shields.io/badge/Fides-6E56CF?style=for-the-badge" alt="Fides" /></a>
  &nbsp;
  <a href="https://ico.org.uk/"><img src="https://img.shields.io/badge/UK%20GDPR-0A7CFF?style=for-the-badge" alt="UK GDPR" /></a>
</p>
| Data area | Store | Default handling note |
|---|---|---|
| Clients | D1 `clients` | Soft delete preferred; retain while service relationship remains active and for justified post-service needs. |
| Dogs | D1 `dogs` | Soft delete preferred; review notes and medical records carefully before deletion. |
| Walks | D1 `walks` | Retain for service history, disputes, and operational follow-up. |
| Walkers | D1 `walkers` | Retain in line with contractual and compliance needs. |
| Walker compliance | D1 `walker_compliance_records` | Retain in line with legal and insurance needs. |
| Invoices | D1 `invoice_headers`, `invoice_lines` | Retain according to financial record obligations. |
| Attachments | D1 `attachments` + R2 | Align attachment retention with the owning record and legal need. |
| Device registrations | D1 `device_registrations` | Remove revoked or stale registrations when no longer needed. |
| Calendar sync links | D1 `calendar_sync_links` | Remove credentials and links promptly when revoked. |

Use [`docs/database/schema-notes.md`](../database/schema-notes.md) for current table names and relational notes.

---
<p align="center">
  Built in Wales ❤️ Designed with Cwtch<br/>
  Adeiladwyd yng Nghymru ❤️ Dyluniwyd gyda Cwtch
</p>
