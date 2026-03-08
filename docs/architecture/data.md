# Data Architecture

## Primary datastore

Current primary datastore: **Cloudflare D1**.

The implemented schema lives in:

- `migrations/0001_initial_schema.sql`

## Current implemented entities in code or schema

Schema exists for:

- addresses
- clients
- client_contacts
- dogs
- dog_notes
- walkers
- walker_compliance_items
- walks
- walk_reports
- invoice_headers
- invoice_lines
- attachments
- audit_log

Implemented CRUD API handlers currently cover:

- clients
- dogs
- walks
- walkers
- invoice_headers
- invoice_lines

## Data handling status

Implemented today:

- parameterised D1 statements in Worker handlers
- soft delete on most core entities via `archived_at`
- explicit Dart models matching D1 column names

Not yet implemented in application logic:

- DSAR traversal/export
- DSAR erasure orchestration
- retention enforcement jobs
- audit log writes on CRUD actions
- attachment uploads to R2

## Invoice terminology note

The current schema and API use:

- `invoice_headers`
- `invoice_lines`

The product language may say “invoices”, but the implemented API surface is split into header and line resources.
