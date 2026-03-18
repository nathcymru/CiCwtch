<img src="../../brand/app_icon_base.svg" alt="CiCwtch Logo" align="left" height="60" />
<!-- HEADER BADGES -->
<p align="right">
<a href="https://github.com/nathcymru/CiCwtch/actions/workflows/ci.yml"><img src="https://img.shields.io/github/actions/workflow/status/nathcymru/CiCwtch/ci.yml?branch=main&style=for-the-badge" alt="Build Status" /></a>
&nbsp;
<a href="https://github.com/nathcymru/CiCwtch/releases"><img src="https://img.shields.io/github/v/tag/nathcymru/CiCwtch?sort=semver&style=for-the-badge&label=Release" alt="Release" /></a>
&nbsp;
  <a href="https://github.com/nathcymru/CiCwtch/commits/main"><img src="https://img.shields.io/github/last-commit/nathcymru/CiCwtch?style=for-the-badge" alt="Last Commit" /></a>
</p clear="right">

# CiCwtch - Application Architecture
## Flutter client structure and backend API interaction model

<p align="left">
  <a href="https://flutter.dev/"><img src="https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white" alt="Flutter" /></a>
  &nbsp;
  <a href="https://developers.cloudflare.com/workers/"><img src="https://img.shields.io/badge/Cloudflare%20Workers-F38020?style=for-the-badge&logo=cloudflare&logoColor=white" alt="Cloudflare Workers" /></a>
  &nbsp;
  <a href="https://developers.cloudflare.com/d1/"><img src="https://img.shields.io/badge/Cloudflare%20D1-F38020?style=for-the-badge&logo=cloudflare&logoColor=white" alt="Cloudflare D1" /></a>
  &nbsp;
  <a href="https://developers.cloudflare.com/r2/"><img src="https://img.shields.io/badge/Cloudflare%20R2-F38020?style=for-the-badge&logo=cloudflare&logoColor=white" alt="Cloudflare R2" /></a>
</p>

## Flutter structure

The Flutter application is organised into:

- `app/` for bootstrap, routing, shell, and theme concerns
- `features/` for vertical slices such as clients, dogs, walks, walkers, invoices, and dashboard
- `shared/` for common models, API client logic, and reusable presentation helpers

## Feature pattern

Each implemented feature broadly follows this structure:

- `application/` service layer
- `data/` repository layer using `ApiClient`
- `presentation/` screens and widgets

This is intentionally lightweight. It is not a large enterprise state-management circus.

## Current runtime flow

1. Flutter screen calls a feature service.
2. Service delegates to repository.
3. Repository calls `ApiClient`.
4. `ApiClient` sends JSON HTTP requests to the Worker API.
5. Worker validates input and uses D1 prepared statements.
6. Worker returns JSON to the app.

## Live API integration status

The following features are fully wired to the deployed Workers API for list, create, update, and archive operations:

- Clients
- Dogs
- Walks
- Walkers

Each feature's data layer (repository) uses the shared `ApiClient` with the configured API base URL. The presentation layer shows loading indicators during requests, displays error states on failure, and refreshes the list after mutations. Dog-to-client relationships are preserved through the `client_id` foreign key in the domain model and API payloads. Walk records reference clients, dogs, and optionally walkers through their respective foreign keys.

Behaviour snapshots are stored as timestamped historical records per dog via `GET` and `POST /api/v1/dogs/:id/behavior-snapshots`. This separates stable dog identity data from time-varying behavioural observations. The latest snapshot is surfaced on the dog detail screen, and new snapshots can be added from the same screen.

Vaccination records are stored per dog via `GET` and `POST /api/v1/dogs/:id/vaccinations`. Each record includes the vaccination name, date administered, optional expiration date, and an optional R2 document object key for supporting certificates. The dog detail screen lists all vaccinations and allows adding new ones.

Veterinary practices are available as a read-only lookup via `GET /api/v1/vet-practices`. The dog create/edit form uses this endpoint to populate a vet practice dropdown. Dogs may reference a vet practice via `vet_practice_id`, and the existing free-text `veterinary_practice` field is retained for backward compatibility.

The dog create/edit flow uses a 4-step wizard: Identity, Health, Behaviour, and Logistics. Each step validates independently, with a progress indicator and bottom-pinned navigation. The multi-step form loads breeds and vet practices from the API on initialisation.

The Dashboard feature uses the dedicated `GET /api/v1/dashboard` aggregation endpoint to fetch summary counts for clients, dogs, walks, walkers, and invoices in a single request. The dashboard data layer (`DashboardRepository`) calls this endpoint via `ApiClient`, and the presentation layer displays the returned metrics in dashboard cards with loading and error states.

The Dashboard also includes a **Today's Weather** card. Weather data is fetched from `GET /api/v1/weather/today`, which is a server-side proxy endpoint. The Worker calls the Google Weather API using credentials stored in environment secrets (`CICWTCH_GOOGLE_WEATHER_API`), reads the documented top-level response fields, calculates dog-walking safety factors (paw safety, brachy/heat risk, mud, itch/pollen, gear check), generates a layered daily verdict, and returns structured JSON. The Flutter client renders this data in the `WeatherCard` widget. Weather failures are non-blocking, but they are no longer silent: the dashboard now shows a lightweight retry card so live configuration or upstream failures are visible.

## Navigation

The app currently uses a shared shell with primary navigation for:

- Dashboard
- Clients
- Dogs
- Walks
- Walkers
- Invoices

Detail, create, and edit flows are routed through `AppRouter`.

---
<p align="center">
  Built in Wales ❤️ Designed with Cwtch<br/>
  Adeiladwyd yng Nghymru ❤️ Dyluniwyd gyda Cwtch
</p>
