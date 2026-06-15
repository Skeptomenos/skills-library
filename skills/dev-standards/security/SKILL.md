---
name: security-standards
description: >-
  Security standards — edge input validation, auth/authorization patterns, BOLA
  checks, secrets handling, PII redaction, OWASP web headers. Use when handling
  user input, authentication, secrets, or reviewing security.
author: David Helmus
version: 0.1.0
source:
  type: self
  name: ai-dev
triggers:
  - user input
  - authentication
  - secrets
  - security review
when_to_use:
  - 'Handling external input, auth flows, or secrets'
  - 'Reviewing code for injection, BOLA, or data leakage'
  - Setting security headers
when_not_to_use:
  - SQL injection specifics already covered when loading sql-standards
---

# Security Standards

> **Mandate:** Trust No One. Verify Everything.

## 1. Input Validation (The Firewall)
- **Edge Validation:** EVERY external input (API body, Query param, WebSocket message) MUST be validated with Zod/Pydantic.
- **Strict Mode:** Strip unknown fields. Do not allow "pollution" of extra data.
- **Type Casting:** Never cast user input (`input as User`). Validate it (`UserSchema.parse(input)`).

## 2. Authentication & Authorization
- **No Custom Crypto:** Use standard libraries (bcrypt, Argon2, WebCrypto API). NEVER implement hashing yourself.
- **Least Privilege:** API Tokens should be scoped (Read-Only vs Admin).
- **Broken Object Level Authorization (BOLA):** Always check ownership.
  - ❌ `SELECT * FROM items WHERE id = ?`
  - ✅ `SELECT * FROM items WHERE id = ? AND owner_id = ?`

## 3. Data Protection
- **Secrets:** NO secrets in code. NO secrets in Docker images. Load from ENV.
- **Logs:** Redact PII (Emails, Phones) and Credentials from logs.
- **Output:** Never return full user objects. Use a DTO to strip `password`, `salt`, `2fa_secret`.

## 4. Web Security (OWASP)
- **XSS:** React handles this mostly. Avoid `dangerouslySetInnerHTML`.
- **CSRF:** Use `SameSite=Strict` cookies.
- **Headers:** Set security headers (e.g., `helmet` for Express, or framework equivalent):
  - `Content-Security-Policy`
  - `X-Content-Type-Options: nosniff`
  - `Strict-Transport-Security`

## 5. Negative Patterns (Don'ts)
- **NO** sending Sensitive PII in URL params (`/login?token=secret`).
- **NO** committing `.env` files.
- **NO** disabling SSL verification in HTTP clients.

Related skills: `api-design-standards`, `sql-standards`, `logging-standards`, `devops-standards`.
