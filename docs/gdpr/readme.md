<img src="../../brand/app_icon_base.svg" alt="CiCwtch Logo" align="left" height="60" />
<!-- HEADER BADGES -->
<p align="right">
<a href="https://github.com/nathcymru/CiCwtch/actions/workflows/ci.yml"><img src="https://img.shields.io/github/actions/workflow/status/nathcymru/CiCwtch/ci.yml?branch=main&style=for-the-badge" alt="Build Status" /></a>
&nbsp;
<a href="https://github.com/nathcymru/CiCwtch/releases"><img src="https://img.shields.io/github/v/tag/nathcymru/CiCwtch?sort=semver&style=for-the-badge&label=Release" alt="Release" /></a>
&nbsp;
  <a href="https://github.com/nathcymru/CiCwtch/commits/main"><img src="https://img.shields.io/github/last-commit/nathcymru/CiCwtch?style=for-the-badge" alt="Last Commit" /></a>
</p clear="right">

# CiCwtch - GDPR & Privacy
## Working privacy-by-design documentation for the current build

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

This folder documents the **current privacy posture** of CiCwtch.

It is not a claim that the product is fully GDPR-complete. It is the place where the current truth, gaps, and next controls are recorded so the project does not drift into confident nonsense.

## Included documents

- [Record of Processing Activities (RoPA)](ropa.md)
- [DPIA working draft](dpia.md)
- [Retention schedule](retention_schedule.md)
- [DSAR and erasure handling notes](dsar_and_erasure.md)
- [CNIL gap audit](cnil_gap_audit.md)
- [Privacy-first checklist](privacy_first_checklist.md)

## Multi-tenant data model

CiCwtch is a multi-tenant platform. Each tenant (dog-walking business) is an independent `organisations` record. All core business tables must include `organisation_id` to enforce data isolation between tenants. This is a platform rule.

The multi-tenant model is relevant to GDPR/privacy documentation because:

- personal data is scoped per organisation — one tenant cannot access another tenant's data,
- retention, erasure, and DSAR obligations must be evaluated per organisation,
- future DPIA and RoPA updates should account for the organisation-level data boundary.

See [`docs/architecture/multi-tenant-model.md`](../architecture/multi-tenant-model.md) for the full schema pattern and query rules.


## v0.3.0 pre-release privacy update

The v0.3.0 pre-release changes extend Flutter presentation and dashboard access paths for clients, dogs, walks, walkers, and invoices. Those screens handle personal and operational data already described in the RoPA and privacy checklist, so this release records the privacy impact explicitly rather than pretending the UI layer is magically exempt.

**Privacy impact noted for this release:**

- Flutter presentation screens expose personal data fields for clients, dogs, walkers, walks, and invoices.
- The dashboard repository requests aggregated operational metrics from the API rather than introducing a separate shadow data source.
- The Worker API now supports minimal bearer-token protection for `/api/v1/*` routes to reduce accidental exposure of personal and operational data in early-stage hosted environments.
- No new external processor or third-country transfer has been introduced by this release.
- No change to the current retention schedule is claimed by this release.

**Required follow-on controls remain:**

- full user authentication and authorisation,
- per-tenant enforcement tied to authenticated identity,
- automated retention and erasure workflows,
- attachment-specific privacy controls once file handling goes live.

## Current status

- personal data is already present in the D1 schema,
- authentication is not yet implemented,
- retention enforcement is not yet automated,
- attachment/R2 workflows are not yet live,
- DSAR operations are documented but not fully automated,
- Phase 1 schema predates the formal multi-tenant rule; `organisation_id` will be added to existing tables in a future migration.

---
<p align="center">
  Built in Wales ❤️ Designed with Cwtch<br/>
  Adeiladwyd yng Nghymru ❤️ Dyluniwyd gyda Cwtch
</p>
