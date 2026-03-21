# Core Philosophy of AGENTS.md

> "A bad line of instruction is worse than a bad line of code."

## Hierarchy of Leverage

`AGENTS.md` is the highest-leverage point in your harness because it affects every single session and every phase of work.

1.  **Instruction (`AGENTS.md`)**: Affects Research, Planning, and Coding.
2.  **Research**: Affects Planning and Coding.
3.  **Plan**: Affects Coding.
4.  **Code**: The final artifact.

**Impact:**
- 1 bad line of code = 1 bad line of code.
- 1 bad line of plan = 100 wrong lines of code.
- 1 bad line of `AGENTS.md` = **Degradation of core competency and methodology** across all sessions.

## The Instruction Budget

Frontier thinking LLMs can reliably follow **150-200 instructions**.
- Claude Code's system prompt already uses ~50.
- Every rule you add consumes this budget.
- **Decay is uniform**: As you exceed the budget, the agent doesn't just ignore new rules; it starts ignoring *all* rules randomly.

## Core Rules

### 1. Less is More
Include as few instructions as reasonably possible.
- **Bad**: "Always write clean code." (Vague, redundant)
- **Bad**: "Use `const` instead of `var`." (Linter's job)
- **Good**: "This is a React project using pnpm." (Context)

### 2. Don't Auto-Generate
Never use `/init` scripts to auto-generate this file.
- Auto-generated files are bloated with "useful" but low-leverage instructions.
- Because this file is high-leverage, every line must be intentionally crafted.

### 3. Statelessness
The agent knows nothing about your codebase at the start of a session. `AGENTS.md` is its only onboarder.
- **WHAT**: Tech stack, structure.
- **WHY**: Purpose of the project.
- **HOW**: Build commands, key constraints.

---
*Sources: HumanLayer Blog, Hierarchy of Leverage Diagram*
