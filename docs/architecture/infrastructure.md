<img src="../../brand/app_icon_base.svg" alt="CiCwtch Logo" align="left" height="60" />
<!-- HEADER BADGES -->
<p align="right">
<a href="https://github.com/nathcymru/CiCwtch/actions/workflows/ci.yml"><img src="https://img.shields.io/github/actions/workflow/status/nathcymru/CiCwtch/ci.yml?branch=main&style=for-the-badge" alt="Build Status" /></a>
&nbsp;
<a href="https://github.com/nathcymru/CiCwtch/releases"><img src="https://img.shields.io/github/v/tag/nathcymru/CiCwtch?sort=semver&style=for-the-badge&label=Release" alt="Release" /></a>
&nbsp;
  <a href="https://github.com/nathcymru/CiCwtch/commits/main"><img src="https://img.shields.io/github/last-commit/nathcymru/CiCwtch?style=for-the-badge" alt="Last Commit" /></a>
</p clear="right">

# CiCwtch - Infrastructure Architecture
## Current deployment and runtime topology

<p align="left">
  <a href="https://flutter.dev/"><img src="https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white" alt="Flutter" /></a>
  &nbsp;
  <a href="https://developers.cloudflare.com/workers/"><img src="https://img.shields.io/badge/Cloudflare%20Workers-F38020?style=for-the-badge&logo=cloudflare&logoColor=white" alt="Cloudflare Workers" /></a>
  &nbsp;
  <a href="https://developers.cloudflare.com/d1/"><img src="https://img.shields.io/badge/Cloudflare%20D1-F38020?style=for-the-badge&logo=cloudflare&logoColor=white" alt="Cloudflare D1" /></a>
  &nbsp;
  <a href="https://developers.cloudflare.com/r2/"><img src="https://img.shields.io/badge/Cloudflare%20R2-F38020?style=for-the-badge&logo=cloudflare&logoColor=white" alt="Cloudflare R2" /></a>
</p>

## Current platform components

- **Flutter** for the client application
- **Cloudflare Workers** for the API runtime
- **Cloudflare D1** for relational data storage
- **Cloudflare R2** for object/file storage (binding `CICWTCH_ATTACHMENTS` configured; used for dog media attachments and official Trust Centre document uploads)
- **GitHub Actions** for CI and documentation/privacy guardrails
- **Cloudflare Pages** for Flutter web hosting (git-based deployment from `flutter/` directory)

## Current repository-level automation

- `ci.yml` runs Flutter analyze/test/build and Worker typecheck
- `docs_guardrails.yml` enforces documentation updates on architecture-sensitive PRs
- `scorecard.yml` provides repository security posture reporting
- `privacy_compliance.yml` validates local Fides manifests and privacy documentation guardrails

## Cloudflare Worker deployment

The API backend is deployed as a Cloudflare Worker named **`cicwtch-api`**.

| Setting             | Value                                          |
|---------------------|------------------------------------------------|
| Worker name         | `cicwtch-api`                                  |
| Live URL            | `https://cicwtch-api.nathcymru.workers.dev`    |
| Wrangler config     | `worker/wrangler.toml`                         |
| Deploy command      | `cd worker && npm run deploy`                  |

The `npm run deploy` script runs `wrangler deploy --env production`, which uses the `[env.production]` configuration in `wrangler.toml` to deploy to the `cicwtch-api` Worker with the correct D1 and R2 bindings.

A staging environment (`cicwtch-api-staging`) is also defined in `wrangler.toml` and can be deployed via `npm run deploy:staging`.

## Cloudflare Pages deployment

The Flutter web app is deployed to Cloudflare Pages using git-based integration.

| Setting            | Value                                      |
|--------------------|--------------------------------------------|
| Root directory     | `flutter`                                  |
| Build command      | `bash scripts/cloudflare-pages-build.sh`   |
| Build output dir   | `build/web`                                |

Because the default Pages build environment does not include Flutter, the repository provides `scripts/cloudflare-pages-build.sh` which installs the SDK and runs the build. No additional redirect rules are required because the app uses hash-based routing.

## Local development shape

Typical local developer flow:

1. Run Worker locally with Wrangler.
2. Run Flutter locally against the Worker base URL.
3. Apply D1 migrations from the `migrations/` directory.
4. Use seeded test data where needed.

---
<p align="center">
  Built in Wales ❤️ Designed with Cwtch<br/>
  Adeiladwyd yng Nghymru ❤️ Dyluniwyd gyda Cwtch
</p>
