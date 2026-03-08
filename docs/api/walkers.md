# Walkers API

Walker records with soft delete via `archived_at`.

## Endpoints


- `GET /api/v1/walkers`
- `GET /api/v1/walkers/:id`
- `POST /api/v1/walkers`
- `PUT /api/v1/walkers/:id`
- `DELETE /api/v1/walkers/:id`


## Behaviour notes

- JSON responses only.
- Soft delete via `archived_at`.
- `full_name` is required.
- `active` is stored as integer `0`/`1` in D1 and mapped to `bool` in Flutter.


## Error shape

```json
{
  "error": {
    "message": "...",
    "type": "..."
  }
}
```
