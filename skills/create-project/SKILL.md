---
name: create-project
description: How to create a new project in the ai-dev monorepo. Covers placement via decision tree, required files, naming, scope map, and index.md updates. Use when asked to "create a new", "add a project", "start a new", "scaffold", or when a new piece of work needs a home. Does NOT cover AGENTS.md writing conventions (load create-agents-md) or index maintenance (load update-index).
---

## Step 0 — Linear Issue (Soft)

Before creating a project directory:
1. Ask: "Which Linear issue is this for?"
2. If issue exists: `linear issue view DEV-123 --no-pager` — read it, verify it matches the work
3. If no issue: "Should I create one?" — substantial work (>1 session) should have a Linear issue and project. Quick experiments don't need one.
   ```bash
   linear issue create --title "New project: <name>" --assignee self --no-interactive
   linear project create --name "<Project Name>" --team DEV --lead @me --status backlog
   ```

## Step 1 — Determine Placement

Run this decision tree:

```
Is it foundational infrastructure, shared tooling, or a published package?
  → YES → _infra/

Is it an AI agent implementation (personality, orchestration, knowledge)?
  → YES → agents/

Is it a developer tool for OpenCode ecosystem (dashboards, CLI, session tools)?
  → YES → devtools/

Is it a standalone application (user-facing, potentially published)?
  → YES → apps/

Is it deep research with no runnable code?
  → YES → research/

Is it work-adjacent tooling (tools for the day job, not personal projects)?
  → YES → work/
```

If genuinely ambiguous, default to `devtools/` and note the ambiguity in AGENTS.md.

## Step 2 — Create the Directory

- Name: **kebab-case**, no spaces, no ticket IDs
- Example: `devtools/session-viewer/`

## Step 3 — Create Required Files

Three files required for every project:

**AGENTS.md** — behavioral rules (slim):

```markdown
# {Project Name}

One-line description.

## Identity
- **Status:** {poc / mvp / production / archived — or research / experimental / stable / archived}
- **Tech:** {list of technologies}

Read `index.md` for project metadata.

## Rules
{Only what differs from the category AGENTS.md. If nothing differs, remove this section.}
```

**index.md** — project metadata (for category catalog):
Not needed per-project — the project is added to the parent category `index.md` instead.

**README.md** — human-readable description:

```markdown
# {Project Name}

{Description. Setup instructions. Usage.}
```

## Step 3b — Create `_planning/`

Create a `_planning/` subdirectory for development context — plans, session notes, and internal docs that support the project but aren't part of the deliverable:

```
<project>/_planning/
```

**What goes in `_planning/`:**
- Implementation plans (see `writing-plans` skill)
- Strategy and decision docs ("why we're building this")
- Session logs and handoff notes
- Code reviews and QA reports
- Competitive analysis, private brainstorm notes

**What does NOT go in `_planning/`:**
- Secrets → git-crypt (`.env`, `.tfvars`)
- AGENTS.md → stays in project root (behavioral, goes public)
- README.md → stays in project root (helps contributors)
- Source code → stays in project root (goes public)

For public (split) projects, CI automatically strips `_planning/` directories before publishing to public repos. For private projects, `_planning/` keeps planning artifacts organized and separated from deliverable code.

## Step 4 — Add to `.git-scope-map`

**This step is mandatory.** Without it, the pre-commit hook will reject commits on scoped branches.

Add a line to `.git-scope-map`:
```
<category>/<project-name>:<category>/<project-name>/
```

Example: `devtools/session-viewer:devtools/session-viewer/`

## Step 5 — Update Parent `index.md`

**This step is mandatory. Do not skip it.**

1. Read the category's `index.md` (e.g., `devtools/index.md`)
2. Add a new row to the Projects table
3. Add the project to the correct "By Status" section
4. Update the "Last updated" date
5. Also update the root `index.md` with the new project

See skill `update-index` for the detailed protocol.

## Step 6 — Tech-Specific Setup

After the directory and required files are created:

- **TypeScript:** Load the `ts-standards` skill (`_infra/skills/skills/dev-standards/ts/SKILL.md`)
- **Python:** Load the `python-standards` skill (`_infra/skills/skills/dev-standards/python/SKILL.md`)
- **Swift:** Read project-specific rules (Drawer, Murmeln have their own)
- **Terraform:** Load the `devops-standards` skill (`_infra/skills/skills/dev-standards/devops/SKILL.md`)

Do not create build config files in this skill — those are handled by tech-specific standards.

## Hard Rules

> - Directory name must be kebab-case
> - AGENTS.md + README.md are required
> - `.git-scope-map` entry is required
> - Parent `index.md` + root `index.md` must be updated before the task is done
