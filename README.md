<img src="brand/app_icon_base.svg" alt="CiCwtch Logo" align="left" height="60" />
<!-- HEADER BADGES -->
<p align="right">
<a href="https://github.com/nathcymru/CiCwtch/actions/workflows/ci.yml"><img src="https://img.shields.io/github/actions/workflow/status/nathcymru/CiCwtch/ci.yml?branch=main&style=for-the-badge" alt="Build Status" /></a>
&nbsp;
<a href="https://github.com/nathcymru/CiCwtch/releases"><img src="https://img.shields.io/github/v/tag/nathcymru/CiCwtch?sort=semver&style=for-the-badge&label=Release" alt="Release" /></a>
&nbsp;
  <a href="https://github.com/nathcymru/CiCwtch/commits/main"><img src="https://img.shields.io/github/last-commit/nathcymru/CiCwtch?style=for-the-badge" alt="Last Commit" /></a>
</p clear="right">

# CiCwtch

CiCwtch is a structured digital platform designed for small dog walking and pet care businesses across the UK and Europe.

It began as a passion project — an attempt to build something calmer, clearer, and more dependable than the tools I could find. What started as solving small, everyday frustrations has grown into a disciplined effort to create a platform that balances warmth with technical integrity.

CiCwtch is engineered with long-term architectural stability in mind. The aim is simple: dependable systems for professionals, reassuring simplicity for families.
<img src="brand/cutedog.png" alt="Bentley the Cavapoo" align="right" height="300" />

### 🖐 About the Builder

I build for peace, for enjoyment, and to fix the little inefficiencies in my world.

Dogs keep me grounded — especially Bentley, my delightfully bonkers Cavapoo. 🐾

I am autistic, and the structured puzzles of engineering — whether an application, infrastructure, or a Home Assistant system — bring a kind of quiet order to an otherwise noisy world. There is something quietly powerful about improving what is right in front of you, properly and with care.

CiCwtch is built in that spirit.
<p>&nbsp;</p clear="right">

## 🛠️ Development Status

CiCwtch is currently in development.

<p align="left">
  <a href="https://github.com/nathcymru/CiCwtch/pulse"><img src="https://img.shields.io/github/commit-activity/m/nathcymru/CiCwtch?style=for-the-badge" alt="Commit Activity" /></a>
</p>

The repository now includes a lean Flutter starter in `flutter/` so CI, Dependabot, and docs guardrails all point at a real application root. Native platform wrappers can be regenerated later with `flutter create . --platforms=android,ios,web` from inside `flutter/`.

<!-- DEVELOPMENT STATUS -->

<p align="left">
<a href="docs/gdpr/readme.md"><img src="https://img.shields.io/badge/DPIA-In%20Progress-FFA500?style=for-the-badge" alt="GDPR DPIA: In Progress" /></a>
&nbsp;
<a href="https://github.com/nathcymru/CiCwtch/security"><img src="https://img.shields.io/badge/GitHub%20Security-Open%20Dashboard-181717?style=for-the-badge&logo=github&logoColor=white" alt="GitHub Security" /></a>
&nbsp;
<a href="https://scorecard.dev/viewer/?uri=github.com/nathcymru/CiCwtch"><img src="https://api.scorecard.dev/projects/github.com/nathcymru/CiCwtch/badge?style=for-the-badge" alt="OpenSSF Scorecard" /></a>
</p>

This repository is publicly visible to support structured collaboration and transparency during the build phase.

### 📂 Key project documents:

- Architecture: [docs/architecture.md](docs/architecture.md)
- Roadmap: [docs/ROADMAP.md](docs/ROADMAP.md)
- Governance: [docs/GOVERNANCE.md](docs/GOVERNANCE.md)
- Changelog: [docs/CHANGELOG.md](docs/CHANGELOG.md)
- Contribution Guide: [.github/CONTRIBUTING.md](.github/CONTRIBUTING.md)
- Code of Conduct: [.github/CODE_OF_CONDUCT.md](.github/CODE_OF_CONDUCT.md)
- Security Policy: [.github/SECURITY.md](.github/SECURITY.md)
- Support: [.github/SUPPORT.md](.github/SUPPORT.md)
- Flutter App Starter: [flutter/README.md](flutter/README.md)
<p>&nbsp;</p>

## 📦 Package & Dependency Health
These badges monitor the health of CiCwtch dependencies across npm, Dart (pub.dev), and container tooling, helping ensure packages remain current and free from known vulnerabilities.
<!-- PACKAGE & DEPENDENCY HEALTH (HONEST UNTIL PUBLISHED) -->
<p align="left">
  <a href="docs/ROADMAP.md"><img src="https://img.shields.io/badge/npm-not%20published-lightgrey?style=for-the-badge&logo=npm&logoColor=white" alt="npm" /></a>
&nbsp;
  <a href="docs/ROADMAP.md"><img src="https://img.shields.io/badge/pub.dev-not%20published-lightgrey?style=for-the-badge&logo=dart&logoColor=white" alt="pub.dev" /></a>
&nbsp;
  <a href="docs/ROADMAP.md"><img src="https://img.shields.io/badge/Docker-not%20published-lightgrey?style=for-the-badge&logo=docker&logoColor=white" alt="Docker" /></a>
</p>

### 🏗 Built on
CiCwtch uses Cloudflare’s developer platform for edge-hosted services, with Workers providing the runtime and D1 and R2 handling database and object storage, as outlined in the system architecture documentation.
<p align="left">
  <a href="https://www.cloudflare.com/"><img src="https://img.shields.io/badge/Cloudflare-F38020?style=for-the-badge&logo=cloudflare&logoColor=white" alt="Cloudflare" /></a>
  &nbsp;
  <a href="https://developers.cloudflare.com/workers/"><img src="https://img.shields.io/badge/Cloudflare%20Workers-F38020?style=for-the-badge&logo=cloudflare&logoColor=white" alt="Cloudflare Workers" /></a>
  &nbsp;
  <a href="https://developers.cloudflare.com/d1/"><img src="https://img.shields.io/badge/Cloudflare%20D1-F38020?style=for-the-badge&logo=cloudflare&logoColor=white" alt="Cloudflare D1" /></a>
  &nbsp;
  <a href="https://developers.cloudflare.com/r2/"><img src="https://img.shields.io/badge/Cloudflare%20R2-F38020?style=for-the-badge&logo=cloudflare&logoColor=white" alt="Cloudflare R2" /></a>
</p>

### 🧠 Built with
The application is written primarily in Flutter and Dart, enabling a single cross-platform codebase, with Stripe handling payments and SQLite used where lightweight storage is required, as defined in the project’s User Requirements Specification (URS).
<p align="left">
  <a href="https://flutter.dev/"><img src="https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white" alt="Flutter" /></a>
  &nbsp;
  <a href="https://dart.dev/"><img src="https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white" alt="Dart" /></a>
  &nbsp;
  <a href="https://stripe.com/"><img src="https://img.shields.io/badge/Stripe-635BFF?style=for-the-badge&logo=stripe&logoColor=white" alt="Stripe" /></a>
  &nbsp;
  <a href="https://www.sqlite.org/"><img src="https://img.shields.io/badge/SQLite-003B57?style=for-the-badge&logo=sqlite&logoColor=white" alt="SQLite" /></a>
</p>

### 📱Built for
CiCwtch targets iOS, Android, modern web browsers, and Progressive Web App installation from a unified Flutter codebase, consistent with the platform scope described in the URS.
<p align="left">
  <a href="https://www.apple.com/ios/"><img src="https://img.shields.io/badge/iOS-000000?style=for-the-badge&logo=apple&logoColor=white" alt="iOS" /></a>
  &nbsp;
  <a href="https://www.android.com/"><img src="https://img.shields.io/badge/Android-34A853?style=for-the-badge&logo=android&logoColor=white" alt="Android" /></a>
  &nbsp;
  <a href="https://developer.mozilla.org/en-US/docs/Web/Progressive_web_apps"><img src="https://img.shields.io/badge/Web-4285F4?style=for-the-badge&logo=google-chrome&logoColor=white" alt="Web App" /></a>
  &nbsp;
  <a href="https://web.dev/progressive-web-apps/"><img src="https://img.shields.io/badge/PWA-5A0FC8?style=for-the-badge&logo=pwa&logoColor=white" alt="Progressive Web App" /></a>
</p>
<p>&nbsp;</p>

## 🤝 Collaboration & Community

CiCwtch welcomes thoughtful and structured collaboration under a formal approval process.  
<!-- COLLAB / COMMUNITY -->
<p align="left">
  <a href="https://github.com/nathcymru/CiCwtch/graphs/contributors"><img src="https://img.shields.io/github/contributors/nathcymru/CiCwtch?style=for-the-badge" alt="Contributors" /></a>
&nbsp;
  <a href="https://github.com/nathcymru/CiCwtch/issues"><img src="https://img.shields.io/github/issues/nathcymru/CiCwtch?style=for-the-badge" alt="Open Issues" /></a>
&nbsp;
  <a href="https://github.com/nathcymru/CiCwtch/pulls"><img src="https://img.shields.io/github/issues-pr/nathcymru/CiCwtch?style=for-the-badge" alt="Open PRs" /></a>
</p>

The project is proprietary (not open source), but approved contributors may participate either voluntarily or under procurement/contract arrangements via GitHub workflows.

Before submitting substantial changes, please open a GitHub Issue or Discord Discussion to align on direction and scope. This maintains architectural coherence and avoids duplicated effort.

<p align="left">
<a href="https://discord.gg/w8SsYu9pUT"><img src="https://img.shields.io/badge/Join%20Discord-5865F2?style=for-the-badge&logo=discord&logoColor=white" alt="Join Discord" /></a>
&nbsp;
<a href="https://github.com/nathcymru/CiCwtch/issues"><img src="https://img.shields.io/badge/Report%20an%20Issue-181717?style=for-the-badge&logo=github&logoColor=white" alt="Report Issue" /></a>
</p>

Areas where collaboration is especially valuable:

- Frontend and backend engineering  
- UX and accessibility refinement  
- Welsh language localisation  
- Documentation and technical clarity  
- Security review  

By contributing, you acknowledge that contributions may be incorporated into current or future commercial versions of the platform in accordance with the contribution terms.

### 🦴 Sponsorship & Support
If you find this project valuable, please consider supporting its ongoing development. Every bit of help goes a long way in keeping the project growing!

<p align="left">
<a href="https://github.com/sponsors/nathcymru"><img src="https://img.shields.io/badge/Join%20the%20Pack-EA4AAA?style=for-the-badge&logo=githubsponsors&logoColor=white" alt="Join our Pack" /></a>
&nbsp;
<a href="https://buymeacoffee.com/cicwtch"><img src="https://img.shields.io/badge/Buy%20us%20a%20Bone-FFDD00?style=for-the-badge&logo=buymeacoffee&logoColor=black" alt="Buy us a Bone" /></a>
</p>
<p>&nbsp;</p>

## 📜 Licensing

<p align="left">
  <a href="https://github.com/nathcymru/CiCwtch/blob/main/LICENSE"><img src="https://img.shields.io/badge/license-Proprietary%20%E2%80%94%20All%20Rights%20Reserved-lightgrey?style=for-the-badge" alt="License" /></a>
</p>
CiCwtch is proprietary software.  No permission is granted to copy, modify, distribute, sublicense, or commercially exploit this software, in whole or in part, without explicit written permission from the copyright holder, except as defined in the [docs/LICENCSE.md](docs/LICENCSE.md) file. Copyright © 2026 Nathan Jones.
<p>&nbsp;</p>

---
<p align="center">
  Built in Wales ❤️ Designed with Cwtch<br/>
  Adeiladwyd yng Nghymru ❤️ Dyluniwyd gyda Cwtch
</p>
