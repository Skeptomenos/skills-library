---
name: logging-standards
description: Logging standards — structured JSON logging (Pino/Consola), log levels, request IDs, PII redaction, no console.log. Use when implementing or reviewing logging.
triggers:
  - "add logging"
  - "console.log"
  - "structured logging"
  - "log levels"
when_to_use:
  - Implementing logging in backend or frontend code
  - Choosing a logging library or log format
  - Reviewing logs for PII/credential leakage
when_not_to_use:
  - Metrics/tracing/observability infrastructure (load devops-standards)
---

# Logging Standards

> **Mandate:** Logs must be machine-readable (JSON) and filterable (Levels).

## 1. The "No Console" Rule
- **Problem:** `console.log` prints unstructured text.
  - Hard to parse in Datadog/CloudWatch.
  - No "Level" (Debug vs Error).
  - No metadata (User ID, Request ID).
- **Rule:** `console.log`, `console.error`, `console.warn` are **FORBIDDEN** in backend/production code.

## 2. Best Practice: Structured Logging
Use a library that outputs **JSON objects**.

### Recommended Libraries
1.  **Pino (Node.js/Backend):**
    - *Why:* Fastest logger. Native JSON.
    - *Usage:* `logger.info({ userId: '123' }, 'User logged in')`
2.  **Consola (Frontend/Fullstack):**
    - *Why:* Browser-friendly, nice CLI output in dev, JSON in prod.

### The JSON Standard
```json
{
  "level": "error",
  "time": 1678888888,
  "msg": "Database connection failed",
  "context": {
    "requestId": "req_123",
    "dbHost": "localhost",
    "error": "ConnectionRefused"
  }
}
```

## 3. Log Levels (When to use what)
- **DEBUG:** Verbose details for dev (e.g., "Parsed API response").
- **INFO:** Key events (e.g., "User logged in", "Job started").
- **WARN:** Unexpected but handled (e.g., "Rate limit hit, retrying").
- **ERROR:** Something broke (e.g., "DB query failed"). **Must alert.**
- **FATAL:** App crashed.

## 4. Implementation (Frontend vs Backend)
- **Backend (Server):** Use **Pino**. Capture `requestId` in middleware and attach to every log.
- **Frontend (Client):** Use a wrapper (e.g., `logger.error`).
  - *Dev:* Print nicely to console.
  - *Prod:* Send critical errors to Sentry/PostHog (do not just print to user console).

## 5. Negative Patterns
- **NO** logging Sensitive Data (Passwords, Tokens). Use Pino's redaction option: `pino({ redact: ['password', 'token', '*.authorization'] })`.
- **NO** `JSON.stringify(error)`. Log the raw Error object so stack traces are preserved.

Related skills: `security-standards`, `devops-standards`.
