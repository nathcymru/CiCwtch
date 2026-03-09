<img src="../../brand/app_icon_base.svg" alt="CiCwtch Logo" align="left" height="60" />
<!-- HEADER BADGES -->
<p align="right">
<a href="https://github.com/nathcymru/CiCwtch/actions/workflows/ci.yml"><img src="https://img.shields.io/github/actions/workflow/status/nathcymru/CiCwtch/ci.yml?branch=main&style=for-the-badge" alt="Build Status" /></a>
&nbsp;
<a href="https://github.com/nathcymru/CiCwtch/releases"><img src="https://img.shields.io/github/v/tag/nathcymru/CiCwtch?sort=semver&style=for-the-badge&label=Release" alt="Release" /></a>
&nbsp;
  <a href="https://github.com/nathcymru/CiCwtch/commits/main"><img src="https://img.shields.io/github/last-commit/nathcymru/CiCwtch?style=for-the-badge" alt="Last Commit" /></a>
</p clear="right">

# CiCwtch - Data Protection Impact Assessment
## Working DPIA draft focused on current and near-term risks

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

## Why a DPIA is relevant

CiCwtch handles operational data about individuals and may process care notes, contact details, compliance records, and potentially attachments in future phases. The CNIL recommends DPIAs for higher-risk processing and for documenting security measures in a structured way.

## Current risk themes

1. **API access control**
   The Worker API now requires a valid bearer token on all protected routes (v0.3.0). Health endpoints remain public. Full user-level authentication and role-based authorisation are not yet implemented.

2. **Operational notes containing special or sensitive context**
   Free-text notes may contain medical, behavioural, or care-related context.

3. **Future attachment handling**
   R2-backed attachments can introduce additional confidentiality and retention risk if not tightly controlled.

4. **Deletion and retention maturity**
   Schema-level soft delete exists for some entities, but full erasure and retention enforcement is not yet automated.

## Current mitigations

- prepared D1 statements,
- explicit JSON API routes,
- bearer-token authentication on protected API routes (environment-sourced secret, not hardcoded),
- code/documentation guardrails in CI,
- schema inventory documented in-repo,
- initial privacy data mapping via Fides manifests,
- dashboard aggregation endpoint returns only summary counts, not personal data.

## Required next mitigations

- implement user-level authentication and role-based access control,
- define production session controls,
- implement attachment/R2 access policy,
- add retention jobs and erasure workflows,
- document lawful basis and privacy notices before live use.

---
<p align="center">
  Built in Wales ❤️ Designed with Cwtch<br/>
  Adeiladwyd yng Nghymru ❤️ Dyluniwyd gyda Cwtch
</p>
