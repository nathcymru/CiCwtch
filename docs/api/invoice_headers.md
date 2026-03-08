# Invoice Headers API

Invoice header records linked to clients, with soft delete via `archived_at`.

## Endpoints


- `GET /api/v1/invoice-headers`
- `GET /api/v1/invoice-headers/:id`
- `POST /api/v1/invoice-headers`
- `PUT /api/v1/invoice-headers/:id`
- `DELETE /api/v1/invoice-headers/:id`


## Behaviour notes

- JSON responses only.
- Soft delete via `archived_at`.
- `client_id` must reference an existing, non-archived client.
- `invoice_number` must be unique.
- Current status values: `draft`, `issued`, `paid`, `cancelled`.
- PDF generation, payment gateway processing, and emailing are not implemented in Phase 1.


## Error shape

```json
{
  "error": {
    "message": "...",
    "type": "..."
  }
}
```
