---
name: update-index
description: >-
  How to maintain index.md catalog files in the ai-dev monorepo. Covers the
  read-before-write protocol, required columns, By Status regeneration, and
  staleness checks. Use when adding a project to an index, changing a project's
  status, or checking for stale entries. Does NOT create projects (load
  create-project) or write AGENTS.md files (load create-agents-md).
author: David Helmus
version: 0.1.0
source:
  type: self
  name: ai-dev
triggers:
  - update indexes
  - update index.md
  - add project to index
  - regenerate by status
  - catalog entry
when_to_use:
  - >-
    Adding, moving, renaming, archiving, or changing status for indexed ai-dev
    projects.
  - Updating root or category `index.md` tables and By Status sections.
  - A project creation or metadata change requires catalog maintenance.
when_not_to_use:
  - Creating the project itself; use create-project first.
  - Writing project AGENTS.md instructions; use create-agents-md.
  - Updating non-catalog documentation.
---

## Core Principle

**Index-First Navigation.** Every folder with sub-folders has an `index.md`. Unindexed content is invisible to agents. The index is the source of truth for what exists.

## When to Update

- After creating a new project (mandatory — see `create-project` skill)
- After changing a project's status
- After deleting or archiving a project
- During periodic cleanup (check for stale entries)

## Read-Before-Write Protocol

**Never append blindly. Always read first.**

1. Read the existing `index.md` completely
2. Find the correct position for the new/updated entry (alphabetical in the table)
3. Integrate the change — insert, update, or remove the row
4. Regenerate the "By Status" section from the table data
5. Update the "Last updated" date

## Two Levels of index.md

### 1. Root `index.md`
Master catalog of all projects across all categories. Updated whenever any project is added, removed, or changes status.

### 2. Category `index.md` (e.g., `_infra/index.md`, `apps/index.md`)
Lists all projects in that category. Updated alongside the root index.

When creating a project, you must update BOTH:
- The category's `index.md` (add a row)
- The root `index.md` (add a row)

## Required Columns

| Column | Values | Notes |
|--------|--------|-------|
| Project | kebab-case name (linked) | Must match directory name. Format: `[name](path/)` |
| Status | Code: `poc / mvp / production / archived`. Agent: `research / experimental / stable / archived`. Non-code: `planning / active / completed / archived`. | Three lifecycle tracks |
| Type | `Private` or `Public (split)` | Whether auto-published via splitsh CI |
| Tech | Comma-separated tech list | e.g., `Python, FastMCP` |
| Description | One line | What this project does |

## By Status Sections

After the project table, include "By Status" sections:

```markdown
## By Status

### Production
- [name](path/) — description

### MVP
- ...
```

Remove empty status sections. Keep only sections that have entries.

## Handling Special Cases

**Archived projects:** Keep in the table with status `archived`. Add to "### Archived" section. Only remove when the directory is deleted.

**Split-published projects:** Mark as `Public (split)` in Type column. Private planning content lives in `<project>/_planning/` — CI strips it before publishing.

**New category:** If a new top-level category is created (rare), it needs its own `index.md` and a section in the root `index.md`.

## Staleness Check

During cleanup, flag entries matching ALL of:
- Status is `poc` or `planning`
- Created date (check `git log --oneline -1 -- <path>`) is > 6 months ago
- Directory has no source code (only AGENTS.md and README.md)

These are archive candidates. Verify with user before archiving.

## Hard Rule

> Creating a project without updating the parent and root index.md is not done. The index update is part of the project creation — not a follow-up task.
