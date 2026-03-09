<img src="../../brand/app_icon_base.svg" alt="CiCwtch Logo" align="left" height="60" />
<!-- HEADER BADGES -->
<p align="right">
<a href="https://github.com/nathcymru/CiCwtch/actions/workflows/ci.yml"><img src="https://img.shields.io/github/actions/workflow/status/nathcymru/CiCwtch/ci.yml?branch=main&style=for-the-badge" alt="Build Status" /></a>
&nbsp;
<a href="https://github.com/nathcymru/CiCwtch/releases"><img src="https://img.shields.io/github/v/tag/nathcymru/CiCwtch?sort=semver&style=for-the-badge&label=Release" alt="Release" /></a>
&nbsp;
  <a href="https://github.com/nathcymru/CiCwtch/commits/main"><img src="https://img.shields.io/github/last-commit/nathcymru/CiCwtch?style=for-the-badge" alt="Last Commit" /></a>
</p clear="right">

# CiCwtch - Architecture Decisions
## Key implementation decisions currently reflected in the codebase

<p align="left">
  <a href="https://flutter.dev/"><img src="https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white" alt="Flutter" /></a>
  &nbsp;
  <a href="https://developers.cloudflare.com/workers/"><img src="https://img.shields.io/badge/Cloudflare%20Workers-F38020?style=for-the-badge&logo=cloudflare&logoColor=white" alt="Cloudflare Workers" /></a>
  &nbsp;
  <a href="https://developers.cloudflare.com/d1/"><img src="https://img.shields.io/badge/Cloudflare%20D1-F38020?style=for-the-badge&logo=cloudflare&logoColor=white" alt="Cloudflare D1" /></a>
  &nbsp;
  <a href="https://developers.cloudflare.com/r2/"><img src="https://img.shields.io/badge/Cloudflare%20R2-F38020?style=for-the-badge&logo=cloudflare&logoColor=white" alt="Cloudflare R2" /></a>
</p>

## ADR-style summary

### A1. Flutter is the client application stack
Chosen to maintain one cross-platform codebase for web and mobile.

### A2. Cloudflare Workers + D1 is the backend baseline
Chosen for low-ops deployment, straightforward JSON APIs, and a relational operational data model.

### A3. Keep architecture lightweight
The codebase uses feature folders, repositories, and services, but intentionally avoids speculative complexity.

### A4. Soft delete for primary operational entities
Top-level operational records use `archived_at` so records can be hidden without immediate destructive deletion.

### A5. Documentation must track the implemented state
This repository now explicitly treats stale architecture documentation as a defect, not a nice-to-have.

### A6. Privacy inventory starts in-repo
Fides manifests are stored in-repo so data mapping evolves with the schema instead of becoming archaeological guesswork later.

### A7. CiCwtch is a multi-tenant platform
Every dog-walking business using CiCwtch is a separate tenant. All core business tables must include `organisation_id` to enforce data isolation. This is a platform rule from which no deviation is permitted. See [multi-tenant-model.md](multi-tenant-model.md).

---
<p align="center">
  Built in Wales ❤️ Designed with Cwtch<br/>
  Adeiladwyd yng Nghymru ❤️ Dyluniwyd gyda Cwtch
</p>
