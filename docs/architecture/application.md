<img src="../../brand/app_icon_base.svg" alt="CiCwtch Logo" align="left" height="60" />
<!-- HEADER BADGES -->
<p align="right">
<a href="https://github.com/nathcymru/CiCwtch/actions/workflows/ci.yml"><img src="https://img.shields.io/github/actions/workflow/status/nathcymru/CiCwtch/ci.yml?branch=main&style=for-the-badge" alt="Build Status" /></a>
&nbsp;
<a href="https://github.com/nathcymru/CiCwtch/releases"><img src="https://img.shields.io/github/v/tag/nathcymru/CiCwtch?sort=semver&style=for-the-badge&label=Release" alt="Release" /></a>
&nbsp;
  <a href="https://github.com/nathcymru/CiCwtch/commits/main"><img src="https://img.shields.io/github/last-commit/nathcymru/CiCwtch?style=for-the-badge" alt="Last Commit" /></a>
</p clear="right">

# CiCwtch - Internal Application Architecture (Flutter + Clean Architecture)
## Architecture & Engineering Source of Truth

<p align="left">
  <a href="https://flutter.dev/"><img src="https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white" alt="Flutter" /></a>
  &nbsp;
  <a href="https://developers.cloudflare.com/workers/"><img src="https://img.shields.io/badge/Cloudflare%20Workers-F38020?style=for-the-badge&logo=cloudflare&logoColor=white" alt="Cloudflare Workers" /></a>
  &nbsp;
  <a href="https://developers.cloudflare.com/d1/"><img src="https://img.shields.io/badge/Cloudflare%20D1-F38020?style=for-the-badge&logo=cloudflare&logoColor=white" alt="Cloudflare D1" /></a>
</p>

CiCwtch uses Clean Architecture to keep business rules stable even as UI frameworks, storage engines, and APIs evolve.

---

## 1) Layer responsibilities

### Presentation (Flutter)
- Material 3 / Cupertino widgets only (no web UI frameworks)
- Screen/view composition, navigation, form validation, state management
- **No business logic** (only orchestration and display)

Recommended patterns:
- BLoC / Cubit (preferred) or Provider/Riverpod if consistent
- UI depends on `UseCases` only, never directly on repositories

### Application (Use Cases)
- “verbs” of the system: `RequestBooking`, `ApproveBooking`, `StartVisit`, `CompleteVisit`, `GenerateInvoice`
- Orchestrates domain rules + repositories
- Handles transactions, concurrency boundaries, retries (where appropriate)

### Domain
- Entities: `Client`, `Pet`, `Booking`, `Visit`, `Invoice`, `ComplianceItem`
- Value objects: `Money`, `DateRange`, `GpsTrack`, `Role`
- Interfaces: `BookingRepository`, `VisitRepository`, `InvoiceRepository`
- Pure Dart only (no Flutter imports)

### Data
- Implements repositories:
  - Remote: Workers API client
  - Local: SQLite cache + Outbox queue
- DTO mapping (remote ↔ domain), schema migrations, encryption at rest where required

---

## 2) Suggested folder layout (Flutter)

```text
lib/
  app/
    bootstrap/
    routing/
    theme/
  features/
    bookings/
      presentation/
      application/
      domain/
      data/
    visits/
    invoices/
    compliance/
    auth/
    clients/        ← added Task 08
  shared/
    presentation/
    application/
    domain/
    data/
```

**Rule:** each feature is vertically sliced; shared code is minimal and intentional.

---

## 3) Key abstractions (non-negotiable)

### Repository pattern
All persistence goes through repositories (domain interfaces).  
This enables:
- offline implementations
- test doubles
- future storage swaps (without rewriting the app)

### Outbox pattern (offline sync)
When offline, writes go to a local **Outbox** table with:
- unique id
- entity type
- payload (json)
- created timestamp
- retry count
- last error
- dependency ordering (optional)

This makes sync deterministic and testable.

### Revisioning
Server responses return a `revision` (or `updatedAt`) value used to:
- avoid overwriting newer server state
- detect conflicts cleanly

---

## 5) Domain model layer (Task 06)

Shared domain models live at `flutter/lib/shared/domain/models/`.

- Models are pure Dart — no Flutter imports.
- Each model maps 1:1 to the D1 schema defined in `migrations/0001_initial_schema.sql`.
- JSON field names are snake_case, matching the database column names exactly.
- No code generators — all `fromJson`/`toJson` is explicit.
- This layer constitutes the shared API contract between the Cloudflare Worker and the Flutter client.

Import all models via the barrel file:

```dart
import 'package:cicwtch/shared/domain/models/models.dart';
```

---

## 4) Trade-offs (explicit)

- **Offline-first adds complexity**: conflict resolution and sync ordering must be designed carefully.
- **Workers edge runtime**: great latency, but requires disciplined runtime constraints (cold starts, CPU limits).
- **D1**: excellent for edge SQL use cases, but not positioned as “write-heavy infinite scale” — design accordingly.
- **Single codebase**: reduces feature drift across platforms, but requires careful UX decisions for web vs mobile.

---
<p align="center">
  Built in Wales ❤️ Designed with Cwtch<br/>
  Adeiladwyd yng Nghymru ❤️ Dyluniwyd gyda Cwtch
</p>
