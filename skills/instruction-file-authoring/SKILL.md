---
name: "instruction-file-authoring"
description: "Use when writing, updating, or auditing AGENTS.md, SOUL.md, IDENTITY.md, or SKILL.md files. Covers phrasing rules, vocabulary freezing, scope fencing, and loader contracts for Claude Opus 4.x and GPT-5 era models."
author: David Helmus
version: 0.1.0
source:
  type: self
  name: ai-dev
triggers:
  - "write AGENTS.md"
  - "update SOUL.md"
  - "audit SKILL.md"
  - "instruction file"
  - "loader contract"
  - "scope fencing"
  - "vocabulary freezing"
when_to_use:
  - "Writing, updating, or auditing persistent agent instruction files."
  - "Creating or reviewing AGENTS.md, SOUL.md, IDENTITY.md, USER.md, or SKILL.md files."
  - "Turning vague model behavior guidance into concrete loader-friendly instructions."
when_not_to_use:
  - "Writing ordinary project documentation that is not loaded as model context."
  - "Editing application code without changing agent instructions."
license: MIT
compatibility: opencode
---

# Instruction File Authoring

> Use this skill when writing, updating, or refining persistent instruction files:
> AGENTS.md, SOUL.md, IDENTITY.md, USER.md, SKILL.md, or any file loaded as
> system-level context for Claude Opus 4.x or GPT-5 era models.

## When to Use

- Creating a new agent workspace (AGENTS.md, SOUL.md, IDENTITY.md).
- Refining existing instruction files after role changes or behavioral drift.
- Writing or updating SKILL.md files for modular skills.
- Auditing instruction files for model adherence issues.

## Core Principle

Modern models follow structured, specific, positive instructions reliably.
Vague prose and prohibitions degrade adherence. Treat instruction files as
engineering specifications, not brand manifestos.

## Phrasing Rules

### Rule 1 — Positive Framing

State the target behavior. Avoid negations — they force the model to infer
the positive alternative, which is lossy.

- ✅ `Use const by default; use let only when rebinding is required.`
- ✅ `Write all source changes inside src/. Files outside src/ are read-only.`
- ❌ `Never use var, only const/let.`
- ❌ `Don't modify files outside src/.`

### Rule 2 — Priority Signaling

Use a strict three-tier vocabulary. Never mix tiers on the same concept.

| Signal | Meaning | Use for |
|---|---|---|
| `MUST` / `ALWAYS` | Hard constraint. Violation breaks output. | Safety, correctness, irreversibility |
| `PREFER` / `DEFAULT TO` | Soft constraint. Overridable with reason. | Style, conventions, defaults |
| `AVOID` | Discouraged, not forbidden. | Performance, maintainability nudges |

Example:
```
MUST: Run the full test suite before marking any task complete.
PREFER: Functional components over class components.
AVOID: Deeply nested ternaries — extract to named functions instead.
```

### Rule 3 — Instruction Atomicity

One sentence, one action. Compound instructions are partially dropped.

- ✅ `Step 1. Create the route handler in src/routes/<resource>.ts.`
- ✅ `Step 2. Register the new path in docs/openapi.yaml under /paths.`
- ❌ `When adding a new API endpoint, create the route file and add it to the OpenAPI schema.`

### Rule 4 — Context Before Constraint

Lead with why, then state what. Rationale gives the model a decision
heuristic for ambiguous edge cases, not just a pattern to match.

- ✅ `Production logs are aggregated in Datadog by the internal logger. Use logger.info / logger.error (from src/lib/logger.ts); never use console.log directly.`
- ❌ `Use the internal logger, not console.log.`

### Rule 5 — "When X, Do Y" Format

Conditional rules outperform vague principles.

- ✅ `When changing API behavior, update the OpenAPI schema and affected client tests.`
- ✅ `When touching authentication code, run the auth test suite and inspect permission checks.`
- ❌ `Be careful with API changes.`

### Rule 6 — Self-Verification Anchors

Place an explicit VERIFY checkpoint after every irreversible or destructive
step. The keyword `VERIFY:` is an explicit checkpoint instruction — it raises
the likelihood the model performs a verification action on the previous
step's output rather than assuming success.

```
After editing any database migration file:
 VERIFY: Running `pnpm db:validate` exits with code 0 before proceeding.

After adding a new npm package:
 VERIFY: package.json and pnpm-lock.yaml are both modified in the same commit.
```

### Rule 7 — Termination Conditions

State explicitly what "done" means. Without this, the model may keep
iterating or stop prematurely.

```
DONE WHEN:
 - All modified files pass `pnpm lint --fix` with zero errors.
 - `pnpm test` exits 0 with no skipped tests.
 - A one-paragraph summary of changes is written to CHANGES.md.
```

### Rule 8 — Ambiguity Escalation

Tell the model what to do when it does not know. Otherwise it guesses.

```
When the correct approach is unclear:
 1. State the ambiguity explicitly in a comment block.
 2. Implement the most conservative option.
 3. Add a TODO tagged // AGENT-QUESTION: <question> for human review.
```

### Rule 9 — Scope Fencing

Open scope declarations prevent drift into unrelated files.

```
SCOPE: This task concerns only the authentication subsystem (src/auth/**).
Read or modify files outside this scope only when explicitly asked.
```

### Rule 10 — Edge Cases via Inclusive Examples

Examples outperform rules for edge cases. Pair every ambiguous rule with
yes/no examples.

```
Filenames: lowercase-kebab-case.
 YES: user-profile-service.ts
 YES: get-user-by-id.test.ts
 NO: UserProfileService.ts
 NO: getUserById.test.ts
```

## Vocabulary Rules

### Freeze the Vocabulary

Pick one term per concept. Use it everywhere. Synonyms create ambiguity in
multi-hop reasoning.

- Pick `repository` → ALWAYS use `repository`. Never `repo`, `data layer`, `DB class`.
- Pick `service` → ALWAYS use `service`. Never `business logic layer`, `use case`.

### Avoid Meta-Commentary

Instructions like "be careful" or "think deeply" consume tokens with zero
behavioral effect. Replace them with concrete checkpoints.

- ✅ `Inspect git diff for accidental unrelated edits before committing.`
- ❌ `Be careful when editing shared files.`

### Avoid Personality Bloat

- ✅ `Act as a pragmatic senior engineer. Prioritize correctness, maintainability, and focused delivery.`
- ❌ `You are a world-class 10x principal engineer with elite judgment and unparalleled expertise...`

### Avoid Universal Behavior Instructions

Do not put generic LLM advice in instruction files.

- ❌ `Think step by step.`
- ❌ `Use best practices.`
- ❌ `Be thorough.`

Replace with repo-specific operational guidance:
- ✅ `Use pnpm test -- --runInBand for auth tests because the local test database is shared.`

## Structural Rules

### Front-Load Critical Constraints

Put the highest-priority constraints at the top. Attention degrades over
token distance.

### One File, One Job

| File | Job |
|---|---|
| AGENTS.md | Repo navigation, module boundaries, where code goes |
| CLAUDE.md | Build/test commands and hard constraints |
| SOUL.md / IDENTITY.md | Identity, voice, and tone |
| SKILL.md | Reusable workflows with steps, verification, done-state |

MUST NOT mix responsibilities across files. If a section does not belong
to the file's job, move it.

### Short Over Complete

A 200-line file read reliably beats a 600-line file skimmed. Use
progressive disclosure: keep root files minimal, link to skills or
reference docs for depth.

### Decision Order

Give the agent explicit tie-breakers for ambiguous choices.

```
Prefer existing repo patterns over new abstractions.
Prefer small, localized changes over broad refactors.
Prefer explicit code over clever metaprogramming.
Prefer deleting dead code over preserving unused compatibility layers.
```

## Recommended Structure — Root Instruction Files

Use `templates/root-instruction-template.md` as the canonical skeleton (role,
`SCOPE:`, hard constraints, workflow with `VERIFY:` checkpoints, voice, safety
boundaries, examples). Copy it and fill each section. Keep structural
boilerplate in the template — do not inline it into multiple files.

## Recommended Structure — SKILL.md Files

Use `templates/skill-template.md` as the canonical skeleton (When to Use,
Preconditions, Inputs, Steps with `VERIFY:`, `DONE WHEN:`, Error Recovery).

### SKILL.md Loader Contract

A SKILL.md is only discoverable if it satisfies the host loader contract
(opencode shown here):

- **Location**: user-wide `~/.config/opencode/skills/<skill-name>/SKILL.md`;
  project-scoped `.opencode/skills/<skill-name>/SKILL.md`.
- **Name matches directory**: the `name` field MUST equal the parent
  directory name.
- **Frontmatter**: include `compatibility: opencode` (and a `license` if the
  skill is shared).
- **Description is the discovery key**: the `description` is the only text the
  model reads when deciding whether to load the skill. Pack it with concrete
  trigger conditions — exact error strings, symptoms, file/tool names — and an
  action phrase ("Use when…"). A vague one-liner will not surface reliably.

```
YES: description: "Fix \"ENOENT: no such file\" when running pnpm scripts in a
     monorepo. Use when paths resolve at root but fail inside packages/*."
NO:  description: "One-line description"
```

## Audit Checklist

Run this checklist when refining an existing instruction file:

1. [ ] Is the role defined in the first 2-3 lines?
2. [ ] Are critical constraints front-loaded (top of file)?
3. [ ] Are instructions atomic (one sentence, one action)?
4. [ ] Is framing positive ("Use X") over negative ("Don't use Y")?
5. [ ] Is scope explicit with a SCOPE: declaration?
6. [ ] Are there 1-2 concrete examples of desired behavior?
7. [ ] Is the file under 300 lines, or does it use progressive disclosure?
8. [ ] Are there contradictions between sections?
9. [ ] Are VERIFY: checkpoints placed after irreversible steps?
10. [ ] Is there a DONE WHEN: block defining termination?
11. [ ] Is the vocabulary frozen (one term per concept, no synonyms)?
12. [ ] Are meta-commentary and personality bloat removed?
13. [ ] Are "When X, Do Y" rules used instead of vague principles?
14. [ ] Is priority signaling consistent (MUST / PREFER / AVOID)?

## Iteration Rule

Treat instruction files as living documentation. After real agent work,
note where the agent:
- Misunderstood a rule → make the rule more specific.
- Ignored a rule → move it higher, or add a MUST: prefix.
- Over-applied a rule → narrow the scope with a SCOPE: declaration.
- Contradicted another rule → add an explicit resolution.

Refine based on observed behavior, not theory.

## Source

Compiled from vendor prompting guidance (Anthropic Claude, OpenAI GPT-5) and
community AGENTS.md / SKILL.md conventions. Specific citations are not tracked
here; treat the rules above as standing on their own merits, and verify any
claim independently before citing it as authoritative.
