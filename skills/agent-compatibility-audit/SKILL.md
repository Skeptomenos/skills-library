---
name: agent-compatibility-audit
description: >-
  Audit whether a repository is easy for coding agents to start, validate, and
  trust. Use when checking agent readiness, startup docs, validation loops, or
  whether a project is AFK-agent friendly.
author: Cursor
source:
  type: git
  name: cursor/plugins
  url: 'https://github.com/cursor/plugins'
  path: agent-compatibility/skills/check-agent-compatibility/SKILL.md
  commit: 3347cbab5b54136f6fba0994c3a01a56f7fb7fca
  version: 1.0.0
triggers:
  - agent compatibility audit
  - agent-ready repo
  - AFK-agent friendly
  - startup validation docs review
when_to_use:
  - Auditing whether a repository is ready for autonomous coding agents.
  - 'Checking setup docs, validation loops, and startup reliability.'
  - Preparing a project or public split for agent-driven work.
when_not_to_use:
  - Only fixing a known implementation bug.
  - Reviewing product UX without concern for agent onboarding.
  - Running a normal code review instead of a repo-readiness audit.
---

# Agent Compatibility Audit

Audit whether a repository can be handled safely by an autonomous coding agent. The score is about operational readiness: can a fresh agent understand the repo, start it, make a small change, verify it, and trust the docs without guessing?

## When To Use

Use when:

- The user asks whether a repo/project is agent-ready or AFK-agent friendly.
- A public split project is being prepared for release.
- A repo has flaky setup, unclear validation, stale docs, or repeated agent confusion.
- You need a prioritized list of fixes that would improve future autonomous work.

## Workflow

Run four checks. Prefer parallel exploration when tools allow it, but keep the final synthesis unified.

### 1. Deterministic Scan

Try the published scanner:

```bash
npx -y agent-compatibility@latest --json "<repo-path>"
```

If the scanner fails because of local tool availability, say the deterministic scan was unavailable due to the tool environment. Do not treat that as a repo defect.

Capture:

- score, if available
- top reported problems
- any missing metadata, setup, or validation signals

### 2. Startup Review

Act like a cold agent:

1. Read obvious startup surfaces: `README`, `AGENTS.md`, setup docs, package files, env examples, workflow docs.
2. Identify the most likely bootstrap and startup command.
3. Try to reach first meaningful success within a reasonable time budget.
4. If the first path fails, allow a small recovery step and record what had to be inferred.

Score anchors:

- `93/100`: startup works with little correction.
- `84/100`: startup works after mild digging or recovery.
- `68/100`: startup path probably exists but is too manual or ambiguous.
- `27/100`: no credible startup path works from repo/docs.
- `12/100`: blocked on secrets, accounts, or inaccessible infrastructure.

### 3. Validation Review

Check whether an agent can verify a small change without falling back to a full expensive loop:

1. Inspect declared lint, typecheck, test, smoke, and build paths.
2. Identify the smallest reliable validation loop for a typical change.
3. Try the relevant command when practical.
4. Judge whether the loop is targeted, actionable, noisy, and cheap enough for iteration.

Score anchors:

- `93/100`: repeatable validation path gives useful signal.
- `84/100`: validation works but is broader or heavier than ideal.
- `68/100`: valid loop probably exists but takes guesswork or has noisy output.
- `27/100`: no practical validation loop is usable.
- `12/100`: loop blocked on secrets, accounts, or infrastructure.

### 4. Docs Reliability Review

Check whether the written docs lead to the real working path:

1. Follow the documented setup and run path as literally as practical.
2. Note accurate, stale, incomplete, misleading, or missing instructions.
3. Penalize docs drift by actual damage, not by the mere existence of minor stale references.

Score anchors:

- `93/100`: docs lead to the working path with little correction.
- `84/100`: docs drift, but recovery is easy.
- `68/100`: docs are stale enough that important steps must be reconstructed.
- `27/100`: docs point down the wrong path or omit key steps.
- `12/100`: real path depends on private docs or hidden context.

## Synthesis

Compute one internal score:

- If all four checks produced scores, use a weighted judgment around `70% deterministic scan + 30% workflow checks`.
- If the deterministic scan is unavailable, use the three workflow checks and clearly say the deterministic scan was unavailable.
- Do not show arithmetic unless the user asks.

Prefer specific scores like `81`, `86`, or `92` over round buckets.

## Output

Use this shape:

```markdown
## Agent Compatibility Score: N/100

Top fixes
- Highest-impact fix
- Second fix
- Third fix

Evidence
- Startup: <score or result>; <one sentence>
- Validation: <score or result>; <one sentence>
- Docs: <score or result>; <one sentence>
- Deterministic scan: <score/result/unavailable>; <one sentence>
```

Keep the top fixes flat and prioritized. Focus on changes that would most improve real future agent workflows.

## Guardrails

- Do not penalize a repo for requiring ordinary prerequisites like Docker, Node, Bun, Python, Xcode, or a local database if the docs say so clearly.
- Do not call startup failed just because a port is occupied or logs are noisy.
- Do not require a web HTTP response unless the documented app surface implies one.
- Treat secrets and private infrastructure as blockers, but distinguish unavoidable product dependencies from fixable documentation gaps.
- Do not propose huge rewrites when a focused README, `AGENTS.md`, script, or test-command fix would unlock agents.
