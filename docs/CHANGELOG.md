<img src="../brand/app_icon_base.svg" alt="CiCwtch Logo" align="left" height="60" />
<!-- HEADER BADGES -->
<p align="right">
<a href="https://github.com/nathcymru/CiCwtch/actions/workflows/ci.yml"><img src="https://img.shields.io/github/actions/workflow/status/nathcymru/CiCwtch/ci.yml?branch=main&style=for-the-badge" alt="Build Status" /></a>
&nbsp;
<a href="https://github.com/nathcymru/CiCwtch/releases"><img src="https://img.shields.io/github/v/tag/nathcymru/CiCwtch?sort=semver&style=for-the-badge&label=Release" alt="Release" /></a>
&nbsp;
  <a href="https://github.com/nathcymru/CiCwtch/commits/main"><img src="https://img.shields.io/github/last-commit/nathcymru/CiCwtch?style=for-the-badge" alt="Last Commit" /></a>
</p clear="right">

# CiCwtch - Changelog
## Project release notes and repository-level change history

<p align="left">
  <a href="https://flutter.dev/"><img src="https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white" alt="Flutter" /></a>
  &nbsp;
  <a href="https://developers.cloudflare.com/workers/"><img src="https://img.shields.io/badge/Cloudflare%20Workers-F38020?style=for-the-badge&logo=cloudflare&logoColor=white" alt="Cloudflare Workers" /></a>
  &nbsp;
  <a href="https://developers.cloudflare.com/d1/"><img src="https://img.shields.io/badge/Cloudflare%20D1-F38020?style=for-the-badge&logo=cloudflare&logoColor=white" alt="Cloudflare D1" /></a>
  &nbsp;
  <a href="https://developers.cloudflare.com/r2/"><img src="https://img.shields.io/badge/Cloudflare%20R2-F38020?style=for-the-badge&logo=cloudflare&logoColor=white" alt="Cloudflare R2" /></a>
</p>

All notable changes to CiCwtch should be documented here.

The format is intentionally simple and practical rather than ceremonial.

## [0.2.0] - 2026-03-08

### Added
- Full Phase 1 CRUD coverage across Clients, Dogs, Walks, Walkers, and invoice headers.
- Dashboard overview screen with core operational summary cards.
- Shared navigation shell for the Flutter application.
- Client-side search and filtering across core list screens.
- Shared UX polish components for forms, detail views, and list states.
- Initial GDPR working pack under `docs/gdpr/`.
- Initial `.fides/` dataset and system manifests.
- Privacy compliance workflow scaffold for pull requests.

### Changed
- Invoice frontend now uses `/api/v1/invoices` as the primary user-facing API path while the Worker keeps backward-compatible `/api/v1/invoice-headers` support.
- Dashboard and app shell now expose invoice navigation and invoice counts.
- Dog form sex values were corrected to match backend validation (`male`, `female`, `unknown`).
- Documentation was rewritten to reflect the codebase as it actually exists at Phase 1 completion.

### Fixed
- Removed duplicate and stale documentation fragments in multiple README and architecture files.
- Corrected invoice API naming drift between user-facing docs and internal handler naming.
- Restored workflow coverage in the repository package.

## [0.1.1] - 2026-03-06
- Initial repository alignment pass.

## [0.1.0] - 2026-03-05
- Initial project structure, CI workflow, and core repository scaffolding.

---
<p align="center">
  Built in Wales ❤️ Designed with Cwtch<br/>
  Adeiladwyd yng Nghymru ❤️ Dyluniwyd gyda Cwtch
</p>
