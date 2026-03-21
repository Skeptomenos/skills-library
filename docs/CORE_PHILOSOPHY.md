# Core Philosophy: Skill Engineering

> "Writing skills is TDD (Test-Driven Development) applied to process documentation."

## The Hierarchy of Leverage in Skills

A skill is a reusable instruction set loaded into the context window. It has massive leverage because it's distributed to agents across many sessions.

1.  **The Skill (`SKILL.md`)**: The root instruction.
2.  **The Agent's Behavior**: Controlled by the skill.
3.  **The Output**: Produced by the agent.

**Impact:**
- A bad line of code affects one feature.
- A bad line in a **Skill** affects *every* task that uses that skill, causing widespread degradation of capability.

## Core Rules

### 1. Context is a Public Good
Every token in your skill competes with the user's actual request and the system prompt.
- **Rule**: Keep skills minimal. Use Progressive Disclosure (link to reference docs) within the skill itself.
- **Goal**: Give the agent a map, not an encyclopedia.

### 2. TDD for Process (The Iron Law)
You cannot write a good skill unless you know exactly *why* the agent fails without it.
- **RED**: Run the task *without* the skill (use a subagent). Watch it fail. Document the failure.
- **GREEN**: Write the skill to fix that specific failure. Verify it passes.
- **REFACTOR**: Optimize the skill for brevity and clarity.

**"If you didn't watch an agent fail without the skill, you don't know if the skill teaches the right thing."**

### 3. Statelessness & Modularity
Skills must work in isolation. Do not assume the agent remembers previous sessions.
- **Skills as Context Templates**: They define the *workflow*.
- **Skills as Output Templates**: They define the *artifact*.
- **Skills as Orchestrators**: They define *who* does the work.
