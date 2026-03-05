# Contributing to CiCwtch

Thank you for your interest in contributing to CiCwtch.

CiCwtch is a proprietary project. Contributions are welcome only where they align with the project direction and are explicitly approved by the maintainer.

## Before you start

- Open an Issue before beginning substantial work.
- Confirm scope, architectural direction, and ownership expectations.
- Avoid submitting large unsolicited changes.

## Development expectations

- Keep changes focused and easy to review.
- Update relevant documentation when behaviour, structure, APIs, or data models change.
- Follow the pull request template in full.
- Run the local Flutter checks before opening a PR:
  - `flutter pub get`
  - `flutter analyze`
  - `flutter test`

## Documentation guardrails

If you change architecture-sensitive areas, you are expected to update one or more of the following:

- `docs/architecture.md`
- supporting files under `docs/architecture/`
- `README.md`
- `flutter/README.md`

If documentation genuinely does not need changing, use the PR label `docs-not-required` and explain why in the pull request.

## Licensing and ownership

By submitting a contribution, you acknowledge that approved contributions may be incorporated into current or future commercial versions of CiCwtch.

Do not submit third-party code or assets unless you have the legal right to do so and have clearly identified the licence terms.
