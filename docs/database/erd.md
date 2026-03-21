<img src="../../brand/app_icon_base.svg" alt="CiCwtch Logo" align="left" height="60" />
<!-- HEADER BADGES -->
<p align="right">
<a href="https://github.com/nathcymru/CiCwtch/actions/workflows/ci.yml"><img src="https://img.shields.io/github/actions/workflow/status/nathcymru/CiCwtch/ci.yml?branch=main&style=for-the-badge" alt="Build Status" /></a>
&nbsp;
<a href="https://github.com/nathcymru/CiCwtch/releases"><img src="https://img.shields.io/github/v/tag/nathcymru/CiCwtch?sort=semver&style=for-the-badge&label=Release" alt="Release" /></a>
&nbsp;
  <a href="https://github.com/nathcymru/CiCwtch/commits/main"><img src="https://img.shields.io/github/last-commit/nathcymru/CiCwtch?style=for-the-badge" alt="Last Commit" /></a>
</p clear="right">

# CiCwtch - Database ERD
## Mermaid entity-relationship view of the current D1 baseline

<p align="left">
  <a href="https://developers.cloudflare.com/d1/"><img src="https://img.shields.io/badge/Cloudflare%20D1-F38020?style=for-the-badge&logo=cloudflare&logoColor=white" alt="Cloudflare D1" /></a>
  &nbsp;
  <a href="https://www.sqlite.org/index.html"><img src="https://img.shields.io/badge/SQLite-003B57?style=for-the-badge&logo=sqlite&logoColor=white" alt="SQLite" /></a>
  &nbsp;
  <a href="https://mermaid.js.org/"><img src="https://img.shields.io/badge/Mermaid-FF3670?style=for-the-badge&logo=mermaid&logoColor=white" alt="Mermaid" /></a>
</p>
The diagram below is the quickest way to understand the current CiCwtch relational model.

- Tenant-owned tables carry `organisation_id`.
- Global reference tables do not.
- R2 file binaries are intentionally outside the ERD; only metadata pointers live in D1.

```mermaid
erDiagram
    organisations ||--o{ clients : owns
    organisations ||--o{ addresses : owns
    organisations ||--o{ dogs : owns
    organisations ||--o{ walks : owns
    organisations ||--o{ walkers : owns
    organisations ||--o{ invoice_headers : owns
    organisations ||--o{ client_contacts : owns
    organisations ||--o{ client_documents : owns
    organisations ||--o{ dog_medical_records : owns
    organisations ||--o{ compliance_templates : owns
    organisations ||--o{ walker_compliance_records : owns
    organisations ||--o{ weather_snapshots : owns
    organisations ||--o{ route_snapshots : owns
    organisations ||--o{ device_registrations : owns
    organisations ||--o{ calendar_sync_links : owns

    addresses ||--o{ clients : primary_or_billing_address
    clients ||--o{ dogs : owns
    clients ||--o{ client_contacts : has
    clients ||--o{ client_documents : has
    clients ||--o{ walks : books
    clients ||--o{ invoice_headers : billed

    breeds ||--o{ dogs : classifies
    vets ||--o{ dogs : supports

    dogs ||--o{ dog_notes : has
    dogs ||--o{ dog_medical_records : has
    dogs ||--o{ vaccinations : has
    dogs ||--o{ behavior_snapshots : has
    dogs ||--o{ walks : attends

    walkers ||--o{ walks : delivers
    walkers ||--o{ walker_compliance_records : holds

    walks ||--o{ walk_reports : produces
    walks ||--o{ route_snapshots : captures
    walks ||--o{ weather_snapshots : references
    walks ||--o{ invoice_lines : may_generate

    invoice_headers ||--o{ invoice_lines : contains
    invoice_line_item_templates ||--o{ invoice_line_items_catalog : seeds
    tax_rates ||--o{ invoice_lines : applies
```

## Notes

- Use the [data dictionary](data-dictionary.md) for field-level explanations.
- Use [schema notes and constraints](schema-notes.md) for uniqueness, FK behaviour, indexing, and deletion rules.
- Keep the Mermaid source in [`erd.mmd`](erd.mmd) aligned with any schema change.

---
<p align="center">
  Built in Wales ❤️ Designed with Cwtch<br/>
  Adeiladwyd yng Nghymru ❤️ Dyluniwyd gyda Cwtch
</p>
