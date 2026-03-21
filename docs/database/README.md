<img src="../../brand/app_icon_base.svg" alt="CiCwtch Logo" align="left" height="60" />
<!-- HEADER BADGES -->
<p align="right">
<a href="https://github.com/nathcymru/CiCwtch/actions/workflows/ci.yml"><img src="https://img.shields.io/github/actions/workflow/status/nathcymru/CiCwtch/ci.yml?branch=main&style=for-the-badge" alt="Build Status" /></a>
&nbsp;
<a href="https://github.com/nathcymru/CiCwtch/releases"><img src="https://img.shields.io/github/v/tag/nathcymru/CiCwtch?sort=semver&style=for-the-badge&label=Release" alt="Release" /></a>
&nbsp;
  <a href="https://github.com/nathcymru/CiCwtch/commits/main"><img src="https://img.shields.io/github/last-commit/nathcymru/CiCwtch?style=for-the-badge" alt="Last Commit" /></a>
</p clear="right">

# CiCwtch - Database Documentation
## Source of truth for CiCwtch schema, relationships, and operating rules

<p align="left">
  <a href="https://developers.cloudflare.com/d1/"><img src="https://img.shields.io/badge/Cloudflare%20D1-F38020?style=for-the-badge&logo=cloudflare&logoColor=white" alt="Cloudflare D1" /></a>
  &nbsp;
  <a href="https://www.sqlite.org/index.html"><img src="https://img.shields.io/badge/SQLite-003B57?style=for-the-badge&logo=sqlite&logoColor=white" alt="SQLite" /></a>
  &nbsp;
  <a href="https://mermaid.js.org/"><img src="https://img.shields.io/badge/Mermaid-FF3670?style=for-the-badge&logo=mermaid&logoColor=white" alt="Mermaid" /></a>
</p>
This folder is the documentation source of truth for the CiCwtch database layer.

Architecture, API, and GDPR pages should summarise database behaviour and link here rather than restating table-by-table details in multiple places.

## Contents

- [Entity-relationship diagram](erd.md)
- [Mermaid source](erd.mmd)
- [Data dictionary](data-dictionary.md)
- [Schema notes and constraints](schema-notes.md)
- [Database build and seed strategy](migrations-and-seeding.md)
- [Database maintenance SOPs](maintenance.md)

## Current documented baseline

The current repository baseline assumes:

- Cloudflare D1 as the operational relational store.
- SQLite-compatible SQL only.
- Tenant scoping through `organisation_id` on tenant-owned tables.
- Global reference tables limited to `breeds` and `vets`.
- Invoice numbers unique per organisation via `UNIQUE (organisation_id, invoice_number)`.
- Attachment binaries stored in R2, with metadata and object keys stored in D1.
- Demo data present across canonical operational tables for local development, QA, and UI proving.

## Documentation rules

- Update this folder in the same pull request as any schema change.
- Keep architectural summaries short and link back here.
- Do not introduce a new table, relationship, enum, or retention rule without documenting it here.
- Where code and docs disagree, fix the docs or the code immediately; no drift is acceptable.

---
<p align="center">
  Built in Wales ❤️ Designed with Cwtch<br/>
  Adeiladwyd yng Nghymru ❤️ Dyluniwyd gyda Cwtch
</p>
