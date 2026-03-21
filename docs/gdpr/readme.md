<img src="../../brand/app_icon_base.svg" alt="CiCwtch Logo" align="left" height="60" />
<!-- HEADER BADGES -->
<p align="right">
<a href="https://github.com/nathcymru/CiCwtch/actions/workflows/ci.yml"><img src="https://img.shields.io/github/actions/workflow/status/nathcymru/CiCwtch/ci.yml?branch=main&style=for-the-badge" alt="Build Status" /></a>
&nbsp;
<a href="https://github.com/nathcymru/CiCwtch/releases"><img src="https://img.shields.io/github/v/tag/nathcymru/CiCwtch?sort=semver&style=for-the-badge&label=Release" alt="Release" /></a>
&nbsp;
  <a href="https://github.com/nathcymru/CiCwtch/commits/main"><img src="https://img.shields.io/github/last-commit/nathcymru/CiCwtch?style=for-the-badge" alt="Last Commit" /></a>
</p clear="right">

# CiCwtch - Privacy and GDPR Pack
## Privacy documentation index for current CiCwtch data handling

<p align="left">
  <a href="https://developers.cloudflare.com/d1/"><img src="https://img.shields.io/badge/Cloudflare%20D1-F38020?style=for-the-badge&logo=cloudflare&logoColor=white" alt="Cloudflare D1" /></a>
  &nbsp;
  <a href="https://docs.ethyca.com/"><img src="https://img.shields.io/badge/Fides-6E56CF?style=for-the-badge" alt="Fides" /></a>
  &nbsp;
  <a href="https://ico.org.uk/"><img src="https://img.shields.io/badge/UK%20GDPR-0A7CFF?style=for-the-badge" alt="UK GDPR" /></a>
</p>
This folder contains the repository privacy working pack.

## Current data-platform position

- CiCwtch is a multi-tenant platform. Each tenant is an `organisations` record.
- Tenant-owned operational tables carry `organisation_id`.
- Global reference datasets are limited to `breeds` and `vets`.
- Binary files are stored in Cloudflare R2; D1 stores metadata and object keys.

## Database cross-reference

For detailed database structure, use [`docs/database/`](../database/README.md). GDPR pages should describe privacy implications, not duplicate the full relational schema.

## Contents

- [RoPA](ropa.md)
- [DPIA](dpia.md)
- [Retention schedule](retention_schedule.md)
- [DSAR and erasure guidance](dsar_and_erasure.md)
- [Privacy-first checklist](privacy_first_checklist.md)
- [CNIL gap audit](cnil_gap_audit.md)

---
<p align="center">
  Built in Wales ❤️ Designed with Cwtch<br/>
  Adeiladwyd yng Nghymru ❤️ Dyluniwyd gyda Cwtch
</p>
