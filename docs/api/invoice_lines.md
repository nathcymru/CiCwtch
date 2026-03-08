# Invoice Lines API

Invoice line records linked to invoice headers and optionally walks. These do **not** use soft delete.

## Endpoints


- `GET /api/v1/invoice-lines`
- `GET /api/v1/invoice-lines/:id`
- `POST /api/v1/invoice-lines`
- `PUT /api/v1/invoice-lines/:id`
- `DELETE /api/v1/invoice-lines/:id`


## Behaviour notes

- JSON responses only.
- `invoice_header_id` is required on create.
- `walk_id` is optional but validated when supplied.
- `quantity` must be positive.
- `unit_price_minor` and `line_total_minor` must be non-negative integers.
- `DELETE` is a hard delete because the schema has no `archived_at` column for invoice lines.


## Error shape

```json
{
  "error": {
    "message": "...",
    "type": "..."
  }
}
```
