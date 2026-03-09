<img src="../../brand/app_icon_base.svg" alt="CiCwtch Logo" align="left" height="60" />
<!-- HEADER BADGES -->
<p align="right">
<a href="https://github.com/nathcymru/CiCwtch/actions/workflows/ci.yml"><img src="https://img.shields.io/github/actions/workflow/status/nathcymru/CiCwtch/ci.yml?branch=main&style=for-the-badge" alt="Build Status" /></a>
&nbsp;
<a href="https://github.com/nathcymru/CiCwtch/releases"><img src="https://img.shields.io/github/v/tag/nathcymru/CiCwtch?sort=semver&style=for-the-badge&label=Release" alt="Release" /></a>
&nbsp;
  <a href="https://github.com/nathcymru/CiCwtch/commits/main"><img src="https://img.shields.io/github/last-commit/nathcymru/CiCwtch?style=for-the-badge" alt="Last Commit" /></a>
</p clear="right">

# CiCwtch - Security Architecture
## Current security posture and known gaps

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

## Security controls currently present

- JSON-only API surface
- D1 prepared statements to reduce SQL injection risk
- typed Worker error responses
- CI checks for Flutter and Worker code quality
- documentation guardrails for architecture-sensitive changes
- initial privacy inventory scaffolding through Fides manifests
- minimal bearer-token authentication on protected API routes (v0.3.0)

## Bearer token authentication (v0.3.0)

A minimal environment-token authentication layer protects all `/api/v1/*` routes except the health endpoint. This is intentionally lightweight and is **not** full user authentication or RBAC.

**How it works:**

- Middleware in `worker/src/middleware/auth.ts` validates the `Authorization: Bearer <token>` header.
- The expected token is read from the `API_BEARER_TOKEN` environment variable (never hardcoded).
- Health endpoints (`/health` and `/api/v1/health`) remain public.
- Missing, malformed, unconfigured, or invalid tokens return a `401` JSON error response.

**Scope and limitations:**

This layer provides early-stage environment protection only. It does not implement user accounts, sessions, passwords, JWTs, OAuth, refresh tokens, or role-based access control.

**Setting the token:**

```bash
# Local development — create worker/.dev.vars
API_BEARER_TOKEN=my-dev-token

# Deployed environments — use Wrangler secrets
echo "<token>" | npx wrangler secret put API_BEARER_TOKEN --env production
```

**Example request:**

```bash
curl -H "Authorization: Bearer my-dev-token" http://localhost:8787/api/v1/clients
```

The Flutter web client can be configured with the same token using `--dart-define=API_BEARER_TOKEN=...` or the Cloudflare Pages `API_BEARER_TOKEN` environment variable.

For full details, see the [Worker README](../../worker/README.md#authentication).

## Known security gaps

The following are **not yet implemented** and must not be described as done elsewhere:

- full user authentication and authorisation
- role-based access control
- user/session management
- per-tenant access segregation
- attachment access control
- security event logging beyond schema placeholders
- automated retention and erasure enforcement

## Practical rule

The current bearer-token layer provides basic environment protection but is not a substitute for full user authentication. The API should not be deployed as a public multi-user production service until proper user authentication and per-tenant access control are in place.

---
<p align="center">
  Built in Wales ❤️ Designed with Cwtch<br/>
  Adeiladwyd yng Nghymru ❤️ Dyluniwyd gyda Cwtch
</p>
