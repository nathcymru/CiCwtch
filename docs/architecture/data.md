<img src="../../brand/app_icon_base.svg" alt="CiCwtch Logo" align="left" height="60" />
<!-- HEADER BADGES -->
<p align="right">
<a href="https://github.com/nathcymru/CiCwtch/actions/workflows/ci.yml"><img src="https://img.shields.io/github/actions/workflow/status/nathcymru/CiCwtch/ci.yml?branch=main&style=for-the-badge" alt="Build Status" /></a>
&nbsp;
<a href="https://github.com/nathcymru/CiCwtch/releases"><img src="https://img.shields.io/github/v/tag/nathcymru/CiCwtch?sort=semver&style=for-the-badge&label=Release" alt="Release" /></a>
&nbsp;
  <a href="https://github.com/nathcymru/CiCwtch/commits/main"><img src="https://img.shields.io/github/last-commit/nathcymru/CiCwtch?style=for-the-badge" alt="Last Commit" /></a>
</p clear="right">

# CiCwtch - Data Architecture
## Architecture & Engineering Source of Truth

<p align="left">
  <a href="https://flutter.dev/"><img src="https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white" alt="Flutter" /></a>
  &nbsp;
  <a href="https://developers.cloudflare.com/workers/"><img src="https://img.shields.io/badge/Cloudflare%20Workers-F38020?style=for-the-badge&logo=cloudflare&logoColor=white" alt="Cloudflare Workers" /></a>
  &nbsp;
  <a href="https://developers.cloudflare.com/d1/"><img src="https://img.shields.io/badge/Cloudflare%20D1-F38020?style=for-the-badge&logo=cloudflare&logoColor=white" alt="Cloudflare D1" /></a>
</p>

CiCwtch treats data as a first-class product: it must be consistent, auditable (where needed), and resilient offline.

---

## 1) Canonical data stores

### Server-side (system of record)
- **Cloudflare D1 (SQL)**: canonical relational store
- **Cloudflare R2 (objects)**: photos, PDFs, media attachments

### Client-side (offline capability)
- **SQLite**: cached reads + offline writes + outbox queue

---

## 2) Core entities (conceptual)

- `Client` (pet owner / billing contact)
- `Pet` (belongs to a Client)
- `Walker` (staff member / contractor)
- `WalkSlot` (capacity inventory)
- `BookingRequest` (client asks)
- `Booking` (approved scheduled visit)
- `Visit` (execution record + notes + GPS + media)
- `Invoice` (financial record)
- `ComplianceItem` (insurance/certs/vaccinations expiry etc.)

---

## 3) Conceptual ER diagram (Mermaid)

```mermaid
erDiagram
  CLIENT ||--o{ PET : owns
  WALKER ||--o{ WALKSLOT : has
  WALKSLOT ||--o{ BOOKINGREQUEST : offers
  BOOKINGREQUEST ||--o| BOOKING : becomes
  BOOKING ||--o{ VISIT : produces
  CLIENT ||--o{ INVOICE : billed
  INVOICE ||--o{ INVOICE_LINE : contains
  CLIENT ||--o{ COMPLIANCE_ITEM : tracks
  PET ||--o{ COMPLIANCE_ITEM : tracks

  CLIENT {
    string id PK
    string name
    string email
    string phone
    string billingAddress
    datetime createdAt
  }

  PET {
    string id PK
    string clientId FK
    string name
    string breed
    string notes
    datetime createdAt
  }

  BOOKINGREQUEST {
    string id PK
    string petId FK
    string walkSlotId FK
    string status
    datetime requestedAt
  }

  BOOKING {
    string id PK
    string bookingRequestId FK
    string walkerId FK
    datetime startAt
    datetime endAt
    string status
  }

  VISIT {
    string id PK
    string bookingId FK
    string summary
    string gpsTrackRef
    datetime startedAt
    datetime completedAt
  }

  INVOICE {
    string id PK
    string clientId FK
    string status
    string stripeRef
    datetime issuedAt
    datetime paidAt
  }
```

---

## 4) Consistency rules (server)

- Capacity cannot be over-allocated:
  - Approving a booking is a transaction: check capacity → allocate → commit.
- A `Visit` must reference a valid `Booking`.
- Invoice status is updated only by:
  - Admin action (issue/cancel) and/or
  - Stripe webhook reconciliation (paid/failed)

---

## 5) Offline sync rules (client)

- Local SQLite is the source of truth while offline.
- Outbox items are applied in deterministic order.
- If the server rejects a write due to conflict:
  - Store server response and mark item “NEEDS_ATTENTION”
  - UI surfaces a “Resolve” action (policy varies by entity)

**Principle:** silent data loss is forbidden.

---
<p align="center">
  Built in Wales ❤️ Designed with Cwtch<br/>
  Adeiladwyd yng Nghymru ❤️ Dyluniwyd gyda Cwtch
</p>
