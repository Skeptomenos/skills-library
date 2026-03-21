# Jira Integration Proposal

**Created:** 2026-01-20
**Status:** Proposed
**Author:** OpenCode

---

## Executive Summary

Integrate Jira as the single source of truth for task management within the existing work routine skills. This enables bidirectional sync between action items discovered in emails/meetings and Jira tickets.

---

## Current State

### Workflow Architecture
```
Morning:
  morning-boot
    ├── mail-triage (parallel) → Email scan
    ├── cal-grid (parallel)    → Calendar scan
    └── synthesis              → daily-log.md

During Day:
  mail-triage → MEETING_NOTES → post-meeting-drill → ACTION_ITEMS
  
Evening:
  evening-close
    ├── Audit daily-log vs accomplishments
    ├── Extract overflow → work/inbox/overflow-YYYY-MM-DD.md
    └── Persist to KB (chronicle, people, projects)
```

### Current Task Tracking (Gap)

Tasks are currently tracked in:
- `daily-log.md` → Top 3 priorities, pending responses
- `overflow-*.md` → Incomplete items carried forward
- `post-meeting-drill` → Extracts ACTION_ITEMS → routes to daily-log

**Problem:** No single source of truth. Tasks live in markdown files, not a centralized system.

---

## Atlassian MCP Capabilities

| Category   | Key Tools                                                  | Use Case                               |
| ---------- | ---------------------------------------------------------- | -------------------------------------- |
| **Read**   | `searchJiraIssuesUsingJql`, `getJiraIssue`                 | Morning scan, status checks            |
| **Create** | `createJiraIssue`                                          | New action items from meetings, emails |
| **Update** | `editJiraIssue`, `transitionJiraIssue`                     | Complete tasks, update status          |
| **Context**| `getVisibleJiraProjects`, `getJiraProjectIssueTypesMetadata` | Project setup                        |
| **Search** | `atlassian_search` (Rovo)                                  | Unified Jira+Confluence search         |

---

## Proposed Integration

### Phase 1: New Skill — `jira-pulse`

**Purpose:** Morning scan of Jira tickets assigned to user, analogous to `mail-triage` for email.

```
morning-boot (updated)
  ├── mail-triage (parallel)
  ├── cal-grid (parallel)
  ├── jira-pulse (parallel) ← NEW
  └── synthesis
```

**`jira-pulse` outputs:**

| Category     | JQL Query                                       | Classification   |
| ------------ | ----------------------------------------------- | ---------------- |
| MY_OPEN      | `assignee = currentUser() AND status != Done`  | Active tasks     |
| MY_DUE_SOON  | `assignee = currentUser() AND due <= 7d`       | Urgent deadlines |
| MY_BLOCKED   | `assignee = currentUser() AND status = Blocked`| Blockers         |
| WATCHING     | `watcher = currentUser() AND updated >= -24h`  | FYI updates      |

**Output:** `work/operations/daily-log/YYYY-MM-DD/jira-pulse.md`

---

### Phase 2: Update `morning-boot`

Add jira-pulse as third parallel scanner:

| Agent              | Skill       | Purpose            |
| ------------------ | ----------- | ------------------ |
| `email_scanner`    | mail-triage | Inbox scan         |
| `calendar_scanner` | cal-grid    | Calendar analysis  |
| `jira_scanner`     | jira-pulse  | Jira tickets ← NEW |

**Synthesis updates:**
- Cross-reference Jira tickets with calendar (meeting prep)
- Include Jira due dates in complexity budget
- Surface blocked tickets in Top 3

---

### Phase 3: Update `post-meeting-drill`

When ACTION_ITEMS are extracted, optionally create Jira tickets:

For each ACTION_ITEM with DRI = user:

| Condition           | Action                                   |
| ------------------- | ---------------------------------------- |
| Priority P0/P1      | Create Jira ticket automatically         |
| Has deadline        | Set due date on ticket                   |
| Has project context | Link to project (if Jira project exists) |

**Fields mapping:**

| From     | To Jira Field                             |
| -------- | ----------------------------------------- |
| Task     | Summary                                   |
| Context  | Description                               |
| Deadline | Due Date                                  |
| Priority | Priority (P0→Highest, P1→High, P2→Medium) |

---

### Phase 4: Update `evening-close`

Add Jira reconciliation:

1. Query today's completed items from daily-log
2. For each completed item with linked Jira ticket:
   - Transition ticket to "Done" (or appropriate status)
   - Add comment: "Closed via evening-close — {DATE}"
3. For blocked items:
   - Update Jira ticket status to "Blocked"
   - Add blocker reason as comment
4. For deferred items:
   - Update due date if needed

---

### Phase 5: New Skill — `jira-sync`

**Purpose:** Bidirectional sync helper, callable from any skill.

| Action               | Description                    |
| -------------------- | ------------------------------ |
| `create_from_action` | Create ticket from action item |
| `transition_to_done` | Complete a ticket              |
| `add_blocker`        | Mark as blocked with reason    |
| `update_due_date`    | Adjust deadline                |
| `link_to_project`    | Associate with Jira project    |

---

## Target Architecture

```
Morning:
  morning-boot
    ├── mail-triage (parallel)  → Email scan
    ├── cal-grid (parallel)     → Calendar scan
    ├── jira-pulse (parallel)   → Jira scan ← NEW
    └── synthesis               → daily-log.md (includes Jira tasks)

During Day:
  mail-triage → MEETING_NOTES → post-meeting-drill 
                                     ↓
                               ACTION_ITEMS 
                                     ↓
                               jira-sync.create_from_action ← NEW
  
Evening:
  evening-close
    ├── Audit daily-log vs accomplishments
    ├── jira-sync.reconcile ← NEW (transition completed/blocked)
    ├── Extract overflow
    └── Persist to KB
```

---

## Configuration Requirements

### New: `jira-config.json`

Location: `~/.config/opencode/jira-config.json`

```json
{
  "cloudId": "your-atlassian-cloud-id",
  "defaultProject": "PROJ",
  "issueType": "Task",
  "autoCreateThreshold": "P1",
  "userAccountId": "your-account-id"
}
```

### Update: `identity-discovery` skill

Add Jira context resolution:

1. Read `~/.config/opencode/jira-config.json`
2. Call `atlassian_atlassianUserInfo` to get account ID
3. Call `atlassian_getAccessibleAtlassianResources` to get cloud ID
4. Return: `{ cloudId, defaultProject, userAccountId }`

---

## Implementation Roadmap

| Order | Deliverable                     | Effort | Dependencies | Phase |
| ----- | ------------------------------- | ------ | ------------ | ----- |
| 1     | `jira-config.json` setup        | Low    | None         | MVP   |
| 2     | Update `identity-discovery`      | Low    | #1           | MVP   |
| 3     | Create `jira-pulse` skill       | Medium | #2           | MVP   |
| 4     | Update `morning-boot`           | Low    | #3           | v1    |
| 5     | Create `jira-sync` helper skill | Medium | #2           | v1    |
| 6     | Update `post-meeting-drill`     | Medium | #5           | v2    |
| 7     | Update `evening-close`          | Medium | #5           | v2    |

---

## MVP Scope

**Goal:** Standalone `jira-pulse` skill that can be invoked manually.

**What's included:**
- `jira-pulse` skill (standalone, no morning-boot integration)
- Scans Jira for open/due/blocked tickets
- Outputs structured report
- Can be called manually: "Check my Jira tickets"

**What's NOT included:**
- Morning-boot integration (Phase 2)
- Automatic ticket creation (Phase 3)
- Evening reconciliation (Phase 4)

**Why MVP first:**
- Test Atlassian MCP connectivity
- Learn Jira project structure
- Validate JQL queries
- No risk to existing morning-boot orchestration

---

## Key Design Decisions

### 1. Parallel vs Sequential Scanning
**Recommendation:** Add `jira-pulse` as third parallel scanner — keeps morning boot fast.

### 2. Automatic vs Manual Ticket Creation
**Recommendation:** Auto-create for P0/P1 only, prompt for P2 — balances automation with noise control.

### 3. Single Source of Truth
**Recommendation:** Jira becomes the source of truth for tasks. Daily-log becomes a *view* of Jira + email + calendar.

### 4. Bidirectional Sync
**Recommendation:** 
- Morning: Pull from Jira → daily-log
- Evening: Push completions → Jira
- Meeting notes: Create tickets in Jira

---

## Open Questions

1. **Default Jira project:** What project key should new tasks go to?
2. **Issue type:** Task, Story, or custom type?
3. **Auto-create threshold:** P0/P1 only, or include P2?
4. **Board/Sprint:** Should tickets be added to active sprint?

---

## Changelog

| Date       | Change                    |
| ---------- | ------------------------- |
| 2026-01-20 | Initial proposal created  |
