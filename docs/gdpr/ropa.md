# Record of Processing Activities (RoPA)

## Controller
CiCwtch project owner / maintainer.

## Current processing activities reflected by the repo

### 1. Client administration
- **Purpose:** operate client records for pet-care administration.
- **Data subjects:** customers.
- **Data categories:** name, phone, email, address linkage, emergency contact details, notes.
- **System:** Cloudflare Worker + D1.
- **Lawful basis:** contract / pre-contract steps; legitimate interests for operational administration.

### 2. Pet administration
- **Purpose:** maintain dog profiles.
- **Data categories:** dog name, breed, microchip number, medical notes, behavioural notes, feeding notes.
- **Status:** schema exists; runtime feature not yet fully implemented.

### 3. Walker administration
- **Purpose:** manage worker profiles and compliance.
- **Data categories:** name, email, phone, employment/compliance notes.
- **Status:** schema exists; runtime feature not yet fully implemented.

### 4. Walk scheduling and reporting
- **Purpose:** schedule and record pet-care services.
- **Data categories:** schedule metadata, notes, incident information.
- **Status:** schema exists; runtime feature not yet fully implemented.

### 5. Billing and invoicing
- **Purpose:** issue and track invoices.
- **Data categories:** invoice numbers, dates, status, financial line items.
- **Status:** schema exists; runtime feature not yet fully implemented.

### 6. Attachments and object storage
- **Purpose:** future storage of uploaded files or visit-related objects.
- **Data categories:** filenames, object keys, MIME type, file size; potentially photos or documents.
- **Status:** schema exists; R2 runtime flows not yet implemented.
