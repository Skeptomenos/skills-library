---
name: jira-pulse
description: >-
  Use when scanning Jira for active tickets, deadlines, and blockers. Provides
  structured visibility into the user's task queue.
author: David Helmus
version: 0.1.0
source:
  type: self
  name: ai-dev
triggers:
  - check my jira
  - jira status
  - what tickets do i have
  - my tasks
template: jira-pulse-template.md
created: 2026-01-20T00:00:00.000Z
updated: 2026-01-20T00:00:00.000Z
---

<!--
ARCHITECTURE REFERENCE: docs/concepts/skill-architecture.md
This skill can be invoked standalone OR as a subagent context template for daily routines.
-->

# Jira Pulse

**Core principle:** Surface blockers and due dates to ensure a "no surprises" work routine.

---

## Context Requirements

This skill requires Jira configuration and user identity.

**Step 0 — Get Atlassian Context:**

1. **Get user info:**
   ```
   atlassian_atlassianUserInfo()
   ```
   Store the `accountId` as `USER_ACCOUNT_ID`.

2. **Get accessible resources:**
   ```
   atlassian_getAccessibleAtlassianResources()
   ```
   Store the first `id` as `CLOUD_ID`.

3. **If either fails:** Stop and report error. User may need to authenticate with Atlassian MCP.

**Step 1 — Get Date Context:**

```
TODAY = current date (YYYY-MM-DD)
OUTPUT_DIR = work/operations/daily-log/{TODAY}/
```

---

## When to Use

- During morning routine for task planning.
- When the user asks for task status or "what's next".
- To identify blockers or urgent deadlines across Jira projects.

**Do NOT use when:**
- Creating a single ticket (use `atlassian_createJiraIssue` directly).
- Modifying ticket status (use `atlassian_transitionJiraIssue`).
- Performing deep backlog grooming or sprint planning.

---

## Quick Reference

| Task | Command/Action |
|------|----------------|
| Scan Active Tasks | JQL: `assignee = currentUser() AND statusCategory != Done` |
| Scan Blockers | JQL: `assignee = currentUser() AND (status = Blocked OR labels = blocked)` |
| Scan Updates | JQL: `watcher = currentUser() AND updated >= -1d` |

---

## Process

### Phase 1: Scan Open Tickets
Execute a JQL search for active work assigned to the user.

```
atlassian_searchJiraIssuesUsingJql(
  cloudId: {CLOUD_ID},
  jql: "assignee = currentUser() AND statusCategory != Done ORDER BY priority DESC, updated DESC",
  fields: ["summary", "status", "priority", "duedate", "project", "issuetype", "created", "updated"]
)
```

**Classification Logic:**
- **OVERDUE:** `duedate < TODAY`
- **DUE_SOON:** `duedate <= TODAY + 7 days`
- **BLOCKED:** `status == Blocked` or labels contain "blocked"
- **IN_PROGRESS:** `statusCategory == 4` (Indeterminate/Yellow)
- **BACKLOG:** `statusCategory == 2` (To Do/New)

### Phase 2: Scan Watched Tickets
Scan for tickets the user is watching that had activity in the last 24 hours.

```
atlassian_searchJiraIssuesUsingJql(
  cloudId: {CLOUD_ID},
  jql: "watcher = currentUser() AND updated >= -1d AND assignee != currentUser()",
  fields: ["summary", "status", "priority", "updated", "project"]
)
```

### Phase 3: Build & Persist Report
1. **Extract Metadata:** For each issue, generate a clickable link: `https://{site}.atlassian.net/browse/{key}`.
2. **Apply Template:** Load `jira-pulse-template.md`.
3. **Write Output:** Save to `{OUTPUT_DIR}/jira-pulse.md`.

---

## Output Format

**Template:** `jira-pulse-template.md`
**Output path:** `work/operations/daily-log/{YYYY-MM-DD}/jira-pulse.md`

| Placeholder | Value |
|-------------|-------|
| `{{DATE}}` | Today's date (YYYY-MM-DD) |
| `{{TIME}}` | Scan completion time |
| `{{TOTAL_OPEN}}` | Count of issues with `statusCategory != Done` |
| `{{OVERDUE_TABLE}}` | Table of tickets where `duedate < TODAY` |
| `{{WATCHING_TABLE}}` | Table of watched issues updated in last 24h |

---

## Common Mistakes

| Mistake | Prevention |
|---------|------------|
| Missing "Done" categories | Use `statusCategory != Done` instead of `status != "Done"` to capture Resolved/Cancelled. |
| Hardcoded Cloud ID | Always fetch `cloudId` via `atlassian_getAccessibleAtlassianResources`. |
| Missing Links | Ensure every ticket key is a clickable Markdown link. |

---

## Red Flags - STOP

- No Atlassian resources found (Account not linked).
- JQL returns 0 results for a user known to have active tasks (Check `currentUser()` resolution).
- Attempting to scan for a specific project only when a global pulse was requested.

---

## Verification Checklist

- [ ] Atlassian context (accountId, cloudId) successfully acquired.
- [ ] Overdue items correctly identified relative to `TODAY`.
- [ ] Report persisted to the correct `daily-log` subdirectory.
- [ ] Final verbal summary includes counts for Overdue and Blocked items.

---

*Jira Pulse Skill v1.1 | Process-Hardened Task Visibility*
