<img src="../brand/app_icon_base.svg" alt="CiCwtch Logo" align="left" height="60" />
<!-- HEADER BADGES -->
<p align="right">
<a href="https://github.com/nathcymru/CiCwtch/actions/workflows/ci.yml"><img src="https://img.shields.io/github/actions/workflow/status/nathcymru/CiCwtch/ci.yml?branch=main&style=for-the-badge" alt="Build Status" /></a>
&nbsp;
<a href="https://github.com/nathcymru/CiCwtch/releases"><img src="https://img.shields.io/github/v/tag/nathcymru/CiCwtch?sort=semver&style=for-the-badge&label=Release" alt="Release" /></a>
&nbsp;
  <a href="https://github.com/nathcymru/CiCwtch/commits/main"><img src="https://img.shields.io/github/last-commit/nathcymru/CiCwtch?style=for-the-badge" alt="Last Commit" /></a>
</p clear="right">

# CiCwtch - Worker API
## Cloudflare Workers backend for the current CiCwtch Phase 1 API surface

<p align="left">
  <a href="https://developers.cloudflare.com/workers/"><img src="https://img.shields.io/badge/Cloudflare%20Workers-F38020?style=for-the-badge&logo=cloudflare&logoColor=white" alt="Cloudflare Workers" /></a>
  &nbsp;
  <a href="https://developers.cloudflare.com/d1/"><img src="https://img.shields.io/badge/Cloudflare%20D1-F38020?style=for-the-badge&logo=cloudflare&logoColor=white" alt="Cloudflare D1" /></a>
  &nbsp;
  <a href="https://developers.cloudflare.com/r2/"><img src="https://img.shields.io/badge/Cloudflare%20R2-F38020?style=for-the-badge&logo=cloudflare&logoColor=white" alt="Cloudflare R2" /></a>
</p>

## Bindings

| Binding | Type | Purpose |
|---|---|---|
| `DB` | D1 Database | Relational data storage |
| `CICWTCH_ATTACHMENTS` | R2 Bucket | Attachment/file object storage |

## Current API modules

- `src/index.ts` — Worker entrypoint and top-level error handling
- `src/router.ts` — route dispatch and health endpoints
- `src/response.ts` — JSON success/error helpers
- `src/errors.ts` — typed API errors
- `src/handlers/` — resource handlers for current endpoints
- `src/storage.ts` — R2 attachment helpers (put, get, delete)

## Current resources

- clients
- dogs
- walks
- walkers
- invoice headers / invoices
- invoice lines
- attachments

## Routing note

Invoice headers are the underlying data model and handler naming, but the API now also supports user-facing invoice alias routes:

- `/api/v1/invoices`
- `/api/v1/invoices/:id`

Legacy compatibility remains for:

- `/api/v1/invoice-headers`
- `/api/v1/invoice-headers/:id`

## Local checks

```bash
cd worker
npm ci
npm run typecheck
npx wrangler dev
```

## Deployment

The live API Worker is named **`cicwtch-api`** and is served at:

**https://cicwtch-api.nathcymru.workers.dev**

### Deploy to production

Before deploying, ensure the production D1 database ID and R2 bucket name are set in `wrangler.toml` under `[env.production]`.

```bash
cd worker
npm run deploy
```

This runs `wrangler deploy --env production`, which targets the `cicwtch-api` Worker.

### Deploy to staging

```bash
cd worker
npm run deploy:staging
```

This runs `wrangler deploy --env staging`, which targets `cicwtch-api-staging`.

### Environment summary

| Environment | Worker name          | URL                                              |
|-------------|----------------------|--------------------------------------------------|
| Local dev   | (local)              | `http://localhost:8787`                           |
| Staging     | `cicwtch-api-staging`| `cicwtch-api-staging.nathcymru.workers.dev`       |
| Production  | `cicwtch-api`        | `cicwtch-api.nathcymru.workers.dev`               |

## Security note

This Worker is still pre-auth. Treat it as development-stage until authentication and authorisation are implemented.

---
<p align="center">
  Built in Wales ❤️ Designed with Cwtch<br/>
  Adeiladwyd yng Nghymru ❤️ Dyluniwyd gyda Cwtch
</p>
