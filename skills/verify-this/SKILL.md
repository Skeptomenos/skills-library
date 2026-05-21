---
name: verify-this
description: Verify a claim with fresh local evidence. Use when asked to prove a fix, confirm behavior, compare before/after results, or produce a VERIFIED, NOT VERIFIED, or INCONCLUSIVE verdict.
source: Adapted from cursor/plugins cursor-team-kit verify-this at 3347cbab5b54136f6fba0994c3a01a56f7fb7fca.
---

# Verify This

Verification is not a recap. It proves or disproves one specific claim with repeatable evidence.

## When To Use

Use this skill when:

- The user asks "verify this", "prove it works", "did this fix it", or "show me evidence".
- A bug fix needs a before/after reproduction.
- A UI, CLI, API, performance, memory, or integration claim needs measurement.
- Tests pass, but user-visible behavior still needs a concrete check.

Do not use this for vague claims like "the code is cleaner". First restate a measurable claim or ask for the measurable claim if it cannot be inferred.

## Workflow

1. Restate the claim in falsifiable form: condition, metric or observable behavior, and threshold.
2. Pick the smallest local surface that can disprove it.
3. Capture a baseline from the old state when practical: merge base, parent commit, failing branch, known-bad fixture, screenshot, transcript, or failing command.
4. Capture treatment from the changed state with the same command, data, warmup, environment, and viewport where relevant.
5. Compare raw artifacts: test output, terminal transcript, HTTP response, screenshot, accessibility snapshot, profile, heap data, or diff.
6. Return exactly one verdict: `VERIFIED`, `NOT VERIFIED`, or `INCONCLUSIVE`.

## Local Surfaces

- Code behavior: focused unit/integration test or minimal repro script.
- CLI/TUI behavior: terminal transcript, PTY/tmux harness, or repo demo harness.
- UI behavior: browser automation, screenshot, accessibility snapshot, or trace.
- API behavior: local request/response diff.
- Performance: same-machine baseline/treatment timings or profiles.
- Memory: before/after heap snapshots or process metrics.

## Artifact Layout

When safe and useful, write artifacts under:

```text
/tmp/verify-this/<claim-slug>/
├── claim.md
├── timeline.md
├── baseline/
├── treatment/
├── diff/
└── verdict.md
```

If artifacts may contain private code, prompts, screenshots, HTTP bodies, credentials, customer data, or heap contents, keep only minimal inline evidence unless the user agrees to disk storage.

## Verdict Rules

- `VERIFIED`: baseline and treatment differ in the predicted direction, meet the threshold, and have no obvious confound.
- `NOT VERIFIED`: behavior is unchanged, moves the wrong way, misses the threshold, or the claimed condition is false.
- `INCONCLUSIVE`: no valid baseline, noisy signal, failed measurement, or environment difference invalidates the comparison.

## Output

Use this shape:

```text
VERIFIED | NOT VERIFIED | INCONCLUSIVE
Claim: <falsifiable claim>

Evidence:
<metric/artifact>: baseline=<...>, treatment=<...>, delta=<...>, threshold=<...>

Reasoning:
<one tight paragraph naming the evidence and any confounds>
```

Do not soften a negative result. A clear `NOT VERIFIED` is useful.
