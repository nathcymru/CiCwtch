# Copilot Development Instructions — CiCwtch

GitHub Copilot must follow these instructions when generating code, tests, migrations, documentation, and pull request content for this repository.

## Project overview

CiCwtch is a structured software platform for dog-walking and pet-care operations.

The system is being built for:
- Flutter (Dart) client application
- Targets: Web, iOS, Android
- Cloudflare Workers backend API
- Cloudflare D1 database (SQLite)
- Cloudflare R2 for future file/object storage
- Stripe for future payments and billing workflows

Primary reference documents:
- `docs/URS.md`
- `docs/architecture.md`

If generated code conflicts with the URS or architecture documents, follow the documents and do not invent alternatives.

---

## Core delivery rules

- Implement only the requested task.
- One feature or task per pull request.
- Do not expand scope beyond the issue or prompt.
- Do not introduce unrelated refactors.
- Do not speculate beyond the current task unless explicitly asked.
- Prefer small, reviewable, incremental changes.
- Output complete and working code rather than partial sketches.
- Keep solutions understandable and maintainable for a solo developer.

---

## Technology stack — do not deviate

### Client
- Flutter
- Dart
- Stock Flutter Material and Cupertino components only

### Backend
- Cloudflare Workers
- REST-style JSON API
- Versioned routes under `/api/v1/`

### Database
- Cloudflare D1
- SQLite-compatible SQL only

### Future integrations
- Cloudflare R2
- Stripe

Do not introduce alternative platforms, frameworks, or services unless explicitly requested.

---

## Explicitly do not introduce

Do not add or migrate to:
- React
- Next.js
- Angular
- Vue
- Express
- NestJS
- Firebase
- Supabase
- Prisma
- Tailwind
- Bootstrap
- shadcn
- custom design systems
- heavy state-management libraries unless explicitly approved
- unnecessary ORM layers
- unnecessary repository/service abstraction layers

Do not add dependencies unless they are necessary for the task and consistent with the URS and architecture.

---

## UI rules

- Use stock Flutter Material/Cupertino widgets only.
- Do not introduce a custom design system.
- Do not add extra UI libraries unless explicitly approved.
- Keep layouts simple, accessible, and maintainable.
- Prioritise working CRUD flows over visual polish.
- No speculative theming work.
- No unnecessary animations.
- No placeholder mock UI when real wired UI is expected.

For MVP work, functional and clear beats fancy.

---

## Architecture rules

### API
- Use REST-style JSON endpoints.
- Version all routes under `/api/v1/`.
- Use consistent request and response structures.
- Return clear error responses in JSON.
- Keep route naming predictable and resource-oriented.

### Database
- Use `TEXT` UUID primary keys.
- Include timestamps where appropriate:
  - `created_at`
  - `updated_at`
- Use `archived_at` for soft deletes where appropriate.
- Keep SQL compatible with SQLite and D1.
- Add indexes only where useful and justified.
- Avoid premature over-normalisation.
- Avoid circular foreign-key complexity.

### Application structure
- Keep modules and folders aligned with the architecture documents.
- Prefer explicit code over complex indirection.
- Do not create deep abstraction hierarchies unless explicitly required.
- Keep dependency direction simple and obvious.

---

## Data and schema guidance

When building CRUD or schema-related work, prefer models that support both MVP delivery and later expansion.

Expected broad business domains include:
- clients
- client contacts
- dogs
- dog notes
- walkers
- walker compliance / HR records
- walks / bookings
- walk reports
- invoicing
- attachments / files
- audit logging

However:
- only implement what the task asks for;
- when creating schema, make it future-ready but not bloated;
- do not build full future features unless explicitly requested.

---

## Coding standards

- Write clean, direct, readable code.
- Use descriptive names.
- Keep files focused.
- Add comments only where they genuinely improve clarity.
- Avoid magic values where constants improve readability.
- Avoid cleverness for its own sake.
- Ensure generated code compiles or is syntactically valid.
- Do not leave TODO litter unless specifically requested.

When making changes, preserve the existing conventions in the repository unless they conflict with the documented architecture.

---

## Testing and verification

When relevant to the task:
- add or update tests;
- keep tests scoped to the feature;
- do not create large speculative test suites for unrelated areas.

Prefer practical verification over excessive ceremony.

For Flutter tasks, consider:
- `flutter analyze`
- `flutter test`

For API/backend tasks, consider:
- route-level verification
- migration success
- basic CRUD validation

---

## Documentation rules

If a change affects any of the following, update documentation where appropriate:
- architecture
- database schema
- API contract
- setup instructions
- environment configuration
- deployment assumptions

If documentation is not updated for an architecture-sensitive change, explicitly explain why in the pull request.

Do not rewrite large documentation sections unless the task requires it.

---

## Pull request rules

When asked to draft or complete a pull request summary:

- read the relevant task/issue first;
- review the changed files;
- align the summary with:
  - `docs/URS.md`
  - `docs/architecture.md`
  - `.github/PULL_REQUEST_TEMPLATE.md`

The pull request summary must:
- be truthful and specific;
- be written in plain English;
- describe only what was actually changed;
- state clearly whether there are architecture, database, API, UI, documentation, or migration impacts;
- not leave placeholders behind;
- include a short demo path where appropriate;
- avoid exaggerated claims.

If a section is not applicable, explicitly state that it is not applicable.

---

## Issue execution rules

When implementing a GitHub issue created from the Copilot task template:

- treat the issue as the scope boundary;
- use the issue's Goal, Scope, Constraints, Acceptance Criteria, and Demo Steps as mandatory instructions;
- do not silently expand the feature;
- do not combine multiple issues into one branch or PR unless explicitly told to do so.

---

## Preferred working style

Copilot should behave like a disciplined implementation assistant:
- focused;
- conservative with dependencies;
- faithful to the repo architecture;
- plain and practical in explanations;
- careful with schema and API changes.

Do not behave like a product manager, redesign consultant, or framework evangelist.

Build the requested thing. Keep it tidy. Do not get clever for sport.
