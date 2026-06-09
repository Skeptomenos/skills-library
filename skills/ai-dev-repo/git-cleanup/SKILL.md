---
name: ai-dev-repo-git-cleanup
description: Use when cleaning ai-dev branches, triaging stale pull requests, protecting dirty main state, archiving side-project work, or reducing branch sprawl in the ai-dev monorepo.
triggers:
  - "git cleanup"
  - "branch cleanup"
  - "stale PR"
  - "archive side project branches"
  - "clean ai-dev branches"
license: MIT
compatibility: opencode
---

# ai-dev Repo Git Cleanup

## Core Principle

Consolidate work into PRs, archives, and harvest issues; do not treat every branch as active work.

## Baseline Failure Evidence

This skill exists because a normal Git cleanup pass in ai-dev can go wrong:

- `ahead of main` was misleading for branches whose patches had already merged.
- Open PRs looked stale by date, but some were still operationally useful.
- Linked worktrees blocked branch deletion.
- Dirty `main` included durable docs/config plus generated build caches.
- A giant mixed PR needed harvesting, not merging or blind deletion.
- Entire checkpoint refs looked like cleanup candidates but are tool-owned.

## When To Use

Use for ai-dev monorepo branch/PR cleanup, especially when the user mentions ADHD side-project drift, stale branches, dirty `main`, or reducing active branch count.

Do not use for ordinary feature branching. Use `git-workflow` directly for that.

## Required Skills

Load these first:

- `git-workflow` for branch, commit, push, and PR rules.
- `writing-plans` when the cleanup spans multiple PRs or will continue later.
- `repo-conventions` when deciding whether a branch/project is active, archived, or misplaced.

## Quick Reference

```bash
git fetch --prune origin
git status --short --branch
git branch -vv --sort=-committerdate
git worktree list --porcelain
gh pr list --state open --limit 100 --json number,title,headRefName,updatedAt,url
git cherry -v origin/main <branch>
```

Classify with this order:

1. Protect dirty `main`.
2. Keep open active PRs.
3. Delete merged or patch-equivalent branches.
4. Archive stale unique branches before deleting.
5. Close giant stale PRs only after creating a harvest issue.
6. Return the main worktree to clean `main`.

## Process

### 1. Protect Dirty State

If `main` is dirty, separate durable work from generated output.

- Preserve docs, source, config, launchd files, plans, and scripts on a cleanup branch.
- Do not commit build caches, dependency folders, tool state, `.env`, `.entire`, `.opencode`, `.xcodebuildmcp`, or large archives.
- If generated files already have a PR protecting them as tracked files, remove local untracked duplicates from `main` after verifying hashes.
- For multi-area dirty state, use `cross/<description>`; otherwise use the narrowest valid scope.

### 2. Inventory Branches And PRs

Collect:

- Local branches and upstreams: `git branch -vv`.
- Remote branches after prune.
- Linked worktrees: `git worktree list --porcelain`.
- Open PRs with head branch, title, updated date, URL, checks, and review comments.
- Recently closed PRs to detect branches already merged by content.

Use the current date explicitly. For a one-week active window, compute and state the cutoff date.

### 3. Check Patch Equivalence

Never rely on ahead/behind alone.

Run:

```bash
git cherry -v origin/main <branch>
```

Interpretation:

- `- <commit>` means the patch is already in `origin/main`; branch can usually be deleted.
- `+ <commit>` means the patch is not in `origin/main`; keep, archive, or harvest it.

For stale branches with noisy double-dot diffs, inspect only the project paths that branch owns.

### 4. Triage Open PRs

Open PRs are collaboration state. Do not delete their branches casually.

- **Keep/finish:** updated within the active window or tied to work the user says is active.
- **Close:** stale and not currently active. Add a comment explaining it can be revived from a fresh branch.
- **Revive:** create a fresh branch from `origin/main`, cherry-pick only useful commits, address comments, and open/update a clean PR.
- **Harvest:** for giant mixed PRs, create an issue with topical slices before closing.

Alfred approval may appear as a PR comment from the owner rather than a formal GitHub review decision. Read comments, not just `reviewDecision`.

### 5. Delete Or Archive Branches

Before deleting:

- Remove or switch clean linked worktrees for branches checked out elsewhere.
- Archive stale unique work with annotated tags:

```bash
git tag -a archive/YYYY-MM-DD/<original-branch> <branch-or-origin/ref> -m "Archive stale branch <branch> on YYYY-MM-DD"
git push origin refs/tags/archive/YYYY-MM-DD/<original-branch>
```

- Delete only after the tag is pushed.
- Use `git branch -d` for merged local branches and `git branch -D` only when the branch is archived or patch-equivalent.
- Use `git push origin --delete <branch>` only for branches that are merged, archived, or intentionally closed.

Never delete `entire/checkpoints/v1` or other tool-owned refs without confirming the tool no longer uses them.

### 6. Final State

End on clean `main` unless the user asks to remain on a work branch.

Report:

- Branch started on and branch ended on.
- PRs opened, closed, renamed, or kept.
- Branches deleted.
- Archive tags pushed.
- Harvest issues created.
- Remaining active PRs and the concrete work left on each.
- Any local excludes added to avoid generated-file noise.

## Common Mistakes

| Mistake | Correction |
| --- | --- |
| Trusting `ahead_main > 0` | Run `git cherry -v origin/main <branch>`. |
| Treating recent commits as active work | Check PR state, user intent, and actual diff. |
| Deleting stale branches without recovery | Push `archive/YYYY-MM-DD/...` tags first. |
| Merging mixed stale PRs | Close with a harvest issue. |
| Committing build output to preserve dirty state | Ignore generated output; commit durable files only. |
| Deleting branch refs checked out in worktrees | Remove/switch clean worktrees first. |
| Waiting on Alfred via `reviewDecision` only | Read PR comments and checks. |

## Verification Checklist

- [ ] `git status --short --branch` is clean on `main` at the end.
- [ ] Open PR list contains only active, intentionally kept PRs.
- [ ] Closed stale PRs have comments explaining close/revive path.
- [ ] Giant stale PRs have harvest issues before closure.
- [ ] Deleted unique-work branches have pushed archive tags.
- [ ] No build caches, secrets, or tool state were committed.
