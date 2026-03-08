<img src="../../brand/app_icon_base.svg" alt="CiCwtch Logo" align="left" height="60" />
<!-- HEADER BADGES -->
<p align="right">
<a href="https://github.com/nathcymru/CiCwtch/actions/workflows/ci.yml"><img src="https://img.shields.io/github/actions/workflow/status/nathcymru/CiCwtch/ci.yml?branch=main&style=for-the-badge" alt="Build Status" /></a>
&nbsp;
<a href="https://github.com/nathcymru/CiCwtch/releases"><img src="https://img.shields.io/github/v/tag/nathcymru/CiCwtch?sort=semver&style=for-the-badge&label=Release" alt="Release" /></a>
&nbsp;
  <a href="https://github.com/nathcymru/CiCwtch/commits/main"><img src="https://img.shields.io/github/last-commit/nathcymru/CiCwtch?style=for-the-badge" alt="Last Commit" /></a>
</p clear="right">

# CiCwtch - Architecture Diagrams (Mermaid)
## Architecture & Engineering Source of Truth

<p align="left">
  <a href="https://flutter.dev/"><img src="https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white" alt="Flutter" /></a>
  &nbsp;
  <a href="https://developers.cloudflare.com/workers/"><img src="https://img.shields.io/badge/Cloudflare%20Workers-F38020?style=for-the-badge&logo=cloudflare&logoColor=white" alt="Cloudflare Workers" /></a>
  &nbsp;
  <a href="https://developers.cloudflare.com/d1/"><img src="https://img.shields.io/badge/Cloudflare%20D1-F38020?style=for-the-badge&logo=cloudflare&logoColor=white" alt="Cloudflare D1" /></a>
</p>

This file contains the **canonical diagrams**.  
When changing architecture, update these diagrams first — they are the quickest way to spot broken assumptions.

---

## 1) C4 — System Context

```mermaid
flowchart LR
  subgraph Users
    C[Client\n(Pet Owner)]
    W[Walker\n(Field Staff)]
    A[Admin\n(Business Owner)]
  end

  subgraph CiCwtch["CiCwtch Platform"]
    App[Flutter App\nWeb / iOS / Android]
    API[Cloudflare Workers\nBFF API]
  end

  subgraph External["External Systems"]
    Stripe[Stripe\nPayments & Subscriptions]
    Maps[Maps Provider\nGoogle/Apple]
    Notify[Push Notifications\nAPNs/FCM/Web Push]
  end

  DB[(Cloudflare D1\nRelational Data)]
  OBJ[(Cloudflare R2\nObjects: photos, PDFs)]

  C -->|use| App
  W -->|use| App
  A -->|use| App

  App -->|HTTPS JSON| API
  API -->|SQL| DB
  API -->|PUT/GET objects| OBJ

  API -->|payments webhooks / intents| Stripe
  App -->|location / routing| Maps
  API -->|send notifications| Notify
```

---

## 2) C4 — Container Diagram

```mermaid
flowchart TB
  subgraph ClientTier["Client Tier"]
    Flutter[Flutter App\nWeb / iOS / Android]
    Local[(Local SQLite\nOffline Cache + Outbox)]
  end

  subgraph EdgeTier["Edge Tier (Cloudflare)"]
    Worker[Workers API\nBackend-for-Frontend]
    D1[(D1 SQL)]
    R2[(R2 Object Store)]
  end

  subgraph ThirdParty["Third Party"]
    Stripe[Stripe]
    Maps[Maps]
  end

  Flutter <--> Local
  Flutter -->|HTTPS JSON| Worker
  Worker --> D1
  Worker --> R2
  Worker --> Stripe
  Flutter --> Maps
```

---

## 3) Clean Architecture Layering (App internals)

```mermaid
flowchart LR
  UI[Presentation\nFlutter UI + State]
  UC[Application\nUse Cases]
  DM[Domain\nEntities + Interfaces]
  DT[Data\nRepo Implementations]

  UI --> UC --> DM
  DT --> DM
  UC --> DT
```

---

## 4) “Happy Path” — Client booking request → approval

```mermaid
sequenceDiagram
  autonumber
  participant C as Client App
  participant API as Workers API
  participant D as D1
  participant A as Admin App

  C->>API: GET /slots?date=YYYY-MM-DD
  API->>D: Query capacity + availability
  D-->>API: Slots
  API-->>C: Slots

  C->>API: POST /booking-requests {petId, slotId}
  API->>D: Insert BookingRequest (PENDING_APPROVAL)
  D-->>API: bookingRequestId
  API-->>C: 202 Accepted + requestId

  API-->>A: Notify "New booking request"
  A->>API: POST /booking-requests/{id}/approve
  API->>D: Update status APPROVED + allocate capacity
  API-->>A: 200 OK
  API-->>C: Notify "Booking approved"
```

---

## 5) Offline walk execution → sync

```mermaid
sequenceDiagram
  autonumber
  participant W as Walker UI
  participant L as Local SQLite
  participant S as Sync Manager
  participant API as Workers API
  participant D as D1
  participant R as R2

  W->>L: Start Visit (timestamp, bookingId)
  W->>L: Add Notes, Events
  W->>L: Capture Photo (store file ref)
  W->>L: End Visit (gpsRoute)

  Note over W,L: While offline, local is the source of truth.

  loop background sync when connectivity available
    S->>L: Load Outbox items (ordered)
    L-->>S: Pending writes
    S->>API: POST /visits {payload}
    API->>D: Upsert visit record
    API->>R: Upload photos (if present)
    API-->>S: 200 OK + server revision
    S->>L: Mark outbox item ACK + store revision
  end
```

---

## 6) Payment flow — invoice → Stripe → webhook reconciliation

```mermaid
sequenceDiagram
  autonumber
  participant A as Admin App
  participant API as Workers API
  participant D as D1
  participant S as Stripe
  participant C as Client App

  A->>API: POST /invoices {clientId, items}
  API->>D: Insert invoice (UNPAID)
  API->>S: Create PaymentIntent / Invoice
  S-->>API: Stripe reference ids
  API->>D: Save Stripe ids on invoice
  API-->>A: Invoice created

  C->>API: GET /invoices/{id}
  API->>D: Read invoice + status
  API-->>C: Invoice + pay link / client secret

  C->>S: Pay via Stripe UI
  S-->>API: Webhook payment_succeeded
  API->>D: Update invoice PAID + ledger entry
  API-->>C: Notify "Payment received"
```

---
<p align="center">
  Built in Wales ❤️ Designed with Cwtch<br/>
  Adeiladwyd yng Nghymru ❤️ Dyluniwyd gyda Cwtch
</p>
