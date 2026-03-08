<img src="../brand/app_icon_base.svg" alt="CiCwtch Logo" align="left" height="60" />
<!-- HEADER BADGES -->
<p align="right">
<a href="https://github.com/nathcymru/CiCwtch/actions/workflows/ci.yml"><img src="https://img.shields.io/github/actions/workflow/status/nathcymru/CiCwtch/ci.yml?branch=main&style=for-the-badge" alt="Build Status" /></a>
&nbsp;
<a href="https://github.com/nathcymru/CiCwtch/releases"><img src="https://img.shields.io/github/v/tag/nathcymru/CiCwtch?sort=semver&style=for-the-badge&label=Release" alt="Release" /></a>
&nbsp;
  <a href="https://github.com/nathcymru/CiCwtch/commits/main"><img src="https://img.shields.io/github/last-commit/nathcymru/CiCwtch?style=for-the-badge" alt="Last Commit" /></a>
</p clear="right">

# CiCwtch - CiCwtch Architecture Overview
## Project Documentation

<p align="left">
  <a href="https://flutter.dev/"><img src="https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white" alt="Flutter" /></a>
  &nbsp;
  <a href="https://developers.cloudflare.com/workers/"><img src="https://img.shields.io/badge/Cloudflare%20Workers-F38020?style=for-the-badge&logo=cloudflare&logoColor=white" alt="Cloudflare Workers" /></a>
  &nbsp;
  <a href="https://developers.cloudflare.com/d1/"><img src="https://img.shields.io/badge/Cloudflare%20D1-F38020?style=for-the-badge&logo=cloudflare&logoColor=white" alt="Cloudflare D1" /></a>
</p>

This file is a **high-level index only**.

The authoritative architecture documentation for CiCwtch is maintained in:

- [docs/architecture/README.md](architecture/README.md)
- [docs/architecture/application.md](architecture/application.md)
- [docs/architecture/data.md](architecture/data.md)
- [docs/architecture/infrastructure.md](architecture/infrastructure.md)
- [docs/architecture/security.md](architecture/security.md)
- [docs/architecture/decisions.md](architecture/decisions.md)
- [docs/architecture/diagrams.md](architecture/diagrams.md)

## Platform direction

CiCwtch is being built as a **Flutter application for Web, iOS, and Android**, with a backend platform centred on:

- **Cloudflare Workers** for server-side runtime and APIs
- **Cloudflare D1** for relational data storage
- **Cloudflare R2** for object and media storage
- **SQLite** for lightweight local persistence and offline-first behaviour inside the app where required

## Documentation rule

If this overview and the detailed architecture documents ever disagree, treat the files under `docs/architecture/` as the source of truth and update this page immediately.

---
<p align="center">
  Built in Wales ❤️ Designed with Cwtch<br/>
  Adeiladwyd yng Nghymru ❤️ Dyluniwyd gyda Cwtch
</p>
