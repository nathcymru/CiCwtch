# DSAR and erasure playbook

## Current state

The repository does **not yet** implement a complete right-to-erasure workflow across D1 and R2.

## Minimum production expectation

A valid erasure request should:
1. identify all relevant records in D1
2. determine which records must be deleted versus retained for legal obligations
3. delete or anonymise eligible D1 rows
4. delete linked R2 objects where retention is no longer justified
5. record completion in an auditable internal log

## Current engineering gap

- no authenticated DSAR workflow
- no deletion orchestration service
- no R2 object purge implementation
- no retention-driven scheduled cleanup job

## Interim rule

Do not describe CiCwtch as GDPR-complete or production-ready until this is implemented.
