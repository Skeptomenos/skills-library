# OpenCode Skills Repository

A collection of reusable skills for AI coding agents. Skills are markdown-based instruction sets that shape how agents behave during specific tasks.

## Philosophy

Skill writing is **TDD for process documentation**:

| Phase | Action |
|-------|--------|
| RED | Run task without skill, document failure |
| GREEN | Write skill to fix that failure |
| REFACTOR | Optimize for brevity and clarity |

**The "No Slop" Rule**: Never create a skill without a baseline failure. Context is a public good—every token competes with the user's actual request.

## Skills

| Skill | Purpose |
|-------|---------|
| `skill-generator` | Meta-skill for creating new skills (TDD methodology) |
| `auto-skill` | Autonomous skill extraction from work sessions |
| `agents-md` | Audits AGENTS.md files using progressive disclosure |
| `prd` | Generate AI-optimized Product Requirements Documents |
| `morning-boot` | Daily operations orchestrator—parallelizes email/calendar scans |
| `evening-close` | Day closure, extracts incomplete tasks, persists learnings |
| `mail-triage` | Inbox processing with classification (ACTION/FYI/ARCHIVE) |
| `cal-grid` | Calendar analysis—meetings, deep work slots, prep needs |
| `identity-discovery` | KB context discovery utility |
| `gardener` | Knowledge base health maintenance |

## Structure

```
skills/
├── AGENTS.md              # Entry point
├── docs/                  # Core protocols
│   ├── CORE_PHILOSOPHY.md
│   ├── QUALITY.md
│   ├── SKILL_ARCHITECTURE.md
│   ├── SKILL_STANDARDS.md
│   ├── TESTING_PROTOCOL.md
│   └── PLANNING.md
├── docu/                  # Reference documentation
│   ├── AGENTS-MD-GUIDE.md
│   └── OPENCODE-SKILLS-CONFIG.md
└── skills/                # Individual skills
    └── <skill-name>/
        ├── SKILL.md       # Main skill file (required)
        ├── *-template.md  # Output template (optional)
        └── docs/          # Reference docs (optional)
```

## Usage

### Skill Discovery

OpenCode discovers skills via hierarchy:
1. **Project-local**: `.opencode/skills/<name>/SKILL.md`
2. **Walk-up**: Parent `.opencode/skills/` folders
3. **Global**: `~/.config/opencode/skills/<name>/SKILL.md`

### Invoking Skills

```
/morning-boot
/mail-triage
skill({ name: "agents-md" })
```

### Creating New Skills

Use the `skill-generator` skill:

1. Document baseline failure (RED phase)
2. Run `/skill-generator` to scaffold
3. Verify agent passes task (GREEN phase)
4. Apply progressive disclosure (REFACTOR phase)

## Documentation

| Document | Content |
|----------|---------|
| `docs/QUALITY.md` | The Iron Law, Verification Gates |
| `docs/TESTING_PROTOCOL.md` | Pressure tests, Subagent templates |
| `docs/SKILL_ARCHITECTURE.md` | Nesting, Context Flow, Templates |
| `docs/CORE_PHILOSOPHY.md` | Skills as Leverage |
| `docs/SKILL_STANDARDS.md` | Format, Frontmatter requirements |
| `docs/PLANNING.md` | Concise planning requirements |

## Key Concepts

- **Progressive Disclosure**: Keep root files minimal, link to detailed docs
- **Hierarchy of Leverage**: 1 bad instruction = many wrong behaviors
- **Pressure Testing**: Skills must resist time/authority/sunk-cost pressures
- **Statelessness**: Skills work in isolation without session memory

## License

MIT
