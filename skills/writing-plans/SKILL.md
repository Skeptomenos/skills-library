---
name: writing-plans
description: Write and maintain living implementation plans for multi-step work. Use when work has 3+ steps, touches multiple files or subsystems, may span sessions, or needs a handoff-quality vertical-slice implementation plan.
author: David Helmus
version: 0.3.0
source:
  type: self
  name: ai-dev
triggers:
  - "multi-step implementation plan"
  - "vertical slice implementation plan"
  - "risky change plan"
  - "living plan"
  - "implementation handoff"
  - "orchestrator handoff"
  - "continue later"
  - "validation workflow"
when_to_use:
  - "Work has three or more distinct steps."
  - "Work touches multiple files, subsystems, or repositories."
  - "Another agent may need to continue the work later."
  - "An architecture or orchestrator session must hand implementation to an execution session."
  - "A risky change needs a self-contained plan, validation gate, and handoff context."
when_not_to_use:
  - "The task is a quick one-shot answer or single-file fix."
  - "The user only wants execution of an existing plan; use self-correction-loop for that."
---

# Skill: writing-plans

Write and maintain living implementation plans for multi-step work. Plans are self-contained documents that any agent can pick up and execute without prior context.

This skill is for plan authoring. Execution of a multi-step implementation plan is governed by `self-correction-loop`. A good plan does not paste that skill in full; it makes the loop concrete for the project by defining vertical slices with project-specific probes, validation, evidence, and exit criteria.

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

## Execution Protocol

Execution must use the `self-correction-loop` skill. This plan defines what to
build and how each slice proves itself; `self-correction-loop` defines how an
execution session probes, implements, validates, records evidence, and triggers
independent verification.

Do not mark a slice complete without evidence. Do not bypass the validation
gate. Do not remove the final independent verification step.

## Steps

Concrete, ordered vertical slices. Prefer slices that produce a verifiable
product increment over flat feature checklists. Each slice names expected files,
modules, commands, tests, assumptions, and exit criteria.

- [x] (YYYY-MM-DD HH:MMZ) Completed step — brief outcome. Evidence: `<command>` → <observed result>
- [ ] Slice 1: <vertical product or infrastructure increment>
  Goal: <observable capability after this slice>
  Probe first:
  - <test, smoke, fixture, or command that should fail or expose the missing behavior before implementation>
  Implementation:
  - <files/modules/functions to create or change>
  Validation:
  - `<targeted command>` → <expected result>
  - `<full validation gate>` → <expected result before checking this slice complete>
  Evidence required:
  - <commands and observed outputs required in the checkbox evidence>
  Record:
  - <Progress/Discoveries/Decision Log updates expected for this slice>
  Exit criteria:
  - <specific conditions that make the slice complete>
  Assumption: <unconfirmed belief this step rests on, if any>
  Verify: <command that exposes the assumption if false>
- [ ] Slice 2: <next vertical increment>
- [ ] FINAL: independent verification — run a fresh-context verifier that did not write the code to re-derive every `[x]` claim as VERIFIED / DISPUTED / UNVERIFIABLE HERE and re-run the validation gate. Disputed claims re-enter Steps as open work. Protocol: `self-correction-loop` skill, `references/verify-plan-prompt.md`.

Every plan ends with the FINAL independent-verification step. It may not be
removed, and it may not be performed by the agent that implemented the steps.

Split partially completed slices into "done" and "remaining" rather than
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

3. **Use vertical slices for implementation handoffs.** A handoff plan should be organized around verifiable product or infrastructure increments, not a long unordered feature checklist. Tiny tasks can live inside a slice, but the checkbox should represent a slice that can be probed, implemented, validated, and reviewed.

4. **Steps are concrete.** Name expected file paths, modules, functions, commands, and verification probes. "Add validation" is not a step. "Add `validateInput()` to `src/lib/parser.ts:45` that rejects empty strings" is. When exact files do not exist yet, state the discovery step that will determine them.

5. **Embed the loop pattern per slice.** Each vertical slice should have project-specific `Probe first`, `Implementation`, `Validation`, `Evidence required`, `Record`, and `Exit criteria` blocks. Do not paste generic `self-correction-loop` boilerplate under every tiny task.

6. **Discoveries outlive the plan.** If a finding matters beyond this plan, promote it to a project-level doc or AGENTS.md rule.

7. **Follow-ups are captured, not acted on.** Out-of-scope work goes in Follow-ups. Do not expand the plan's scope mid-execution.

8. **Archive, don't delete.** When a plan is complete or superseded, leave it in place. Start a new plan file rather than overwriting.

9. **Checkboxes carry evidence.** A step may only be flipped to `[x]` together with an evidence line (command + observed result). Steps resting on unconfirmed beliefs get `Assumption:`/`Verify:` lines before implementation starts. The authoritative wording of the evidence rule lives in the `self-correction-loop` skill; reference it, don't restate it.

## Git Workflow Integration

Plans do not dictate git workflow. Follow the repo's `git-workflow` skill for branching, committing, and PRs. The plan records which branch and Linear issue it's associated with, but the git skill controls how those work.

## Execution

To execute a plan:

1. Read the plan fully before starting.
2. Read `self-correction-loop`; it governs the implementation loop.
3. If anything is unclear or missing, update the plan first.
4. Work through exactly one open vertical slice at a time, updating checkboxes and Progress as you go.
5. When blocked, log the blocker in Progress and stop.
6. When done, fill in Validation results and update Follow-ups.
7. Close the plan only after the FINAL independent-verification step has run and reported no DISPUTED claims (or its disputes have been resolved as new steps).
