# CiCwtch Architecture (Source of Truth)

> CiCwtch is a cross-platform (Web, iOS, Android) pet-care operations platform for dog walkers and their clients, built to bring *quiet order* to scheduling, walking, compliance, and billing — including **offline-first** field execution.

This documentation is the **source of truth** for how the system is intended to work.  
If the code and this doc disagree, **the doc is lying** — update it or fix the code. ✅

---

## 1) System purpose

CiCwtch provides a single, coherent workflow from:
- **Client** discovering availability → requesting a booking
- **Walker/Admin** approving and executing visits
- **Billing** producing invoices and collecting payment
- **Compliance** tracking required documents and expiries

All of this must work reliably in **low connectivity** conditions typical of rural trails and field work.

### Worker API module structure

The Cloudflare Worker API layer is structured as four modules:

- `src/index.ts` — entry point; delegates to router, catches `ApiError` and unhandled errors
- `src/router.ts` — routes requests to handlers; passes `env` (including `env.DB`) through for D1 access
- `src/response.ts` — `jsonOk()` / `jsonError()` helpers; all responses use `Content-Type: application/json`
- `src/errors.ts` — `ApiError` class with `status`, `message`, and `type` fields

Health endpoints: `GET /health` and `GET /api/v1/health` → `{"status":"ok","service":"cicwtch-api"}`  
Error response shape: `{"error":{"message":"...","type":"..."}}`  
All business routes are versioned under `/api/v1/`.

#### Clients CRUD (live)

| Method | Path | Description |
|--------|------|-------------|
| GET | `/api/v1/clients` | List non-archived clients, sorted by `full_name ASC` |
| GET | `/api/v1/clients/:id` | Get single non-archived client |
| POST | `/api/v1/clients` | Create client (`full_name` required) |
| PUT | `/api/v1/clients/:id` | Update client (`full_name` required) |
| DELETE | `/api/v1/clients/:id` | Soft-delete (sets `archived_at`) |

---

## 2) Personas & access

### Primary personas
- **Client (Pet Owner)**  
  Browse services, request/confirm bookings, view invoices, receive walk updates (notes/photos), manage pets.
- **Walker (Staff / Contractor)**  
  View schedule, execute visits, record notes/media, complete walks offline, sync later.
- **Admin (Business Owner / Dispatcher)**  
  Manage clients/pets/walkers, configure capacity, approve requests, handle billing, compliance, reporting.

### System roles (RBAC)
- `ADMIN`
- `WALKER`
- `CLIENT`

RBAC is enforced **server-side** (Cloudflare Worker) and mirrored in the UI for UX only (never trusted).

---

## 3) Scope boundaries

### Inside this repository
- Flutter app (Web/iOS/Android) — **pure Flutter widgets** (Material 3 / Cupertino)
- Domain + application use-cases (clean architecture)
- Data layer clients (D1, R2, Stripe via Workers API)
- Offline persistence and sync queue

### Outside this repository
- Cloudflare platform runtime (Workers, D1, R2)
- Stripe payment processing and subscription lifecycle
- Maps provider (Google / Apple), location services
- Push notification delivery infrastructure (provider may vary per platform)

---

## 4) How to navigate this architecture
- **Diagrams & “Big Picture”** → `docs/architecture/diagrams.md`
- **App internals (Clean Architecture)** → `docs/architecture/application.md`
- **Data model & flows** → `docs/architecture/data.md`
- **Infra, environments, CI/CD** → `docs/architecture/infrastructure.md`
- **Security & cross-cutting concerns** → `docs/architecture/security.md`
- **Architectural Decision Records (ADRs)** → `docs/architecture/decisions.md`

---

## 5) Living-doc rule (non-negotiable)

Any PR that changes:
- domain entities,
- API contracts,
- persistence schemas,
- auth/roles,
- offline sync behaviour,
- infrastructure,

…must update at least one of the docs in `docs/architecture/`.

If this becomes a lie, it becomes worse than useless. 🙂
