<img src="../../brand/app_icon_base.svg" alt="CiCwtch Logo" align="left" height="60" />
<!-- HEADER BADGES -->
<p align="right">
<a href="https://github.com/nathcymru/CiCwtch/actions/workflows/ci.yml"><img src="https://img.shields.io/github/actions/workflow/status/nathcymru/CiCwtch/ci.yml?branch=main&style=for-the-badge" alt="Build Status" /></a>
&nbsp;
<a href="https://github.com/nathcymru/CiCwtch/releases"><img src="https://img.shields.io/github/v/tag/nathcymru/CiCwtch?sort=semver&style=for-the-badge&label=Release" alt="Release" /></a>
&nbsp;
  <a href="https://github.com/nathcymru/CiCwtch/commits/main"><img src="https://img.shields.io/github/last-commit/nathcymru/CiCwtch?style=for-the-badge" alt="Last Commit" /></a>
</p clear="right">

# CiCwtch - Attachments API
## Attachment upload and retrieval endpoints

<p align="left">
  <a href="https://developers.cloudflare.com/workers/"><img src="https://img.shields.io/badge/Cloudflare%20Workers-F38020?style=for-the-badge&logo=cloudflare&logoColor=white" alt="Cloudflare Workers" /></a>
  &nbsp;
  <a href="https://developers.cloudflare.com/d1/"><img src="https://img.shields.io/badge/Cloudflare%20D1-F38020?style=for-the-badge&logo=cloudflare&logoColor=white" alt="Cloudflare D1" /></a>
  &nbsp;
  <a href="https://developers.cloudflare.com/r2/"><img src="https://img.shields.io/badge/Cloudflare%20R2-F38020?style=for-the-badge&logo=cloudflare&logoColor=white" alt="Cloudflare R2" /></a>
</p>

Attachments link uploaded files (stored in R2) to business entities via metadata in D1.

## Endpoints

- `POST /api/v1/attachments`
- `GET /api/v1/attachments/:id`

## Upload

**Request:** `multipart/form-data`

| Field | Type | Required | Description |
|---|---|---|---|
| `file` | File | Yes | The file to upload |
| `entity_type` | string | Yes | Entity kind the attachment belongs to (e.g. `dog`, `client`) |
| `entity_id` | string | Yes | UUID of the parent entity |

**Response:** `201 Created`

```json
{
  "id": "uuid",
  "entity_type": "dog",
  "entity_id": "uuid",
  "storage_provider": "r2",
  "object_key": "attachments/uuid",
  "original_filename": "photo.jpg",
  "mime_type": "image/jpeg",
  "file_size_bytes": 102400,
  "created_at": "2025-01-01T00:00:00.000Z",
  "updated_at": "2025-01-01T00:00:00.000Z"
}
```

## Retrieve

**Request:** `GET /api/v1/attachments/:id`

Returns the raw file content with the stored `Content-Type` header.

| Status | Description |
|---|---|
| `200 OK` | File body returned with correct MIME type |
| `404 Not Found` | Attachment record or R2 object not found |

**Error response:**

```json
{
  "error": {
    "message": "Attachment not found",
    "code": "not_found"
  }
}
```

## Notes

- Object keys follow the format `attachments/{uuid}`.
- `storage_provider` is always `r2`.
- `mime_type` and `original_filename` are derived from the uploaded file.
- All SQL uses prepared statements in the Worker.

---
<p align="center">
  Built in Wales ❤️ Designed with Cwtch<br/>
  Adeiladwyd yng Nghymru ❤️ Dyluniwyd gyda Cwtch
</p>
