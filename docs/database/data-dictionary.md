<img src="../../brand/app_icon_base.svg" alt="CiCwtch Logo" align="left" height="60" />
<!-- HEADER BADGES -->
<p align="right">
<a href="https://github.com/nathcymru/CiCwtch/actions/workflows/ci.yml"><img src="https://img.shields.io/github/actions/workflow/status/nathcymru/CiCwtch/ci.yml?branch=main&style=for-the-badge" alt="Build Status" /></a>
&nbsp;
<a href="https://github.com/nathcymru/CiCwtch/releases"><img src="https://img.shields.io/github/v/tag/nathcymru/CiCwtch?sort=semver&style=for-the-badge&label=Release" alt="Release" /></a>
&nbsp;
  <a href="https://github.com/nathcymru/CiCwtch/commits/main"><img src="https://img.shields.io/github/last-commit/nathcymru/CiCwtch?style=for-the-badge" alt="Last Commit" /></a>
</p clear="right">

# CiCwtch - Data Dictionary
## Field-level reference for the documented database baseline

<p align="left">
  <a href="https://developers.cloudflare.com/d1/"><img src="https://img.shields.io/badge/Cloudflare%20D1-F38020?style=for-the-badge&logo=cloudflare&logoColor=white" alt="Cloudflare D1" /></a>
  &nbsp;
  <a href="https://www.sqlite.org/index.html"><img src="https://img.shields.io/badge/SQLite-003B57?style=for-the-badge&logo=sqlite&logoColor=white" alt="SQLite" /></a>
  &nbsp;
  <a href="https://mermaid.js.org/"><img src="https://img.shields.io/badge/Mermaid-FF3670?style=for-the-badge&logo=mermaid&logoColor=white" alt="Mermaid" /></a>
</p>
This data dictionary focuses on the currently documented baseline and the tables that materially shape application behaviour.

## Table index

| Table | Scope | Purpose |
|---|---|---|
| organisations | global | Tenant registry. |
| addresses | tenant | Validated address records and geocoding metadata. |
| clients | tenant | Customer account and service preferences. |
| client_contacts | tenant | Related contacts for a client account. |
| client_documents | tenant | Signed or operational client documents. |
| dogs | tenant | Core dog profile and handling information. |
| dog_notes | tenant | General dog notes. |
| dog_medical_records | tenant | Structured medical records per dog. |
| vaccinations | tenant | Vaccination history per dog. |
| behavior_snapshots | tenant-lite | Time-stamped behavioural observations per dog. |
| walkers | tenant | Walker profiles. |
| walker_compliance_records | tenant | Evidence-backed walker compliance records. |
| compliance_templates | tenant | Required compliance rules by entity type. |
| walks | tenant | Scheduled and completed walks. |
| walk_reports | tenant-lite | Outcome reports for walks. |
| invoice_headers | tenant | Invoice master records. |
| invoice_lines | tenant | Invoice line items. |
| invoice_sequences | tenant | Per-organisation invoice numbering. |
| invoice_branding_profiles | tenant | Invoice branding and presentation settings. |
| invoice_line_item_templates | tenant | Reusable line-item definitions. |
| invoice_line_items_catalog | tenant | Catalogued invoiceable items. |
| tax_rates | reference | Tax configuration. |
| service_templates | tenant/reference | Reusable service definitions. |
| attachments | shared metadata | File metadata for R2 objects. |
| weather_snapshots | tenant | Walk weather capture. |
| route_snapshots | tenant | Walk route capture. |
| device_registrations | tenant | Device and push-token registration. |
| calendar_sync_links | tenant | External calendar sync metadata. |
| breeds | global reference | Breed lookup data. |
| vets | global reference | Veterinary practice lookup data. |
| users | tenant/platform | Application user accounts. |

## Confirmed field definitions

### addresses

| Column | Type | Description | Constraints |
|---|---|---|---|
| id | TEXT | Address primary key. | PK |
| organisation_id | TEXT | Owning tenant. | Not null |
| line_1 | TEXT | Primary address line. | Not null |
| line_2 | TEXT | Secondary address line. | Nullable |
| city | TEXT | City or locality. | Nullable |
| county | TEXT | County or principal area. | Nullable |
| postcode | TEXT | Postal code. | Not null |
| country_code | TEXT | ISO country code. | Default `GB` |
| latitude / longitude | REAL | Geocode coordinates. | Nullable |
| address_type | TEXT | Home, billing, service, or other. | Check constraint |
| formatted_address | TEXT | Provider-formatted address string. | Demo data should be populated when validated |
| formatted_postcode | TEXT | Normalised postcode. | Nullable |
| is_validated | INTEGER | Validation flag. | `0` or `1` |
| validation_source | TEXT | Address validation provider. | Nullable but should be populated in demo validated rows |
| validation_payload_json | TEXT | Raw validation payload. | JSON text |
| place_id | TEXT | External place identifier. | Populate in demo validated rows |
| street_number / route / locality | TEXT | Parsed address components. | Nullable |
| administrative_area_level_1 / administrative_area_level_2 | TEXT | Provider administrative components. | Nullable |
| postal_town | TEXT | UK postal town. | Nullable |
| country | TEXT | Full country name. | Nullable |
| geocode_source | TEXT | Geocoding provider. | Nullable |
| geocode_confidence | REAL | Confidence score. | Nullable |
| geocode_payload_json / raw_components_json / raw_place_json / raw_geometry_json | TEXT | Provider payload storage. | JSON text |
| validated_at / geocoded_at / verified_at / place_refreshed_at | TEXT | Lifecycle timestamps. | Nullable ISO datetime text |
| source_system | TEXT | Upstream origin. | Nullable |
| verification_status | TEXT | Verification state. | Nullable |
| archived_at / created_at / updated_at | TEXT | Lifecycle timestamps. | Created/updated defaulted |

### clients

| Column | Type | Description | Constraints |
|---|---|---|---|
| id | TEXT | Client primary key. | PK |
| organisation_id | TEXT | Owning tenant. | Not null |
| client_code | TEXT | Friendly account code. | Nullable |
| status | TEXT | Operational state. | Default `active` |
| full_name | TEXT | Main customer name. | Not null |
| preferred_name | TEXT | Preferred display name. | Nullable |
| email | TEXT | Primary email. | Nullable |
| phone_primary / phone_secondary | TEXT | Contact numbers. | Nullable |
| address_id / billing_address_id | TEXT | Linked address records. | Nullable |
| household_notes / other_pets_present | TEXT | Household context. | Nullable |
| children_present | INTEGER | Household flag. | `0` or `1` |
| parking_notes / access_details / alarm_instructions | TEXT | Service access details. | Nullable |
| key_safe_code_encrypted | TEXT | Sensitive access credential storage. | Nullable, encrypted form only |
| key_safe_location / preferred_visit_window_notes | TEXT | Visit support fields. | Nullable |
| emergency_contact_* | TEXT | Emergency contact details. | Nullable |
| safeguarding_notes | TEXT | Safeguarding concerns. | Nullable |
| authorised_vet_decision | INTEGER | Vet treatment permission flag. | `0` or `1` |
| billing_contact_name / billing_email | TEXT | Billing contact info. | Nullable |
| default_payment_method / invoice_frequency | TEXT | Billing preferences. | Nullable |
| payment_terms_days | INTEGER | Payment terms. | Default `14` |
| discount_rate_percentage | REAL | Discount percentage. | Default `0` |
| price_list_id | TEXT | Pricing profile reference. | Nullable |
| vat_exempt | INTEGER | VAT exemption flag. | `0` or `1` |
| account_balance_minor | INTEGER | Minor-unit account balance. | Default `0` |
| marketing_consent / photo_consent | INTEGER | Consent flags. | `0` or `1` |
| terms_accepted_at / privacy_notice_accepted_at / service_agreement_signed_at | TEXT | Agreement timestamps. | Nullable |
| service_agreement_version | TEXT | Agreement version accepted. | Nullable |
| onboarding_status | TEXT | Onboarding progress. | Default `not_started` |
| onboarded_at / last_booking_at / last_invoice_at | TEXT | Lifecycle timestamps. | Nullable |
| internal_notes / archived_at / created_at / updated_at | TEXT | Ops and lifecycle fields. | Standard timestamps |

### client_contacts

| Column | Type | Description | Constraints |
|---|---|---|---|
| id | TEXT | Primary key. | PK |
| organisation_id | TEXT | Owning tenant. | Not null |
| client_id | TEXT | Parent client. | Not null |
| full_name | TEXT | Contact name. | Not null |
| relationship | TEXT | Relationship to client. | Nullable |
| email / phone_primary / phone_secondary | TEXT | Contact methods. | Nullable |
| is_primary / is_emergency_contact / is_billing_contact | INTEGER | Contact roles. | `0` or `1` |
| notes | TEXT | Internal context. | Nullable |
| archived_at / created_at / updated_at | TEXT | Lifecycle fields. | Standard timestamps |

### client_documents

| Column | Type | Description | Constraints |
|---|---|---|---|
| id | TEXT | Primary key. | PK |
| organisation_id | TEXT | Owning tenant. | Not null, FK to organisations |
| client_id | TEXT | Parent client. | Not null, FK to clients |
| document_type | TEXT | Agreement or document class. | Not null |
| attachment_id | TEXT | Linked attachment metadata. | Nullable |
| signed_at / expires_at | TEXT | Document lifecycle dates. | Nullable |
| notes / archived_at / created_at / updated_at | TEXT | Context and timestamps. | Standard timestamps |

### dog_notes

| Column | Type | Description | Constraints |
|---|---|---|---|
| id | TEXT | Primary key. | PK |
| dog_id | TEXT | Parent dog. | Not null |
| note_type | TEXT | Optional category. | Nullable |
| note_body | TEXT | Note content. | Not null |
| archived_at / created_at / updated_at | TEXT | Lifecycle fields. | Standard timestamps |

### dog_medical_records

| Column | Type | Description | Constraints |
|---|---|---|---|
| id | TEXT | Primary key. | PK |
| organisation_id | TEXT | Owning tenant. | Not null |
| dog_id | TEXT | Parent dog. | Not null |
| record_type | TEXT | Medical record class. | `allergy`, `medication`, `condition`, `vaccination`, `injury`, `other` |
| title | TEXT | Short record title. | Not null |
| description | TEXT | Detail. | Nullable |
| severity | TEXT | Operational severity. | `low`, `moderate`, `high`, `critical` |
| start_date / end_date | TEXT | Effective dates. | Nullable |
| is_active | INTEGER | Current flag. | `0` or `1` |
| notes / archived_at / created_at / updated_at | TEXT | Context and timestamps. | Standard timestamps |

### vaccinations

| Column | Type | Description | Constraints |
|---|---|---|---|
| id | TEXT | Primary key. | PK |
| dog_id | TEXT | Parent dog. | Not null, FK to dogs |
| vaccination_name | TEXT | Vaccine name. | Not null |
| date_administered | TEXT | Administration date. | Not null |
| expiration_date | TEXT | Expiry date. | Nullable |
| document_object_key | TEXT | R2 object key for evidence. | Nullable |
| created_at / updated_at | TEXT | Lifecycle fields. | Standard timestamps |

### behavior_snapshots

| Column | Type | Description | Constraints |
|---|---|---|---|
| id | TEXT | Primary key. | PK |
| dog_id | TEXT | Parent dog. | Not null, FK to dogs |
| recall_rating / leash_manners_rating / energy_level_rating | INTEGER | Behaviour ratings. | 1 to 5 when supplied |
| behavior_tags_json | TEXT | Array-like tags. | JSON text |
| notes | TEXT | Snapshot notes. | Nullable |
| created_at | TEXT | Snapshot timestamp. | Default current timestamp |

### walker_compliance_records

| Column | Type | Description | Constraints |
|---|---|---|---|
| id | TEXT | Primary key. | PK |
| organisation_id | TEXT | Owning tenant. | Not null |
| walker_id | TEXT | Parent walker. | Not null |
| record_type | TEXT | Compliance class. | `insurance`, `dbs_check`, `training`, `certification`, `licence`, `other` |
| title | TEXT | Short title. | Not null |
| description | TEXT | Detail. | Nullable |
| issue_date / expiry_date | TEXT | Validity window. | Nullable |
| status | TEXT | Current state. | `valid`, `expired`, `pending`, `revoked` |
| document_url | TEXT | Evidence location. | Nullable |
| notes / archived_at / created_at / updated_at | TEXT | Context and timestamps. | Standard timestamps |

### compliance_templates

| Column | Type | Description | Constraints |
|---|---|---|---|
| id | TEXT | Primary key. | PK |
| organisation_id | TEXT | Owning tenant. | Not null, FK to organisations |
| name | TEXT | Template name. | Not null |
| item_type | TEXT | Template category. | Not null |
| applies_to | TEXT | Target entity. | `walker`, `client`, `dog`, `organisation` |
| mandatory | INTEGER | Requirement flag. | `0` or `1` |
| default_validity_days | INTEGER | Suggested validity. | Nullable |
| reminder_days_before | INTEGER | Reminder lead time. | Nullable |
| notes | TEXT | Operational note. | Nullable |
| is_active | INTEGER | Active flag. | `0` or `1` |
| archived_at / created_at / updated_at | TEXT | Lifecycle fields. | Standard timestamps |

### walk_reports

| Column | Type | Description | Constraints |
|---|---|---|---|
| id | TEXT | Primary key. | PK |
| walk_id | TEXT | Parent walk. | Not null, FK to walks |
| walker_id | TEXT | Walker involved. | Nullable, FK to walkers |
| summary | TEXT | Walk summary. | Nullable |
| wee_done / poo_done / food_given / water_given / incident_flag | INTEGER | Operational booleans. | `0` or `1` |
| incident_notes | TEXT | Incident detail. | Nullable |
| duration_minutes | INTEGER | Recorded duration. | Nullable, non-negative |
| created_at / updated_at | TEXT | Lifecycle fields. | Standard timestamps |

### attachments

| Column | Type | Description | Constraints |
|---|---|---|---|
| id | TEXT | Primary key. | PK |
| entity_type | TEXT | Owning entity category. | Not null |
| entity_id | TEXT | Owning entity ID. | Not null |
| storage_provider | TEXT | Storage backend. | Default `r2` |
| object_key | TEXT | R2 object key. | Nullable until upload completes |
| original_filename | TEXT | Uploaded filename. | Nullable |
| mime_type | TEXT | MIME type. | Nullable |
| file_size_bytes | INTEGER | File size. | Nullable, non-negative |
| created_at / updated_at | TEXT | Lifecycle fields. | Standard timestamps |

### invoice_headers

| Column | Type | Description | Constraints |
|---|---|---|---|
| id | TEXT | Primary key. | PK |
| organisation_id | TEXT | Owning tenant. | Not null |
| client_id | TEXT | Billed client. | Not null |
| invoice_number | TEXT | Human-facing invoice number. | Not null, unique with organisation |
| status | TEXT | Invoice state. | `draft`, `issued`, `part_paid`, `paid`, `overdue`, `cancelled`, `credited` |
| issue_date / due_date / period_start_at / period_end_at | TEXT | Billing dates. | Nullable |
| currency_code | TEXT | ISO currency code. | Default `GBP` |
| subtotal_minor / tax_minor / total_minor / amount_paid_minor / balance_due_minor | INTEGER | Minor-unit values. | Default `0` |
| billing_contact_name / billing_email | TEXT | Billing addressee. | Nullable |
| payment_terms_days | INTEGER | Payment term days. | Default `14` |
| notes / internal_notes | TEXT | Invoice notes. | Nullable |
| archived_at / created_at / updated_at | TEXT | Lifecycle fields. | Standard timestamps |

### weather_snapshots

| Column | Type | Description | Constraints |
|---|---|---|---|
| id | TEXT | Primary key. | PK |
| organisation_id | TEXT | Owning tenant. | Not null |
| walk_id / route_id | TEXT | Related walk or route reference. | Nullable |
| latitude / longitude | REAL | Snapshot coordinates. | Nullable |
| temperature_c / feels_like_c / precipitation_mm / wind_speed_kph / humidity_percent | REAL | Weather metrics. | Nullable |
| condition | TEXT | Weather summary. | Nullable |
| source | TEXT | Weather provider. | Nullable |
| source_payload_json | TEXT | Raw provider payload. | JSON text |
| observed_at | TEXT | Observation timestamp. | Not null |
| created_at | TEXT | Insert timestamp. | Default current timestamp |

### route_snapshots

| Column | Type | Description | Constraints |
|---|---|---|---|
| id | TEXT | Primary key. | PK |
| organisation_id | TEXT | Owning tenant. | Not null |
| walk_id | TEXT | Parent walk. | Not null |
| start_lat / start_lng / end_lat / end_lng | REAL | Route endpoints. | Nullable |
| distance_m / duration_seconds / elevation_gain_m | REAL | Route metrics. | Nullable |
| route_polyline / route_geojson | TEXT | Route geometry. | Nullable |
| source / source_payload_json | TEXT | Provider information. | Nullable / JSON text |
| recorded_at | TEXT | Capture timestamp. | Not null |
| created_at | TEXT | Insert timestamp. | Default current timestamp |

### device_registrations

| Column | Type | Description | Constraints |
|---|---|---|---|
| id | TEXT | Primary key. | PK |
| organisation_id | TEXT | Owning tenant. | Not null |
| user_id | TEXT | Related user. | Nullable |
| device_type | TEXT | Device platform. | `ios`, `android`, `web`, `other` |
| device_name | TEXT | Human label. | Nullable |
| device_identifier | TEXT | Device identifier. | Nullable, unique with organisation |
| push_token | TEXT | Push token. | Nullable |
| last_active_at / revoked_at | TEXT | Lifecycle dates. | Nullable |
| created_at / updated_at | TEXT | Lifecycle fields. | Standard timestamps |

### calendar_sync_links

| Column | Type | Description | Constraints |
|---|---|---|---|
| id | TEXT | Primary key. | PK |
| organisation_id | TEXT | Owning tenant. | Not null |
| provider | TEXT | External calendar provider. | `google`, `apple`, `outlook`, `other` |
| external_calendar_id / external_calendar_name | TEXT | External identifiers. | Nullable |
| sync_direction | TEXT | Direction of sync. | `import_only`, `export_only`, `two_way` |
| sync_status | TEXT | Sync state. | `active`, `paused`, `error`, `revoked` |
| last_sync_at / last_successful_sync_at / last_error_at | TEXT | Operational timestamps. | Nullable |
| last_error_message | TEXT | Latest sync error. | Nullable |
| credentials_json / settings_json | TEXT | Provider config. | JSON text |
| created_at / updated_at | TEXT | Lifecycle fields. | Standard timestamps |

## Coverage note

Where a table is listed in the table index but does not yet have a field-by-field breakdown above, treat this file as the minimum current baseline and extend it in the next schema-touching pull request.

---
<p align="center">
  Built in Wales ❤️ Designed with Cwtch<br/>
  Adeiladwyd yng Nghymru ❤️ Dyluniwyd gyda Cwtch
</p>
