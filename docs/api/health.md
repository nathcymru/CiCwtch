# Health API

## Endpoints

- `GET /health`
- `GET /api/v1/health`

## Response

```json
{
  "status": "ok",
  "service": "cicwtch-api"
}
```

## Notes

- No authentication is currently implemented.
- This is a lightweight liveness endpoint only.
- A dedicated readiness endpoint is **not** currently implemented.
