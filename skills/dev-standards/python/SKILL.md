---
name: python-standards
description: Python coding standards — 100% type hints, Pydantic for structured data, uv/ruff toolchain, modern 3.12+ idioms. Use when writing or reviewing Python code.
triggers:
  - "writing Python"
  - "new Python project"
  - "pyproject setup"
  - "Python code review"
when_to_use:
  - Writing or modifying Python code
  - Setting up a new Python project or toolchain
  - Reviewing Python code quality
when_not_to_use:
  - Project-specific conventions that a repo AGENTS.md already defines
---

# Python Standards

> **Mandate:** Type-Safe, Modern, and Pydantic-Driven.

## 1. Typing & Safety
- **100% Type Hints:** Every function argument and return value MUST be typed.
  ```python
  # ❌ Bad
  def process(data): ...

  # ✅ Good
  def process(data: dict[str, Any]) -> int: ...
  ```
- **Strict Checks:** Code must pass `mypy --strict` or `pyright`.
- **No Raw Dicts:** Use **Pydantic** models for all structured data. Do not pass `dict` around.

## 2. Modern Python (3.12+)
- **Package Management:** Use **`uv`** (preferred). It is the "pnpm of Python".
  - *Why:* Orders of magnitude faster than pip/poetry.
- **Pathlib:** Use `pathlib.Path` exclusively. No `os.path`.
- **F-Strings:** Use f-strings for formatting. No `%` or `.format()`.

## 3. Architecture
- **Pydantic Everything:** Use Pydantic for Config, DTOs, and API Schemas.
- **Dependency Injection:** explicit arguments > global variables.
- **Modules:** Keep files small. `__init__.py` should expose a clean public API.

## 4. Quality & Tooling
- **Linter/Formatter:** Use `ruff`. It replaces Flake8, Black, and Isort.
- **Testing:** `pytest`. Fixtures for setup.
- **Docstrings:** Google-style docstrings for complex logic only.

## 5. Negative Patterns (Don'ts)
- **NO** `from module import *`.
- **NO** mutable default arguments (`def foo(x=[])`).
- **NO** bare `except:` clauses. Catch specific exceptions.
- **NO** global state modification.

Related skills: `testing-standards`, `logging-standards`, `architecture-standards`.
