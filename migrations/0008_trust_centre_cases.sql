-- Migration: 0008_trust_centre_cases.sql
-- Adds case/report management tables for the Trust Centre submission flow.
-- Supports public reports, official police/emergency and regulator/legal routes,
-- attachment metadata for R2-stored official documents, audit events, and assignment history.

-- ── trust_reports ──────────────────────────────────────────────────────────────
-- Central case record. One row per submitted report.

CREATE TABLE IF NOT EXISTS trust_reports (
  id                TEXT    PRIMARY KEY,  -- Internal UUID (crypto.randomUUID())
  reference         TEXT    NOT NULL UNIQUE, -- Public human-readable reference (e.g. TCR-2025-00001)

  -- Lifecycle timestamps
  created_at        TEXT    NOT NULL,
  updated_at        TEXT    NOT NULL,
  submitted_at      TEXT    NOT NULL,
  assigned_at       TEXT,
  resolved_at       TEXT,
  closed_at         TEXT,

  -- Assignment
  assigned_to       TEXT,

  -- Status and priority
  status            TEXT    NOT NULL DEFAULT 'open',
  -- Allowed: open | in_progress | awaiting_response | closed | rejected
  priority          TEXT    NOT NULL DEFAULT 'normal',
  -- Allowed: low | normal | high | urgent

  -- Routing fields
  role_type         TEXT    NOT NULL,
  -- Values: business_client | dog_owner_client | accessibility | rights_holder |
  --         police | regulator | security_researcher | prospective_client | public | other
  help_type         TEXT,
  -- Values (client routes): harmful | privacy | complaint
  subtype           TEXT,

  -- Reporter personal details
  reporter_name     TEXT    NOT NULL,
  reporter_email    TEXT    NOT NULL,
  reporter_phone    TEXT,

  -- Organisation / official details
  organisation_name TEXT,
  organisation_type TEXT,
  official_role     TEXT,
  official_ref      TEXT,

  -- Structured form data (JSON string)
  form_data         TEXT,

  -- Declaration / checkbox state (JSON string, e.g. {"decl_accurate":true,"decl_privacy":true})
  declarations      TEXT,

  -- Anonymity / sensitivity flags
  anonymity_flag    INTEGER NOT NULL DEFAULT 0, -- 1 = anonymised

  -- Police-specific fields
  collar_number     TEXT,
  force_name        TEXT,
  station_unit      TEXT,
  cad_number        TEXT,
  crime_reference   TEXT,
  risk_to_life      TEXT,   -- yes | no
  avoid_notification TEXT,  -- yes | no

  -- Regulator-specific fields
  regulator_ref     TEXT,

  -- Free-text description
  description       TEXT    NOT NULL DEFAULT '',

  -- Requested outcome
  requested_outcome TEXT,

  -- Supporting links (JSON array of URL strings, public routes)
  supporting_links  TEXT,

  -- Internal case management
  internal_notes    TEXT,
  closure_reason    TEXT,

  -- Preferred contact method (accessibility route)
  preferred_contact TEXT
);

CREATE INDEX IF NOT EXISTS idx_trust_reports_reference ON trust_reports(reference);
CREATE INDEX IF NOT EXISTS idx_trust_reports_status    ON trust_reports(status);
CREATE INDEX IF NOT EXISTS idx_trust_reports_role_type ON trust_reports(role_type);
CREATE INDEX IF NOT EXISTS idx_trust_reports_created_at ON trust_reports(created_at);
CREATE INDEX IF NOT EXISTS idx_trust_reports_reporter_email ON trust_reports(reporter_email);

-- ── trust_report_attachments ────────────────────────────────────────────────
-- Metadata for official documents uploaded to R2 as part of police/regulator routes.
-- Files themselves are stored in R2; only metadata lives in D1.

CREATE TABLE IF NOT EXISTS trust_report_attachments (
  id              TEXT PRIMARY KEY, -- Internal UUID
  report_id       TEXT NOT NULL REFERENCES trust_reports(id) ON DELETE CASCADE,
  report_reference TEXT NOT NULL,   -- Denormalised for fast lookup

  -- File metadata
  original_filename TEXT,
  content_type    TEXT,
  file_size_bytes INTEGER,

  -- R2 storage
  r2_key          TEXT NOT NULL,    -- Key in the R2 trust-reports bucket

  -- Provenance
  route           TEXT NOT NULL,    -- police | regulator
  uploaded_at     TEXT NOT NULL,

  FOREIGN KEY (report_id) REFERENCES trust_reports(id) ON DELETE CASCADE
);

CREATE INDEX IF NOT EXISTS idx_trust_attachments_report_id ON trust_report_attachments(report_id);
CREATE INDEX IF NOT EXISTS idx_trust_attachments_reference ON trust_report_attachments(report_reference);

-- ── trust_report_events ─────────────────────────────────────────────────────
-- Immutable audit trail: one row per state change or notable action.

CREATE TABLE IF NOT EXISTS trust_report_events (
  id          TEXT PRIMARY KEY,
  report_id   TEXT NOT NULL REFERENCES trust_reports(id) ON DELETE CASCADE,
  occurred_at TEXT NOT NULL,
  event_type  TEXT NOT NULL,
  -- Examples: created | status_changed | assigned | note_added | resolved | closed | attachment_added
  actor       TEXT,            -- System or user identifier
  detail      TEXT,            -- JSON or plain text describing the event

  FOREIGN KEY (report_id) REFERENCES trust_reports(id) ON DELETE CASCADE
);

CREATE INDEX IF NOT EXISTS idx_trust_events_report_id   ON trust_report_events(report_id);
CREATE INDEX IF NOT EXISTS idx_trust_events_occurred_at ON trust_report_events(occurred_at);

-- ── trust_report_sequence ────────────────────────────────────────────────────
-- Single-row counter used to generate human-readable reference numbers.

CREATE TABLE IF NOT EXISTS trust_report_sequence (
  id          INTEGER PRIMARY KEY CHECK (id = 1), -- Singleton row
  next_val    INTEGER NOT NULL DEFAULT 1
);

INSERT OR IGNORE INTO trust_report_sequence (id, next_val) VALUES (1, 1);
