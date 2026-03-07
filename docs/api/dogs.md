# Dogs API

The Dogs API manages dog records belonging to clients. Dogs are linked to a client via `client_id`.

All endpoints are versioned under:

/api/v1/dogs

All responses are JSON.

Dogs use **soft deletion**. Records are archived using `archived_at` and are not returned by default queries.

---

## Data Model

Typical dog record:

```json
{
  "id": "uuid",
  "client_id": "uuid",
  "name": "Bella",
  "breed": "Labrador",
  "notes": "Friendly with other dogs",
  "created_at": "timestamp",
  "updated_at": "timestamp",
  "archived_at": null
}
```

---

## Endpoints

### List Dogs

GET /api/v1/dogs

Returns all active dogs.

Example response:

```json
[
  {
    "id": "uuid",
    "client_id": "uuid",
    "name": "Bella",
    "breed": "Labrador",
    "created_at": "...",
    "updated_at": "...",
    "archived_at": null
  }
]
```

---

### Get Dog

GET /api/v1/dogs/:id

Returns a single dog.

Errors:

404 Not Found

---

### Create Dog

POST /api/v1/dogs

Example request:

```json
{
  "client_id": "uuid",
  "name": "Bella",
  "breed": "Labrador"
}
```

Creates a new dog linked to a client.

Validation:

- `client_id` must reference an existing non-archived client
- required fields must be present

---

### Update Dog

PUT /api/v1/dogs/:id

Updates an existing dog.

Rules:

- archived dogs cannot be updated
- `updated_at` is automatically updated

Errors:

404 Not Found

---

### Delete Dog

DELETE /api/v1/dogs/:id

Soft deletes a dog.

Behaviour:

- `archived_at` is set
- record is excluded from future queries

Errors:

404 Not Found

---

## Notes

- Dogs belong to **Clients**
- Deleting a dog does **not delete the client**
- Dog history and related records will be handled by other modules