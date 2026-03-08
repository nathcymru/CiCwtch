# Clients API

Client records with soft delete via `archived_at`.

## Endpoints


- `GET /api/v1/clients`
- `GET /api/v1/clients/:id`
- `POST /api/v1/clients`
- `PUT /api/v1/clients/:id`
- `DELETE /api/v1/clients/:id`


## Behaviour notes

- JSON responses only.
- Soft delete via `archived_at`.
- `full_name` is required.
- `address_id` is present in the schema but address CRUD is not yet implemented in Phase 1.


## Error shape

```json
{
  "error": {
    "message": "...",
    "type": "..."
  }
}
```
