# Application Architecture

## Flutter app

Current app structure:

- `lib/app/`
  - routing
  - shell
- `lib/features/`
  - clients
  - dashboard
  - dogs
  - invoices
  - walkers
  - walks
  - auth (placeholder only)
- `lib/shared/`
  - data
  - domain models
  - presentation helpers

## Current interaction pattern

The Flutter app currently uses a straightforward service/repository/API-client pattern:

- screen
- feature service
- feature repository
- shared `ApiClient`
- Workers API

This is intentionally lightweight and suitable for solo development.

## Current UX shell

Implemented:

- Material 3 app shell
- dashboard
- responsive navigation rail / bottom navigation
- CRUD flows for the Phase 1 resources above

Not yet implemented:

- Cupertino app shell parity on iOS
- authenticated app state
- offline-first write queue
- domain-level state management beyond feature-local async loading

## Important accuracy note

The URS describes a broader Clean Architecture ambition and iOS-adaptive theming. The current codebase is **not yet at that full target state**. Documentation must therefore treat those elements as roadmap items until implemented.
