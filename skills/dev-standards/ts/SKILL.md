---
name: ts-standards
description: >-
  TypeScript & Node.js coding standards — strict typing, Zod at IO boundaries,
  async patterns, 3-layer separation, pnpm ecosystem rules. Use when writing or
  reviewing TypeScript or Node.js code.
author: David Helmus
version: 0.1.0
source:
  type: self
  name: ai-dev
triggers:
  - writing TypeScript
  - new Node.js code
  - tsconfig setup
  - TypeScript code review
when_to_use:
  - Writing or modifying TypeScript/Node.js code
  - Setting up a new TS project or tsconfig
  - Reviewing TypeScript code quality
when_not_to_use:
  - React component patterns (load react-standards)
  - Project-specific conventions that a repo AGENTS.md already defines
---

# TypeScript & Node.js Standards

> **Mandate:** Robustness, Runtime Safety, and Explicit Intent.

## 1. Type Safety (Non-Negotiable)
- **Strict Mode:** `tsconfig.json` MUST have `"strict": true`.
- **No `any`:** `any` is forbidden. Use `unknown` and strict type narrowing (Zod/guards).
- **Return Types:** ALL functions must have explicit return types.
  ```ts
  // ❌ Bad
  const add = (a, b) => a + b;

  // ✅ Good
  const add = (a: number, b: number): number => a + b;
  ```
- **IO Boundaries:** ALL external data (API, DB, Env Vars) MUST be validated with **Zod** at the edge. Trust nothing.

## 2. Asynchronous Patterns
- **Async/Await Only:** No `.then()` chains.
- **Top-Level Await:** Allowed and encouraged in ES Modules.
- **Error Handling:**
  - Wrap `await` in `try/catch`.
  - Never throw raw strings. Throw `Error` objects or custom subclasses.
  - Handle `unknown` error types in catch blocks safely.

## 3. Architecture & Clean Code
- **3-Layer Separation:**
  1.  **Controller/CLI:** Input parsing, calling services.
  2.  **Service:** Pure business logic. Types in/Types out.
  3.  **Repository:** Database access / Raw IO.
- **Dependency Injection:** Pass dependencies (DBs, Services) as arguments. Do not import singletons directly into logic.
- **Immutability:** Prefer `const`. Use `readonly` for array/object properties in interfaces.

## 4. Ecosystem & Tooling
- **Package Manager:** Use **`pnpm`** exclusively.
  - *Why:* Enforces strict dependencies (no phantom access), saves disk space, and is faster.
  - ❌ No `npm` or `yarn`.
- **Validation:** `zod` (Runtime check).
- **Dates:** `date-fns` (Immutable). No `moment.js`.
- **Linting:** `eslint` or `biome` with strict rules.
- **Testing:** `vitest` (preferred) or `jest`. TDD is mandatory.

## 5. Negative Patterns (Don'ts)
- **NO** default exports (Use named exports).
- **NO** magic numbers/strings. Define constants.
- **NO** `console.log` in production code. Use a structured logger (load `logging-standards`).

Related skills: `react-standards`, `testing-standards`, `logging-standards`, `architecture-standards`.
