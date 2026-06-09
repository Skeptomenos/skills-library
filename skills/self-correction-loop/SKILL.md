---
name: self-correction-loop
description: "Use when implementing multi-step work where the agent must catch its own mistakes and wrong assumptions during implementation, not at review. Defines the plan → probe → implement → validate → fix loop: a single validation gate, falsifiable assumptions, evidence-gated checkboxes, gate falsifiability, and independent fresh-context verification. Triggers on: implementation loop, self-correction, validation gate, fix own mistakes, verify assumptions, evidence rule, independent verification."
triggers:
  - implementation loop
  - self-correction loop
  - validation gate
  - fix own mistakes
  - verify assumptions
  - evidence rule
  - independent verification
when_to_use:
  - Executing a living plan with 3+ steps where wrong assumptions are likely.
  - Setting up a new project's validation gate and loop protocol.
  - Running or requesting a fresh-context verification of plan claims.
when_not_to_use:
  - Quick fixes or single-file changes verifiable in one pass.
  - Authoring the plan document itself (use writing-plans).
author: David Helmus
version: 0.1.0
source:
  type: self
  name: ai-dev
---

# Self-Correction Loop

**Core principle:** An agent can only fix mistakes it can detect, and it cannot be trusted to detect its own. Convert every belief into a checkable claim, every claim into an executable check, and have something other than the author run the checks.

## When to Use / NOT Use

Use for any multi-step implementation governed by a living plan (see `writing-plans` for the plan document format — the plan is this loop's shared memory). Do not use for one-pass work; the overhead only pays off when wrong assumptions can compound across steps or sessions.

## The Cycle

1. **Plan.** Pick exactly ONE open plan step. If it rests on an unconfirmed belief (API shape, output path, ordering semantics, third-party contract), add `Assumption:` and `Verify:` lines under the step before coding. An assumption without a verify command is a guess.
2. **Probe.** For behavior claims ("X is excluded", "A ranks above B"), write the failing test BEFORE the implementation. If the test fails differently than expected, the mental model is wrong: record that in the plan's Discoveries before fixing anything.
3. **Implement** the smallest change that makes the probe pass.
4. **Validate.** Run the project's single validation gate (see `references/gate-design.md`). Never substitute a subset for the full gate.
5. **Fix.** On failure: record a Discovery with evidence, fix, re-run. Two rules:
   - Same failure twice in a row → STOP. Re-plan the step or escalate to the user. Do not iterate blindly.
   - Never fix a bug without first adding the test or gate that would have caught it. This makes the loop ratchet instead of oscillate.
6. **Record.** Flip the checkbox WITH an evidence line, append Progress, log non-obvious choices in the Decision Log.
7. **Verify independently.** Every few steps and always before a PR/handoff, a fresh-context session that did not write the code re-derives all checkbox claims (see `references/verify-plan-prompt.md`). Disputed claims re-enter the plan as open steps.

## The Evidence Rule (authoritative wording)

> A status claim — a checked checkbox, "done", "tests pass" — may only be made together with re-derivable evidence: the command run and the observed result. A claim without evidence is a bug, not a candidate for benefit of the doubt.

Other skills and project docs should reference this rule, not restate it.

## Gate Requirements

The gate is one deterministic, indivisible command (e.g. `pnpm validate`, `make validate`) chaining ALL checks: build, typecheck, tests, end-to-end smoke, drift checks. Two design rules:

- **Fidelity:** the smoke stage must exercise the artifact the way production uses it — the real built entry point, the real documented start command, a real client against the real protocol. Most escaped bugs live in the seam between "how tests run the code" and "how production runs it."
- **Falsifiability:** never trust a new gate until you have watched it fail once. Break the guarded behavior deliberately, see red, restore, see green.

Per-project gate design checklists are in `references/gate-design.md`.

## Litmus Test

When wiring the loop into a project, ask: "If the agent confidently did X wrong, what turns red, and who checks that the red thing works?" If the answer is "nothing" or "the agent itself", that is the hole to close.

## Degrees of Freedom

- **High:** choosing probe granularity, gate stage ordering, when to run the verifier (minimum: before every PR).
- **Low:** the evidence rule, the same-failure-twice stop, test-before-fix, and full-gate-before-checkbox are not optional.

## References

- `references/verify-plan-prompt.md` — handoff prompt for the independent fresh-context verifier.
- `references/gate-design.md` — designing the single validation gate per project type.
