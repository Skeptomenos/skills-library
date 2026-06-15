---
name: skill-generator
description: >-
  Use when creating a new skill, editing an existing skill, or when asked to
  document a reusable process or technique
author: David Helmus
version: 0.1.0
source:
  type: self
  name: ai-dev
triggers:
  - create a new skill
  - edit a skill
  - skill generator
  - document a reusable process
when_to_use:
  - >-
    Creating or materially editing a skill with baseline failure and pressure
    testing.
  - The user asks to document a reusable process or technique as a skill.
  - >-
    A process pattern needs progressive disclosure, templates, or skill-quality
    gates.
when_not_to_use:
  - Only adding metadata to existing skills for catalog retrieval.
  - The task is creating a project or AGENTS.md file.
  - No reusable agent behavior is being captured.
license: MIT
compatibility: opencode
---

# Skill Generator

**Core principle:** No skill without baseline failure first. TDD for process documentation.

**Violating the letter of this process is violating the spirit of this process.**

---

## The Iron Law

```
NO SKILL FILE CREATED UNTIL RED PHASE SUBAGENT COMPLETES
```

If you create SKILL.md before documenting a baseline failure, delete it. Start over. No exceptions.

---

## Quick Reference: The Phases

| Phase | Action | Gate |
|-------|--------|------|
| 0 | Check exists, classify type | — |
| 1 RED | Subagent WITHOUT skill → document failure | Must have failure |
| 2 GREEN | Write skill | — |
| 3 GREEN | Subagent WITH skill → verify fix | Must pass |
| 4 REFACTOR | Quality checks | All pass |

---

## Phase 0: Setup

**Check exists:** `ls {skills-dir}/ | grep -i {name}`

**Classify type:**
- **Discipline** — Rules resisting rationalization
- **Workflow** — Multi-step with checkpoints  
- **Technique** — Concrete method
- **Reference** — API docs

**Determine requirements:**
- Structured output? → Create template file
- Needs user config? → Add context discovery
- Needs external config? → Document in skill

---

## Phase 1: RED — Baseline Test (MANDATORY)

Dispatch subagent WITHOUT the skill:

```
task(
  subagent_type="general",
  description="Baseline test for {skill-name}",
  prompt="""
You are testing baseline behavior WITHOUT a skill.

**Task:** {Describe the task}
**Context:** {Relevant context}

Complete the task using your best judgment. Do NOT load any skills.

**Report:** What approach? What output? What assumptions?
"""
)
```

**Document:** What went wrong? What rationalizations? What must skill teach?

**GATE:** Do not proceed without documented failure.

---

## Phase 2: GREEN — Write Skill

### Location

Choose based on scope:
- **Project-specific:** `.opencode/skills/{skill-name}/SKILL.md`
- **Global (all projects):** `~/.config/opencode/skills/{skill-name}/SKILL.md`
- **KB-specific:** `{kb-root}/.opencode/skills/{skill-name}/SKILL.md`

### Create SKILL.md

See `skill-template.md` in this folder for the complete template.

**Required frontmatter:**
```yaml
---
name: skill-name
description: Use when [triggers]. No workflow summary.
license: MIT
compatibility: opencode
---
```

**Required sections:** Core principle, When to Use, Quick Reference, Process, Common Mistakes, Red Flags, Verification Checklist

**If skill produces output:** Create `skill-name-template.md` with `{{PLACEHOLDER}}` syntax.

---

## Phase 3: GREEN — Verify (MANDATORY)

Dispatch subagent WITH the skill:

```
task(
  subagent_type="general",
  description="Skill-guided test for {skill-name}",
  prompt="""
You are testing a skill.

**REQUIRED SKILL:**
---
{Paste skill content}
---

**Task:** {Same as baseline}

Follow the skill exactly. Report: What approach? Did you follow completely?
"""
)
```

**Verify:** Avoided baseline mistakes? New rationalizations? Ambiguities?

**GATE:** Do not proceed until agent performs correctly.

---

## Phase 4: REFACTOR — Quality Checks

### Quality Checklist

- [ ] Baseline failure documented (Phase 1)
- [ ] Skill-guided test passed (Phase 3)
- [ ] Name: lowercase, hyphens only
- [ ] Description: "Use when...", no workflow summary
- [ ] Under 500 lines (under 200 if frequent)

---

## Rationalization Table

| Excuse | Reality |
|--------|---------|
| "Too simple for structure" | Simple skills need discoverability. Follow format. |
| "I'll add sections later" | Later never comes. Add now. |
| "Baseline is overkill" | Baseline reveals what you'll skip. Mandatory. |
| "I already know what will fail" | You're guessing. Run the subagent. |
| "I'll test after writing" | That's not TDD. RED before GREEN. |
| "Description can summarize workflow" | Agent follows descriptions instead of reading. Never summarize. |

---

## Red Flags - STOP

- Creating SKILL.md before RED phase completes
- Skipping baseline for ANY skill type
- Description summarizes workflow
- Proceeding to Phase 4 without Phase 3 verification

**All mean: STOP. Go back.**

---

## Skill Types

| Type | Purpose | Example |
|------|---------|---------|
| **Technique** | Concrete method with steps | `systematic-debugging` |
| **Pattern** | Way of thinking about problems | `test-driven-development` |
| **Reference** | API docs, syntax guides | `pptxgenjs.md` |
| **Discipline** | Rules that resist rationalization | `verification-before-completion` |
| **Workflow** | Multi-step process with checkpoints | `morning-boot` |

---

## Related

- `skill-template.md` — SKILL.md and output templates

---

*Skill Generator v3.1 | TDD enforcement for process documentation*
