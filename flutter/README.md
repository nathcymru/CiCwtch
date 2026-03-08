# CiCwtch Flutter App

This is the primary Flutter application root for CiCwtch.

## Current implementation status

The Flutter app currently provides:

- a Material 3 application shell
- a basic home screen
- clients list / detail / create / edit flows
- shared domain models in `lib/shared/domain/models/`
- a simple HTTP API client wired to the Cloudflare Worker

The wider URS remains broader than the currently implemented app. Dogs, walks, walkers, invoices, auth, offline queueing, and client portal flows are still future work unless and until their code appears in this repo.

## Included in this app workspace

- `lib/main.dart` — app entrypoint and starter shell
- `lib/app/routing/app_router.dart` — named-route generation
- `lib/features/clients/` — current implemented feature slice
- `lib/shared/data/` — API client and shared data helpers
- `lib/shared/domain/models/` — explicit plain Dart models matching D1 tables
- `test/widget_test.dart` — basic widget smoke test
- `web/` assets so GitHub Actions can run `flutter build web`

## Important note about native wrappers

This repository pack includes a lean app starter rather than a fully regenerated platform wrapper set.

To regenerate native platform wrappers locally, run the following from inside this folder after installing Flutter:

```bash
flutter create . --platforms=android,ios,web
```

That command preserves existing Dart code while regenerating platform-specific wrapper files.

## Local checks

```bash
flutter pub get
flutter analyze
flutter test
flutter run -d chrome
```

## Theming and Flutter rules

- UI must remain pure Flutter.
- Material 3 is the current active theme path.
- Cupertino adaptation for iOS is part of the target architecture, but is **not yet fully implemented** in code.
- No HTML/CSS UI frameworks should be introduced.

## Domain models

Plain Dart models live in `lib/shared/domain/models/`. Import them via the barrel file:

```dart
import 'package:cicwtch/shared/domain/models/models.dart';
```

Key points:

- Each model corresponds directly to a table in the D1 database (`migrations/0001_initial_schema.sql`).
- JSON keys in `fromJson` / `toJson` are **snake_case**, matching the database column names exactly.
- Dart property names are the **camelCase** equivalents.
- SQLite `INTEGER` boolean columns are mapped to Dart `bool` explicitly.
- No code generators are used.
- Model files are pure Dart with no Flutter imports.
