-- Migration: 0004_behavior_snapshots
-- Purpose: Add timestamped behaviour snapshots for dogs so behaviour
--          can evolve over time instead of being stored as static fields only.

CREATE TABLE IF NOT EXISTS behavior_snapshots (
  id TEXT PRIMARY KEY,
  dog_id TEXT NOT NULL,
  created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  recall_rating INTEGER CHECK (recall_rating IS NULL OR (recall_rating >= 1 AND recall_rating <= 5)),
  leash_manners_rating INTEGER CHECK (leash_manners_rating IS NULL OR (leash_manners_rating >= 1 AND leash_manners_rating <= 5)),
  energy_level_rating INTEGER CHECK (energy_level_rating IS NULL OR (energy_level_rating >= 1 AND energy_level_rating <= 5)),
  behavior_tags_json TEXT,
  notes TEXT,
  FOREIGN KEY (dog_id) REFERENCES dogs(id) ON DELETE CASCADE
);

CREATE INDEX IF NOT EXISTS idx_behavior_snapshots_dog_id ON behavior_snapshots(dog_id);
CREATE INDEX IF NOT EXISTS idx_behavior_snapshots_created_at ON behavior_snapshots(created_at);
