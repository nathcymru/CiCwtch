# Infrastructure

## Current repository tooling

### GitHub Actions
Current workflows in `.github/workflows/`:
- `ci.yml` — Flutter analyze/test/build-web and Worker typecheck
- `docs_guardrails.yml` — requires docs updates for architecture-sensitive changes
- `scorecard.yml` — OpenSSF Scorecard analysis
- `privacy_compliance.yml` — Fides manifest validation and privacy guardrails

### Cloudflare
Current backend target:
- Cloudflare Workers runtime
- Cloudflare D1 database binding via Wrangler

R2 is part of the intended platform design but is not yet active in the current code.

## Current maturity assessment

Implemented:
- CI for Flutter and Worker basics
- docs guardrails
- privacy manifest validation scaffold

Not yet implemented:
- staged deployment automation
- production release workflow
- secrets governance beyond standard GitHub/Cloudflare practices
- attachment lifecycle jobs
- retention automation jobs
