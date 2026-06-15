---
name: mail-triage
description: >-
  Use when user asks to check email, process inbox, or scan for messages.
  Exhaustively drains inbox and outputs structured triage report with meeting
  notes detection.
author: David Helmus
version: 0.1.0
source:
  type: self
  name: ai-dev
triggers:
  - mail triage
  - triage Gmail
  - email inbox scan
  - process emails
license: MIT
compatibility: opencode
---

# Mail Triage Skill

**Core principle:** Exhaust the inbox, classify everything, detect meeting notes for handoff, persist structured output. Never improvise.

---

## Context Requirements (EXECUTE FIRST)

This skill requires the user's email address for API calls.

**Step 0 — Get Identity:**

1. **Check if passed in context**: If you received `context.identity.email`, use it directly.

2. **If not passed, invoke identity-discovery skill**: Call `skill({ name: "identity-discovery" })` and use the returned `email` value.

3. **Store as `EMAIL`** for use in all API calls below.

**If discovery fails**: Stop and report the error from identity-discovery.

---

## When to Use

- User asks to check email or process inbox
- Morning boot routine (mail-triage is a component)
- Any request about what's in the inbox

**Do NOT use when:**
- User asks to read a specific email (just read it)
- User asks to send/draft an email (use email-draft skill)
- Processing meeting notes deeply (that's post-meeting-drill)

---

## Quick Reference

| Task | Tool | Command |
|------|------|---------|
| Query inbox | gws-mcp-advanced_search_gmail_messages | `query: "label:inbox"` |
| Read threads batch | gws-mcp-advanced_get_gmail_threads_content_batch | `thread_ids: [...]` |
| Read single message | gws-mcp-advanced_get_gmail_message_content | `message_id: "..."` |
| Persist output | write | `work/operations/daily-log/YYYY-MM-DD/mail-triage.md` |

**Email:** Use `{EMAIL}` from Context Discovery (Step 0)

---

## Process

### Phase 1: Query Inbox

```
gws-mcp-advanced_search_gmail_messages(
  query="label:inbox",
  user_google_email={EMAIL},
  page_size=25
)
```

Paginate until inbox is exhausted.

### Phase 2: Batch Read Threads

```
gws-mcp-advanced_get_gmail_threads_content_batch(
  thread_ids=[...],
  user_google_email={EMAIL}
)
```

Process in batches of 25 max.

### Phase 3: Classify Each Item

| Classification | Definition | Action |
|----------------|------------|--------|
| **ACTION** | Requires user's decision/response | Add to ACTION_ITEMS table |
| **FYI** | Contextually relevant, no immediate action | Add to FYI_ITEMS table |
| **ARCHIVE** | Noise, automated, redundant | Add to ARCHIVED table |
| **MEETING_NOTES** | From `gemini-notes@google.com` or contains meeting notes | Add to MEETING_NOTES_DETECTED table |

#### Priority Boosters (for ACTION items)

| Signal | Boost |
|--------|-------|
| From: Direct report | +1 |
| From: Manager or skip-level | +2 |
| Contains "urgent", "blocker", "ASAP" | +1 |
| Contains deadline language | +1 |
| In TO: (not CC:) | +1 |
| Unanswered >24h | +1 |

### Phase 4: MEETING_NOTES Detection

**CRITICAL GATE: Meeting notes trigger handoff or flagging.**

#### Detection Rules

| Pattern | Classification |
|---------|----------------|
| From: `gemini-notes@google.com` | MEETING_NOTES |
| Subject contains "Notes from" + meeting context | MEETING_NOTES |
| Subject contains "shared a document" + "meeting"/"notes" | MEETING_NOTES |

#### When Detected — Extract Doc ID

1. **STOP** — Do NOT read the Google Doc content
2. **STOP** — Do NOT extract action items
3. **Extract the Google Doc ID** from the email body:
   - Look for link pattern: `docs.google.com/document/d/{DOC_ID}/`
   - Extract `DOC_ID` from the URL
4. Extract metadata:
   - Meeting title (from subject)
   - Meeting date (from email date)
   - **Doc ID** (extracted from link)
   - Message ID (for reference)
5. Add to `MEETING_NOTES_DETECTED` table with doc_id
6. Continue to next email

### Phase 5: Output (MANDATORY FORMAT)

**Template:** Read `mail-triage-template.md` from this skill folder.

**Output path:** `work/operations/daily-log/YYYY-MM-DD/mail-triage.md`

Fill the template placeholders with scan results:

| Placeholder | Value |
|-------------|-------|
| `{{DATE}}` | Today's date (YYYY-MM-DD) |
| `{{TIME}}` | Scan completion time (HH:MM) |
| `{{TOTAL_ITEMS}}` | Total emails processed |
| `{{EXECUTIVE_SUMMARY}}` | 2-3 sentences: What needs attention? |
| `{{ACTION_ITEMS_TABLE}}` | Table rows for ACTION items |
| `{{ACTION_COUNT}}` | Count of ACTION items |
| `{{FYI_ITEMS_TABLE}}` | Table rows for FYI items |
| `{{FYI_COUNT}}` | Count of FYI items |
| `{{MEETING_NOTES_TABLE}}` | Table rows for detected meeting notes (must include doc_id column) |
| `{{MEETING_NOTES_COUNT}}` | Count of meeting notes |
| `{{ARCHIVED_TABLE}}` | Table rows for archived items |
| `{{ARCHIVED_COUNT}}` | Count of archived items |
| `{{RECOMMENDATIONS}}` | Specific follow-up actions |

### Phase 6: Report to User

After persisting, return verbal summary:

```
Processed [N] emails.

**ACTION (N):** [Brief list]
**FYI (N):** [Brief list]  
**MEETING_NOTES (N):** Ready for processing
**ARCHIVED (N):** [Count]

Persisted to: work/operations/daily-log/YYYY-MM-DD/mail-triage.md
```

---

## Common Mistakes

| Mistake | Prevention |
|---------|------------|
| Reading Gemini docs during triage | MEETING_NOTES = metadata only. Flag for later. |
| Not persisting to file | Output MUST be written to `mail-triage.md`. Not optional. |
| Improvising output format | Use the exact template. Tables must have correct columns. |
| Processing meeting notes "since I'm already here" | No. Flag and move on. |
| Forgetting message IDs | Every item needs Message ID for downstream tools. |
| Stopping before inbox exhausted | Paginate until `page_token` is empty. |

---

## Red Flags - STOP

- About to call `get_drive_file_content` for a Gemini doc → STOP. That's not this skill's job.
- Not writing to file → STOP. Persistence is mandatory.
- Skipping MEETING_NOTES_DETECTED table → STOP. This enables handoff.
- Using wrong email address → STOP. Use `{EMAIL}` from Context Discovery.

---

## Verification Checklist

Before reporting complete:

- [ ] All inbox items processed (paginated to exhaustion)
- [ ] Each item classified into exactly one category
- [ ] MEETING_NOTES items have doc_id (not processed deeply)
- [ ] Output written to `work/operations/daily-log/YYYY-MM-DD/mail-triage.md`
- [ ] All tables have correct columns per template
- [ ] Verbal summary provided to user

---

## Edge Cases

### Empty Inbox
```markdown
# Mail Triage — [Date]

**Items Processed:** 0

Inbox clear. No items to process.
```

### High Volume (>50 items)
- Process in batches of 25
- Prioritize ACTION classification first
- Aggregate ARCHIVE items: "12 PIM notifications archived"

### Ambiguous Classification
- Default to FYI with note: "Review recommended"
- Never auto-archive if sender is a known stakeholder

---

*Mail Triage Skill v2.1 | Inbox exhaustion with structured output*
