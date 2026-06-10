---
name: repo-conventions
description: Naming conventions, file placement, lifecycle states, branch naming, and organizational rules for the ai-dev monorepo. Use when asked "where should I put", "how do I name", "what's the convention", or any organizational question. Does NOT cover project creation steps (load create-project) or navigation (load repo-navigation).
---

## Naming

- **Directories:** kebab-case. No spaces, no PascalCase, no underscores for new directories.
  - *Why:* Prevents case-collision bugs on macOS (case-insensitive), avoids shell-quoting issues.
  - Exception: Xcode app target directories inside projects (e.g., `drawer/Drawer/`) keep their PascalCase — these are project internals, not monorepo convention.
- **Files:** kebab-case for docs and configs. Source code follows language conventions (camelCase for TS/JS, snake_case for Python, PascalCase for Swift).
- **No ticket IDs in filenames.** Linear references go in AGENTS.md and PR titles, not filenames.

## Lifecycle

Three lifecycle tracks:

**Code projects:** `poc → mvp → production → archived`
- `poc` — proof of concept, testing feasibility
- `mvp` — has users, not fully rolled out
- `production` — fully rolled out, stable
- `archived` — retired, no longer maintained

**Agent/research projects:** `research → experimental → stable → archived`
- `research` — deep investigation, no implementation
- `experimental` — working implementation, not production-ready
- `stable` — reliable, actively used
- `archived` — retired

**Non-code projects:** `planning → active → completed → archived`
- `planning` — early stage, specs only
- `active` — in-progress work
- `completed` — finished
- `archived` — historical reference

Transitions are intentionally loose — update the Status field in AGENTS.md when appropriate.

## File Conventions

| File | Purpose | Required? |
|------|---------|-----------|
| `AGENTS.md` | AI agent rules, Identity block, routing | Required for every project |
| `index.md` | Catalog of contents | Required for every folder with sub-folders |
| `README.md` | Human-readable project description | Required for every project |

## Git Workflow

### Branches
Format: `<scope>/<description>` — scope from `.git-scope-map`.

| Special Prefix | When |
|----------------|------|
| `cross/*` | Cross-project work (all files allowed) |
| `root/*`, `meta/*` | Root-level files + `docs/*`, `scripts/*`, `.github/*`, `.agents/*` |

Pre-commit hook + CI enforce scope automatically.

### Commit Messages
Conventional commits: `feat:`, `fix:`, `chore:`, `docs:`, `refactor:`, `test:`

### Pull Requests
- Always create a PR — never push to main directly.
- One change per PR. Alfred (AI bot) auto-reviews.
- Load skill `github-workflow` for full protocol.

## Where Things Go

| What | Where |
|------|-------|
| Infrastructure, engines, shared tooling | `_infra/` |
| Agent implementations | `agents/` |
| OpenCode developer tools | `devtools/` |
| Standalone applications | `apps/` |
| Deep research (no code) | `research/` |
| Work-adjacent tooling | `work/` |
| Private planning for public projects | `<project>/_planning/` |
| AI agent skills | `.agents/skills/` |
| Monorepo-level documentation | `docs/` |
| Git hooks, helper scripts | `scripts/` |
| CI/CD workflows | `.github/workflows/` |

## Split Publishing

Directories marked `Public (split)` in `index.md` auto-publish to GitHub on merge to `main`.
- Never put secrets in split directories — everything in the prefix goes public.
- Private content for public projects lives in `<project>/_planning/` — CI strips these directories before publishing.
- AGENTS.md files are behavioral (no secrets) — they go public. This is intentional.

## What NOT to Commit

- `.env` — secrets must never be in git (use git-crypt for `.tfvars`)
- Cache: `.ruff_cache/`, `.pytest_cache/`, `__pycache__/`, `node_modules/`
- Build: `dist/`, `build/`, `.build/`
- `.entire/` — Entire.dev session data
- `.opencode/` — local OpenCode state
- `.xcodebuildmcp/` — Xcode build MCP state
- Large files (`.zip`, `.tar.gz`) — use `.gitignore`
