---
name: git-workflow
description: Use when branching, committing, pushing, opening, independently reviewing, or merging PRs in the ai-dev monorepo; coordinating concurrent Git work; or handling split publishing. Covers scope enforcement, review evidence, and authorized merges. For Linear issue lifecycle, load linear-workflow; for project creation, load create-project.
author: David Helmus
version: 0.2.0
source:
  type: self
  name: ai-dev
triggers:
  - "git workflow"
  - "create branch"
  - "commit changes"
  - "open PR"
  - "pull request"
  - "independent review"
  - "merge PR"
  - "split publishing"
when_to_use:
  - "Creating or switching branches in the ai-dev monorepo."
  - "Staging, committing, pushing, opening, reviewing, or merging a pull request."
  - "Coordinating multi-session Git work or checking existing PR feedback."
  - "Handling split-published project constraints."
when_not_to_use:
  - "Only managing Linear issue state; use linear-workflow."
  - "Only creating a new project; use create-project."
---

## The Golden Path

Every unit of work follows this sequence: Discover → Branch → Work → Commit → Push & PR → Independent Review → Merge → Done.

### 1. Discover — before creating a branch

Check for existing work before starting:

```bash
git fetch origin
git branch --list '*search-term*'
gh pr list --search 'search-term'
```

**Three outcomes:**
- **No branch found** → create new branch from `origin/main`
- **Branch exists, no PR** → ask user: "Found branch `scope/description`. Continue on it, or start fresh?"
- **Branch exists, open PR** → check PR status:
  ```bash
  gh pr view {number} --json reviews,comments
  ```
  Surface any review feedback before proceeding.

### 2. Branch — scope-enforced naming

Format: `<scope>/<description>` — scope must match an entry in `.git-scope-map`.

```bash
git fetch origin main
git checkout -b <scope>/<description> origin/main
```

Start new work from `origin/main`, never local `main` — local may have unpushed commits from other sessions. A dependent PR may branch from its prerequisite branch; record the dependency and follow the stack gate in Section 5.

**Linear integration:** Check for a Linear issue covering this work. If none exists, create one (see linear-workflow skill). Then use `linear issue start DEV-123 --branch <scope>/DEV-123-description --from-ref origin/main` to create the branch, assign the issue, and transition to In Progress in one command.

**Special prefixes:**
- `cross/*` — all files allowed (cross-project work)
- `root/*`, `meta/*` — root-level files + `docs/*`, `scripts/*`, `.github/*`, `.agents/*`

The pre-commit hook and CI (`scope-check.yml`) enforce scope automatically. If the hook rejects your commit, your branch scope doesn't cover the files you changed.

### 3. Commit — branch guard + selective staging

**Branch Guard — before EVERY commit:**

Run this as a **standalone command — never chained with `&&`**:

```bash
git branch --show-current
```

Read the output. If it does not match your expected branch, STOP. Do not stage or commit. Check for uncommitted changes first, then switch:

```bash
git status --short
git checkout {your-branch}
```

**Why standalone:** Chaining `git branch --show-current && git add && git commit` bypasses the guard — the agent executes all three without evaluating the check result.

**Selective staging:**

```bash
git add path/to/specific/file
```

Never `git add .` or `git add -A` — other sessions may have uncommitted changes in the same working directory.

**Commit messages:** Conventional commits — `feat:`, `fix:`, `chore:`, `docs:`, `refactor:`, `test:`

### 4. Push & PR

```bash
git push -u origin <branch>
gh pr create --title "type: description" --body "..."
```

**Linear integration:** Use `linear issue pr DEV-123` to create the PR with the issue title/description pre-filled and auto-link it in Linear. See linear-workflow skill.

- One change per PR — multiple distinct changes → separate branches
- Root `AGENTS.md` mandates the PR workflow — never push to main directly

### 5. Independent Review & Merge

Every PR requires a reviewer subagent or a different chat that did not implement any part of the reviewed change. Changing roles within the implementing chat is self-review and cannot approve the PR.

1. **Review the final diff.** Give the independent reviewer the PR, exact head commit SHA, base ref and exact base commit SHA, relevant context and acceptance criteria, and validation evidence. The reviewer reads the actual PR diff and affected context, checks the evidence, and reports findings with a `PASS` or `BLOCKED` verdict.
2. **Record the verdict.** Put the reviewer chat/subagent identity, exact reviewed head commit SHA, base ref and exact base commit SHA, findings and their resolution, validation evidence, and verdict in a durable PR body or comment. An author may relay the result, but must identify the actual reviewer. `PASS` requires no unresolved blocking findings; a private chat alone is not PR evidence.
3. **Resolve and re-review.** Fix blocking findings and obtain independent re-review of the changed diff and affected context. Every new head commit SHA, base ref, base commit SHA, or changed diff needs a fresh independent verdict; an earlier approval does not transfer. Required checks must pass for the final relevant source and environment. Rerun affected gates; reuse evidence only when its relevant inputs are unchanged.
4. **Merge the approved head.** Under the task's merge authorization, the implementation or orchestrator agent may merge after independent `PASS` and all required checks pass. Immediately before submitting the merge, re-read the open PR's head commit SHA, base ref and base commit SHA, review evidence, and checks. Compare both commit SHAs and the base ref with the recorded verdict; if any changed, obtain a fresh independent verdict before merging. Use the repository-supported merge method with a head guard such as `--match-head-commit <reviewed-head-sha>`. This guards the head, not the base. If the merge interface cannot atomically guard the base commit, recheck it immediately before submission and record that limitation; do not claim the base was atomically protected. Respect branch protection and required formal approvals; never use an admin override or bypass a failing gate. Report a blocked gate instead of merging.

**Stacked PRs:** Record dependencies and merge prerequisites first. Then fetch `origin/main`, retarget the dependent PR to `main`, and rebase if needed to remove already-merged commits or resolve conflicts. Inspect the resulting PR diff, run checks for the final source, and obtain a fresh independent verdict for its exact head commit SHA, base ref and base commit SHA before merging. Approval of a prerequisite does not approve its dependents.

**Alfred:** Optional notifications or bot services do not replace the mandatory independent subagent/chat review and its PR evidence. Do not wait for Alfred once the authorized merge gate passes. Report incompatible automation settings separately; changing GitHub Actions or external bot configuration requires its own scoped task.

**Branch lifecycle:**
- After PR creation, keep the branch limited to requested fixes and the dependency updates above. Put unrelated new work on a fresh branch from `origin/main`.
- Before pushing a fix, confirm the PR is still open. Every new head returns to independent review.
- After merge, never reuse or push to that branch. Start from current `origin/main` so the next PR contains only its own change.

### 6. Multi-Session Safety

Multiple agents share the same working directory (no worktree isolation). These guards prevent collisions:

- **Branch guard** before every commit (Section 3)
- **Before editing shared files** (`AGENTS.md`, `index.md`, `opencode.json`): `git pull origin main` first
- **If `git pull` shows conflicts:** STOP, show user, ask how to resolve. Never auto-resolve.
- **Each session uses its own branch** — shared branches mean conflicting staging areas

**Recovery — committed to wrong branch:**

```bash
git log --oneline -1          # note the commit hash
git checkout {correct-branch}
git cherry-pick {hash}
# wrong-branch commit cleaned up when branch is deleted
```

### 7. Split Publishing

Some directories auto-publish to public GitHub repos via splitsh-lite CI on merge to `main`.

| Monorepo Directory | Public Repo |
|--------------------|-------------|
| `apps/murmeln` | Skeptomenos/Murmeln |
| `apps/vibe-remote` | Skeptomenos/VibeRemote |
| `apps/portfolio-prism` | Skeptomenos/Portfolio-Prism-App |
| `apps/open-jupy` | Skeptomenos/OpenJupy |
| `apps/drawer` | Skeptomenos/Drawer |
| `apps/luma` | Skeptomenos/Luma |
| `apps/poker-chip-counter` | Skeptomenos/TableStakes |
| `_infra/dev-handbook` | Skeptomenos/dev-handbook |
| `_infra/skills` | Skeptomenos/skills-library |
| `_infra/google-workspace-mcp-advanced` | Skeptomenos/google-workspace-mcp-advanced |

**Rules:**
- Never push directly to public repos — all changes go through ai-dev
- After your PR merges to `main`, CI auto-publishes affected split targets
- Private content lives in `_planning/` subdirectories within each project — CI removes these before publishing
- Do not put secrets in split directories — use git-crypt for `.env`/`.tfvars`
- AGENTS.md files are behavioral (no secrets) — they go public intentionally

**External PRs on public repos:** Cherry-pick into ai-dev, next split includes the change.

### 8. Scope Map Reference

Read `.git-scope-map` for valid scope prefixes. Adding a new project requires adding a scope entry — see `create-project` skill.

For git-crypt, secrets management, and machine setup: read `docs/git-workflow.md`.
