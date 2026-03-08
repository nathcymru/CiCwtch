# Dogs API

Dog records linked to a client via `client_id`, with soft delete via `archived_at`.

## Endpoints


- `GET /api/v1/dogs`
- `GET /api/v1/dogs/:id`
- `POST /api/v1/dogs`
- `PUT /api/v1/dogs/:id`
- `DELETE /api/v1/dogs/:id`


## Behaviour notes

- JSON responses only.
- Soft delete via `archived_at`.
- `client_id` is required and must reference an existing, non-archived client.
- Supported `sex` values: `male`, `female`, `unknown`.
- `neutered` is stored as integer `0`/`1` in D1 and mapped to `bool` in Flutter.


## Error shape

```json
{
  "error": {
    "message": "...",
    "type": "..."
  }
}
```
