# Skill Standards & Format

## Directory Structure

Each skill lives in its own directory:

```
skills/my-skill/
├── SKILL.md              # The entry point (Minimal map)
├── reference.md          # Detailed docs (Progressive Disclosure)
└── templates/            # Output templates (if needed)
```

## SKILL.md Format

### Frontmatter (Required)

```yaml
---
name: my-skill
description: Use when [triggers]. Third person. No workflow summary.
triggers:
  - "trigger phrase"
license: MIT
compatibility: opencode
---
```

**Rules:**
- **name**: Lowercase, hyphens only. Must match directory.
- **description**: Starts with "Use when...". Tells the agent *when* to load it, not *how* to use it.
- **triggers**: Explicit phrases to help the router.

### Body Content

1.  **Core Principle**: One sentence. What is this skill for?
2.  **Context Requirements**: How to get identity/paths (use `identity-discovery`).
3.  **When to Use / NOT Use**: Clear boundaries.
4.  **Degrees of Freedom**: How much autonomy does the agent have?
    *   **High**: "Analyze and suggest" (Open field)
    *   **Medium**: "Follow this pattern" (Template)
    *   **Low**: "Execute exactly" (Narrow bridge)
5.  **Process/Protocol**: The step-by-step instructions.
6.  **Rationalization Table**: (For Discipline skills) Map excuses to reality.
7.  **Common Mistakes / Red Flags**: "Stop" signals.

## Rationalization Table (Pattern)

For skills that enforce discipline, anticipate agent laziness:

| Excuse | Reality |
| :--- | :--- |
| "It's too simple to test" | Simple code breaks. Test it. |
| "I'll do it later" | Later never comes. Do it now. |

## Progressive Disclosure

If a skill needs detailed reference material (API docs, long tables), **do not put it in `SKILL.md`**.
Create a `reference.md` and link to it:

```markdown
## API Reference
For detailed parameter options, see [reference.md](reference.md).
```

The agent will read `reference.md` *only if* it needs those details.

## Templates

If the skill produces a file (e.g., a report), use a template.
- Use `{{PLACEHOLDER}}` syntax.
- Store in `templates/` or root of skill folder.
- Don't make the agent "improvise" the format.
