# Architectural Decision Records (ADRs)

This is the “why” log.  
When a meaningful architectural decision is made, add an ADR entry.

Format:
- Date (YYYY-MM-DD)
- Decision
- Status: Proposed | Accepted | Rejected | Superseded
- Context
- Decision
- Consequences

---

## ADR Index

| Date       | Decision | Status | Why |
|------------|----------|--------|-----|
| 2026-03-05 | Adopt offline-first Outbox sync model | Accepted | Field work requires resilience; prevents write-loss |
| 2026-03-05 | Use Cloudflare Workers as BFF API | Accepted | Edge latency + simple ops + unified API surface |
| 2026-03-05 | Use D1 as primary relational store | Accepted | SQL model fits bookings/invoices; integrates with Workers |
| 2026-03-05 | Use R2 for media/PDF storage | Accepted | Durable object storage + cost-effective |
| 2026-03-05 | Enforce Clean Architecture boundaries | Accepted | Keeps domain stable and testable |

---

## ADR-2026-03-05-01: Offline-first Outbox Sync

**Status:** Accepted

### Context
Walkers may operate without reliable signal. We must support creating visit records, notes, and photos offline without data loss.

### Decision
Use an Outbox pattern in local SQLite. All offline writes are appended to Outbox and synced in order when connectivity returns.

### Consequences
- More complex sync logic (conflicts must be handled)
- Requires careful schema design and deterministic ordering
- Dramatically improves reliability in real-world conditions

---

## ADR-2026-03-05-02: Workers API as Backend-for-Frontend

**Status:** Accepted

### Context
We need one API surface tailored to a Flutter app and low-latency UX across the UK/Europe.

### Decision
Use Cloudflare Workers as a BFF layer to:
- enforce RBAC
- perform server-side validation
- orchestrate D1/R2/Stripe actions

### Consequences
- Need to design within edge runtime constraints
- Simpler ops than traditional server hosting
- Strong performance and good cost profile
