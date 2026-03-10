<img src="../../brand/app_icon_base.svg" alt="CiCwtch Logo" align="left" height="60" />
<!-- HEADER BADGES -->
<p align="right">
<a href="https://github.com/nathcymru/CiCwtch/actions/workflows/ci.yml"><img src="https://img.shields.io/github/actions/workflow/status/nathcymru/CiCwtch/ci.yml?branch=main&style=for-the-badge" alt="Build Status" /></a>
&nbsp;
<a href="https://github.com/nathcymru/CiCwtch/releases"><img src="https://img.shields.io/github/v/tag/nathcymru/CiCwtch?sort=semver&style=for-the-badge&label=Release" alt="Release" /></a>
&nbsp;
  <a href="https://github.com/nathcymru/CiCwtch/commits/main"><img src="https://img.shields.io/github/last-commit/nathcymru/CiCwtch?style=for-the-badge" alt="Last Commit" /></a>
</p clear="right">

# CiCwtch - Dogs API
## Dog CRUD endpoints

<p align="left">
  <a href="https://developers.cloudflare.com/workers/"><img src="https://img.shields.io/badge/Cloudflare%20Workers-F38020?style=for-the-badge&logo=cloudflare&logoColor=white" alt="Cloudflare Workers" /></a>
  &nbsp;
  <a href="https://developers.cloudflare.com/d1/"><img src="https://img.shields.io/badge/Cloudflare%20D1-F38020?style=for-the-badge&logo=cloudflare&logoColor=white" alt="Cloudflare D1" /></a>
</p>
Dogs belong to clients through `client_id`.

Dogs may optionally reference a breed from the `breeds` lookup table via `breed_id`. When a breed is linked, the API response includes `breed_name` resolved via a join.

Dog media is stored in Cloudflare R2, not in D1. The API response includes nullable R2 object-key pointer fields: `avatar_object_key`, `profile_photo_object_key`, and `nose_print_object_key`. Avatar upload and retrieval is implemented via the `/api/v1/dogs/:id/avatar` endpoint. Profile photo and nose print upload workflows are not yet implemented.

## Endpoints

- `GET /api/v1/dogs`
- `GET /api/v1/dogs/:id`
- `POST /api/v1/dogs`
- `PUT /api/v1/dogs/:id`
- `DELETE /api/v1/dogs/:id`
- `GET /api/v1/dogs/:id/avatar` — retrieve dog avatar image from R2
- `POST /api/v1/dogs/:id/avatar` — upload dog avatar (multipart/form-data, field: `avatar_file`)
- `GET /api/v1/breeds` — list all available breeds

## Validation

- `client_id` is required and must reference an active client.
- `name` is required.
- `sex` must be one of `male`, `female`, or `unknown` when supplied.
- `breed_id` is optional and references the `breeds` lookup table.

---
<p align="center">
  Built in Wales ❤️ Designed with Cwtch<br/>
  Adeiladwyd yng Nghymru ❤️ Dyluniwyd gyda Cwtch
</p>
