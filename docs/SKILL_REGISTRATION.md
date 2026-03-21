# Skill Registration Guide

In this ecosystem, skills follow a **Source vs. Deployment** model.

## 1. The Skill Factory (Source)
The `opencode-skills` repository (where you are now) is the **Source of Truth**, **Database**, and **Factory** for all skills. 
- All development, versioning, and testing happens here.
- Skills are organized in `skills/<skill-name>/SKILL.md`.

## 2. Registration (Deployment)
To make a skill usable by your agent, it must be **Registered**. In practice, this means copying or symlinking the skill directory from this factory into a location recognized by the OpenCode discovery engine.

### Recognized Locations
OpenCode searches these paths on startup/initialization:

**Global Skills (Recommended):**
- `~/.config/opencode/skills/<skill-name>/SKILL.md`
- `~/.claude/skills/<skill-name>/SKILL.md`

**Project-Specific Skills:**
- `.opencode/skills/<skill-name>/SKILL.md`
- `.claude/skills/<skill-name>/SKILL.md`

---

## 3. How to Register a Skill

To "activate" a skill from this factory:

1. **Identify the skill** in `skills/`.
2. **Copy the directory** to your global or project-specific skill folder.
   ```bash
   # Example: Registering jira-pulse globally
   mkdir -p ~/.config/opencode/skills/jira-pulse
   cp skills/jira-pulse/SKILL.md ~/.config/opencode/skills/jira-pulse/
   ```
3. **Restart OpenCode** (or start a new session) to trigger the discovery engine.

---

## 4. Naming Conventions
To be correctly discovered, a skill must follow these naming rules:
- **Directory Name:** Must match the `name` field in the frontmatter.
- **Skill Name:** 1–64 characters, lowercase alphanumeric, single hyphen separators (e.g., `jira-pulse`).

---

## 5. Definition Structure (`SKILL.md`)
Every skill must start with a YAML frontmatter block:
- `name`: (Required) Must match directory name.
- `description`: (Required) 1-1024 chars. This is what the agent uses to select the skill.

---

## 6. How it Works (Discovery Engine)
1. **Detection:** OpenCode scans recognized directories for `SKILL.md` files.
2. **Indexing:** It adds the `name` and `description` to the `skill` tool's manifest.
3. **On-Demand Loading:** When an agent sees a relevant description, it calls `skill({ name: "skill-name" })` to fetch the full instructions.
