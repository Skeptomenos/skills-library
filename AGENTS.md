# OpenCode Skills Repository

Source of Truth, Database, and Skill Factory for all AI coding agent skills.

## Identity
- **Status:** active
- **Tech:** Markdown, Bash/Node

## Core Protocol

**"No Slop" Rule**: Writing skills is TDD for process. Never create a skill without a baseline failure.

1. **RED**: Identify a task the agent fails at
2. **GREEN**: Create skill using `skill-generator`, verify pass
3. **REFACTOR**: Apply progressive disclosure

## Key Docs
- `docs/QUALITY.md` — Iron Law, verification gates
- `docs/TESTING_PROTOCOL.md` — Pressure tests, subagent templates
- `docs/SKILL_ARCHITECTURE.md` — Nesting, context flow, templates
- `docs/SKILL_STANDARDS.md` — Format, frontmatter
- `docs/SKILL_REGISTRATION.md` — Deployment, discovery, activation

## Discovery Locations
- **Shared global**: `~/.agents/skills/<name>/SKILL.md`
- **Codex global**: `~/.codex/skills/<name>/SKILL.md`
- **OpenCode global**: `~/.config/opencode/skills/<name>/SKILL.md`
- **Project**: `.agents/skills/<name>/SKILL.md` (auto-discovered)

## Registration
After creating or modifying skills, run `register_skills.sh` to refresh skills through `npx skills@latest`.

Use `register_skills.sh github` when you want an install from `Skeptomenos/skills-library` that can later be updated with `npx skills@latest update -g -y`.

## Private Skills
`x-bookmarks/` is a personal utility skill stored in `_planning/x-bookmarks/` (stripped by CI before publishing to the public skills-library repo).
