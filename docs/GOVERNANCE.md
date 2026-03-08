<img src="../brand/app_icon_base.svg" alt="CiCwtch Logo" align="left" height="60" />
<!-- HEADER BADGES -->
<p align="right">
<a href="https://github.com/nathcymru/CiCwtch/actions/workflows/ci.yml"><img src="https://img.shields.io/github/actions/workflow/status/nathcymru/CiCwtch/ci.yml?branch=main&style=for-the-badge" alt="Build Status" /></a>
&nbsp;
<a href="https://github.com/nathcymru/CiCwtch/releases"><img src="https://img.shields.io/github/v/tag/nathcymru/CiCwtch?sort=semver&style=for-the-badge&label=Release" alt="Release" /></a>
&nbsp;
  <a href="https://github.com/nathcymru/CiCwtch/commits/main"><img src="https://img.shields.io/github/last-commit/nathcymru/CiCwtch?style=for-the-badge" alt="Last Commit" /></a>
</p clear="right">

# CiCwtch - Governance
## Repository governance, documentation rules, and delivery discipline

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
  <a href="https://github.com/nathcymru/CiCwtch/blob/main/LICENSE"><img src="https://img.shields.io/badge/license-Proprietary%20%E2%80%94%20All%20Rights%20Reserved-lightgrey?style=for-the-badge" alt="License" /></a>
</p>

## Maintainer model

CiCwtch is currently founder-led. Architectural, delivery, and release decisions are made by the maintainer.

## Working rules

- One task per pull request where practical.
- Architecture-sensitive changes must update documentation in the same PR.
- Privacy-sensitive changes must update `docs/gdpr/` and `.fides/` where relevant.
- Do not merge code that claims tests were run when they were not actually executed.
- Do not silently introduce new frameworks, major state-management patterns, or storage systems.

## Release discipline

- `main` is the protected integration branch.
- Milestone tags should describe the current implemented state honestly.
- Documentation must reflect current reality, not planned mythology.

## Privacy-first rule

Any feature that changes personal data collection, storage, export, retention, or deletion must also consider:

- lawful basis and transparency,
- data minimisation,
- retention period,
- erasure/export handling,
- auditability,
- documentation updates,
- Fides annotations.

---
<p align="center">
  Built in Wales ❤️ Designed with Cwtch<br/>
  Adeiladwyd yng Nghymru ❤️ Dyluniwyd gyda Cwtch
</p>
