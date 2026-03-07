# worker

This is the CiCwtch Cloudflare Workers backend API workspace.

## Contents

- `src/index.ts` — Worker entry point (health endpoint)
- `wrangler.toml` — Wrangler configuration with D1 bindings
- `package.json` — Node.js dependencies and scripts
- `tsconfig.json` — TypeScript configuration

All API routes will be versioned under `/api/v1/`.

## Getting started

```bash
cd worker
npm install
npm run dev
```

This starts a local dev server using Wrangler. The health endpoint is
available at `http://localhost:8787/health`.

## Environments

| Environment | Worker name              | D1 database              |
|-------------|--------------------------|--------------------------|
| Local dev   | cicwtch-api              | cicwtch-db (local)       |
| Staging     | cicwtch-api-staging      | cicwtch-db-staging       |
| Production  | cicwtch-api-production   | cicwtch-db-production    |

Replace the placeholder `database_id` values in `wrangler.toml` with
actual D1 database IDs after creating them via `wrangler d1 create`.

## Scripts

| Command          | Description                       |
|------------------|-----------------------------------|
| `npm run dev`    | Start local dev server            |
| `npm run deploy` | Deploy to Cloudflare Workers      |
| `npm run typecheck` | Run TypeScript type checking  |
