# Error Responses

> Error contract and status code conventions.

---

## Standard shape

All errors return `{"detail": "<human readable>"}` with the appropriate HTTP status. No stack traces in production responses.

## Status codes

| Code | Meaning | When |
|---|---|---|
| 400 | Validation failure | Malformed input, missing required field |
| 401 | Unauthenticated | Missing or invalid token |
| 403 | Authenticated but not authorized | Token valid, resource not yours |
| 404 | Not found | Resource missing |
| 409 | Conflict | Duplicate key, state mismatch |
| 429 | Rate-limited | Exceeded limiter |
| 500 | Server error | Log full detail server-side, return generic message |

## Logging
- Every 500 logs the full exception with request ID.
- Never log tokens, passwords, PII beyond user ID.
