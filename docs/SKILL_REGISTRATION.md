# Skill Registration Guide

In this ecosystem, skills follow a **Source vs. Deployment** model.

## 1. The Skill Factory (Source)
The `opencode-skills` repository (where you are now) is the **Source of Truth**, **Database**, and **Factory** for all skills. 
- All development, versioning, and testing happens here.
- Skills are organized in `skills/<skill-name>/SKILL.md`.

## 2. Registration (Deployment)

To make a skill usable by your agent, it must be **Registered**. Prefer the `skills` CLI because it understands multiple agents and can install into the shared `~/.agents/skills` location used by Codex and OpenCode. Direct symlinks remain available as a legacy fallback for OpenCode-only setups.

### Recognized Locations

Different agents look in different directories. The `skills` CLI handles this mapping for supported agents.

Common locations:

- `~/.agents/skills/<skill-name>/SKILL.md`
- `~/.codex/skills/<skill-name>/SKILL.md`
- `~/.config/opencode/skills/<skill-name>/SKILL.md`

OpenCode also searches these paths on startup/initialization:

**Global Skills (Recommended):**
- `~/.config/opencode/skills/<skill-name>/SKILL.md`
- `~/.claude/skills/<skill-name>/SKILL.md`

**Project-Specific Skills:**
- `.opencode/skills/<skill-name>/SKILL.md`
- `.claude/skills/<skill-name>/SKILL.md`

---

## 3. How to Register Skills With `skills`

From this directory:

```bash
./register_skills.sh list
./register_skills.sh
```

The default command installs all local skills for the `codex` and `opencode` agent ids:

```bash
npx skills@latest add . -g --full-depth --agent codex opencode --skill '*' -y
```

To install a subset:

```bash
SKILLS_AGENTS=codex SKILLS_NAMES="prd writing-plans" ./register_skills.sh
```

To install from the public split repository and let `skills update` track future changes:

```bash
./register_skills.sh github
npx skills@latest update -g -y
```

Local-path installs do not create an update lock. Refresh local installs by pulling the repo and rerunning:

```bash
./register_skills.sh
```

Restart the target agent after installing or updating skills so its skill manifest is rebuilt.

## 4. Legacy OpenCode Symlink Registration

To "activate" a skill from this factory:

1. **Identify the skill** in `skills/`.
2. **Copy the directory** to your global or project-specific skill folder.
   ```bash
   # Example: Registering jira-pulse globally
   mkdir -p ~/.config/opencode/skills/jira-pulse
   cp skills/jira-pulse/SKILL.md ~/.config/opencode/skills/jira-pulse/
   ```
3. **Restart OpenCode** (or start a new session) to trigger the discovery engine.

The old symlink workflow is still wrapped by:

```bash
./register_skills.sh legacy-opencode
```

---

## 5. Naming Conventions
To be correctly discovered, a skill must follow these naming rules:
- **Directory Name:** Must match the `name` field in the frontmatter.
- **Skill Name:** 1–64 characters, lowercase alphanumeric, single hyphen separators (e.g., `jira-pulse`).
- **File Name:** The main skill file must be named `SKILL.md` exactly.

---

## 6. Definition Structure (`SKILL.md`)
Every skill must start with a YAML frontmatter block:
- `name`: (Required) Must match directory name.
- `description`: (Required) 1-1024 chars. This is what the agent uses to select the skill.

---

## 7. How it Works (Discovery Engine)
1. **Detection:** OpenCode scans recognized directories for `SKILL.md` files.
2. **Indexing:** It adds the `name` and `description` to the `skill` tool's manifest.
3. **On-Demand Loading:** When an agent sees a relevant description, it calls `skill({ name: "skill-name" })` to fetch the full instructions.
