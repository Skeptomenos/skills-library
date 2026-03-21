# Progressive Disclosure

> "Context is a public good. Do not pollute it."

## The Principle

Since `AGENTS.md` loads on every request, putting 500 lines of rules in it is wasteful and confusing.
**Progressive Disclosure** means giving the agent a map, not the entire territory.

## Implementation

### 1. The Root File (`AGENTS.md`)
Keep this under 60 lines (ideally).
It should contain:
- **Project Identity**: One sentence (What/Why).
- **Core Stack**: Package manager, key frameworks.
- **The Map**: Links to detailed docs.

### 2. The `docs/` Directory
Create specific markdown files for specific domains.

| File | Purpose |
| :--- | :--- |
| `docs/TYPESCRIPT.md` | Typing rules, strict mode settings. |
| `docs/TESTING.md` | How to run tests, where tests live. |
| `docs/DB_SCHEMA.md` | Schema design, migration rules. |
| `docs/QUALITY.md` | The "Always Works" / "No Slop" discipline rules. |

### 3. Linking
In `AGENTS.md`, use this format:

```markdown
For TypeScript conventions, see docs/TYPESCRIPT.md
For testing patterns, see docs/TESTING.md
For quality standards, see docs/QUALITY.md
```

## Why This Works
The agent is smart enough to read `docs/TYPESCRIPT.md` *only* when it is writing TypeScript. When it is writing SQL, it reads `docs/DB_SCHEMA.md`.
This keeps the active context window focused and relevant.

---
*Source: HumanLayer Blog*
