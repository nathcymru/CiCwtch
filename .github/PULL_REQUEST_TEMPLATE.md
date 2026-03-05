# Pull Request: CiCwtch

## Summary
<!-- What does this PR change? Keep it clear and specific. -->

## Why
<!-- Why is this change needed? Link to issue(s) or explain the user/problem. -->
- Closes: #
- Related: #

## Type of Change
<!-- Mark with an x -->
- [ ] Bug fix
- [ ] Feature
- [ ] Refactor (no behaviour change)
- [ ] Performance improvement
- [ ] Documentation only
- [ ] Build/CI or tooling
- [ ] Security fix
- [ ] Breaking change

## Scope
<!-- Mark with an x (add more if relevant) -->
- [ ] Client Portal (Pet Owner)
- [ ] Admin/Walker App
- [ ] Auth / RBAC (roles/permissions)
- [ ] Bookings / Slots / Approvals
- [ ] Visit Records / Media
- [ ] Invoicing / Payments / Vouchers
- [ ] Rewards / Loyalty
- [ ] Compliance
- [ ] Notifications
- [ ] Maps / GPS Tracking
- [ ] Offline / Sync / Caching
- [ ] Web platform specifics
- [ ] iOS platform specifics
- [ ] Android platform specifics
- [ ] API / Backend integration

---

## Architecture Impact (Required)
<!-- Be explicit about the Clean Architecture layers you touched and why. -->
### Layers changed
- [ ] Presentation (UI)
- [ ] Application (use cases / state)
- [ ] Domain (entities / contracts)
- [ ] Data (repositories / models / persistence / API clients)

### Notes
<!--
- New use cases introduced?
- Changes to routing or navigation?
- State management changes (Riverpod providers, scopes)?
- Any new abstractions (repositories, services, adapters)?
-->

### Risks / Trade-offs
<!-- What might be fragile? What assumptions are being made? -->

---

## Database Schema Changes (Required if applicable)
- [ ] No DB changes
- [ ] DB changes included

### Summary of DB changes
<!--
List tables/collections and fields added/changed/removed.
Include the purpose and any backwards-compat considerations.
-->

### Migration Plan
<!--
If you have migrations, document them:
- migration identifier/version
- steps to apply
- steps to rollback (if possible)
- data backfill notes
-->

### Data Integrity & Backwards Compatibility
<!--
- Are existing records safe?
- Default values?
- Nullability changes?
- Any destructive changes?
-->

---

## API Changes (Required if applicable)
- [ ] No API changes
- [ ] API changes included

### Endpoints affected
<!--
List any endpoints (client-facing and admin) impacted.
Example:
- GET /api/v1/client/slots
- POST /api/v1/client/bookings
- POST /api/v1/admin/bookings/{id}/approve
-->

### Contract changes
<!--
- request/response body changes
- query param changes
- status code changes
- auth/roles changes
-->

### Versioning / Compatibility
<!--
If the API is consumed by released clients, note how this remains compatible
or what version bump / feature flag is used.
-->

---

## UI Evidence (Required)
### Mobile screenshots (iOS / Android)
<!-- Paste screenshots or screen recordings. If unchanged, state why. -->

### Web screenshots
<!-- Include desktop and at least one smaller viewport breakpoint. -->

### Accessibility Notes
<!--
- Semantics/labels added?
- Keyboard navigation for web verified?
- Focus order and tap targets OK?
-->

---

## Testing
### Local verification (Required)
<!-- Mark what you actually ran -->
- [ ] `flutter pub get`
- [ ] `flutter analyze`
- [ ] `flutter test`
- [ ] Web: `flutter run -d chrome`
- [ ] Android: `flutter run -d <device>`
- [ ] iOS: `flutter run -d <device>`

### Test notes
<!--
- Which scenarios did you test?
- Any test gaps?
- Any flaky tests or follow-ups needed?
-->

---

## Migration Steps (Required if applicable)
- [ ] No migration required
- [ ] Migration required

### Steps for reviewers / deployers
<!--
Example:
1) Run bootstrap script / regenerate platforms (if needed)
2) Apply DB migration
3) Update environment variables
4) Clear caches / re-seed data
5) Smoke test key flows
-->

### Environment / Config changes
<!--
List new/changed env vars, secrets, build flags, API base URLs, etc.
-->

---

## Security & Privacy
- [ ] No security impact
- [ ] Security impact reviewed

### Notes
<!--
- Auth/role checks enforced?
- Sensitive fields not logged?
- Secure storage used for tokens?
- Media access permissions correct for iOS/Android?
-->

---

## Checklist (Must be completed)
- [ ] No business logic in widgets (Clean Architecture respected)
- [ ] Changes are role-safe (client cannot access admin data)
- [ ] Web-first routing works (deep links, refresh, back button)
- [ ] No placeholder/lite implementations for the feature shipped
- [ ] Errors handled gracefully (network failures, offline, retries)
- [ ] Any new dependency is justified and version-pinned
- [ ] Documentation updated where needed (URS / README / docs)

---

## Reviewer Notes
<!-- What should the reviewer focus on? What is most important to verify? -->
