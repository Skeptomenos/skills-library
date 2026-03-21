# Configuring OpenCode Skills

OpenCode skills allow you to define reusable behaviors and protocols that agents can load on demand via the `skill` tool.

## Skill Discovery Hierarchy

OpenCode searches for skills in multiple locations, allowing for both global and project-specific behaviors.

| Level | Location | Scope |
| :--- | :--- | :--- |
| **Project-local** | `.opencode/skills/<name>/SKILL.md` | Only the current project. |
| **Walk-up** | Parent `.opencode/skills/` folders | Inherited by subdirectories up to git root. |
| **Global** | `~/.config/opencode/skills/<name>/SKILL.md` | Available across all projects on your machine. |
| **Claude-compatible** | `.claude/skills/` or `~/.claude/skills/` | Cross-tool compatibility. |

### Folder-Level Enabling

Because OpenCode walks up the directory tree to find `.opencode/skills/` folders, you can enable a set of skills for an entire directory tree by placing them in a parent folder's `.opencode/` directory.

Example:
```
~/my-knowledge-base/
├── .opencode/skills/
│   ├── morning-boot/
│   └── gardener/
├── work/
│   └── project-a/  <-- Has access to morning-boot and gardener
└── life/           <-- Has access to morning-boot and gardener
```

## Creating a Skill

Each skill must be in its own directory named after the skill, containing a `SKILL.md` file.

### Required Frontmatter

```yaml
---
name: skill-name-with-hyphens
description: Use when [specific triggering conditions]. Third person.
license: MIT (optional)
compatibility: opencode (optional)
---
```

**Naming Rules:**
- Max 64 characters.
- Lowercase alphanumeric and hyphens only.
- Must match the parent directory name.

**Description Rules:**
- Must be 1-1024 characters.
- Start with "Use when..." to define triggers.
- This is what the agent sees in its tool list to decide whether to load the skill.

## Progressive Disclosure in Skills

If a skill is large (>500 lines) or has many reference documents, use progressive disclosure:

```
skills/my-skill/
├── SKILL.md (Table of contents & core protocol)
├── reference.md
└── patterns.md
```

Link to these files from `SKILL.md`. The agent will read them only if needed.

## Skill Routing & Triggers

You can define explicit `triggers` in frontmatter to help the agent route requests to specific skills:

```yaml
---
name: morning-boot
description: Morning routine orchestrator
triggers:
  - "start my day"
  - "morning routine"
---
```

## Permissions

Control skill access in `opencode.json`:

```json
{
  "permission": {
    "skill": {
      "*": "allow",
      "internal-*": "deny",
      "experimental-*": "ask"
    }
  }
}
```

- `allow`: Loads immediately.
- `deny`: Hidden from agent.
- `ask`: Prompts user before loading.

---
*For more details, see the official [OpenCode Skills Documentation](https://opencode.ai/docs/skills/)*
