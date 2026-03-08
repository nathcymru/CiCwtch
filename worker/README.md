# worker

This is the CiCwtch Cloudflare Workers backend API workspace.

## Current implementation status

As of the current repository state, the Worker exposes:

- `GET /health`
- `GET /api/v1/health`
- `GET /api/v1/clients`
- `GET /api/v1/clients/:id`
- `POST /api/v1/clients`
- `PUT /api/v1/clients/:id`
- `DELETE /api/v1/clients/:id`

Clients are soft-deleted via `archived_at`.

## Contents

- `src/index.ts` — Worker entry point; delegates to router, catches errors
- `src/router.ts` — URL routing; maps paths to handlers
- `src/response.ts` — Standard JSON response helpers
- `src/errors.ts` — ApiError class and typed error helpers
- `wrangler.toml` — Wrangler configuration with D1 bindings
- `package.json` — Node.js dependencies and scripts
- `tsconfig.json` — TypeScript configuration

## Internal structure

The worker is intentionally small at this stage:

- **`index.ts`** is the Cloudflare Worker entry point. It delegates all routing to `router.ts` and wraps errors in structured JSON responses.
- **`router.ts`** matches incoming request paths and dispatches to handlers. It currently supports a health route and the Clients CRUD slice. Unsupported methods on known routes return `405 Method Not Allowed`.
- **`response.ts`** provides `jsonOk()` and `jsonError()` helpers so all responses remain JSON.
- **`errors.ts`** defines `ApiError`, a typed error class carrying an HTTP status and machine-readable `type` string.
- **`handlers/clients.ts`** contains the current D1-backed clients CRUD implementation.

Business API routes are versioned under `/api/v1/`.

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

| Environment | Worker name            | D1 database            |
|-------------|------------------------|------------------------|
| Local dev   | `cicwtch-api`          | local D1 binding       |
| Staging     | `cicwtch-api-staging`  | staging D1 binding     |
| Production  | `cicwtch-api-production` | production D1 binding |

Replace the placeholder `database_id` values in `wrangler.toml` with actual D1 database IDs after creating them via `wrangler d1 create`.

## Scripts

| Command             | Description                  |
|---------------------|------------------------------|
| `npm run dev`       | Start local dev server       |
| `npm run deploy`    | Deploy to Cloudflare Workers |
| `npm run typecheck` | Run TypeScript type checking |

## Privacy and security notes

- All queries must use prepared statements.
- Sensitive data lives in D1 and must be reflected in `.fides/` and `docs/gdpr/` when the schema changes.
- Authentication, RBAC, DSAR automation, retention enforcement, and R2 attachment controls are **not yet fully implemented** in code and remain Phase 2 work.
