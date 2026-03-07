PRAGMA foreign_keys = ON;

CREATE TABLE IF NOT EXISTS addresses (
  id TEXT PRIMARY KEY,
  line_1 TEXT NOT NULL,
  line_2 TEXT,
  city TEXT NOT NULL,
  county TEXT,
  postcode TEXT NOT NULL,
  country_code TEXT NOT NULL DEFAULT 'GB',
  access_notes TEXT,
  created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS clients (
  id TEXT PRIMARY KEY,
  full_name TEXT NOT NULL,
  preferred_name TEXT,
  phone TEXT,
  email TEXT,
  address_id TEXT,
  emergency_contact_name TEXT,
  emergency_contact_phone TEXT,
  notes TEXT,
  archived_at TEXT,
  created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (address_id) REFERENCES addresses(id) ON DELETE SET NULL
);

CREATE TABLE IF NOT EXISTS client_contacts (
  id TEXT PRIMARY KEY,
  client_id TEXT NOT NULL,
  full_name TEXT NOT NULL,
  relationship_to_client TEXT,
  phone TEXT,
  email TEXT,
  is_primary INTEGER NOT NULL DEFAULT 0 CHECK (is_primary IN (0, 1)),
  notes TEXT,
  archived_at TEXT,
  created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (client_id) REFERENCES clients(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS dogs (
  id TEXT PRIMARY KEY,
  client_id TEXT NOT NULL,
  name TEXT NOT NULL,
  breed TEXT,
  sex TEXT CHECK (sex IN ('male', 'female', 'unknown')),
  neutered INTEGER NOT NULL DEFAULT 0 CHECK (neutered IN (0, 1)),
  date_of_birth TEXT,
  colour TEXT,
  microchip_number TEXT,
  veterinary_practice TEXT,
  medical_notes TEXT,
  behavioural_notes TEXT,
  feeding_notes TEXT,
  archived_at TEXT,
  created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (client_id) REFERENCES clients(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS dog_notes (
  id TEXT PRIMARY KEY,
  dog_id TEXT NOT NULL,
  note_type TEXT,
  note_body TEXT NOT NULL,
  archived_at TEXT,
  created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (dog_id) REFERENCES dogs(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS walkers (
  id TEXT PRIMARY KEY,
  full_name TEXT NOT NULL,
  phone TEXT,
  email TEXT,
  role_title TEXT,
  start_date TEXT,
  active INTEGER NOT NULL DEFAULT 1 CHECK (active IN (0, 1)),
  notes TEXT,
  archived_at TEXT,
  created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS walker_compliance_items (
  id TEXT PRIMARY KEY,
  walker_id TEXT NOT NULL,
  item_type TEXT NOT NULL,
  status TEXT NOT NULL CHECK (status IN ('pending', 'valid', 'expired')),
  issue_date TEXT,
  expiry_date TEXT,
  reference_number TEXT,
  notes TEXT,
  archived_at TEXT,
  created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (walker_id) REFERENCES walkers(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS walks (
  id TEXT PRIMARY KEY,
  client_id TEXT NOT NULL,
  dog_id TEXT NOT NULL,
  walker_id TEXT,
  scheduled_date TEXT NOT NULL,
  scheduled_start_time TEXT,
  scheduled_end_time TEXT,
  actual_start_time TEXT,
  actual_end_time TEXT,
  status TEXT NOT NULL DEFAULT 'planned' CHECK (status IN ('planned', 'in_progress', 'completed', 'cancelled')),
  service_type TEXT NOT NULL DEFAULT 'walk',
  pickup_address_id TEXT,
  notes TEXT,
  archived_at TEXT,
  created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (client_id) REFERENCES clients(id) ON DELETE CASCADE,
  FOREIGN KEY (dog_id) REFERENCES dogs(id) ON DELETE CASCADE,
  FOREIGN KEY (walker_id) REFERENCES walkers(id) ON DELETE SET NULL,
  FOREIGN KEY (pickup_address_id) REFERENCES addresses(id) ON DELETE SET NULL
);

CREATE TABLE IF NOT EXISTS walk_reports (
  id TEXT PRIMARY KEY,
  walk_id TEXT NOT NULL,
  walker_id TEXT,
  summary TEXT,
  wee_done INTEGER NOT NULL DEFAULT 0 CHECK (wee_done IN (0, 1)),
  poo_done INTEGER NOT NULL DEFAULT 0 CHECK (poo_done IN (0, 1)),
  food_given INTEGER NOT NULL DEFAULT 0 CHECK (food_given IN (0, 1)),
  water_given INTEGER NOT NULL DEFAULT 0 CHECK (water_given IN (0, 1)),
  incident_flag INTEGER NOT NULL DEFAULT 0 CHECK (incident_flag IN (0, 1)),
  incident_notes TEXT,
  duration_minutes INTEGER CHECK (duration_minutes IS NULL OR duration_minutes >= 0),
  created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (walk_id) REFERENCES walks(id) ON DELETE CASCADE,
  FOREIGN KEY (walker_id) REFERENCES walkers(id) ON DELETE SET NULL
);

CREATE TABLE IF NOT EXISTS invoice_headers (
  id TEXT PRIMARY KEY,
  client_id TEXT NOT NULL,
  invoice_number TEXT NOT NULL UNIQUE,
  status TEXT NOT NULL DEFAULT 'draft' CHECK (status IN ('draft', 'issued', 'paid', 'cancelled')),
  issue_date TEXT,
  due_date TEXT,
  currency_code TEXT NOT NULL DEFAULT 'GBP',
  notes TEXT,
  archived_at TEXT,
  created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (client_id) REFERENCES clients(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS invoice_lines (
  id TEXT PRIMARY KEY,
  invoice_header_id TEXT NOT NULL,
  walk_id TEXT,
  description TEXT NOT NULL,
  quantity REAL NOT NULL DEFAULT 1 CHECK (quantity > 0),
  unit_price_minor INTEGER NOT NULL DEFAULT 0 CHECK (unit_price_minor >= 0),
  line_total_minor INTEGER NOT NULL DEFAULT 0 CHECK (line_total_minor >= 0),
  sort_order INTEGER NOT NULL DEFAULT 0,
  created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (invoice_header_id) REFERENCES invoice_headers(id) ON DELETE CASCADE,
  FOREIGN KEY (walk_id) REFERENCES walks(id) ON DELETE SET NULL
);

CREATE TABLE IF NOT EXISTS attachments (
  id TEXT PRIMARY KEY,
  entity_type TEXT NOT NULL,
  entity_id TEXT NOT NULL,
  storage_provider TEXT NOT NULL DEFAULT 'r2',
  object_key TEXT,
  original_filename TEXT,
  mime_type TEXT,
  file_size_bytes INTEGER CHECK (file_size_bytes IS NULL OR file_size_bytes >= 0),
  created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS audit_log (
  id TEXT PRIMARY KEY,
  entity_type TEXT NOT NULL,
  entity_id TEXT NOT NULL,
  action TEXT NOT NULL,
  actor_type TEXT,
  actor_id TEXT,
  change_summary TEXT,
  created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_clients_archived_at ON clients(archived_at);
CREATE INDEX IF NOT EXISTS idx_client_contacts_client_id ON client_contacts(client_id);
CREATE INDEX IF NOT EXISTS idx_dogs_client_id ON dogs(client_id);
CREATE INDEX IF NOT EXISTS idx_dogs_archived_at ON dogs(archived_at);
CREATE INDEX IF NOT EXISTS idx_dog_notes_dog_id ON dog_notes(dog_id);
CREATE INDEX IF NOT EXISTS idx_walkers_active ON walkers(active);
CREATE INDEX IF NOT EXISTS idx_walker_compliance_items_walker_id ON walker_compliance_items(walker_id);
CREATE INDEX IF NOT EXISTS idx_walker_compliance_items_expiry_date ON walker_compliance_items(expiry_date);
CREATE INDEX IF NOT EXISTS idx_walks_client_id ON walks(client_id);
CREATE INDEX IF NOT EXISTS idx_walks_dog_id ON walks(dog_id);
CREATE INDEX IF NOT EXISTS idx_walks_walker_id ON walks(walker_id);
CREATE INDEX IF NOT EXISTS idx_walks_scheduled_date ON walks(scheduled_date);
CREATE INDEX IF NOT EXISTS idx_walks_status ON walks(status);
CREATE INDEX IF NOT EXISTS idx_walk_reports_walk_id ON walk_reports(walk_id);
CREATE INDEX IF NOT EXISTS idx_invoice_headers_client_id ON invoice_headers(client_id);
CREATE INDEX IF NOT EXISTS idx_invoice_headers_status ON invoice_headers(status);
CREATE INDEX IF NOT EXISTS idx_invoice_lines_invoice_header_id ON invoice_lines(invoice_header_id);
CREATE INDEX IF NOT EXISTS idx_attachments_entity ON attachments(entity_type, entity_id);
CREATE INDEX IF NOT EXISTS idx_audit_log_entity ON audit_log(entity_type, entity_id);
