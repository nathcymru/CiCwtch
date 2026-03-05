# Internal Application Architecture (Flutter + Clean Architecture)

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

## 4) Trade-offs (explicit)

- **Offline-first adds complexity**: conflict resolution and sync ordering must be designed carefully.
- **Workers edge runtime**: great latency, but requires disciplined runtime constraints (cold starts, CPU limits).
- **D1**: excellent for edge SQL use cases, but not positioned as “write-heavy infinite scale” — design accordingly.
- **Single codebase**: reduces feature drift across platforms, but requires careful UX decisions for web vs mobile.
