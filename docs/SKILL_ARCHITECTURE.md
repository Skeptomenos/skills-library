# Skill Architecture

This document defines the architectural pattern for skills. **Read this before modifying any skill.**

---

## Core Concept: Skills as Modular Context Units

A skill is NOT just "code that does something." A skill is a **self-contained unit** that serves three functions:

| Function             | Purpose                                              |
| -------------------- | ---------------------------------------------------- |
| **Context Template** | Tells an agent HOW to do something (workflow logic)  |
| **Output Template**  | Defines WHAT the output looks like (consistent format) |
| **Orchestration**    | Coordinates WHO does what (parallel execution)       |

---

## Skill Folder Structure

```
skill-name/
├── SKILL.md              # Workflow logic (required)
├── skill-name-template.md   # Output template (optional)
└── skill-name.prose      # OpenProse orchestration (optional)
```

### SKILL.md (Required)

The main skill file. Contains:
- **Frontmatter**: Metadata including `template` reference
- **Workflow phases**: Step-by-step execution instructions
- **Context discovery**: How to get required context
- **Output specification**: What to produce (references template)

### Template Files (Optional)

Define the output format with placeholders:
- `{{PLACEHOLDER}}` syntax for variable substitution
- Frontmatter for file metadata
- `SCAN_DATA_START` / `SCAN_DATA_END` markers for parseable sections

---

## Skills as Context Templates for Subagents

A key architectural insight: **skills shape how subagents work**.

When a subagent invokes a skill:
1. The skill's SKILL.md becomes the subagent's context
2. The subagent follows the workflow defined in SKILL.md
3. The subagent uses the template for consistent output
4. Results flow back to the orchestrating agent

This means skills are **composable**:
- Invoked directly by user (`/mail-triage`)
- Invoked by another skill as subagent context
- Invoked by OpenProse as part of parallel orchestration

---

## Nesting Pattern

Skills can invoke other skills for context discovery:

```
morning-boot (orchestrator)
├── identity-discovery (nested skill for identity)
├── mail-triage (subagent context template)
│   └── identity-discovery (nested, or uses passed context)
└── cal-grid (subagent context template)
    └── identity-discovery (nested, or uses passed context)
```

### Context Flow

1. **Orchestrator discovers context first** (optional optimization)
2. **Passes context to subagents** via OpenProse `context:` property
3. **Subagents check for passed context** before discovering their own
4. **If not passed, subagents discover independently**

---

## Template Placeholder Syntax

Templates use `{{PLACEHOLDER}}` syntax:

```markdown
# Report — {{DATE}}

**Generated:** {{TIME}}

## Summary

{{EXECUTIVE_SUMMARY}}
```

### Placeholder Conventions

| Pattern | Purpose | Example |
|---------|---------|---------|
| `{{UPPER_SNAKE}}` | Simple value substitution | `{{DATE}}`, `{{TIME}}` |
| `{{*_TABLE}}` | Multi-row table content | `{{ACTION_ITEMS_TABLE}}` |
| `{{*_COUNT}}` | Numeric count | `{{EMAIL_COUNT}}` |
| `{{#if CONDITION}}...{{/if}}` | Conditional sections | `{{#if MEETING_NOTES_COUNT > 0}}` |
