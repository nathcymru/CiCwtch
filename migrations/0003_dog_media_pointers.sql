-- CiCwtch migration: Add dog media pointer fields (R2)
-- Issue: #103
-- Version: v0.3.5
--
-- Adds nullable object-key columns for dog media stored in Cloudflare R2.
-- These fields store R2 object keys only — no binary data is stored in D1.
-- Expected key pattern: dogs/{dog_id}/avatar/original.jpg

-- ── Add media pointer columns ────────────────────────────────────────

ALTER TABLE dogs ADD COLUMN avatar_object_key TEXT;

ALTER TABLE dogs ADD COLUMN profile_photo_object_key TEXT;

ALTER TABLE dogs ADD COLUMN nose_print_object_key TEXT;
