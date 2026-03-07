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
- **Create walk** — `WalkCreateScreen` / `WalkFormScreen` — form with required `client_id`, `dog_id`, `scheduled_date`, `status`, and `service_type`; optional walker ID, start/end times, and notes.
- **Edit walk** — `WalkEditScreen` / `WalkFormScreen` — pre-populated form; saves via `PUT /api/v1/walks/:id`.
- **Archive walk** — confirmation dialog; calls `DELETE /api/v1/walks/:id`; returns to list on success.

API dependency: `/api/v1/walks` (GET, POST, GET /:id, PUT /:id, DELETE /:id).

### Walkers

Walkers CRUD is implemented at `lib/features/walkers/`. Screens:

- **Walkers list** — `WalkersListScreen` — lists active walkers; FAB to create; tap to view detail.
- **Walker detail** — `WalkerDetailScreen` — shows full walker record including name, phone, email, role, start date, active status, and notes; edit and archive actions.
- **Create walker** — `WalkerCreateScreen` / `WalkerFormScreen` — form with required `full_name`; optional phone, email, role title, start date, active toggle, and notes.
- **Edit walker** — `WalkerEditScreen` / `WalkerFormScreen` — pre-populated form; saves via `PUT /api/v1/walkers/:id`.
- **Archive walker** — confirmation dialog; calls `DELETE /api/v1/walkers/:id`; returns to list on success.

API dependency: `/api/v1/walkers` (GET, POST, GET /:id, PUT /:id, DELETE /:id).

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
