<img src="../brand/app_icon_base.svg" alt="CiCwtch Logo" align="left" height="60" />
<!-- HEADER BADGES -->
<p align="right">
<a href="https://github.com/nathcymru/CiCwtch/actions/workflows/ci.yml"><img src="https://img.shields.io/github/actions/workflow/status/nathcymru/CiCwtch/ci.yml?branch=main&style=for-the-badge" alt="Build Status" /></a>
&nbsp;
<a href="https://github.com/nathcymru/CiCwtch/releases"><img src="https://img.shields.io/github/v/tag/nathcymru/CiCwtch?sort=semver&style=for-the-badge&label=Release" alt="Release" /></a>
&nbsp;
  <a href="https://github.com/nathcymru/CiCwtch/commits/main"><img src="https://img.shields.io/github/last-commit/nathcymru/CiCwtch?style=for-the-badge" alt="Last Commit" /></a>
</p clear="right">

# CiCwtch - Flutter App
## Current Flutter application structure and Phase 1 feature coverage

<p align="left">
  <a href="https://flutter.dev/"><img src="https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white" alt="Flutter" /></a>
</p>

## Current implemented frontend scope

The Flutter application currently includes:

- dashboard overview screen,
- clients CRUD screens,
- dogs CRUD screens,
- walks CRUD screens,
- walkers CRUD screens,
- invoices CRUD screens,
- shared navigation shell,
- lightweight client-side search/filtering,
- shared UX helpers for empty, error, status, and section-heading states.

## App structure

- `lib/app/` — routing, shell, and bootstrap concerns
- `lib/features/` — vertical feature slices
- `lib/shared/` — common models, API client, and reusable widgets

## Platform notes

The repository contains web, Android, and iOS wrapper structure suitable for CI and local development. Desktop support is planned through Flutter’s normal platform tooling when needed.

## Local checks

```bash
cd flutter
flutter pub get
flutter analyze
flutter test
flutter run -d chrome
```

## Current limitations

- authentication is not yet implemented,
- local offline persistence is not yet implemented,
- attachment upload/download flows are not yet implemented.

---
<p align="center">
  Built in Wales ❤️ Designed with Cwtch<br/>
  Adeiladwyd yng Nghymru ❤️ Dyluniwyd gyda Cwtch
</p>
