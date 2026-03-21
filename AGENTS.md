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
- **Project**: `.agents/skills/<name>/SKILL.md` (auto-discovered)
- **Global**: `~/.config/opencode/skills/<name>/SKILL.md`

## Registration
After creating or modifying skills, run `register_skills.sh` to update global symlinks.

## Private Skills
`x-bookmarks/` is a personal utility skill stored at `_planning/skills/x-bookmarks/` (outside the split prefix — not published to the public skills-library repo).
