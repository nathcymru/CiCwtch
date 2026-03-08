# Fides working directory

This directory contains the local Fides manifests used to keep CiCwtch's privacy inventory close to the code.

## Intended workflow

- Update `.fides/dataset.yml` when the D1 schema changes.
- Update `.fides/system.yml` when new systems, processors, or data uses are introduced.
- Keep `docs/gdpr/` aligned with the technical implementation.
- Let GitHub Actions validate the manifests on every PR.

## Notes

The current setup is intentionally local-first. It validates manifests in CI without requiring a hosted Fides server.
