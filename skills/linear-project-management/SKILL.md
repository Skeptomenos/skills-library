---
name: linear-project-management
description: >-
  Orchestrated delivery with Linear as the work desk: one orchestrator plans and
  dispatches issues to Herdr work sessions, which comment on their issues and
  report back in one line. Use when planning work into issues, dispatching or
  receiving an issue, handing off, or closing a work session. Does NOT cover
  per-issue CLI mechanics (load linear-workflow) or branches and PRs (load
  git-workflow).
author: David Helmus
version: 0.1.0
source:
  type: self
  name: ai-dev
triggers:
  - orchestrator
  - dispatch an issue
  - work session
  - report back
  - close a lane
when_to_use:
  - Planning a request into Linear issues and handing them to work sessions.
  - Working on an issue that an orchestrator dispatched.
  - Handing off or closing a work session.
when_not_to_use:
  - Single-session work without an orchestrator; use linear-workflow.
---

# Linear project management

Linear is the desk. Every work item is an issue, and the issue holds its decisions, progress and evidence. Chat and terminal output are not storage.

In orchestrated delivery, this skill's merge and worktree rules override git-workflow's Alfred-merge and shared-directory rules.

## Roles

| Role | Owns | Does not |
|---|---|---|
| Orchestrator | Issues, plan, dispatch, merge at the reviewed head, live changes the user approved | Implement issues itself |
| Work session | Its assigned issues: worktree, branch, PR, checks, issue comments | Merge, dispatch, or touch live instances unless its issue says so |
| Reviewer | Independent review of one exact PR head | Review its own change |

## Orchestrator loop

1. **Capture.** Turn each request, finding and decision into an issue or a comment on one. Record a user decision on the issue it decides, with the date.
2. **Shape.** Each issue states outcome, scope, acceptance and `blocked-by` relations. Group issues that share code, data or a live window into one dispatch.
3. **Dispatch.** Prefer an idle session that knows the area and has context room. Start a fresh session for independent acceptance or when no session fits. The issue is the spec; the brief adds only what the issue lacks.
4. **Receive.** On "Update on DEV-123", read that issue's latest comments, then act: next dispatch, review request, or a question to the user.
5. **Gate.** Send each PR head to the reviewer. Merge only the exact approved head, in stack order. Any new head needs a new review.
6. **Close.** When a session's issues are merged or handed off, it confirms clean worktrees and stopped processes. Then, with the user's approval, close its pane and remove its merged worktrees.

Update the project plan and index when a durable fact changes.

## Work session rules

- Read the issue and its latest comments before you start. Move it to In Progress.
- Work in your own worktree from `origin/main`. Keep the shared checkout on `main`.
- Comment on the issue at each meaningful step: what changed, checks and results, head SHA, blockers.
- When you need a user decision, post the question with your recommendation on the issue, then report back. Do not guess.
- Finish with an open PR linked to the issue and an In Review comment with the head SHA and checks. Do not merge.
- Report back in one short final message: `Update on DEV-123: <one line>`, plus the PR URL and head SHA when there is one. Detail goes in the issue.
- Near your context limit, write a handoff comment on each open issue and report back.

## Brief template

```text
From the <project> orchestrator (herdr pane <id>). Task: DEV-123 <title> — <url>.
<Only what the issue does not say: new decisions, scope changes, constraints.>
Rules: own worktree from origin/main; do not merge; <live-instance rule>.
Linear is the desk: comment updates on the issue. Report back in one line:
"Update on DEV-123: …", plus the PR URL and head SHA.
```

## Herdr mechanics

- See sessions: `herdr agent list`. Read one: `herdr agent read <name> --source recent-unwrapped --lines 80`.
- Dispatch: `herdr agent prompt <name> "<brief>"`, then confirm `herdr agent get <name>` shows `working`. After a timeout, read before you resend.
- Wait for a report: `herdr agent wait <name> --timeout <ms>`, run in the background.
- Name sessions `<project>-lane-<x>` and `<project>-reviewer`.
- New session: `herdr pane split --current --direction right --cwd <repo> --no-focus`, then `herdr agent start <name> --kind claude|codex --pane <new-pane>`.
- Close a pane only with the user's approval: `herdr pane close <pane>`.
