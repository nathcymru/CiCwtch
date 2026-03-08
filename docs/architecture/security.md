# Security & Cross-Cutting Concerns

CiCwtch handles personal data. Security is not optional polish — it is part of the system.

---

## 1) Authentication & sessions

- Auth is implemented via Workers API.
- Clients obtain a session/token after login.
- Tokens are validated server-side for every request.

**Never trust the client** (yes, even your own client).

---

## 2) Authorization (RBAC)

Roles:
- ADMIN, WALKER, CLIENT

Rules:
- A CLIENT can only access their own pets, bookings, invoices, visits.
- A WALKER can access assigned schedule and visit capture for assigned bookings.
- ADMIN can access all tenant data.

Enforce on the API. UI checks are UX only.

---

## 3) Data protection

### In transit
- HTTPS everywhere

### At rest
- D1: platform-managed storage security
- R2: private buckets, signed URLs for controlled access
- Local SQLite: store minimal sensitive data; consider encryption for:
  - auth tokens
  - addresses/phone numbers
  - medical notes (pet)

---

## 4) Error handling strategy

- API errors return:
  - stable error code
  - human-safe message
  - correlation id

Client:
- show actionable error message
- preserve offline writes rather than dropping them
- retries with backoff for transient failures

---

## 5) Concurrency & race conditions

Server must handle:
- two admins approving the same slot concurrently
- double-submission of booking requests
- webhook retries from Stripe (idempotency required)

Techniques:
- idempotency keys
- transactional checks in D1
- unique constraints where appropriate
