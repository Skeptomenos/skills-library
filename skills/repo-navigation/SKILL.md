---
name: repo-navigation
description: How to navigate the ai-dev monorepo, find projects, discover what exists, or understand where things are located. Use when asked "where is", "find the", "what projects exist", "show me", or any navigation question about the repo. Does NOT cover conventions or placement decisions (load repo-conventions).
---

## Three-Layer Navigation

This repo uses three layers of metadata. Always follow this order:

1. **AGENTS.md** (rules) — auto-loaded, tells you constraints and routing for this directory
2. **index.md** (catalog) — read on demand, tells you what exists in this directory
3. **Skills** (procedures) — loaded when needed, tells you how to do things

**Rule: read index.md first, then navigate.** The index is the source of truth for what exists — it includes status, type, tech, and description metadata that file listings don't have.

## Top-Level Layout

```
ai-dev/
├── _infra/          Foundational infrastructure (dev-handbook, skills, MCP servers, ralphus)
├── agents/          Specialized agent implementations (personal-os, team-os, thoth)
├── devtools/        OpenCode ecosystem tools (canvas, kanban, opensync, inspect, smart-fork)
├── apps/            Standalone applications (murmeln, vibe-remote, portfolio-prism, open-jupy, drawer)
├── research/        Deep research projects (agentic-knowledge)
├── work/            Work-adjacent tools (akasha-records)
├── <project>/_planning/  Private planning content (stripped by CI before public split)
├── docs/            Monorepo-level documentation
├── scripts/         Git hooks, worktree helper
└── .agents/skills/  AI agent skills and procedures
```

## How to Find Things

**Find a project:** Read `index.md` at the repo root. Search by name, status, type, or tech.

**Find projects in a category:** Read the category's `index.md` (e.g., `_infra/index.md`, `apps/index.md`).

**Find a project's rules:** Read the project's `AGENTS.md`. Every project has one with an Identity block (Status + Tech).

**Find private planning content:** Check `<project>/_planning/` inside the project directory. CI strips these before publishing to public repos.

## How to Search Across the Repo

1. Read root `index.md` — the master catalog has columns: Project, Status, Type, Tech, Description
2. Filter by the column you need (e.g., all `production` projects, all `Public (split)` projects)
3. For deeper details, read the project's own `AGENTS.md`

## Split Publishing

Some directories are auto-published to public GitHub repos via splitsh-lite CI on merge to `main`. The root `index.md` marks these as `Public (split)` in the Type column. Private content lives in `<project>/_planning/` — CI strips these directories before publishing.

## Cross-References

- A project's `AGENTS.md` tells you its rules and Identity (Status + Tech)
- A category's `index.md` tells you what projects exist in that category
- `docs/git-workflow.md` explains branching, scope enforcement, and secrets
- `.git-scope-map` maps branch scopes to allowed directories
