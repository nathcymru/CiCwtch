<img src="../../brand/app_icon_base.svg" alt="CiCwtch Logo" align="left" height="60" />
<!-- HEADER BADGES -->
<p align="right">
<a href="https://github.com/nathcymru/CiCwtch/actions/workflows/ci.yml"><img src="https://img.shields.io/github/actions/workflow/status/nathcymru/CiCwtch/ci.yml?branch=main&style=for-the-badge" alt="Build Status" /></a>
&nbsp;
<a href="https://github.com/nathcymru/CiCwtch/releases"><img src="https://img.shields.io/github/v/tag/nathcymru/CiCwtch?sort=semver&style=for-the-badge&label=Release" alt="Release" /></a>
&nbsp;
  <a href="https://github.com/nathcymru/CiCwtch/commits/main"><img src="https://img.shields.io/github/last-commit/nathcymru/CiCwtch?style=for-the-badge" alt="Last Commit" /></a>
</p clear="right">

# CiCwtch - CNIL Gap Audit
## Repository-level gap audit against CNIL developer and security guidance

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

## Summary

The repository now has a much clearer privacy inventory than before, but it is **not yet at a production-grade CNIL-aligned maturity level**.

## Aligned or improving areas

- privacy-by-design documentation now exists in-repo,
- data inventory has a first machine-readable form via Fides manifests,
- schema and API surfaces are explicit and reviewable,
- security and documentation checks are integrated into CI.

## Major remaining gaps

- no authentication or authorisation,
- no production-grade session management,
- no attachment governance implementation,
- no automated retention enforcement,
- no full DSAR access/erasure workflow,
- no production privacy notice or consent UX because customer-facing processing is not live.

## Practical conclusion

The codebase is suitable for continued development and disciplined internal milestone releases. It should not yet be described as fully GDPR-ready for public production deployment.

---
<p align="center">
  Built in Wales ❤️ Designed with Cwtch<br/>
  Adeiladwyd yng Nghymru ❤️ Dyluniwyd gyda Cwtch
</p>
