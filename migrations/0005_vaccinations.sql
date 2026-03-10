-- Migration: 0005_vaccinations
-- Purpose: Add vaccination history records per dog with expiry tracking
--          and optional R2 document pointer.

CREATE TABLE IF NOT EXISTS vaccinations (
  id TEXT PRIMARY KEY,
  dog_id TEXT NOT NULL,
  vaccination_name TEXT NOT NULL,
  date_administered TEXT NOT NULL,
  expiration_date TEXT,
  document_object_key TEXT,
  created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (dog_id) REFERENCES dogs(id) ON DELETE CASCADE
);

CREATE INDEX IF NOT EXISTS idx_vaccinations_dog_id ON vaccinations(dog_id);
CREATE INDEX IF NOT EXISTS idx_vaccinations_expiration_date ON vaccinations(expiration_date);
