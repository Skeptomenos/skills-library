---
name: api-design-standards
description: API design standards — RESTful resources, JSON response envelope, status codes, pagination, versioning, input/output safety. Use when designing or modifying an API endpoint or contract.
triggers:
  - "design an API"
  - "new endpoint"
  - "REST API"
  - "API response shape"
when_to_use:
  - Designing or modifying API endpoints
  - Defining request/response contracts
  - Reviewing API consistency
when_not_to_use:
  - Auth and secrets handling specifics (load security-standards)
---

# API & Interface Standards

> **Mandate:** Predictable, Versioned, Safe.

## 1. RESTful API Rules
- **Resources:** Nouns only (`/users`, `/orders`). No RPC-style verbs (`/getUsers`).
- **Methods:**
  - `GET`: Read (Idempotent).
  - `POST`: Create (Return 201 + Resource).
  - `PUT`: Replace (Idempotent). `PATCH`: Partial update.
  - `DELETE`: Remove (Return 204).
- **Status:** Use 200, 201, 204 (Delete success), 400 (Bad Request), 401 (Auth), 403 (Perms), 404 (Missing), 500 (Bug).

## 2. JSON Response Contract
All endpoints MUST return this envelope:

```json
{
  "success": true, // or false
  "data": { ... }, // The resource (or null on error)
  "error": {       // Present only if success=false
    "code": "INVALID_INPUT",
    "message": "User friendly message",
    "details": { ... }
  },
  "meta": {        // Pagination info
    "page": 1,
    "limit": 20,
    "total": 100
  }
}
```

## 3. Pagination
- **Mandatory** for lists > 50 items.
- **Default:** `limit=20`. **Max:** `limit=100` (hard-enforced to prevent DB DoS).
- **Cursor-based** (preferred for feeds/real-time): `?cursor=xyz&limit=20`.
- **Offset-based** (fine for admin tables): `?page=1&limit=20`.

## 4. Versioning
- **URI Versioning:** `/api/v1/resource`.
- **Breaking Changes:** NEVER change a v1 response shape. Add a new field or create `/api/v2`.

## 5. Interface Safety
- **Validation:** Validate ALL inputs (Body, Query, Params) with Zod/Pydantic.
- **Filtering:** Strip unknown fields from inputs (`strict` mode).
- **Output:** Sanitize response data (remove `password_hash`) before sending.

Related skills: `security-standards`, `architecture-standards`.
