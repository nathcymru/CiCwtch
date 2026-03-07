# worker

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

## API endpoints

All responses are JSON. All routes are versioned under `/api/v1/`.

### Clients

| Method | Path                  | Description          |
|--------|-----------------------|----------------------|
| GET    | /api/v1/clients       | List all clients     |
| GET    | /api/v1/clients/:id   | Get a client         |
| POST   | /api/v1/clients       | Create a client      |
| PUT    | /api/v1/clients/:id   | Update a client      |
| DELETE | /api/v1/clients/:id   | Soft-delete a client |

### Dogs

| Method | Path               | Description       |
|--------|--------------------|-------------------|
| GET    | /api/v1/dogs       | List all dogs     |
| GET    | /api/v1/dogs/:id   | Get a dog         |
| POST   | /api/v1/dogs       | Create a dog      |
| PUT    | /api/v1/dogs/:id   | Update a dog      |
| DELETE | /api/v1/dogs/:id   | Soft-delete a dog |

### Walks

| Method | Path                | Description        |
|--------|---------------------|--------------------|
| GET    | /api/v1/walks       | List all walks     |
| GET    | /api/v1/walks/:id   | Get a walk         |
| POST   | /api/v1/walks       | Create a walk      |
| PUT    | /api/v1/walks/:id   | Update a walk      |
| DELETE | /api/v1/walks/:id   | Soft-delete a walk |

#### Walks: notes

- All responses are JSON only.
- Soft delete sets `archived_at` timestamp; records are never hard-deleted.
- `dog_id` and `walker_id` references are validated against their respective tables on create and update. Referenced records must exist and must not be archived.
- `walker_id` is optional; it may be `null` or omitted.
- `status` must be one of: `planned`, `in_progress`, `completed`, `cancelled`. Defaults to `planned` on create.
- `service_type` defaults to `walk` on create.
- All SQL uses parameterised D1 prepared statements only.
- Error responses follow the shape: `{ "error": { "message": "...", "type": "..." } }`
