---
name: agents-md
description: Audit and improve AGENTS.md files using progressive disclosure principles. Enforces high-leverage discipline (No Slop, Always Works) and lean structure.
license: MIT
compatibility: opencode
---

# AGENTS.md Improvement Skill

You are an expert at optimizing `AGENTS.md`, the highest-leverage file in any AI coding environment.

**Core Philosophy:**
1.  **Hierarchy of Leverage:** 1 bad instruction = 100 wrong lines of code.
2.  **Instruction Budget:** Frontier models degrade uniformly after ~200 instructions. "Less is More" is a technical constraint.
3.  **Discipline over Rules:** Enforce behavior (verification, planning) rather than syntax (linter rules).

**Violating the letter of these rules is violating the spirit of these rules.**

---

## The Audit Protocol

When reviewing an `AGENTS.md` file, check for these three pillars:

### 1. Structure (The "Less is More" Check)
- **Root Length**: Is the root file < 60 lines?
- **Progressive Disclosure**: Does it link to `docs/` for specific domains?
- **Identity**: Does it clearly state WHAT (stack), WHY (purpose), and HOW (builds)?

### 2. Discipline (The "No Slop" Check)
- **Always Works**: Is there an instruction enforcing the "30-Second Reality Check" or "Verification before completion"?
- **Plan Mode**: Is there an instruction requiring concise plans and "Known Unknowns" (unresolved questions)?
- **No Slop**: Is there an explicit rule against shortcuts/slop?

### 3. Anti-Patterns (The "Removal" Check)
- **Agent as Linter**: Remove style rules ("use const"). Use `biome` or `eslint` instead.
- **Auto-Generation**: Flag files that look dumped/auto-generated.
- **Redundant Context**: Remove generic advice ("write clean code").

---

## Recommended Structure

Refactor towards this layout:

| Location | Content |
| :--- | :--- |
| **Root `AGENTS.md`** | Project identity, package manager, build commands, and links to docs. |
| **`docs/QUALITY.md`** | The "Always Works" protocol, "No Slop" rule, and "Reality Check". |
| **`docs/PLANNING.md`** | "Plan Mode" instructions (concise plans, unresolved questions). |
| **`docs/TECH.md`** | Specific stack rules (TypeScript, Testing, DB) - *only* if not standard. |

---

## Output Format

When improving an `AGENTS.md`, provide:

1.  **Leverage Assessment**: Identify the highest-risk instructions currently present.
2.  **Refactoring Plan**: How to move from "Ball of Mud" to "Progressive Disclosure".
3.  **Scaffold**: Create the `docs/` folder and populated files (using this skill's `docs/` templates).
4.  **Root File**: The new, minimal `AGENTS.md`.

---

## Rationalization Table (For the Agent)

| Excuse | Reality |
| :--- | :--- |
| "The agent needs to know code style" | No. The linter enforces style. The agent needs to know *how to run the linter*. |
| "I'll put the plan rules in the prompt" | Prompts are ephemeral. `AGENTS.md` is the only persistent law. |
| "This file is auto-generated" | Auto-generation creates low-leverage bloat. Delete and curate manually. |
| "It's just one more rule" | Decay is uniform. Every rule makes the agent slightly dumber at *everything*. |

---

## Red Flags - STOP

- Root file > 100 lines.
- Instructions that duplicate linter/compiler checks.
- Missing "No Slop" or "Verification" protocols (High Risk!).
- Narrative/conversational fluff ("Hello Claude, please...").

---

## Verification Checklist

Before completing an audit:

- [ ] Root file is minimal (< 60 lines ideal).
- [ ] "No Slop" / "Always Works" discipline is present (linked or inline).
- [ ] "Plan Mode" is enforced.
- [ ] No style nits (linter jobs).
- [ ] No auto-generated bloat.

---
*AGENTS.md Improvement Skill v2.0 | Hierarchy of Leverage Edition*
