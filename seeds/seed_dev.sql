-- CiCwtch development seed data
-- Purpose: populate a local D1 database with realistic sample data for
--          development and demos.
-- Usage:   cd worker
--          npx wrangler d1 execute cicwtch-db --local --file=../seeds/seed_dev.sql
--
-- All IDs are deterministic UUIDs so this script is safe to re-run
-- (INSERT OR IGNORE prevents duplicates).
-- Names and details are fictional but realistic, with a Welsh flavour.

PRAGMA foreign_keys = ON;

-- ── Addresses ──────────────────────────────────────────────────────────

INSERT OR IGNORE INTO addresses (id, line_1, line_2, city, county, postcode, country_code, access_notes)
VALUES
  ('addr-0001', '14 Heol y Deri', NULL, 'Cardiff', 'South Glamorgan', 'CF14 6UH', 'GB', 'Side gate to rear garden'),
  ('addr-0002', '7 Ffordd y Môr', 'Flat 2', 'Swansea', 'West Glamorgan', 'SA1 3QR', 'GB', NULL),
  ('addr-0003', '22 Stryd Fawr', NULL, 'Caernarfon', 'Gwynedd', 'LL55 1RT', 'GB', 'Ring bell twice'),
  ('addr-0004', '3 Lôn y Bryn', NULL, 'Aberystwyth', 'Ceredigion', 'SY23 2AX', 'GB', NULL),
  ('addr-0005', '9 Rhodfa''r Parc', NULL, 'Pontypridd', 'Rhondda Cynon Taf', 'CF37 4DL', 'GB', 'Driveway parking available');

-- ── Clients ────────────────────────────────────────────────────────────

INSERT OR IGNORE INTO clients (id, full_name, preferred_name, phone, email, address_id, emergency_contact_name, emergency_contact_phone, notes)
VALUES
  ('client-0001', 'Rhiannon Davies', 'Rhi', '07700 100001', 'rhi.davies@example.com', 'addr-0001', 'Aled Davies', '07700 200001', 'Prefers morning walks'),
  ('client-0002', 'Owain Pritchard', NULL, '07700 100002', 'owain.p@example.com', 'addr-0002', 'Megan Pritchard', '07700 200002', NULL),
  ('client-0003', 'Sian Morgan', 'Sian', '07700 100003', 'sian.morgan@example.com', 'addr-0003', 'Dafydd Morgan', '07700 200003', 'Key under blue flowerpot'),
  ('client-0004', 'Gethin Rees', NULL, '07700 100004', 'gethin.rees@example.com', 'addr-0004', 'Carys Rees', '07700 200004', 'Dogs can be nervous with strangers');

-- ── Client contacts ────────────────────────────────────────────────────

INSERT OR IGNORE INTO client_contacts (id, client_id, full_name, relationship_to_client, phone, email, is_primary, notes)
VALUES
  ('cc-0001', 'client-0001', 'Aled Davies', 'Spouse', '07700 200001', 'aled.d@example.com', 1, NULL),
  ('cc-0002', 'client-0002', 'Megan Pritchard', 'Partner', '07700 200002', NULL, 1, 'Works from home on Tuesdays'),
  ('cc-0003', 'client-0003', 'Dafydd Morgan', 'Husband', '07700 200003', 'dafydd.m@example.com', 1, NULL),
  ('cc-0004', 'client-0004', 'Carys Rees', 'Wife', '07700 200004', 'carys.r@example.com', 1, NULL);

-- ── Dogs ───────────────────────────────────────────────────────────────

INSERT OR IGNORE INTO dogs (id, client_id, name, breed, sex, neutered, date_of_birth, colour, microchip_number, veterinary_practice, medical_notes, behavioural_notes, feeding_notes)
VALUES
  ('dog-0001', 'client-0001', 'Cadi',   'Welsh Springer Spaniel', 'female', 1, '2021-03-15', 'Red and white',   '900118000123456', 'Rhiwbina Vets',       NULL,                                'Friendly with other dogs',      'Grain-free food only'),
  ('dog-0002', 'client-0001', 'Macsen', 'Labrador Retriever',     'male',   1, '2019-08-22', 'Golden',          '900118000234567', 'Rhiwbina Vets',       'Mild hip dysplasia — avoid stairs', 'Calm temperament, slow walker', NULL),
  ('dog-0003', 'client-0002', 'Ffion',  'Border Collie',          'female', 0, '2023-01-10', 'Black and white', '900118000345678', 'Mumbles Vet Surgery', NULL,                                'High energy, needs off-lead time', NULL),
  ('dog-0004', 'client-0003', 'Bryn',   'Pembroke Welsh Corgi',   'male',   1, '2020-06-01', 'Tri-colour',      '900118000456789', 'Menai Vets',          'Allergic to chicken',               'Stubborn on recall',            'Lamb-based kibble'),
  ('dog-0005', 'client-0004', 'Seren',  'Cocker Spaniel',         'female', 1, '2022-11-05', 'Chocolate',       '900118000567890', 'Aber Vets',           NULL,                                'Anxious with loud noises',      NULL),
  ('dog-0006', 'client-0004', 'Dewi',   'Jack Russell Terrier',   'male',   0, '2024-02-14', 'White and tan',   '900118000678901', 'Aber Vets',           NULL,                                'Energetic, pulls on lead',      'Small breed kibble');

-- ── Dog notes ──────────────────────────────────────────────────────────

INSERT OR IGNORE INTO dog_notes (id, dog_id, note_type, note_body)
VALUES
  ('dn-0001', 'dog-0002', 'medical',     'Vet check 2025-01-12 — hip stable, continue glucosamine supplement.'),
  ('dn-0002', 'dog-0004', 'dietary',     'Changed to hypoallergenic lamb kibble as of 2024-09-01.'),
  ('dn-0003', 'dog-0005', 'behavioural', 'Improving with desensitisation — can now tolerate moderate traffic noise.'),
  ('dn-0004', 'dog-0001', 'general',     'Loves water — will try to swim in any puddle or stream.');

-- ── Walkers ────────────────────────────────────────────────────────────

INSERT OR IGNORE INTO walkers (id, full_name, phone, email, role_title, start_date, active, notes)
VALUES
  ('walker-0001', 'Eira Bowen',   '07700 300001', 'eira.bowen@example.com',   'Lead Walker',      '2023-04-01', 1, 'Full-time, covers Cardiff area'),
  ('walker-0002', 'Iolo Jenkins', '07700 300002', 'iolo.jenkins@example.com', 'Walker',           '2024-01-15', 1, 'Part-time, weekday mornings only'),
  ('walker-0003', 'Nia Parry',    '07700 300003', 'nia.parry@example.com',    'Relief Walker',    '2024-06-01', 1, 'Available for holiday cover');

-- ── Walker compliance items ────────────────────────────────────────────

INSERT OR IGNORE INTO walker_compliance_items (id, walker_id, item_type, status, issue_date, expiry_date, reference_number, notes)
VALUES
  ('wci-0001', 'walker-0001', 'DBS Check',         'valid',   '2023-03-10', '2026-03-10', 'DBS-001234', NULL),
  ('wci-0002', 'walker-0001', 'Pet First Aid',      'valid',   '2024-05-20', '2027-05-20', 'PFA-005678', 'Completed with Red Cross'),
  ('wci-0003', 'walker-0001', 'Public Liability Insurance', 'valid', '2025-01-01', '2026-01-01', 'PLI-112233', NULL),
  ('wci-0004', 'walker-0002', 'DBS Check',         'valid',   '2023-11-01', '2026-11-01', 'DBS-002345', NULL),
  ('wci-0005', 'walker-0002', 'Pet First Aid',      'pending', NULL,         NULL,         NULL,         'Booked for March 2026'),
  ('wci-0006', 'walker-0003', 'DBS Check',         'valid',   '2024-05-15', '2027-05-15', 'DBS-003456', NULL);

-- ── Walks ──────────────────────────────────────────────────────────────
-- Mix of completed, planned, and one cancelled walk.

INSERT OR IGNORE INTO walks (id, client_id, dog_id, walker_id, scheduled_date, scheduled_start_time, scheduled_end_time, actual_start_time, actual_end_time, status, service_type, pickup_address_id, notes)
VALUES
  -- Completed walks
  ('walk-0001', 'client-0001', 'dog-0001', 'walker-0001', '2026-02-24', '09:00', '10:00', '09:02', '10:05', 'completed', 'walk',          'addr-0001', NULL),
  ('walk-0002', 'client-0001', 'dog-0002', 'walker-0001', '2026-02-24', '09:00', '10:00', '09:02', '10:05', 'completed', 'walk',          'addr-0001', 'Walked with Cadi — both dogs together'),
  ('walk-0003', 'client-0002', 'dog-0003', 'walker-0001', '2026-02-25', '14:00', '15:00', '14:05', '15:10', 'completed', 'walk',          'addr-0002', 'Extra off-lead time at the park'),
  ('walk-0004', 'client-0003', 'dog-0004', 'walker-0002', '2026-02-26', '10:00', '10:30', '10:00', '10:28', 'completed', 'walk',          'addr-0003', NULL),
  ('walk-0005', 'client-0004', 'dog-0005', 'walker-0001', '2026-02-27', '11:00', '12:00', '11:03', '11:58', 'completed', 'walk',          'addr-0004', NULL),

  -- Planned future walks
  ('walk-0006', 'client-0001', 'dog-0001', 'walker-0001', '2026-03-10', '09:00', '10:00', NULL,    NULL,    'planned',   'walk',          'addr-0001', NULL),
  ('walk-0007', 'client-0002', 'dog-0003', 'walker-0002', '2026-03-10', '14:00', '15:00', NULL,    NULL,    'planned',   'walk',          'addr-0002', NULL),
  ('walk-0008', 'client-0003', 'dog-0004', 'walker-0001', '2026-03-11', '10:00', '10:30', NULL,    NULL,    'planned',   'walk',          'addr-0003', NULL),
  ('walk-0009', 'client-0004', 'dog-0006', 'walker-0003', '2026-03-12', '08:30', '09:30', NULL,    NULL,    'planned',   'walk',          'addr-0004', 'First walk with Dewi — take it slow'),
  ('walk-0010', 'client-0001', 'dog-0002', 'walker-0001', '2026-03-12', '09:00', '10:00', NULL,    NULL,    'planned',   'walk',          'addr-0001', NULL),

  -- Cancelled walk
  ('walk-0011', 'client-0004', 'dog-0005', 'walker-0001', '2026-02-28', '11:00', '12:00', NULL,    NULL,    'cancelled', 'walk',          'addr-0004', 'Client cancelled — dog unwell');

-- ── Walk reports ───────────────────────────────────────────────────────
-- One report per completed walk.

INSERT OR IGNORE INTO walk_reports (id, walk_id, walker_id, summary, wee_done, poo_done, food_given, water_given, incident_flag, incident_notes, duration_minutes)
VALUES
  ('wr-0001', 'walk-0001', 'walker-0001', 'Good walk along Bute Park. Cadi enjoyed splashing in the Taff.',                          1, 1, 0, 1, 0, NULL,                                                        63),
  ('wr-0002', 'walk-0002', 'walker-0001', 'Macsen walked well alongside Cadi. Kept pace gentle for his hips.',                       1, 0, 0, 1, 0, NULL,                                                        63),
  ('wr-0003', 'walk-0003', 'walker-0001', 'Ffion had a great off-lead session in Singleton Park. Very responsive to recall today.',   1, 1, 0, 1, 0, NULL,                                                        65),
  ('wr-0004', 'walk-0004', 'walker-0002', 'Short loop around Caernarfon castle walls. Bryn was a bit stubborn at the halfway point.', 1, 1, 0, 0, 0, NULL,                                                        28),
  ('wr-0005', 'walk-0005', 'walker-0001', 'Seren was initially nervous near the road but settled once on the coastal path.',          1, 0, 0, 1, 1, 'Minor: Seren startled by a cyclist and slipped her harness briefly. Secured immediately, no injury.', 55);

-- ── Audit log entries ──────────────────────────────────────────────────
-- A few sample audit entries so the table is not empty during demos.

INSERT OR IGNORE INTO audit_log (id, entity_type, entity_id, action, actor_type, actor_id, change_summary)
VALUES
  ('audit-0001', 'client', 'client-0001', 'create', 'system', 'seed',    'Seed data: created client Rhiannon Davies'),
  ('audit-0002', 'walk',   'walk-0001',   'create', 'system', 'seed',    'Seed data: created walk for Cadi on 2026-02-24'),
  ('audit-0003', 'walk',   'walk-0001',   'update', 'walker', 'walker-0001', 'Walk completed');
