---
name: morning-boot
description: >-
  The master orchestrator for your morning routine. Parallelizes scans across
  email, calendar, Slack, and Jira, then synthesizes into a daily briefing.
  Path-aware — scans both work and life when run from KB root.
author: David Helmus
version: 0.1.0
source:
  type: self
  name: ai-dev
triggers:
  - start my day
  - morning routine
  - morning boot
when_to_use:
  - 'Starting the day with a briefing across email, calendar, Slack, and Jira.'
  - 'The user asks for a morning routine, daily scan, or start-of-day plan.'
  - A path-aware work/life operations synthesis is needed.
when_not_to_use:
  - Closing the day; use evening-close.
  - Only drafting or sending one message.
  - Only inspecting one calendar event or Jira ticket.
template: daily-log-template.md
created: 2026-01-09T00:00:00.000Z
updated: 2026-01-20T00:00:00.000Z
---

<!--
ARCHITECTURE REFERENCE — READ BEFORE MODIFYING

This skill follows the Skill Architecture pattern documented in:
  docs/SKILL_ARCHITECTURE.md

Key concepts:
- Skills are modular context units (workflow + template + orchestration)
- Subagents invoke skills as context templates
- Templates ensure consistent output quality
- Synthesis happens in main session (not subagent) for full context access
- Nesting enables context discovery chains
- PATH-AWARE: Dual mode (work+life) at KB root, single mode in hemispheres

DO NOT modify this skill without reading the architecture doc first.
-->

# Morning Boot Skill

You are the **Daily Operations Orchestrator**. Coordinate parallel scans, synthesize results with full session context, and produce the daily briefing.

**Path-aware behavior:**
- Running from **KB root** → Scan BOTH work and life (dual mode)
- Running from **work/** → Scan work only (single mode)
- Running from **life/** → Scan life only (single mode)

---

## Architecture

```
Main Session (OpenCode)
│
├─▶ SKILL.md (this file)
│   │
│   ├── Phase 1: Context Discovery (detects mode)
│   │
│   ├── Phase 2: Execute Parallel Scans
│   │   │
│   │   ├── [DUAL MODE] Both hemispheres:
│   │   │   ├── work_email_scanner → mail-triage (work email)
│   │   │   ├── work_calendar_scanner → cal-grid (work calendar)
│   │   │   ├── work_slack_scanner → slack-pulse
│   │   │   ├── work_jira_scanner → jira-pulse
│   │   │   ├── life_email_scanner → mail-triage (personal email)
│   │   │   └── life_calendar_scanner → cal-grid (personal calendar)
│   │   │
│   │   └── [SINGLE MODE] One hemisphere:
│   │       ├── email_scanner → mail-triage
│   │       ├── calendar_scanner → cal-grid
│   │       ├── slack_scanner → slack-pulse (work only)
│   │       └── jira_scanner → jira-pulse (work only)
│   │
│   ├── Phase 3: Synthesize (YOU do this, with full context)
│   │   └── Use daily-log-template.md
│   │
│   ├── Phase 4: Persist outputs
│   │
│   └── Phase 5: Present to user
│
└── Back to Main Session
```

**Key insight:** Subagents do the heavy scanning (keeps main context clean). YOU do the synthesis (you have full context: spillover, projects, commitments).

---

## Phase 1: Context Discovery

**Step 1.1 — Get Identity and Mode:**

```
skill({ name: "identity-discovery" })
```

**Flexible Behavior:** 
If the automatic discovery is blocked or uncertain, you MUST ask the user:
"I'm having trouble identifying your Knowledge Base root or hemisphere. I found potential candidates at [Path]. Should I use one of these, or can you provide the correct path?"

**Store based on mode:**

```
If mode == "dual":
  WORK_EMAIL = hemispheres.work.email
  LIFE_EMAIL = hemispheres.life.email
Else:
  EMAIL = identity.email
  HEMISPHERE = hemisphere
```

**Step 1.2 — Determine output path:**

```
OUTPUT_DIR = {KB_ROOT}/work/operations/daily-log/{YYYY-MM-DD}/
```

Create the directory if it doesn't exist.

---

## Phase 2: Execute Parallel Scans

### Dual Mode (KB root — both hemispheres)

Spawn **6 parallel scanners**:

| Agent | Skill | Email | Purpose |
|-------|-------|-------|---------|
| `work_email_scanner` | mail-triage | `WORK_EMAIL` | Work inbox |
| `work_calendar_scanner` | cal-grid | `WORK_EMAIL` | Work calendar |
| `work_slack_scanner` | slack-pulse | - | Slack activity |
| `work_jira_scanner` | jira-pulse | - | Jira tickets |
| `life_email_scanner` | mail-triage | `LIFE_EMAIL` | Personal inbox |
| `life_calendar_scanner` | cal-grid | `LIFE_EMAIL` | Personal calendar |

**Receive back:** `{ work: { email, calendar, slack, jira }, life: { email, calendar } }` summaries.

### Single Mode (inside hemisphere)

Spawn **4 parallel scanners** (or 2 for life):

| Agent | Skill | Purpose |
|-------|-------|---------|
| `email_scanner` | mail-triage | Inbox scan |
| `calendar_scanner` | cal-grid | Calendar analysis |
| `slack_scanner` | slack-pulse | Slack activity (work only) |
| `jira_scanner` | jira-pulse | Jira task scan (work only) |

**Receive back:** `{ email, calendar, slack, jira }` — summaries from scanners.

---

## Phase 3: Synthesize Daily Briefing

**YOU do this step** — not a subagent. You have the full session context.

**Step 3.1 — Load template:**

Read `daily-log-template.md` from this skill folder.

**Step 3.2 — Gather additional context:**

Check for spillover and commitments:
- Read `{KB_ROOT}/work/dashboard.md` for current priorities
- Read previous day's `daily-log.md` for unfinished items

**Step 3.3 — Apply synthesis logic:**

| Input | Analysis |
|-------|----------|
| Email ACTION items | → Pending responses (email) |
| Calendar meetings | → Meeting load, complexity budget |
| Slack RESPOND items | → Pending responses (slack) |
| Jira ACTIVE tickets | → Task priority, deadlines |
| Meeting notes detected | → Handoff count for post-meeting-drill |
| Spillover from yesterday | → Carry forward or reprioritize |
| Dashboard priorities | → Cross-reference with today's items |

**Step 3.4 — Determine Top Priority and Top 3:**

Apply Executive Filter:
1. What MUST happen today? (deadlines, blockers, commitments)
2. What SHOULD happen today? (important but not urgent)
3. What CAN happen today? (if time permits)

**Step 3.5 — Fill template:**

Replace placeholders in `daily-log-template.md` with synthesized values.

---

## Phase 4: Persist Outputs

Write all files to `{OUTPUT_DIR}`:

| File | Content |
|------|---------|
| `daily-log.md` | Synthesized briefing (from Phase 3) |
| `mail-triage.md` | Email scan results |
| `cal-grid.md` | Calendar analysis |
| `slack-pulse.md` | Slack activity report |
| `jira-pulse.md` | Jira task report |

---

## Phase 5: Present to User

```
## Morning Briefing — {DATE}

**Top Priority:** {TOP_PRIORITY}

**Top 3:**
1. {PRIORITY_1}
2. {PRIORITY_2}
3. {PRIORITY_3}

**Day Shape:** {COMPLEXITY} day — {MEETING_COUNT} meetings, {DEEP_WORK_HOURS}h deep work available

**Pending Responses:** {EMAIL_ACTION_COUNT} emails, {SLACK_RESPOND_COUNT} Slack messages

**Jira Highlights:** {JIRA_ACTIVE_COUNT} active tickets

**Meeting Notes:** {MEETING_NOTES_COUNT} ready for processing

Files saved to: work/operations/daily-log/{DATE}/
```

---

## Fallback Mode

If any scanner fails:
1. **Report which failed** and the error
2. **Continue with remaining scanners**
3. **Synthesize with available data**

---

## Verification Checklist

- [ ] Context discovery completed
- [ ] Email scan completed
- [ ] Calendar scan completed
- [ ] Slack scan completed
- [ ] Jira scan completed
- [ ] Top 3 priorities identified
- [ ] Files persisted to daily-log directory
- [ ] Summary presented to user

---

*Morning Boot Skill v4.1 | Master operations orchestrator*
