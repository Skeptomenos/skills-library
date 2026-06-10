---
name: git-workflow
description: Git branching, commits, PRs, scope enforcement, multi-session safety, Alfred auto-review, and split publishing for the ai-dev monorepo. Use when creating branches, committing, pushing, creating PRs, or when working alongside other agents/sessions. Bridges with linear-workflow via `linear issue start` and `linear issue pr`. Does NOT cover Linear ticket lifecycle (load linear-workflow) or project creation (load create-project).
---

## The Golden Path

Every unit of work follows this sequence: Discover → Branch → Work → Commit → Push & PR → Done.

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

Always branch from `origin/main`, never local `main` — local may have unpushed commits from other sessions.

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

### 5. Auto-Review (Alfred)

Alfred is an AI bot on the homelab server that auto-reviews and auto-approves PRs.

- You cannot merge. Alfred merges after approval.
- PRs merge within minutes.

**"Branch is done" state machine:**

**After `gh pr create` — awaiting review:** Branch is locked for new work. Any additional work → new branch from `origin/main`. Alfred may merge within minutes, so commits pushed after PR creation risk landing on a closed PR.

**Alfred requests changes (ONE exception):** Push only the requested fixes to the same branch. Do not add unrelated changes. Alfred re-reviews automatically.

**After Alfred merges — branch is permanently dead:** Never push to it again. GitHub carries full prior commit history — a new PR from the same branch includes already-merged commits in its diff.

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
