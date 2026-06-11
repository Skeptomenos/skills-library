---
name: testing-standards
description: Testing standards — TDD workflow, testing pyramid (unit/integration/e2e), mocking rules (prefer real over fake), test organization, back-pressure gates. Use when writing, restructuring, or reviewing tests.
triggers:
  - "writing tests"
  - "test strategy"
  - "mocking"
  - "TDD"
when_to_use:
  - Writing or restructuring tests
  - Deciding what to mock vs run for real
  - Setting up test tooling for a project
when_not_to_use:
  - CI pipeline configuration (load devops-standards)
---

# Testing & QA Standards

> **Mandate:** The Ratchet. No regression allowed.

## 1. TDD Workflow
1.  **Write Failing Test:** Prove the feature is missing or the bug exists.
2.  **Verify Failure:** Run test -> Red.
3.  **Implement:** Minimal code to pass.
4.  **Verify Success:** Run test -> Green.

## 2. The Pyramid
- **Unit (60%):** Pure functions, Zod schemas, Utils.
  - *Mocking:* None.
  - *Tool:* Vitest/Pytest.
- **Integration (30%):** Services + Database.
  - *Mocking:* External APIs (Stripe, AI) ONLY. Use REAL SQLite/Docker DB.
  - *Tool:* Vitest + Testcontainers.
- **E2E (10%):** Critical User Flows (Login -> Success).
  - *Tool:* Playwright.

## 3. Mocking Rules
Mocks can create false confidence. Prefer real implementations where practical.

- **Prefer Real Over Fake:**
  - Use real databases via Docker/Testcontainers, not in-memory mocks.
  - Use sandbox/test environments for external APIs (Stripe test mode, not HTTP mocks).
- **Internal:** Do NOT mock your own Service/Repo logic. Test the integration.
- **When Mocking is Acceptable:**
  - 3rd party APIs with no sandbox environment, or where cost/latency makes real calls impractical (use MSW for HTTP mocks).
  - Time (`Date.now()`) and randomness for deterministic tests.
  - Network boundaries only (not internal interfaces).
- **Verify Against Contracts:** If you mock an external API, validate your mock matches the real API's behavior (use contract tests or recorded fixtures).

## 4. Test Organization
- **Unit Tests:** Co-located with source code.
  - `src/features/auth/user.ts` → `src/features/auth/user.test.ts`
- **Integration/E2E:** Top-level `tests/` folder.
  - `tests/integration/api.test.ts`
  - `tests/e2e/login.spec.ts`
- **Naming:** Use `*.test.ts` for Vitest, `*.spec.ts` for Playwright.

## 5. Back Pressure Gates
Code is **REJECTED** if:
- [ ] Any test fails.
- [ ] Linting fails (ESLint/Ruff).
- [ ] Type Check fails (TSC/Mypy).

Related skills: `ts-standards`, `python-standards`, `devops-standards`.
