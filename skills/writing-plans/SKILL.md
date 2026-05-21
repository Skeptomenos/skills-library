---
name: writing-plans
description: Write and maintain living implementation plans for multi-step work. Use when work has 3+ steps, touches multiple files or subsystems, or may span sessions.
---

# Skill: writing-plans

Write and maintain living implementation plans for multi-step work. Plans are self-contained documents that any agent can pick up and execute without prior context.

## When to Write a Plan

Write a plan when work has 3+ distinct steps, touches multiple files or subsystems, or will span multiple sessions. Do not write a plan for quick fixes, single-file changes, or work that can be completed and verified in one pass.

## Plan Location

All plans live in the project's `_planning/` directory:

```
<project>/_planning/plans/YYYY-MM-DD-<description>.md
```

For repo-level work (skills, CI, root config), use:

```
docs/plans/YYYY-MM-DD-<description>.md
```

## Plan Structure

Every plan uses this structure. Sections marked LIVING are updated continuously during execution.

```markdown
# <Short, action-oriented title>

**Goal:** What someone can do after this change that they cannot do before.

**Branch:** `<scope>/<description>`
**Linear:** `DEV-NNN` (if tracked)
**Started:** YYYY-MM-DD

---

## Context

Describe the current state as if the reader knows nothing about this project.
Name key files by full path. Define any term that isn't plain English.
State what exists now and what's missing.

## Approach

2-3 sentences on the chosen design. State what you considered and why you
picked this path. Link to any prior art or reference material.

## Steps

Concrete, ordered steps. Each step names exact files, functions, and commands.
Use checkboxes. Mark steps done as you complete them.

- [x] (YYYY-MM-DD HH:MMZ) Completed step — brief outcome
- [ ] Next step to do
- [ ] Future step

Split partially completed steps into "done" and "remaining" rather than
leaving a half-done checkbox.

## Validation

How to prove the work is done. Exact commands, expected output, observable
behavior. "Run X, see Y" — not "added struct Z."

## Progress (LIVING)

Timestamped log of what actually happened. Update at every stopping point:
commits, blockers, decisions, handoffs.

- (YYYY-MM-DD HH:MMZ) What happened
- (YYYY-MM-DD HH:MMZ) What happened next

## Discoveries (LIVING)

Unexpected findings during implementation. Evidence-first — paste test
output, error messages, or measurements. These persist even if the plan
is archived.

- **Finding:** What you discovered
  **Evidence:** Output, measurement, or link

## Decision Log (LIVING)

Every non-obvious decision with rationale. Future readers need to know
why, not just what.

- **Decision:** What was decided
  **Rationale:** Why
  **Date:** YYYY-MM-DD

## Follow-ups

Work that emerged from this plan but is out of scope. Create Linear issues
or note them here for later triage.

- [ ] Follow-up task description
```

## Rules for Living Plans

1. **Update on every commit.** Mark completed steps, log progress, record discoveries. The plan must always reflect the actual current state.

2. **Self-contained.** A new agent reading only this plan and the codebase must be able to continue the work. Do not reference "what we discussed" or assume prior context.

3. **Steps are concrete.** Name exact file paths, functions, and commands. "Add validation" is not a step. "Add `validateInput()` to `src/lib/parser.ts:45` that rejects empty strings" is.

4. **Discoveries outlive the plan.** If a finding matters beyond this plan, promote it to a project-level doc or AGENTS.md rule.

5. **Follow-ups are captured, not acted on.** Out-of-scope work goes in Follow-ups. Do not expand the plan's scope mid-execution.

6. **Archive, don't delete.** When a plan is complete or superseded, leave it in place. Start a new plan file rather than overwriting.

## Git Workflow Integration

Plans do not dictate git workflow. Follow the repo's `git-workflow` skill for branching, committing, and PRs. The plan records which branch and Linear issue it's associated with, but the git skill controls how those work.

## Execution

To execute a plan:

1. Read the plan fully before starting.
2. If anything is unclear or missing, update the plan first.
3. Work through Steps in order, updating checkboxes and Progress as you go.
4. When blocked, log the blocker in Progress and stop.
5. When done, fill in Validation results and update Follow-ups.
