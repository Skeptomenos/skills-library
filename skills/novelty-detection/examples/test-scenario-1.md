# Novelty Detection Test Scenario 1

**Purpose**: Demonstrate novelty detection on a simulated meeting note with content that contains duplicates, updates, and novel items.

---

## Simulated Meeting Input

**Meeting**: Meteor 2.0 Sync  
**Date**: 2026-01-28  
**Attendees**: Tom Jansson, David Helmus, Christine Hsieh

### Extracted Content (from Phase 2: Deep Extraction)

| Item | Type | Content |
|------|------|---------|
| 1 | RISK | "Training for regional engineers is not on track" |
| 2 | RISK | "Golden Ticket launch (Feb 1) may be at risk due to training" |
| 3 | DECISION | "Decision: Escalate training concern to James Brooks" |
| 4 | ACTION | "Tom to schedule training sessions this week" |
| 5 | FACT | "Golden Ticket target is Feb 1" |
| 6 | FACT | "Tom mentioned timeline is a concern" |
| 7 | ACTION | "Follow up on remote.com Workday field with HR" |

---

## Known State (from Phase 1.5)

### Entity: golden-ticket
**File**: `work/projects/golden-ticket/project-main.md`

**Known Risks/Blockers**:
- Missing GPT hierarchy data (🔴 High)

**Known Decisions**:
- 2026-01-07: Golden Ticket as interim solution until Meteor delivers
- 2026-01-07: Full Meteor automation targeted for H2 2026

**Known Facts**:
- Launch target: Feb 1, 2026
- Status: In Progress

### Entity: tom-jansson
**File**: `work/Stakeholders/tom-jansson.md`

**Recent Interaction Log**:
- 2026-01-21: "Aligned on $100k connector requirement... Tom supporting budget escalation to People Tech (James Brooks)"
- 2026-01-20: "Identified critical blocker: Workday Calculated Fields"

**Open Action Items**:
- Follow up on remote.com Workday field with HR (Due: 2026-02-03) ✓

---

## Expected Novelty Detection Results

### Item 1: "Training for regional engineers is not on track"
| Classification | **NOVEL** |
|----------------|-----------|
| Reasoning | No existing mention of "training" as a blocker in project file. Known risks are "Missing GPT hierarchy data" and "Workday Calculated Fields" — training is a new concern. |
| Action | PERSIST |
| Target | `golden-ticket/project-main.md` → `## Blockers & Risks` |
| Format | `\| Training readiness \| 🔴 High \| IT/People \| Regional engineers not trained \|` |

---

### Item 2: "Golden Ticket launch (Feb 1) may be at risk due to training"
| Classification | **UPDATE** |
|----------------|------------|
| Reasoning | Feb 1 launch date is known, but "at risk due to training" adds new severity. Status escalation from "In Progress" to "At Risk". |
| Delta | Previous: "Launch target: Feb 1, 2026" → New: "Feb 1 at risk due to training" |
| Change Type | Escalation + Detail |
| Action | MERGE (update status, add cause) |
| Target | `golden-ticket/project-main.md` → `## Status` |
| Format | Update row: `\| Overall Health \| 🔴 At Risk (training) \|` |

---

### Item 3: "Escalate training concern to James Brooks"
| Classification | **NOVEL** |
|----------------|-----------|
| Reasoning | No existing decision about escalating training to James Brooks. Previous escalation was about $100k connector, not training. |
| Action | PERSIST |
| Target | `golden-ticket/project-main.md` → `## Strategic Decisions & Agreements` |
| Format | `\| 2026-01-28 \| Escalate training concern to James Brooks \| Tom, David \| Training blocking Feb 1 launch \|` |

---

### Item 4: "Tom to schedule training sessions this week"
| Classification | **NOVEL** |
|----------------|-----------|
| Reasoning | No existing action item for Tom regarding training sessions. His current open items are about remote.com, escalation doc, Sharvil Singh, etc. — none about scheduling training. |
| Action | PERSIST |
| Target | `tom-jansson.md` → `## Action Items` |
| Format | `\| Schedule training sessions for regional engineers \| This week \| Pending \| Jan 28 Meteor Sync \|` |

---

### Item 5: "Golden Ticket target is Feb 1"
| Classification | **DUPLICATE** |
|----------------|---------------|
| Reasoning | This is already captured: "Launch target: Feb 1, 2026" in project file, and "Feb 1" appears in Timeline section. Exact match. |
| Matched Entry | "**Golden Ticket** (interim manual form) \| Feb 1, 2026" |
| Matched File | `golden-ticket/project-main.md` |
| Action | **SKIP** |

---

### Item 6: "Tom mentioned timeline is a concern"
| Classification | **DUPLICATE** |
|----------------|---------------|
| Reasoning | Already captured in tom-jansson.md interaction log: "2026-01-21: Aligned on... Tom supporting budget escalation" and "2026-01-20: Identified critical blocker". Timeline concern is established context. |
| Matched Entry | 2026-01-21 interaction log entry |
| Matched File | `tom-jansson.md` |
| Action | **SKIP** |

---

### Item 7: "Follow up on remote.com Workday field with HR"
| Classification | **DUPLICATE** |
|----------------|---------------|
| Reasoning | Exact match in tom-jansson.md Action Items: "Follow up on remote.com Workday field with HR \| 2026-02-03 \| Pending \| Jan 28 Sync" |
| Matched Entry | Existing action item row |
| Matched File | `tom-jansson.md` |
| Action | **SKIP** |

---

## Summary

| Classification | Count | Items |
|----------------|-------|-------|
| **NOVEL** | 3 | Training blocker, Escalation decision, Tom's training action |
| **UPDATE** | 1 | Launch status escalation |
| **DUPLICATE** | 3 | Feb 1 date, Timeline concern, remote.com action |

**Outcome**: Instead of persisting 7 items, we persist 4 (3 novel + 1 update). **43% reduction in redundant writes.**

---

## Synthesis Report (what user sees)

```markdown
## Meeting Processed: Meteor 2.0 Sync — 2026-01-28

### Novelty Summary
| Classification | Count | Action Taken |
|----------------|-------|--------------|
| NOVEL | 3 | Persisted as new entries |
| UPDATE | 1 | Delta extracted, status updated |
| DUPLICATE | 3 | Skipped (already known) |

### Risks Identified
| Risk | Impact | Novelty | Persisted To |
|------|--------|---------|--------------|
| Training for regional engineers not on track | Feb 1 launch at risk | NOVEL | golden-ticket/project-main.md |

### Updates Applied (Deltas)
| File | Existing Entry | Delta Applied |
|------|----------------|---------------|
| golden-ticket/project-main.md | Overall Health: 🟡 In Progress | → 🔴 At Risk (training) |

### Decisions Made
| Decision | Stakeholders | Novelty | Persisted To |
|----------|--------------|---------|--------------|
| Escalate training concern to James Brooks | Tom, David | NOVEL | golden-ticket/project-main.md |

### Action Items for You
| Task | Context | Deadline | Priority | Novelty | Persisted To |
|------|---------|----------|----------|---------|--------------|
| (None for Zeus in this meeting) | — | — | — | — | — |

### Knowledge Persisted
| File | What Was Added | Type |
|------|----------------|------|
| golden-ticket/project-main.md | Training blocker row | NOVEL |
| golden-ticket/project-main.md | Escalation decision row | NOVEL |
| golden-ticket/project-main.md | Status update (In Progress → At Risk) | UPDATE |
| tom-jansson.md | Training sessions action item | NOVEL |

### Duplicates Skipped
| Content | Matched Existing | In File |
|---------|------------------|---------|
| "Golden Ticket target is Feb 1" | Timeline section: Feb 1, 2026 | golden-ticket/project-main.md |
| "Tom mentioned timeline is a concern" | 2026-01-21 interaction log | tom-jansson.md |
| "Follow up on remote.com Workday field" | Action Items table | tom-jansson.md |
```

---

## Validation Criteria

To verify this works correctly:

1. **No information loss**: All 3 NOVEL items get persisted
2. **Accurate delta**: UPDATE correctly identifies severity change
3. **True duplicates skipped**: All 3 DUPLICATE items are semantically identical to existing
4. **Confidence thresholds**: Classifications have >0.7 confidence
5. **Audit trail**: User can see what was skipped and why
