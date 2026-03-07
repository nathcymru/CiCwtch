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
