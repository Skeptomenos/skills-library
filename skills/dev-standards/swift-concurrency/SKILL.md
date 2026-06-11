---
name: swift-concurrency-standards
description: Swift 6.x concurrency standards — strict actor isolation, Sendable conformance, structured concurrency, legacy GCD replacements, common error fixes. Use when writing async Swift code or fixing concurrency errors.
triggers:
  - "Swift concurrency"
  - "actor isolation"
  - "Sendable error"
  - "DispatchQueue"
when_to_use:
  - Writing async/concurrent Swift code
  - Fixing Sendable or actor-isolation compiler errors
  - Migrating GCD code to modern concurrency
when_not_to_use:
  - General Swift/SwiftUI style questions (load swift-standards)
---

# Swift Concurrency Standards (Swift 6.x)

> **Mandate:** Strict Actor Isolation, Sendable Conformance, No Legacy Patterns.

## 1. Legacy Pattern Replacements

| Legacy | Modern |
|--------|--------|
| `DispatchQueue.main.async` | `@MainActor` or `MainActor.run {}` |
| `DispatchQueue.global().async` | `Task {}` or `Task.detached {}` |
| Completion handlers | `async/await` |
| `DispatchGroup` | `TaskGroup` or `async let` |
| `DispatchSemaphore` | Redesign with actors |
| `NSLock` / `os_unfair_lock` | `actor` isolation |

## 2. Main Actor Isolation

- **Swift 6 new projects:** Main actor isolation is ON by default. Don't add redundant `@MainActor`.
- **Legacy projects:** Add `@MainActor` explicitly when migrating.

## 3. Sendable Rules

Types crossing actor boundaries MUST be `Sendable`:
- Value types are implicitly Sendable
- Reference types need `final class` + immutable properties
- Use `@unchecked Sendable` only with proper internal synchronization

## 4. Task Management

- **Prefer structured concurrency:** `async let`, `TaskGroup` (auto-cancellation)
- **Unstructured tasks:** `Task {}` inherits actor context, `Task.detached {}` does not
- **Always check `Task.isCancelled`** in long-running work

## 5. Common Error Fixes

| Error | Fix |
|-------|-----|
| "Non-sendable type cannot cross actor boundary" | Make type `Sendable` or restructure |
| "Actor-isolated property cannot be referenced" | Add `await` or match actor context |
| "Call to main actor-isolated function in sync context" | Use `Task { @MainActor in }` |

## 6. Anti-Patterns

- **NO** `DispatchQueue.main.async` in new code
- **NO** `@unchecked Sendable` without understanding risks
- **NO** blocking main thread with semaphores
- **NO** ignoring cancellation

Related skills: `swift-standards`, `ios-agentic-standards`.
