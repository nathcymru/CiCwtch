<img src="../brand/app_icon_base.svg" alt="CiCwtch Logo" align="left" height="60" />
<!-- HEADER BADGES -->
<p align="right">
<a href="https://github.com/nathcymru/CiCwtch/actions/workflows/ci.yml"><img src="https://img.shields.io/github/actions/workflow/status/nathcymru/CiCwtch/ci.yml?branch=main&style=for-the-badge" alt="Build Status" /></a>
&nbsp;
<a href="https://github.com/nathcymru/CiCwtch/releases"><img src="https://img.shields.io/github/v/tag/nathcymru/CiCwtch?sort=semver&style=for-the-badge&label=Release" alt="Release" /></a>
&nbsp;
  <a href="https://github.com/nathcymru/CiCwtch/commits/main"><img src="https://img.shields.io/github/last-commit/nathcymru/CiCwtch?style=for-the-badge" alt="Last Commit" /></a>
</p clear="right">

# CiCwtch - Contributing to CiCwtch
## Repository Standards & Collaboration

<p align="left">
  <a href="https://github.com/features/copilot"><img src="https://img.shields.io/badge/GitHub-181717?style=for-the-badge&logo=github&logoColor=white" alt="GitHub" /></a>
  &nbsp;
  <a href="https://flutter.dev/"><img src="https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white" alt="Flutter" /></a>
  &nbsp;
  <a href="https://developers.cloudflare.com/workers/"><img src="https://img.shields.io/badge/Cloudflare%20Workers-F38020?style=for-the-badge&logo=cloudflare&logoColor=white" alt="Cloudflare Workers" /></a>
</p>

Thank you for your interest in contributing to CiCwtch.

CiCwtch is a proprietary project. Contributions are welcome only where they align with the project direction and are explicitly approved by the maintainer.

## Before you start

- Open an Issue before beginning substantial work.
- Confirm scope, architectural direction, and ownership expectations.
- Avoid submitting large unsolicited changes.

## Development expectations

- Keep changes focused and easy to review.
- Update relevant documentation when behaviour, structure, APIs, or data models change.
- Follow the pull request template in full.
- Run the local Flutter checks before opening a PR:
  - `flutter pub get`
  - `flutter analyze`
  - `flutter test`

## Documentation guardrails

If you change architecture-sensitive areas, you are expected to update one or more of the following:

- `docs/architecture.md`
- supporting files under `docs/architecture/`
- `README.md`
- `flutter/README.md`

If documentation genuinely does not need changing, use the PR label `docs-not-required` and explain why in the pull request.

## Licensing and ownership

By submitting a contribution, you acknowledge that approved contributions may be incorporated into current or future commercial versions of CiCwtch.

Do not submit third-party code or assets unless you have the legal right to do so and have clearly identified the licence terms.

---
<p align="center">
  Built in Wales ❤️ Designed with Cwtch<br/>
  Adeiladwyd yng Nghymru ❤️ Dyluniwyd gyda Cwtch
</p>
