<img src="../brand/app_icon_base.svg" alt="CiCwtch Logo" align="left" height="60" />
<!-- HEADER BADGES -->
<p align="right">
<a href="https://github.com/nathcymru/CiCwtch/actions/workflows/ci.yml"><img src="https://img.shields.io/github/actions/workflow/status/nathcymru/CiCwtch/ci.yml?branch=main&style=for-the-badge" alt="Build Status" /></a>
&nbsp;
<a href="https://github.com/nathcymru/CiCwtch/releases"><img src="https://img.shields.io/github/v/tag/nathcymru/CiCwtch?sort=semver&style=for-the-badge&label=Release" alt="Release" /></a>
&nbsp;
  <a href="https://github.com/nathcymru/CiCwtch/commits/main"><img src="https://img.shields.io/github/last-commit/nathcymru/CiCwtch?style=for-the-badge" alt="Last Commit" /></a>
</p clear="right">

# CiCwtch - CiCwtch — User Requirements Specification (URS)
## Project Documentation

<p align="left">
  <a href="https://flutter.dev/"><img src="https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white" alt="Flutter" /></a>
  &nbsp;
  <a href="https://developers.cloudflare.com/workers/"><img src="https://img.shields.io/badge/Cloudflare%20Workers-F38020?style=for-the-badge&logo=cloudflare&logoColor=white" alt="Cloudflare Workers" /></a>
  &nbsp;
  <a href="https://developers.cloudflare.com/d1/"><img src="https://img.shields.io/badge/Cloudflare%20D1-F38020?style=for-the-badge&logo=cloudflare&logoColor=white" alt="Cloudflare D1" /></a>
</p>

Product: CiCwtch Platforms: Web, iOS, Android Technology: Flutter (Dart)
single codebase Architecture: Clean Architecture (Presentation /
Application / Domain / Data) UI Requirement: Pure Flutter (Material 3 /
Cupertino).

------------------------------------------------------------------------

# 1. Purpose and Scope

CiCwtch is a cross-platform dog-walking business management platform
designed to run from a single Flutter codebase supporting Web, iOS, and
Android.

The system supports the operational lifecycle of a professional
dog-walking business including: - Client and pet management - Walk
scheduling and slot inventory - Booking requests and approvals - Walk
execution and GPS tracking - Visit records and media - Invoicing and
payments - Loyalty rewards and vouchers - Compliance tracking -
Operational dashboards - Client self-service portal

The system must scale from single-walker operations to multi-walker
businesses.

------------------------------------------------------------------------

# 2. Target Users

## Dog Walker

Manages daily operations including walks, bookings, and visit records.

## Admin / Owner

Controls pricing, walker management, compliance records, and booking
approvals.

## Client / Pet Owner

Client portal for: - managing pet profiles - requesting bookings -
viewing invoices - applying vouchers - viewing rewards - receiving visit
summaries

Client access is restricted by role (role=client).

------------------------------------------------------------------------

# 3. Build Rules

## Flutter Purity

UI must use Flutter widgets only. Material 3 default design system.
Cupertino components used where appropriate.

Disallowed: - Bootstrap - HTML/CSS UI frameworks - UI wrappers around
HTML.

## Clean Architecture

Enforce separation: Presentation Application Domain Data

Business logic must not exist in widgets.

## Dependency Discipline

Use stable packages and pin versions in pubspec.yaml.

## Cross Platform Requirements

Web must support responsive layouts and keyboard navigation. Mobile must
support native conventions and offline resilience.

------------------------------------------------------------------------

# 4. Functional Requirements

## Authentication

FR-001 Secure login and logout. FR-002 Persistent sessions. FR-003
Password reset. FR-004 Role based access.

## Core Entities

FR-010 System manages: Client Dog / Pet Walker Booking Walk Slot Visit
Record Invoice Payment Compliance Item Incident Reward Campaign Voucher
Walker Leave

## Walk Slots and Booking Requests

FR-020 Walk slots represent available booking inventory. FR-021 Slots
include start time, end time, walk type, capacity and walker assignment.
FR-022 Clients browse available slots. FR-023 Clients request bookings
for pets. FR-024 Requests validate slot capacity and pet ownership.
FR-025 Booking requests begin as PENDING_APPROVAL. FR-026 Admin approves
or rejects requests.

## Visit Records

FR-030 Walkers create visit records linked to bookings. FR-031 Visit
records include notes, incidents, and photos.

## Walk Execution

FR-040 Walk sessions record start/end times. FR-041 GPS route tracking
supported. FR-042 Routes displayed in visit records.

## Client Portal

FR-050 Clients update profile. FR-051 Clients manage pet profiles.
FR-052 Clients request bookings. FR-053 Clients view bookings and
invoices. FR-054 Clients apply voucher codes.

## Invoices

FR-060 Invoices generated from bookings. FR-061 Invoice statuses: Draft,
Issued, Paid, Overdue, Void. FR-062 Payments recorded. FR-063 PDF export
supported.

## Rewards

FR-070 Admin defines reward campaigns. FR-071 Rewards issued to clients.
FR-072 Clients view rewards. FR-073 Vouchers apply discounts to
invoices.

## Compliance

FR-080 Compliance templates defined. FR-081 Expiry tracking supported.
FR-082 Dashboard shows compliance status.

## Search

FR-090 Global search across clients, pets and bookings.

## Notifications

FR-100 Booking reminders. FR-101 Compliance expiry alerts. FR-102 Mobile
notifications supported.

## Dashboard

FR-110 Dashboard displays: today’s bookings outstanding invoices
expiring compliance upcoming walks

------------------------------------------------------------------------

# 5. Non Functional Requirements

## Code Quality

NFR-001 Dart/Flutter codebase only. NFR-002 CI linting required. NFR-003
Unit and widget tests required.

## Performance

NFR-010 60fps UI performance target. NFR-011 Fast startup time.

## Security

NFR-020 Secure credential storage. NFR-021 Least privilege data access.

## Offline

NFR-030 Cached data viewing. NFR-031 Offline write queue.

## Accessibility

NFR-040 Text scaling. NFR-041 Keyboard navigation.

------------------------------------------------------------------------

# 6. UI Requirements

UIR-001 Material 3 theming. UIR-002 Responsive layouts.

Mobile: bottom navigation

Tablet/Web: navigation rail

UIR-003 Forms include validation and error states.

------------------------------------------------------------------------

# 7. Data Storage

DSR-001 Repository pattern single source of truth. DSR-002 Data models
versioned.

------------------------------------------------------------------------

# 8. Deployment

DEP-001 Web builds produce deployable static assets. DEP-002 iOS builds
App Store ready. DEP-003 Android builds Play Store ready. DEP-004 CI
verifies builds.

------------------------------------------------------------------------

# 9. Acceptance Criteria

Release candidate requires: - Web, iOS and Android builds functioning -
Clean architecture compliance - Linting and tests passing

Core flows:

Admin: Login → create client/pet → create slot → approve booking →
complete walk → invoice → payment

Client: Login → manage pets → request booking → view bookings → view
invoice → apply voucher → view rewards

------------------------------------------------------------------------

# 10. Out of Scope

-   Public walker marketplace
-   Payroll
-   Insurance integrations
-   Marketing automation

------------------------------------------------------------------------

# 11. AI Build Instructions

AI must: - generate a full Flutter project - enforce clean
architecture - avoid non-Flutter UI frameworks - implement production
grade routing, storage and authentication

---
<p align="center">
  Built in Wales ❤️ Designed with Cwtch<br/>
  Adeiladwyd yng Nghymru ❤️ Dyluniwyd gyda Cwtch
</p>
