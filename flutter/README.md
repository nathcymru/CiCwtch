# CiCwtch Flutter App

This is the primary Flutter application root for CiCwtch.

## Included in this starter

- `lib/main.dart` with a minimal branded application shell
- `test/widget_test.dart` for a basic widget smoke test
- `web/` assets so GitHub Actions can run `flutter build web`
- `pubspec.yaml` and `analysis_options.yaml`

## Important note about native wrappers

This repository pack includes a lean app starter rather than a full machine-generated Flutter project.

To generate or refresh native platform wrappers locally, run the following from inside this folder after installing Flutter:

```bash
flutter create . --platforms=android,ios,web
```

That command will preserve your existing Dart code while generating the platform-specific folders and metadata.

## Local checks

```bash
flutter pub get
flutter analyze
flutter test
flutter run -d chrome
```

## Domain models

Plain Dart models live in `lib/shared/domain/models/`. Import them all via the barrel file:

```dart
import 'package:cicwtch/shared/domain/models/models.dart';
```

Key points:

- Each model corresponds directly to a table in the D1 database (`migrations/0001_initial_schema.sql`).
- JSON keys in `fromJson` / `toJson` are **snake_case**, matching the database column names exactly.
- Dart property names are the **camelCase** equivalents (e.g. `full_name` → `fullName`).
- SQLite `INTEGER` boolean columns (stored as `0`/`1`) are mapped to Dart `bool`:
  - `fromJson`: `(json['field'] as int) == 1`
  - `toJson`: `value ? 1 : 0`
- No code generators are used — all `fromJson` / `toJson` implementations are explicit plain Dart.
- No Flutter imports — model files are pure Dart.

## Features

### Clients

Clients CRUD is implemented at `lib/features/clients/`. Screens:

- **Clients list** — `ClientsListScreen` — lists active clients; FAB to create; tap to view detail.
- **Client detail** — `ClientDetailScreen` — shows full client record; edit and archive actions.
- **Create client** — `ClientCreateScreen` / `ClientFormScreen` — form with required `full_name`.
- **Edit client** — `ClientEditScreen` / `ClientFormScreen` — pre-populated form; saves via `PUT /api/v1/clients/:id`.

API dependency: `/api/v1/clients` (GET, POST, GET /:id, PUT /:id, DELETE /:id).

### Dogs

Dogs CRUD is implemented at `lib/features/dogs/`. Screens:

- **Dogs list** — `DogsListScreen` — lists all dogs; FAB to create; tap to view detail.
- **Dog detail** — `DogDetailScreen` — shows full dog record including breed, sex, neutered status, medical, behavioural, and feeding notes; edit and archive actions.
- **Create dog** — `DogCreateScreen` / `DogFormScreen` — form with required `name` and `client_id`; optional breed, sex, neutered, date of birth, colour, microchip, vet practice, and notes fields.
- **Edit dog** — `DogEditScreen` / `DogFormScreen` — pre-populated form; saves via `PUT /api/v1/dogs/:id`.
- **Archive dog** — confirmation dialog; calls `DELETE /api/v1/dogs/:id`; returns to list on success.

API dependency: `/api/v1/dogs` (GET, POST, GET /:id, PUT /:id, DELETE /:id).

### Walks

Walks CRUD is implemented at `lib/features/walks/`. Screens:

- **Walks list** — `WalksListScreen` — lists active walks; FAB to create; tap to view detail.
- **Walk detail** — `WalkDetailScreen` — shows full walk record including scheduled date/times, status, service type, dog ID, walker ID, and notes; edit and archive actions.
- **Create walk** — `WalkCreateScreen` / `WalkFormScreen` — form with required `client_id`, `dog_id`, `scheduled_date`, `status` (defaults to `planned`), and `service_type`; optional walker ID, start/end times, and notes.
- **Edit walk** — `WalkEditScreen` / `WalkFormScreen` — pre-populated form; saves via `PUT /api/v1/walks/:id`.
- **Archive walk** — confirmation dialog; calls `DELETE /api/v1/walks/:id`; returns to list on success.

API dependency: `/api/v1/walks` (GET, POST, GET /:id, PUT /:id, DELETE /:id).

#### Walk status presentation and completion recording (Task 22)

Walk status is presented using `WalkStatusBadge`, a shared widget at `lib/shared/presentation/walk_status_badge.dart`.

- **`planned`** — grey badge
- **`in_progress`** — amber badge
- **`completed`** — green badge
- **`cancelled`** — red badge

The badge is used in the walks list (subtitle area), the walk detail screen (status section), and the status dropdown in the create/edit form.

#### Completion recording fields (Task 22)

When a walk status is set to **In progress** or **Completed**, the create/edit form surfaces a **Completion recording** section exposing:

- `actual_start_time` — actual time the walk started (HH:MM)
- `actual_end_time` — actual time the walk ended (HH:MM)

These fields are already present on the `Walk` model and stored in the D1 schema. They are hidden when the status is `Planned` or `Cancelled` to keep the form clean.

The `notes` field remains available for all statuses and is appropriate for recording cancellation context.

**Out of scope:** GPS tracking, live telemetry, route replay, maps, media uploads, customer messaging, and walk report management are not implemented by this task.

### Walkers

Walkers CRUD is implemented at `lib/features/walkers/`. Screens:

- **Walkers list** — `WalkersListScreen` — lists active walkers; FAB to create; tap to view detail.
- **Walker detail** — `WalkerDetailScreen` — shows full walker record including name, phone, email, role, start date, active status, and notes; edit and archive actions.
- **Create walker** — `WalkerCreateScreen` / `WalkerFormScreen` — form with required `full_name`; optional phone, email, role title, start date, active toggle, and notes.
- **Edit walker** — `WalkerEditScreen` / `WalkerFormScreen` — pre-populated form; saves via `PUT /api/v1/walkers/:id`.
- **Archive walker** — confirmation dialog; calls `DELETE /api/v1/walkers/:id`; returns to list on success.

API dependency: `/api/v1/walkers` (GET, POST, GET /:id, PUT /:id, DELETE /:id).

### Invoices

Invoices CRUD is implemented at `lib/features/invoices/`. Screens:

- **Invoices list** — `InvoicesListScreen` — lists active invoice headers; FAB to create; tap to view detail; searchable by invoice number, client ID, and status. Each list item shows a colour-coded status badge and due date where available.
- **Invoice detail** — `InvoiceDetailScreen` — shows full invoice header record; status is displayed as a colour-coded badge at the top of the detail view, followed by invoice number, client ID, currency, issue and due dates, and notes; edit and archive actions.
- **Create invoice** — `InvoiceCreateScreen` / `InvoiceFormScreen` — form with required `client_id`, `invoice_number`, and `currency_code`; status dropdown shows colour-coded badges for each option (draft/issued/paid/cancelled, defaults to draft); optional issue date, due date, and notes (shown under a "Payment tracking" section heading).
- **Edit invoice** — `InvoiceEditScreen` / `InvoiceFormScreen` — pre-populated form; saves via `PUT /api/v1/invoice-headers/:id`.
- **Archive invoice** — confirmation dialog; calls `DELETE /api/v1/invoice-headers/:id`; returns to list on success.

API dependency: `/api/v1/invoice-headers` (GET, POST, GET /:id, PUT /:id, DELETE /:id).

#### Invoice status presentation (Task 21)

Invoice status is presented using `InvoiceStatusBadge`, a shared widget at `lib/shared/presentation/invoice_status_badge.dart`.

- **`draft`** — grey badge
- **`issued`** — blue badge
- **`paid`** — green badge
- **`cancelled`** — red badge

The badge is used in the invoices list (subtitle area), the invoice detail screen (first row), and the status dropdown in the create/edit form.

#### Payment tracking fields (Task 21)

The notes field on invoice create/edit is surfaced under a **Payment tracking** section heading to make its use as an internal tracking field clear. This is a UX labelling improvement only.

**Out of scope:** Payment processing, external payment gateways, PDF generation, email sending, invoice line management, paid_on date fields, payment reference fields, and document generation are not included and remain future work.

### Dashboard

The dashboard overview screen is implemented at `lib/features/dashboard/`. It provides a summary view of active resources and quick navigation to core areas of the app.

- **Overview metric cards** — active counts for Clients, Dogs, Walks, and Walkers, derived from live API data.
- **Upcoming walks** — a short list of the 5 most recently scheduled non-archived walks, sorted by `scheduled_date` descending.
- **Quick navigation** — `ListTile` links to Clients, Dogs, Walks, and Walkers list screens.

API dependencies: `/api/v1/clients`, `/api/v1/dogs`, `/api/v1/walks`, `/api/v1/walkers` (GET list endpoints only).

All four endpoints are called in parallel on screen load. Partial failure is surfaced with an error message and a Retry button.

## App shell and navigation

The shared navigation shell lives at `lib/app/shell/app_shell.dart`.

`AppShell` is the app entry point (set as `home:` in `MaterialApp`). The old `HomePage` starter has been removed.

Primary navigation destinations (in order):

| # | Section | Icon |
|---|---------|------|
| 1 | Dashboard | `Icons.dashboard` |
| 2 | Clients | `Icons.people` |
| 3 | Dogs | `Icons.pets` |
| 4 | Walks | `Icons.directions_walk` |
| 5 | Walkers | `Icons.badge` |

**Responsive behaviour:**

- Screens ≥ 600 px wide: `NavigationRail` on the left with a `VerticalDivider`, content in an `Expanded` area.
- Screens < 600 px wide: `BottomNavigationBar` with `type: BottomNavigationBarType.fixed` (keeps all labels visible).

**State preservation:**

`IndexedStack` is used to render all five section screens simultaneously, showing only the selected one. This preserves each section's internal navigation state (scroll position, loaded data) when switching tabs.

**Detail, create, and edit screens:**

These screens are pushed on top of the shell via `Navigator.push` / `Navigator.pushNamed` as before. They are full-screen `MaterialPageRoute` pushes and are not embedded in the shell.

## List search and filtering

All four core list screens support lightweight client-side search and filtering. Filtering works against already-loaded data and does not trigger additional API calls.

### Search

Each list screen has a search input at the top of the list area. Results narrow as you type.

| Screen | Fields searched |
|--------|----------------|
| Clients | Full name, preferred name, phone, email |
| Dogs | Name, breed, client ID |
| Walkers | Full name, phone, email, role title |
| Walks | Scheduled date, status, service type, dog ID, walker ID |

Clearing the search field restores the full list.

### Walk status filter

The Walks list also includes a row of status filter chips (`All`, `Planned`, `In progress`, `Completed`, `Cancelled`). Selecting a chip narrows the list to walks with that status. The search field and status filter work together.

### No-matches state

If the loaded data is non-empty but no items match the current search or filter, a clear "no matches" message is shown. The existing empty-data state (shown when no records exist at all) is unchanged.

### Notes

- Filtering is client-side only. The existing list fetch behaviour is unchanged.
- No new packages were introduced.
- Existing CRUD flows (create, detail, edit, archive) are unaffected.

## Shared UX polish (Task 18)

Shared presentation widgets were extracted to `lib/shared/presentation/` to eliminate duplication and ensure consistent UX across all four CRUD feature areas.

### Shared widgets

| Widget / helper | File | Purpose |
|-----------------|------|---------|
| `DetailRow` | `detail_row.dart` | Two-column label/value row for detail screens (label width 160, `labelLarge` style) |
| `FormErrorBanner` | `form_error_banner.dart` | Themed error banner shown above form fields on submit failure |
| `EmptyStateBlock` | `empty_state_block.dart` | Centred icon + message for empty list and no-matches states |
| `ErrorStateBlock` | `error_state_block.dart` | Centred error message + Retry button for load failure states |
| `SectionHeading` | `section_heading.dart` | Small titled section heading for grouping form fields |
| `formatDetailDate` | `form_date_helper.dart` | Formats an ISO datetime string to `dd/MM/yyyy HH:mm` local time |

### Changes applied

- All four detail screens (`client_detail_screen.dart`, `dog_detail_screen.dart`, `walk_detail_screen.dart`, `walker_detail_screen.dart`) now use `DetailRow` and `formatDetailDate` from shared, and `ErrorStateBlock` for load errors. The private `_DetailRow` class and `_formatDate` method have been removed from each file.
- All four form screens (`client_form_screen.dart`, `dog_form_screen.dart`, `walk_form_screen.dart`, `walker_form_screen.dart`) now use `FormErrorBanner` from shared instead of the inline error container.
- All four list screens (`clients_list_screen.dart`, `dogs_list_screen.dart`, `walks_list_screen.dart`, `walkers_list_screen.dart`) now use `EmptyStateBlock` and `ErrorStateBlock` from shared.
- Dogs list search was added to match the existing Clients and Walkers pattern, searching by name, breed, and client ID.
- Dog form now has section headings: **Basic details** (before Name), **Health & identity** (before Breed), and **Notes** (before Medical notes), providing visual grouping of the long form.
- Walk form now has section headings: **Booking details** (before Client ID) and **Optional details** (before Walker ID).
- Spacing inconsistencies around `SwitchListTile` in Dog form and Walker form were fixed: the `SizedBox` after the toggle was changed from `height: 8` to `height: 16` to match surrounding field spacing.
- Walkers list empty state icon changed from `Icons.directions_walk_outlined` to `Icons.badge_outlined` to match the navigation section icon for Walkers.
