<img src="../../brand/app_icon_base.svg" alt="CiCwtch Logo" align="left" height="60" />
<!-- HEADER BADGES -->
<p align="right">
<a href="https://github.com/nathcymru/CiCwtch/actions/workflows/ci.yml"><img src="https://img.shields.io/github/actions/workflow/status/nathcymru/CiCwtch/ci.yml?branch=main&style=for-the-badge" alt="Build Status" /></a>
&nbsp;
<a href="https://github.com/nathcymru/CiCwtch/releases"><img src="https://img.shields.io/github/v/tag/nathcymru/CiCwtch?sort=semver&style=for-the-badge&label=Release" alt="Release" /></a>
&nbsp;
  <a href="https://github.com/nathcymru/CiCwtch/commits/main"><img src="https://img.shields.io/github/last-commit/nathcymru/CiCwtch?style=for-the-badge" alt="Last Commit" /></a>
</p clear="right">

# CiCwtch - Infrastructure & Deployment
## Architecture & Engineering Source of Truth

<p align="left">
  <a href="https://flutter.dev/"><img src="https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white" alt="Flutter" /></a>
  &nbsp;
  <a href="https://developers.cloudflare.com/workers/"><img src="https://img.shields.io/badge/Cloudflare%20Workers-F38020?style=for-the-badge&logo=cloudflare&logoColor=white" alt="Cloudflare Workers" /></a>
  &nbsp;
  <a href="https://developers.cloudflare.com/d1/"><img src="https://img.shields.io/badge/Cloudflare%20D1-F38020?style=for-the-badge&logo=cloudflare&logoColor=white" alt="Cloudflare D1" /></a>
</p>

CiCwtch uses Cloudflare as an edge-first BFF platform: low latency, simple ops, strong regional performance.

---

## 1) Environments

- **Local**: Flutter dev + local mocks (optional), SQLite
- **Staging**: Cloudflare Workers + D1 + R2 (separate accounts or namespaces)
- **Production**: Cloudflare Workers + D1 + R2 (prod resources, strict secrets)

Environment parity matters. “Works on my laptop” is not a deployment strategy.

---

## 2) Deployment topology

```mermaid
flowchart TB
  Dev[Developer Laptop] -->|git push| GH[GitHub Repo]
  GH -->|CI| Actions[GitHub Actions]

  Actions -->|deploy| CF[Cloudflare]
  CF --> Worker[Workers API]
  CF --> D1[(D1)]
  CF --> R2[(R2)]

  Users[Users] -->|HTTPS| Worker
```

---

## 3) CI/CD expectations

CI should run at minimum:
- format/lint
- unit tests (domain + use cases)
- integration tests (API contracts where possible)
- build checks for Web/iOS/Android targets (as appropriate)

CD should:
- deploy Workers to staging on merge to main (or release branches)
- promote to production via tagged release / manual approval gate

---

## 4) Observability

### Logging
- Workers logs for API requests, errors, and key workflow events
- Correlation IDs:
  - generated per request, returned to client, logged server-side

### Metrics (at minimum)
- request latency (p50/p95)
- error rate (4xx/5xx)
- sync success/failure counts
- webhook processing success/failure

### Health checks
- `/health` endpoint (no auth) for platform monitoring
- `/ready` endpoint (internal) verifying D1 connectivity (if feasible)

---

## 5) Backups & data retention (policy)

- D1 backup/exports strategy documented here when implemented
- R2 retention rules per object type:
  - walk photos (retention policy)
  - invoices (longer retention)

---
<p align="center">
  Built in Wales ❤️ Designed with Cwtch<br/>
  Adeiladwyd yng Nghymru ❤️ Dyluniwyd gyda Cwtch
</p>
