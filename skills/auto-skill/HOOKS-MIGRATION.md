# Hooks Migration Assessment

## Original Claude Code Hook System

The original Claudeception implementation uses Claude Code's `UserPromptSubmit` hook:

```json
{
  "hooks": {
    "UserPromptSubmit": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "~/.claude/hooks/claudeception-activator.sh"
          }
        ]
      }
    ]
  }
}
```

The hook injects a reminder on **every prompt** telling Claude to evaluate whether the 
current task produced extractable knowledge.

---

## OpenCode Hook Alternatives

As of January 2026, OpenCode does not have an equivalent `UserPromptSubmit` hook system.
However, there are several alternatives:

### Option 1: Custom Command (Implemented)

**Location**: `skills/auto-skill/commands/auto-skill.md`

**Usage**: 
```
/auto-skill
```

**Pros**:
- Works today with no additional configuration
- User controls when to trigger (less noise)
- Follows OpenCode's custom command pattern

**Cons**:
- Requires manual invocation (not automatic)
- Knowledge may be forgotten if user doesn't run it

**Recommendation**: This is the primary activation method for OpenCode.

---

### Option 2: AGENTS.md Protocol

Add to project or global `AGENTS.md`:

```markdown
## Session Close Protocol

Before ending a session, evaluate if extractable knowledge was discovered:
- Non-obvious debugging solutions?
- Error workarounds?
- Project-specific patterns?

If yes, invoke `/auto-skill` or load the auto-skill skill.
```

**Pros**:
- Passive reminder in agent context
- No code changes needed

**Cons**:
- Agents may not reliably follow
- Not enforced, just suggested

---

### Option 3: Semantic Skill Matching

The skill's description is designed for semantic matching:

```yaml
description: |
  Autonomous skill extraction system that captures reusable knowledge...
  Triggers: (1) /auto-skill command, (2) "save this as a skill"...
```

When users say things like:
- "Save what we just learned"
- "Extract a skill from this"
- "What did we learn?"

The skill should be automatically surfaced.

**Pros**:
- Works with natural language
- No configuration needed

**Cons**:
- Relies on user requesting it
- Matching is not guaranteed

---

### Option 4: Future OpenCode Hooks (Not Yet Available)

If OpenCode adds hook support in the future, the equivalent would be:

```json
// opencode.json (hypothetical)
{
  "hooks": {
    "onPromptSubmit": {
      "command": "echo 'Evaluate for skill extraction after this task'"
    }
  }
}
```

**Status**: Not implemented as of 2026-01-19. Monitor OpenCode releases.

---

## Recommendation

For OpenCode integration, use a **hybrid approach**:

1. **Primary**: `/auto-skill` command for explicit invocation
2. **Secondary**: Semantic matching on "save this as a skill" phrases
3. **Tertiary**: Add protocol reminder to `AGENTS.md`

This provides multiple activation paths without requiring hook infrastructure.

---

## Comparison Table

| Feature | Claude Code Hooks | OpenCode Commands |
|---------|-------------------|-------------------|
| Automatic on every prompt | Yes | No |
| User-triggered | Yes (`/claudeception`) | Yes (`/auto-skill`) |
| Semantic matching | Yes | Yes |
| Configuration location | `~/.claude/settings.json` | `.opencode/commands/` |
| Noise level | High (every prompt) | Low (on-demand) |
| Reliability | High (always runs) | Medium (user must remember) |

---

## Migration Checklist

- [x] Create `/auto-skill` command
- [x] Ensure skill description enables semantic matching
- [ ] Optionally: Add reminder to `AGENTS.md`
- [ ] Monitor OpenCode for hook system updates

---

*Assessment date: 2026-01-19*
