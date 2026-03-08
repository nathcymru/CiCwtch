<img src="../brand/app_icon_base.svg" alt="CiCwtch Logo" align="left" height="60" />
<!-- HEADER BADGES -->
<p align="right">
<a href="https://github.com/nathcymru/CiCwtch/actions/workflows/ci.yml"><img src="https://img.shields.io/github/actions/workflow/status/nathcymru/CiCwtch/ci.yml?branch=main&style=for-the-badge" alt="Build Status" /></a>
&nbsp;
<a href="https://github.com/nathcymru/CiCwtch/releases"><img src="https://img.shields.io/github/v/tag/nathcymru/CiCwtch?sort=semver&style=for-the-badge&label=Release" alt="Release" /></a>
&nbsp;
  <a href="https://github.com/nathcymru/CiCwtch/commits/main"><img src="https://img.shields.io/github/last-commit/nathcymru/CiCwtch?style=for-the-badge" alt="Last Commit" /></a>
</p clear="right">

# CiCwtch - worker
## Cloudflare Workers Backend API

<p align="left">
  <a href="https://developers.cloudflare.com/workers/"><img src="https://img.shields.io/badge/Cloudflare%20Workers-F38020?style=for-the-badge&logo=cloudflare&logoColor=white" alt="Cloudflare Workers" /></a>
  &nbsp;
  <a href="https://developers.cloudflare.com/d1/"><img src="https://img.shields.io/badge/Cloudflare%20D1-F38020?style=for-the-badge&logo=cloudflare&logoColor=white" alt="Cloudflare D1" /></a>
  &nbsp;
  <a href="https://developers.cloudflare.com/r2/"><img src="https://img.shields.io/badge/Cloudflare%20R2-F38020?style=for-the-badge&logo=cloudflare&logoColor=white" alt="Cloudflare R2" /></a>
</p>

This is the CiCwtch Cloudflare Workers backend API workspace.

## Contents

- `src/index.ts` — Worker entry point; delegates to router, catches errors
- `src/router.ts` — URL routing; maps paths to handlers
- `src/response.ts` — Standard JSON response helpers
- `src/errors.ts` — ApiError class and typed error helpers
- `wrangler.toml` — Wrangler configuration with D1 bindings
- `package.json` — Node.js dependencies and scripts
- `tsconfig.json` — TypeScript configuration

## Internal structure

The worker is split into four modules with clear separation of concerns:

- **`index.ts`** is the Cloudflare Worker entry point. It delegates all routing to `router.ts` and wraps errors in structured JSON responses: `ApiError` instances produce their own status/type; unhandled errors produce a 500.
- **`router.ts`** matches incoming request paths and dispatches to handlers. It receives `env` (including `env.DB`) so future handlers can access D1.
- **`response.ts`** provides two helpers — `jsonOk()` for success responses and `jsonError()` for structured error responses — to keep response shaping consistent across the codebase.
- **`errors.ts`** defines `ApiError`, a typed error class carrying an HTTP status and a machine-readable `type` string. Use `ApiError.notFound()` (and similar future factories) to throw errors from anywhere in the handler chain.

Business API routes are versioned under `/api/v1/`.
For operational simplicity, the Worker also exposes both `/health` and `/api/v1/health` for health checks.

## Getting started

```bash
cd worker
npm install
npm run dev
```

This starts a local dev server using Wrangler. Health is available at both:

- `http://localhost:8787/health`
- `http://localhost:8787/api/v1/health`

## Environments

| Environment | Worker name              | D1 database              |
|-------------|--------------------------|--------------------------|
| Local dev   | cicwtch-api              | cicwtch-db (local)       |
| Staging     | cicwtch-api-staging      | cicwtch-db-staging       |
| Production  | cicwtch-api-production   | cicwtch-db-production    |

Replace the placeholder `database_id` values in `wrangler.toml` with actual D1 database IDs after creating them via `wrangler d1 create`.

## Scripts

| Command             | Description                  |
|---------------------|------------------------------|
| `npm run dev`       | Start local dev server       |
| `npm run deploy`    | Deploy to Cloudflare Workers |
| `npm run typecheck` | Run TypeScript type checking |

---
<p align="center">
  Built in Wales ❤️ Designed with Cwtch<br/>
  Adeiladwyd yng Nghymru ❤️ Dyluniwyd gyda Cwtch
</p>
