# CiCwtch Architecture (current repository truth)

This folder documents the **current implemented architecture** and, where useful, the intended direction.
If the code and these docs disagree, the docs must be updated.

## Implemented today

### Frontend
- Flutter application in `flutter/`
- Material 3 theme path only
- Named routing via `lib/app/routing/app_router.dart`
- Implemented feature slice: **Clients**
- Shared plain-Dart models under `flutter/lib/shared/domain/models/`
- Simple HTTP API client under `flutter/lib/shared/data/api_client.dart`

### Backend
- Cloudflare Worker in `worker/`
- D1-backed **Clients CRUD** only
- Health endpoints:
  - `GET /health`
  - `GET /api/v1/health`
- JSON response helper + typed API errors

### Database
- D1 migration `migrations/0001_initial_schema.sql` defines the wider intended schema for addresses, clients, dogs, walkers, walks, invoices, attachments, and audit records.
- Only a subset of that schema is currently exercised by application code.

## Intended direction (not yet fully implemented)

The URS describes a much larger system including:
- authentication and RBAC
- dogs, walkers, walks, invoices, compliance, bookings, rewards, vouchers
- offline queueing and sync
- R2-backed attachments/media
- client self-service portal

Those capabilities should be treated as **planned architecture**, not current runtime fact, unless corresponding code exists in this repository.

## Architecture file map

- `application.md` — current Flutter and Worker structure
- `data.md` — schema reality, current data flows, and privacy inventory linkages
- `infrastructure.md` — current CI/CD and Cloudflare setup
- `security.md` — current controls and known gaps
- `decisions.md` — architectural decisions and explicit deferred items
- `diagrams.md` — diagrams kept aligned to current repository reality
