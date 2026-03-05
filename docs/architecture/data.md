# Data Architecture

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
