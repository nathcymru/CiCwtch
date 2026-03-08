# Clients API

## Success response shape

Success responses return raw JSON values:
- list: JSON array
- get/create/update: JSON object
- delete: `{"deleted": true}`

Errors return:

```json
{
  "error": {
    "message": "...",
    "type": "..."
  }
}
```

## Endpoints

### GET /api/v1/clients
Returns non-archived clients ordered by `full_name` ascending.

### GET /api/v1/clients/:id
Returns one non-archived client or `404`.

### POST /api/v1/clients
Required body field:
- `full_name`

### PUT /api/v1/clients/:id
Required body field:
- `full_name`

### DELETE /api/v1/clients/:id
Soft deletes the record by setting `archived_at`.
