-- CiCwtch migration: Introduce breeds lookup table
-- Issue: #102
-- Version: v0.3.5
--
-- Creates a normalised breeds reference table and adds breed_id to dogs.
-- The existing free-text breed column is retained for backward compatibility.

-- ── Breeds lookup table ──────────────────────────────────────────────
-- Global/reference table — no organisation_id required.

CREATE TABLE IF NOT EXISTS breeds (
  breed_id   TEXT PRIMARY KEY,
  breed_name TEXT NOT NULL
);

-- ── Seed common breeds ───────────────────────────────────────────────

INSERT OR IGNORE INTO breeds (breed_id, breed_name) VALUES
  ('breed-labrador-retriever',  'Labrador Retriever'),
  ('breed-golden-retriever',    'Golden Retriever'),
  ('breed-german-shepherd',     'German Shepherd'),
  ('breed-border-collie',       'Border Collie'),
  ('breed-cocker-spaniel',      'Cocker Spaniel'),
  ('breed-cockapoo',            'Cockapoo'),
  ('breed-cavapoo',             'Cavapoo'),
  ('breed-mixed-breed',         'Mixed Breed');

-- ── Add breed_id to dogs ─────────────────────────────────────────────

ALTER TABLE dogs ADD COLUMN breed_id TEXT REFERENCES breeds(breed_id) ON DELETE SET NULL;

-- ── Index for breed_id lookups ───────────────────────────────────────

CREATE INDEX IF NOT EXISTS idx_dogs_breed_id ON dogs(breed_id);
