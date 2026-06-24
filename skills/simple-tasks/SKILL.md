---
name: simple-tasks
description: Install a fast local task workflow for single-project planning with `scripts/task.sh` (claim, done, status, reporting) backed by `tasks/TASKS.md` and optional `tasks/details/` notes. Use for lightweight in-progress task coordination, not full team issue tracking.
author: Paul Solt
version: 0.9.8
source:
  type: self
  name: ai-dev
triggers:
  - "task.sh"
  - "local task tracking"
  - "single-project planning"
  - "lightweight backlog"
  - "task status report"
when_to_use:
  - "Installing a lightweight local task CLI into one project."
  - "Tracking single-project work in tasks/TASKS.md without a team issue tracker."
  - "Generating quick task status, reporting, or agent handoff summaries."
when_not_to_use:
  - "The work should be tracked in Linear, Jira, GitHub Issues, or another team system."
  - "The user only needs Xcode build/run/test tooling; use xcode-makefiles."
  - "The task is a one-off command that does not need project-local task state."
---

# Simple Tasks

## Overview

Paul Solt
Paul@SuperEasyApps.com
Version: 0.9.8

`simple-tasks` installs a lightweight local task CLI into an existing project.

Design goals:
- Fast local planning and execution.
- Human shorthand task numbers + stable task IDs.
- Single canonical backlog file: `tasks/TASKS.md`.
- Optional long-form notes per task: `tasks/details/<id>.md`.

## Install

```bash
skills/simple-tasks/scripts/install.sh --project-dir /path/to/project
```

Common flags:
- `--project-dir PATH` required
- `--mode install|upgrade` default `install`
- `--dry-run` preview changes only

## Commands

Installed `scripts/task.sh` supports:
- `claim`
- `done`
- `status`
- `next`
- `plan`
- `finished`
- `upcoming`
- `needs-planning`
- `blocked`
- `summary`
- `learn`

Filters:
- `--today`
- `--last-24h`
- `--last-week`
- `--last-month`
- `--days`
- `--mine`
- `--agent`
- `--limit`
