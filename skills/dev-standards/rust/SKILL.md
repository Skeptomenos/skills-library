---
name: rust-standards
description: >-
  Rust coding standards — no unwrap in production, clippy-clean, library-first
  structure, thiserror/anyhow error handling. Use when writing or reviewing Rust
  code.
author: David Helmus
version: 0.1.0
source:
  type: self
  name: ai-dev
triggers:
  - writing Rust
  - cargo project
  - Rust error handling
when_to_use:
  - Writing or modifying Rust code
  - Structuring a new Rust crate or binary
  - Reviewing Rust code quality
when_not_to_use:
  - Project-specific conventions that a repo AGENTS.md already defines
---

# Rust Standards

> **Mandate:** Memory Safety, Correctness, and Reliability.

## 1. Safety & Ownership
- **Unwrap is Forbidden:** NEVER use `.unwrap()` in production code.
  - Use `match`, `if let`, or `?` (try operator) to handle `Result` and `Option`.
  - Use `.expect("msg")` ONLY during startup/initialization or in tests.
- **Clippy:** Code must pass `cargo clippy -- -D warnings`.
- **Borrowing:** Prefer borrowing (`&str`, `&[T]`) over owning (`String`, `Vec<T>`) for read-only arguments.

## 2. Structure & Modularity
- **Library First:** Put core logic in `lib.rs`. `main.rs` should only parse args and call lib.
- **Modules:** Use granular modules. Public API (`pub`) should be minimal.
- **Error Handling:** Use specialized error types (e.g., `thiserror` for libs, `anyhow` for apps).

## 3. Modern Patterns
- **Iterators:** Prefer functional iterators (`.map()`, `.filter()`) over raw `for` loops.
- **Immutability:** Variables are immutable by default. Keep it that way unless mutation is strictly local.
- **Async:** Use `tokio` for async runtimes.

## 4. Ecosystem
- **Serialization:** `serde` is the standard.
- **CLI:** `clap` for argument parsing.
- **Logging:** `tracing` for structured logging.

## 5. Negative Patterns (Don'ts)
- **NO** `unsafe` blocks unless absolutely necessary and documented with `// SAFETY: ...`.
- **NO** global mutable state (`static mut`).
- **NO** complex macros where a function would suffice.

Related skills: `testing-standards`, `architecture-standards`.
