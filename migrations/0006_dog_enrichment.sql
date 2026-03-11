-- CiCwtch migration: Dog enrichment — v0.3.5
-- Issue: #107
--
-- Adds veterinary_practices lookup table, expands breeds with metadata,
-- and adds new dog columns for the multi-step create/edit form.

-- ── Veterinary practices lookup table ─────────────────────────────────

CREATE TABLE IF NOT EXISTS veterinary_practices (
  id         TEXT PRIMARY KEY,
  name       TEXT NOT NULL,
  phone      TEXT,
  email      TEXT,
  address    TEXT,
  created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- ── Expand breeds with metadata ──────────────────────────────────────

ALTER TABLE breeds ADD COLUMN breed_group    TEXT;
ALTER TABLE breeds ADD COLUMN size_category  TEXT;
ALTER TABLE breeds ADD COLUMN origin_country TEXT;

-- ── New dog columns — Health ─────────────────────────────────────────

ALTER TABLE dogs ADD COLUMN allergies       INTEGER NOT NULL DEFAULT 0;
ALTER TABLE dogs ADD COLUMN allergies_notes TEXT;
ALTER TABLE dogs ADD COLUMN medication      INTEGER NOT NULL DEFAULT 0;
ALTER TABLE dogs ADD COLUMN medication_notes TEXT;
ALTER TABLE dogs ADD COLUMN vet_practice_id TEXT REFERENCES veterinary_practices(id) ON DELETE SET NULL;

-- ── New dog columns — Behaviour ──────────────────────────────────────

ALTER TABLE dogs ADD COLUMN energy_level    TEXT;
ALTER TABLE dogs ADD COLUMN leash_manners   TEXT;
ALTER TABLE dogs ADD COLUMN recall_rating   TEXT;
ALTER TABLE dogs ADD COLUMN aggressive      INTEGER NOT NULL DEFAULT 0;
ALTER TABLE dogs ADD COLUMN muzzle_required INTEGER NOT NULL DEFAULT 0;
ALTER TABLE dogs ADD COLUMN special_commands TEXT;

-- ── New dog columns — Logistics ──────────────────────────────────────

ALTER TABLE dogs ADD COLUMN walking_gear_object_key TEXT;
ALTER TABLE dogs ADD COLUMN gear_location           TEXT;

-- ── Indexes ──────────────────────────────────────────────────────────

CREATE INDEX IF NOT EXISTS idx_dogs_vet_practice_id ON dogs(vet_practice_id);

-- ── Seed common veterinary practices ─────────────────────────────────

INSERT OR IGNORE INTO veterinary_practices (id, name, phone, email, address) VALUES
  ('vet-rhiwbina',    'Rhiwbina Vets',        '029 2061 1234', 'info@rhiwbinavets.example.com',    '12 Heol y Deri, Rhiwbina, Cardiff CF14 6UH'),
  ('vet-mumbles',     'Mumbles Vet Surgery',  '01792 360123',  'enquiries@mumblesvets.example.com','8 Newton Road, Mumbles, Swansea SA3 4AS'),
  ('vet-menai',       'Menai Vets',           '01248 670456',  'reception@menaivets.example.com',  '15 Stryd y Bont, Caernarfon, Gwynedd LL55 1AB'),
  ('vet-aber',        'Aber Vets',            '01970 612789',  'hello@abervets.example.com',       '4 Terrace Road, Aberystwyth, Ceredigion SY23 1NP'),
  ('vet-ponty',       'Pontypridd Animal Care','01443 400321', 'care@pontyac.example.com',         '21 Taff Street, Pontypridd, CF37 4UQ');

-- ── Update breed metadata ────────────────────────────────────────────

UPDATE breeds SET breed_group = 'Sporting',   size_category = 'large',  origin_country = 'Canada'          WHERE breed_id = 'breed-labrador-retriever';
UPDATE breeds SET breed_group = 'Sporting',   size_category = 'large',  origin_country = 'United Kingdom'  WHERE breed_id = 'breed-golden-retriever';
UPDATE breeds SET breed_group = 'Herding',    size_category = 'large',  origin_country = 'Germany'         WHERE breed_id = 'breed-german-shepherd';
UPDATE breeds SET breed_group = 'Herding',    size_category = 'medium', origin_country = 'United Kingdom'  WHERE breed_id = 'breed-border-collie';
UPDATE breeds SET breed_group = 'Sporting',   size_category = 'medium', origin_country = 'United Kingdom'  WHERE breed_id = 'breed-cocker-spaniel';
UPDATE breeds SET breed_group = 'Hybrid',     size_category = 'medium', origin_country = 'United States'   WHERE breed_id = 'breed-cockapoo';
UPDATE breeds SET breed_group = 'Hybrid',     size_category = 'small',  origin_country = 'Australia'       WHERE breed_id = 'breed-cavapoo';
UPDATE breeds SET breed_group = 'Mixed',      size_category = NULL,     origin_country = NULL              WHERE breed_id = 'breed-mixed-breed';
UPDATE breeds SET breed_group = 'Sporting',   size_category = 'medium', origin_country = 'Wales'           WHERE breed_id = 'breed-welsh-springer-spaniel';
UPDATE breeds SET breed_group = 'Herding',    size_category = 'small',  origin_country = 'Wales'           WHERE breed_id = 'breed-pembroke-welsh-corgi';
UPDATE breeds SET breed_group = 'Terrier',    size_category = 'small',  origin_country = 'England'         WHERE breed_id = 'breed-jack-russell-terrier';
