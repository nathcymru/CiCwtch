# Infrastructure Architecture

## Current deployed components (intended / configured)

- Flutter front-end application
- Cloudflare Worker API
- Cloudflare D1 database

## Current code-level reality

Configured in repo:

- Worker entrypoint and router
- D1 binding in `worker/wrangler.toml`
- local/staging/production D1 placeholders
- CI for Flutter analyze/test/build and Worker typecheck

Not yet implemented in application code:

- Cloudflare R2 storage integration
- Cloudflare Pages deployment configuration in repo
- authentication provider integration
- scheduled jobs / retention workers

## Environment notes

`worker/wrangler.toml` still contains placeholder D1 IDs for staging and production. Those must be replaced before real deployment.
