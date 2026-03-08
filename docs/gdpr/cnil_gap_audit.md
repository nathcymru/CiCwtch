# CNIL-aligned gap audit

## Current strengths

- schema is explicit and reviewable
- Worker SQL uses prepared statements
- privacy docs and Fides manifests now live in the repo
- tracker scripts are not present in `flutter/web/index.html`

## Current gaps against a CNIL-style privacy-by-design posture

- no implemented login/session lifecycle
- no implemented RBAC
- no complete rights-handling workflow
- no retention automation
- no R2 access-control and deletion lifecycle
- no explicit consent mechanism for future trackers/SDKs
- no mobile-permission governance layer yet

## Rule for future PRs

When a PR adds any of the following, update this file and `consent_and_trackers.md`:
- analytics or tracking SDKs
- push notifications
- location/GPS access
- camera/microphone access
- uploads to R2
- new sensitive free-text fields
