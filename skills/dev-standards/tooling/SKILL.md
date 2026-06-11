---
name: tooling-standards
description: Tooling standards — task runner preference (just > make), required package managers (pnpm/uv/cargo), AST-based code transformation, linter/formatter matrix. Use when choosing tools, task runners, or setting up linting.
triggers:
  - "task runner"
  - "package manager"
  - "linter setup"
  - "which tool"
when_to_use:
  - Choosing or configuring build/lint/format tooling
  - Deciding how to run project tasks
  - Structural code transformations
when_not_to_use:
  - Dependency vetting process (load workflow-standards)
---

# Tooling Standards

> **Mandate:** Use the right tool for the job. Prefer modern, maintained options.

## 1. Task Runners
Preference order:
1. **`just`** - If `justfile` exists, use it for build/test/lint.
2. **`make`** - If `Makefile` exists and no `justfile`.
3. **Ask user** - If neither exists, confirm before adding one.

## 2. Code Transformation
- **AST-first:** Prefer `ast-grep` for structural code edits over regex.
- **Regex:** Only for simple text replacements (comments, strings, config values).
- **Manual:** For complex refactors requiring semantic context.

## 3. Package Managers (by ecosystem)

| Ecosystem | Required Tool | Forbidden        |
| --------- | ------------- | ---------------- |
| Node.js   | `pnpm`        | `npm`, `yarn`    |
| Python    | `uv`          | `pip`, `poetry`  |
| Rust      | `cargo`       | -                |

## 4. Environment Management
- **Nix:** If `flake.nix` exists, respect it. Do not run `nix` commands that modify the environment without user approval.
- **Docker:** Preferred for CI reproducibility.
- **Local Setup:** Document in `README.md` or `CONTRIBUTING.md`.

## 5. Linting & Formatting
Run before every commit:

| Language   | Formatter       | Linter                          |
| ---------- | --------------- | ------------------------------- |
| TypeScript | `prettier`      | `eslint` or `biome`             |
| Python     | `ruff format`   | `ruff check`                    |
| Rust       | `cargo fmt`     | `cargo clippy --all-features`   |
| SQL        | `sqlfluff`      | `sqlfluff`                      |

Related skills: `ts-standards`, `python-standards`, `workflow-standards`.
