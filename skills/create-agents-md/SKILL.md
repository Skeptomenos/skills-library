---
name: create-agents-md
description: How to write AGENTS.md files for the ai-dev monorepo. Covers size targets, required fields, what goes in vs out, templates for each level. Use when creating a new AGENTS.md, reviewing an existing one, or asking about AGENTS.md conventions. Does NOT create projects (load create-project) or update indexes (load update-index).
author: David Helmus
version: 0.1.0
source:
  type: self
  name: ai-dev
triggers:
  - "create AGENTS.md"
  - "update AGENTS.md"
  - "instructions file"
  - "project instructions"
  - "agent instructions"
  - "AGENTS.md conventions"
when_to_use:
  - "Creating a new AGENTS.md file in ai-dev."
  - "Updating an existing AGENTS.md for project or directory rules."
  - "Deciding what belongs in AGENTS.md versus README or docs."
  - "Checking size targets, identity fields, and templates."
when_not_to_use:
  - "Creating a new project directory; use create-project first."
  - "Updating index.md files; use update-index."
---

## Design Principles

1. **Standing orders only** — if the agent doesn't need it on every interaction in this directory, it belongs in a skill or README. AGENTS.md is loaded every session; wasted lines cost tokens on every interaction.
2. **Every rule has a rationale** — a rule without explanation is easily overridden. Pattern: `[rule] — [why it matters]`.
3. **Short imperative sentences** — one rule per line, direct statements.
4. **No duplication** — if a rule is inherited from a parent AGENTS.md, do not repeat it.
5. **Positive framing** — tell the agent what to do, not what not to do.

## Size Targets

| Level | Max Lines | Role |
|-------|-----------|------|
| Root | ~50 | Navigator — conventions, mandatory procedures, catalog pointer |
| Category (`_infra/`, `agents/`, etc.) | ~60 | Coordinator — dependency rules, tech routing |
| Project | ~30 (ceiling 60) | Identity + project-specific constraints |

**Chain budget:** ~170 lines from deepest project to root.

## Required Fields — Identity Block

Every project AGENTS.md must include:

```markdown
# {Project Name}

One-line description.

## Identity
- **Status:** {lifecycle state}
- **Tech:** {list of technologies}

Read `index.md` for project metadata.
```

### Lifecycle States

**Code:** `poc | mvp | production | archived`
**Agent/research:** `research | experimental | stable | archived`
**Non-code:** `planning | active | completed | archived`

## What Goes IN vs OUT

| Content | In AGENTS.md? | Where instead? |
|---------|--------------|----------------|
| Status, Tech (Identity) | Yes | Also in category `index.md` |
| "Read index.md for context" | Yes | — |
| Project-specific rules (with rationale) | Yes (only what differs from parent) | — |
| Description, overview | No | `index.md` + `README.md` |
| Quality gates, lint rules | No — inherited from root/category | — |
| Tech-specific standards | No — loaded via dev-handbook | — |
| Setup instructions | No | `README.md` |
| Architecture / design decisions | No | `DESIGN.md` or `README.md` |
| Build commands, operations | No | `README.md` |
| Anti-patterns, objectives | No | `README.md` |

## Templates

### Project AGENTS.md (~25 lines)

```markdown
# {Project Name}

{One sentence: what this project does.}

## Identity
- **Status:** {state}
- **Tech:** {list}

Read `index.md` for project metadata.

## Rules
{3-5 short imperative sentences. Project-specific only.}
{Each rule includes a rationale: [rule] — [why].}
```

### Category AGENTS.md (~40 lines)

```markdown
# {Category Name}

{One sentence: what this category contains.}

## Role
{What an agent does in this context. 3-4 lines.}

## Rules
{Category-specific rules with rationale. 5-10 rules.}

## References
{Pointers to docs, README, related skills.}
```

## Hard Rule

> An AGENTS.md that exceeds its size target or duplicates rules from a parent must be trimmed before the task is complete. Move excess content to README.md, a reference doc, or a skill. Bloated files waste tokens on every session for every user.

## Reference

Read `docs/guides/writing-instructions.md` for the full guide on writing effective instructions for Claude — rationale clauses, anti-sycophancy patterns, Sonnet vs Opus differences, skill description best practices, and an audit checklist.
