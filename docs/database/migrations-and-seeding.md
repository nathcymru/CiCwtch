<img src="../../brand/app_icon_base.svg" alt="CiCwtch Logo" align="left" height="60" />
<!-- HEADER BADGES -->
<p align="right">
<a href="https://github.com/nathcymru/CiCwtch/actions/workflows/ci.yml"><img src="https://img.shields.io/github/actions/workflow/status/nathcymru/CiCwtch/ci.yml?branch=main&style=for-the-badge" alt="Build Status" /></a>
&nbsp;
<a href="https://github.com/nathcymru/CiCwtch/releases"><img src="https://img.shields.io/github/v/tag/nathcymru/CiCwtch?sort=semver&style=for-the-badge&label=Release" alt="Release" /></a>
&nbsp;
  <a href="https://github.com/nathcymru/CiCwtch/commits/main"><img src="https://img.shields.io/github/last-commit/nathcymru/CiCwtch?style=for-the-badge" alt="Last Commit" /></a>
</p clear="right">

# CiCwtch - Database Build and Seed Strategy
## How the current schema is created and populated in a pre-live repository

<p align="left">
  <a href="https://developers.cloudflare.com/d1/"><img src="https://img.shields.io/badge/Cloudflare%20D1-F38020?style=for-the-badge&logo=cloudflare&logoColor=white" alt="Cloudflare D1" /></a>
  &nbsp;
  <a href="https://www.sqlite.org/index.html"><img src="https://img.shields.io/badge/SQLite-003B57?style=for-the-badge&logo=sqlite&logoColor=white" alt="SQLite" /></a>
  &nbsp;
  <a href="https://mermaid.js.org/"><img src="https://img.shields.io/badge/Mermaid-FF3670?style=for-the-badge&logo=mermaid&logoColor=white" alt="Mermaid" /></a>
</p>
## Current strategy

CiCwtch is currently documented as a **pre-live** system. The practical database strategy is therefore:

- maintain a canonical schema baseline,
- rebuild safely when structural drift is discovered, and
- reseed complete demo data for development and QA.

## Important current rule

The working baseline does **not** rely on long chains of historical migrations. The priority is a correct present-tense schema rather than preserving every past mistake like a museum exhibit.

## SQLite and D1 guardrails

- Use SQLite-compatible SQL only.
- Keep statements small enough for D1 limits.
- Avoid oversized `UNION ALL` blocks.
- Validate table shape before rebuilding.
- Copy data in manageable batches when rebuilding a table.

## Rebuild pattern

When a table must be corrected:

1. Inspect the current table definition and indexes.
2. Validate whether data conflicts exist.
3. Create a clean replacement table.
4. Copy rows into the clean table in SQLite-safe batches.
5. Drop the old table.
6. Rename the replacement table.
7. Recreate indexes.
8. Re-validate counts, constraints, and FKs.

## Seed-data expectations

Seed data is not cosmetic. It exists so that:

- the app boots into realistic states,
- dropdowns and joins can be exercised,
- R2 and provider pointer fields can be tested, and
- tenant isolation can be proven across multiple organisations.

Current documented seed coverage should include at least:

- organisations
- clients
- addresses
- dogs
- walkers
- walks
- users
- invoice supporting tables
- reference lookups such as breeds and vets
- operational child tables such as notes, medical records, vaccinations, documents, attachments, walk reports, behaviour snapshots, compliance templates, and compliance records

## When to update this file

Update this document whenever the project changes:

- how schema is created,
- how demo data is generated,
- which lookup datasets are treated as global, or
- which provider fields must be populated for test completeness.

---
<p align="center">
  Built in Wales ❤️ Designed with Cwtch<br/>
  Adeiladwyd yng Nghymru ❤️ Dyluniwyd gyda Cwtch
</p>
