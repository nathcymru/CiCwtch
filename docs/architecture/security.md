<img src="../../brand/app_icon_base.svg" alt="CiCwtch Logo" align="left" height="60" />
<!-- HEADER BADGES -->
<p align="right">
<a href="https://github.com/nathcymru/CiCwtch/actions/workflows/ci.yml"><img src="https://img.shields.io/github/actions/workflow/status/nathcymru/CiCwtch/ci.yml?branch=main&style=for-the-badge" alt="Build Status" /></a>
&nbsp;
<a href="https://github.com/nathcymru/CiCwtch/releases"><img src="https://img.shields.io/github/v/tag/nathcymru/CiCwtch?sort=semver&style=for-the-badge&label=Release" alt="Release" /></a>
&nbsp;
  <a href="https://github.com/nathcymru/CiCwtch/commits/main"><img src="https://img.shields.io/github/last-commit/nathcymru/CiCwtch?style=for-the-badge" alt="Last Commit" /></a>
</p clear="right">

# CiCwtch - Security & Cross-Cutting Concerns
## Architecture & Engineering Source of Truth

<p align="left">
  <a href="https://flutter.dev/"><img src="https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white" alt="Flutter" /></a>
  &nbsp;
  <a href="https://developers.cloudflare.com/workers/"><img src="https://img.shields.io/badge/Cloudflare%20Workers-F38020?style=for-the-badge&logo=cloudflare&logoColor=white" alt="Cloudflare Workers" /></a>
  &nbsp;
  <a href="https://developers.cloudflare.com/d1/"><img src="https://img.shields.io/badge/Cloudflare%20D1-F38020?style=for-the-badge&logo=cloudflare&logoColor=white" alt="Cloudflare D1" /></a>
</p>

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

---
<p align="center">
  Built in Wales ❤️ Designed with Cwtch<br/>
  Adeiladwyd yng Nghymru ❤️ Dyluniwyd gyda Cwtch
</p>
