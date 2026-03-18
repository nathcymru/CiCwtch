<img src="../../brand/app_icon_base.svg" alt="CiCwtch Logo" align="left" height="60" />
<!-- HEADER BADGES -->
<p align="right">
<a href="https://github.com/nathcymru/CiCwtch/actions/workflows/ci.yml"><img src="https://img.shields.io/github/actions/workflow/status/nathcymru/CiCwtch/ci.yml?branch=main&style=for-the-badge" alt="Build Status" /></a>
&nbsp;
<a href="https://github.com/nathcymru/CiCwtch/releases"><img src="https://img.shields.io/github/v/tag/nathcymru/CiCwtch?sort=semver&style=for-the-badge&label=Release" alt="Release" /></a>
&nbsp;
  <a href="https://github.com/nathcymru/CiCwtch/commits/main"><img src="https://img.shields.io/github/last-commit/nathcymru/CiCwtch?style=for-the-badge" alt="Last Commit" /></a>
</p clear="right">

# CiCwtch - Architecture Diagrams
## Simple diagrams reflecting the current implemented topology

<p align="left">
  <a href="https://flutter.dev/"><img src="https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white" alt="Flutter" /></a>
  &nbsp;
  <a href="https://developers.cloudflare.com/workers/"><img src="https://img.shields.io/badge/Cloudflare%20Workers-F38020?style=for-the-badge&logo=cloudflare&logoColor=white" alt="Cloudflare Workers" /></a>
  &nbsp;
  <a href="https://developers.cloudflare.com/d1/"><img src="https://img.shields.io/badge/Cloudflare%20D1-F38020?style=for-the-badge&logo=cloudflare&logoColor=white" alt="Cloudflare D1" /></a>
  &nbsp;
  <a href="https://developers.cloudflare.com/r2/"><img src="https://img.shields.io/badge/Cloudflare%20R2-F38020?style=for-the-badge&logo=cloudflare&logoColor=white" alt="Cloudflare R2" /></a>
</p>

## Runtime overview

```mermaid
flowchart LR
  User[User] --> Flutter[Flutter App]
  Flutter --> Worker[Cloudflare Worker API]
  Worker --> D1[(Cloudflare D1)]
  Worker --> R2[(Cloudflare R2)]
  Worker --> GoogleWeather[Google Weather API]
```

## Frontend structure

```mermaid
flowchart TD
  App[app/] --> Routing[routing]
  App --> Shell[shell]
  Features[features/] --> Clients
  Features --> Dogs
  Features --> Walks
  Features --> Walkers
  Features --> Invoices
  Features --> Dashboard
  Shared[shared/] --> Models
  Shared --> ApiClient
  Shared --> Presentation
```

## API resources

```mermaid
flowchart TD
  API[/api/v1/] --> Clients[clients]
  API --> Dogs[dogs]
  API --> Walks[walks]
  API --> Walkers[walkers]
  API --> Invoices[invoices / invoice-headers]
  API --> InvoiceLines[invoice-lines]
  API --> Breeds[breeds]
  API --> VetPractices[vet-practices]
  API --> Dashboard[dashboard]
  API --> Weather[weather/today]
  Dogs --> BehaviorSnapshots[dogs/:id/behavior-snapshots]
  Dogs --> Vaccinations[dogs/:id/vaccinations]
  Dogs --> Avatar[dogs/:id/avatar]
```

---
<p align="center">
  Built in Wales ❤️ Designed with Cwtch<br/>
  Adeiladwyd yng Nghymru ❤️ Dyluniwyd gyda Cwtch
</p>
