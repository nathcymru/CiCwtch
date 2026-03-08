# Walks API

Walk records linked to clients, dogs, and optionally walkers, with soft delete via `archived_at`.

## Endpoints


- `GET /api/v1/walks`
- `GET /api/v1/walks/:id`
- `POST /api/v1/walks`
- `PUT /api/v1/walks/:id`
- `DELETE /api/v1/walks/:id`


## Behaviour notes

- JSON responses only.
- Soft delete via `archived_at`.
- `client_id` and `dog_id` are required and validated.
- `walker_id` is optional but validated when supplied.
- Current status values: `planned`, `in_progress`, `completed`, `cancelled`.
- Current service type is a plain string; the Worker defaults to `walk` on create.


## Error shape

```json
{
  "error": {
    "message": "...",
    "type": "..."
  }
}
```
