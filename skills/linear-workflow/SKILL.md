---
name: linear-workflow
description: Session lifecycle with Linear issue tracking for the ai-dev monorepo. Uses the `linear` CLI (schpet/linear-cli), not the Linear MCP. Covers issue discovery at session start, milestone comments during work, status transitions, and session-end summaries. Use when working on tracked work, starting a session, or ending a session. Does NOT cover git branching or PRs (load git-workflow).
---

## Linear Setup

- **Workspace:** helmus (https://linear.app/helmus/)
- **Team:** AI Development (key: `DEV`, issues: `DEV-xxx`)
- **Statuses:** Backlog → Todo → In Progress → In Review → Done
- **CLI:** `linear` (schpet/linear-cli). Auth in system keyring. Repo config in `.linear.toml`.
- **Verify:** `linear auth whoami`

## How to Interact with Linear

Use the `linear` CLI via Bash. The repo `.linear.toml` sets workspace and team automatically — no `--team` or `--workspace` flags needed.

Key behavior:
- Always use `--no-interactive` on `create` commands to prevent agent hangs on prompts.
- Issue IDs use `DEV-123` format — the CLI resolves them automatically.
- For markdown content (descriptions, comments), use `--description-file` / `--body-file` to avoid shell escaping issues.
- Use `--json` on `issue view` when you need structured data for parsing.
- `linear api` provides a raw GraphQL escape hatch for anything not covered by built-in commands.

## Session Start

1. **Find the issue:**
   - If on a feature branch, detect automatically:
     ```bash
     linear issue id
     ```
     This prints the issue ID (e.g., `DEV-123`) from the current branch name. If found, use it.
   - If the user mentions a ticket ID:
     ```bash
     linear issue view DEV-123 --no-pager
     ```
   - If working on a known project:
     ```bash
     linear issue list --project "project name" --all-states
     ```
   - If no specific ticket: ask "Which Linear issue is this for?"

2. **Read the issue** — understand current state, previous comments, related sub-issues:
   ```bash
   linear issue view DEV-123 --no-pager
   ```
   For structured data:
   ```bash
   linear issue view DEV-123 --json
   ```

3. **Transition status:**
   - If `Backlog` or `Todo` → transition to `In Progress`:
     ```bash
     linear issue update DEV-123 --state "In Progress"
     ```
   - If `Done` but work resumes → transition back to `In Progress`
   - If already `In Progress` → no change

4. **Start working** (preferred shortcut — creates branch and assigns to you):
   ```bash
   linear issue start DEV-123 --branch <scope>/DEV-123-description --from-ref origin/main
   linear issue update DEV-123 --state "In Progress"
   ```
   **Important:** `issue start` creates the branch and assigns you, but transitions to In Review — not In Progress. Always follow with the explicit state update. Use `--branch` to set a scope-compliant name (git-workflow enforces `<scope>/<description>`). Use `--from-ref origin/main` to branch from remote main (git-workflow rule: never branch from local main).

   If you already have a branch, skip `issue start` and just update the status manually.

5. **No issue?** Ask: "Should I create one?" Substantial work (>1 session) should have a Linear issue. Quick fixes don't need one.
   ```bash
   linear issue create --title "Description" --assignee self --state "In Progress" --no-interactive
   ```

## During Work

### Comment on milestones

When a meaningful step completes, add a comment to the issue:

```bash
linear issue comment add DEV-123 --body "Milestone: Completed X of Y. Remaining: Z."
```

For multi-line comments, use a file:

```bash
cat > /tmp/milestone.md <<'EOF'
## Milestone

- Completed X of Y items
- Remaining: Z
- No blockers
EOF
linear issue comment add DEV-123 --body-file /tmp/milestone.md
```

To attach a file (build log, screenshot, test output):
```bash
linear issue comment add DEV-123 --body "Build results attached" --attach /tmp/build-output.log
```

### Flag scope creep

If the current work reveals additional tasks beyond the original issue scope:

1. Flag it: "This looks like additional work — should I create a new issue?"
2. If user approves — create a new issue (or sub-issue if closely related):
   ```bash
   # Create as a sub-issue of the current issue
   linear issue create --title "Additional: description" --parent DEV-123 --assignee self --no-interactive

   # Or create as a standalone issue
   linear issue create --title "Additional: description" --assignee self --no-interactive
   ```
3. If user declines — note it in a comment:
   ```bash
   linear issue comment add DEV-123 --body "Scope note: discovered X but deferring."
   ```

### Discovered work without an issue

If you encounter work that needs tracking but has no issue:

1. Flag: "I found something that should be tracked — {description}"
2. If user approves:
   ```bash
   linear issue create --title "description" --assignee self --label "Domain: AI-Dev" --no-interactive
   ```

### Link related issues

When overlap or dependencies are detected between issues:

```bash
# Issues are related
linear issue relation add DEV-123 related DEV-456

# This issue blocks another
linear issue relation add DEV-123 blocks DEV-456

# This issue is blocked by another
linear issue relation add DEV-123 blocked-by DEV-456

# This issue duplicates another
linear issue relation add DEV-123 duplicate DEV-456
```

## Session End

1. **Write a summary comment** on the issue:

   ```bash
   cat > /tmp/summary.md <<'EOF'
   ## Session Summary

   **Done:**
   - {list of completed items}

   **Remaining:**
   - {remaining tasks}

   **Follow-ups:**
   - {new issues or concerns discovered}

   **PR:** #{number} (if applicable)
   EOF
   linear issue comment add DEV-123 --body-file /tmp/summary.md
   ```

2. **Transition status:**
   - Work complete:
     ```bash
     linear issue update DEV-123 --state "Done"
     ```
   - PR created, awaiting review:
     ```bash
     linear issue update DEV-123 --state "In Review"
     ```
   - Continuing in next session → leave `In Progress`
   - Blocked → use relation:
     ```bash
     linear issue relation add DEV-123 blocked-by DEV-456
     linear issue comment add DEV-123 --body "Blocked on DEV-456: {reason}"
     ```

3. **Create PR with Linear context** (preferred over plain `gh pr create`):
   ```bash
   linear issue pr DEV-123
   ```
   This calls `gh pr create` with the issue title and description pre-filled. The PR title is prefixed with the issue ID for auto-linking in Linear.

   For more control:
   ```bash
   linear issue pr DEV-123 --base main --draft
   ```

4. **Project status update** (for longer-running projects, optional):
   ```bash
   linear project-update create <projectId> --body "Week summary: ..." --health onTrack
   ```

## Hard Rules

- **Always use `--no-interactive`** on `issue create` commands — prevents agent hangs on prompts. Other create commands (`project create`, `milestone create`) are non-interactive by default when flags are provided.
- **Always assign issues to the user** — use `--assignee self` on create/update.
- **Use "In Review"** when a PR is created — aligns with the git-workflow "awaiting review" state.
- **Link related issues** when overlap is detected.
- **Use `--body-file`** for multi-line content — avoids shell escaping issues.

## Hierarchy

| Linear Concept | ai-dev Mapping | CLI Command | Example |
|---------------|----------------|-------------|---------|
| **Project** | Project-level grouping | `linear project list` | "ai-dev Monorepo" |
| **Issue** | Work item | `linear issue view DEV-123` | "Phase 4.1: GitHub workflow consolidation" |
| **Sub-issue** | Sub-task | `linear issue create --parent DEV-123` | "Create git-workflow skill" |
| **Milestone** | Phased deliverable | `linear milestone list --project <id>` | "Phase 1: Foundation" |

To create a new Linear project (1:1 with monorepo project):
```bash
linear project create --name "Project Name" --team DEV --lead @me --status backlog
```

## Soft Rules

- No issue required for quick fixes (<1 session)
- Assign to current Cycle when applicable:
  ```bash
  linear issue create --title "Work" --cycle active --assignee self --no-interactive
  linear issue update DEV-123 --cycle active
  ```
- Branch names include issue ID for auto-linking: `devtools/kanban/DEV-42-session-viewer`
- Add `Domain: AI-Dev` label for ai-dev monorepo work:
  ```bash
  linear issue update DEV-123 --label "Domain: AI-Dev"
  ```

## Bridge with git-workflow

The `linear-workflow` and `git-workflow` skills have complementary handoff points:

| git-workflow step | linear-workflow bridge |
|---|---|
| **1. Discover** | `linear issue id` — auto-detect issue from current branch |
| **2. Branch** | `linear issue start DEV-123 --branch <scope>/... --from-ref origin/main` + `linear issue update DEV-123 --state "In Progress"` — creates branch, assigns, then sets In Progress |
| **4. Push & PR** | `linear issue pr DEV-123` — creates PR with Linear context pre-filled, auto-links in Linear |
| **5. Alfred merges** | `linear issue update DEV-123 --state "Done"` — close issue after merge confirmed |

When both skills are loaded, prefer the `linear` commands at these handoff points — they keep Linear and git in sync with fewer steps.

## Quick Reference

```bash
# Auth
linear auth whoami

# View issue
linear issue view DEV-123 --no-pager
linear issue view DEV-123 --json

# Detect issue from branch
linear issue id

# List issues
linear issue list                                          # my unstarted
linear issue list --all-states                             # my issues, all states
linear issue list --all-states -A                          # all issues, all states
linear issue list --project "project name" --all-states    # by project

# Start issue (branch + assign, then set In Progress)
linear issue start DEV-123 --branch <scope>/DEV-123-desc --from-ref origin/main
linear issue update DEV-123 --state "In Progress"

# Create issue
linear issue create --title "Title" --assignee self --no-interactive
linear issue create --title "Sub-task" --parent DEV-123 --assignee self --no-interactive

# Update
linear issue update DEV-123 --state "In Progress"
linear issue update DEV-123 --label "Domain: AI-Dev"
linear issue update DEV-123 --cycle active

# Comments
linear issue comment add DEV-123 --body "text"
linear issue comment add DEV-123 --body-file /tmp/comment.md
linear issue comment add DEV-123 --body "Results" --attach /tmp/output.log

# PR with Linear context
linear issue pr DEV-123
linear issue pr DEV-123 --base main --draft

# Relations
linear issue relation add DEV-123 related DEV-456
linear issue relation add DEV-123 blocks DEV-456
linear issue relation add DEV-123 blocked-by DEV-456

# Projects
linear project list
linear project create --name "X" --team DEV --lead @me --status backlog

# Project status updates
linear project-update create <projectId> --body "Update text" --health onTrack

# Milestones
linear milestone list --project <projectId>
linear milestone create --project <projectId> --name "Phase 1"

# GraphQL escape hatch
linear api '{ viewer { id name email } }'

# Help
linear --help
linear issue --help
linear issue create --help
```

## Diagrams

See `docs/linear-workflow-diagram.md` for Mermaid state machine diagrams of the session lifecycle, issue discovery, and status transitions.
