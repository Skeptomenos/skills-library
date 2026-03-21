---
name: novelty-detection
description: Reusable novelty detection module. Compares new content against known state to classify as DUPLICATE, UPDATE, or NOVEL. Extracts deltas for updates. Used by post-meeting-drill, mail-triage, slack-pulse.
version: 1.0
created: 2026-01-28
updated: 2026-01-28
---

# Novelty Detection Skill

**Core principle:** Never persist redundant information. Compare before writing.

This skill is a **reusable module** called by other skills (post-meeting-drill, mail-triage, slack-pulse) to determine if incoming information is:
- **DUPLICATE**: Already known (skip persistence)
- **UPDATE**: Modifies existing knowledge (extract delta, then persist)
- **NOVEL**: Completely new (persist as-is)

---

## Input Requirements

This skill expects to be called with:

```yaml
context:
  new_content: "The extracted content to evaluate"
  content_type: "DECISION | ACTION | RISK | FACT | SENTIMENT"
  entity: "Related entity (person, project, topic)"
  source: "Where this came from (meeting title, email, slack)"
  source_date: "YYYY-MM-DD"
  known_state:
    file_path: "Path to entity file"
    summary: "Structured summary of current knowledge"
    recent_entries: ["Last 5 log entries"]
    open_items: ["Open action items"]
    known_facts: ["Key facts about entity"]
```

---

## Phase 1: Semantic Comparison

### Step 1.1: Compare Against Known Facts

For each piece of new content, check against `known_state.known_facts`:

```
For each known_fact:
  - Calculate semantic similarity
  - If >85% similar: Mark as potential DUPLICATE
  - If 50-85% similar: Mark as potential UPDATE
  - If <50% similar: Continue checking
  
If no matches found: Mark as NOVEL
```

### Step 1.2: Compare Against Recent Entries

Check against `known_state.recent_entries`:

```
For each recent_entry:
  - Does new content restate the same information?
  - Does new content add detail to this entry?
  - Does new content change status/severity?
```

### Step 1.3: Compare Against Open Items

For ACTION items, check against `known_state.open_items`:

```
For each open_item:
  - Is the new action semantically the same task?
  - Same owner? Same deadline?
  - If match: DUPLICATE (task already captured)
```

---

## Phase 2: Classification

### Classification Prompt Template

```markdown
## Novelty Assessment

### New Content
- **Content**: {new_content}
- **Type**: {content_type}
- **Entity**: {entity}
- **Source**: {source} ({source_date})

### Known State for {entity}
**File**: {file_path}
**Summary**: {summary}

**Recent Activity**:
{recent_entries as bullet list}

**Open Items**:
{open_items as bullet list}

**Known Facts**:
{known_facts as bullet list}

---

### Classification Task

Compare the New Content against the Known State and classify:

#### DUPLICATE (Skip persistence)
Criteria:
- The meaning is already captured in Known State
- Same fact restated in different words
- Same action item with same owner

Examples:
- "Tom raised timeline concerns" ≈ "Tom mentioned timeline is a concern"
- "Need to contact regional leads" ≈ "Reach out to regional IT teams"

#### UPDATE (Extract delta, then persist)
Criteria:
- Related content exists but new detail is added
- Status changed (In Progress → At Risk)
- Severity escalated (concern → blocker)
- Deadline changed
- Owner changed
- New specificity (general → specific cause)

Examples:
- "Timeline concern" → "At risk due to training" (added specificity)
- "Feb 1 launch" → "Feb 1 launch at risk" (severity change)

#### NOVEL (Persist as-is)
Criteria:
- No related content in Known State
- Completely new fact, decision, or action
- New entity not previously mentioned

---

### Output Required

```yaml
classification: DUPLICATE | UPDATE | NOVEL
confidence: 0.0-1.0
reasoning: "Explanation for classification"

# If DUPLICATE:
matched_entry: "The existing entry this duplicates"
matched_file: "File containing the duplicate"

# If UPDATE:
delta:
  previous_state: "What was known before"
  new_state: "What is now known"
  change_type: "escalation | detail | status | deadline | owner"
  severity_change: "none | increased | decreased"
related_entry: "The existing entry being updated"
related_file: "File containing the entry"

# If NOVEL:
recommended_destination: "Suggested file path"
recommended_section: "Suggested section name"
```
```

---

## Phase 3: Delta Extraction (for UPDATEs)

When classification is UPDATE, extract precise delta:

### Step 3.1: Identify What Changed

| Change Type | Detection Pattern | Example |
|-------------|-------------------|---------|
| **Escalation** | Severity words: "at risk", "blocker", "critical", "urgent" | concern → blocker |
| **Detail** | New specific cause, name, or number | "issue" → "training not scheduled" |
| **Status** | State transition words | "in progress" → "completed" |
| **Deadline** | Date changed | "end of month" → "Jan 30" |
| **Owner** | Different person assigned | "Tom" → "Christine" |

### Step 3.2: Format Delta for Persistence

```yaml
delta_for_persistence:
  original_text: "Tom mentioned timeline concerns"
  update_text: "Training identified as specific blocker (escalated 2026-01-28)"
  annotation: "[Updated 2026-01-28: Escalated from general concern to specific blocker - training not scheduled]"
```

---

## Phase 4: Output

Return structured result to calling skill:

```yaml
novelty_result:
  content: "{original new_content}"
  classification: "DUPLICATE | UPDATE | NOVEL"
  confidence: 0.85
  reasoning: "Explanation"
  
  # For DUPLICATE:
  action: "SKIP"
  matched_entry: "Existing entry text"
  matched_file: "File path"
  
  # For UPDATE:
  action: "MERGE"
  delta:
    previous: "Was known"
    new: "Now known"
    change_type: "escalation"
  target_file: "File to update"
  target_section: "Section name"
  merge_strategy: "ANNOTATE | APPEND | REPLACE"
  formatted_update: "Text to add/update"
  
  # For NOVEL:
  action: "PERSIST"
  target_file: "Recommended file"
  target_section: "Recommended section"
  formatted_content: "Text to persist with attribution"
```

---

## Golden Rules

1. **Conservative Classification**: When in doubt, classify as NOVEL (prevent info loss)
2. **Semantic, Not Lexical**: Match meaning, not exact words
3. **Recency Bias**: If similar content was logged recently (within 7 days), more likely DUPLICATE
4. **Escalation Always Updates**: Any severity increase is always an UPDATE, never DUPLICATE
5. **New Specificity = UPDATE**: Adding detail to vague content is UPDATE
6. **Cross-Entity = NOVEL**: Same fact about different entity is NOVEL

---

## Usage Example

Called from post-meeting-drill:

```
# After extraction, for each item:
skill({
  name: "novelty-detection",
  context: {
    new_content: "Training for regional engineers is not on track",
    content_type: "RISK",
    entity: "golden-ticket",
    source: "Meteor 2.0 Sync",
    source_date: "2026-01-28",
    known_state: {
      file_path: "work/projects/golden-ticket/project-main.md",
      summary: "Golden Ticket project, Feb 1 launch, interim solution for Meteor",
      recent_entries: [
        "2026-01-21: Timeline concern discussed with Tom",
        "2026-01-07: Decided to use Golden Ticket as interim"
      ],
      open_items: [],
      known_facts: [
        "Launch: Feb 1, 2026",
        "Missing GPT hierarchy data (blocker)",
        "Tom coordinating stakeholder comms"
      ]
    }
  }
})

# Returns:
{
  classification: "UPDATE",
  confidence: 0.88,
  reasoning: "Timeline concern was known, but 'training' as specific cause is new",
  delta: {
    previous: "Timeline concern (general)",
    new: "Training not on track (specific blocker)",
    change_type: "detail + escalation"
  },
  target_file: "work/projects/golden-ticket/project-main.md",
  target_section: "## Blockers & Risks",
  merge_strategy: "APPEND",
  formatted_update: "| Training readiness | 🔴 High | IT/People | Feb 1 launch at risk (2026-01-28) |"
}
```

---

## Integration Points

| Calling Skill | When Called | Purpose |
|---------------|-------------|---------|
| post-meeting-drill | Phase 2.5 | Classify each extracted item |
| mail-triage | Before persistence | Check if email content is new |
| slack-pulse | Before persistence | Check if slack message adds value |
| knowledge-capture | Before persistence | Validate manual capture |

---

## Metrics

Track these for quality monitoring:

| Metric | Target | Purpose |
|--------|--------|---------|
| Duplicate Detection Rate | >80% | Measure redundancy prevented |
| False Positive Rate | <5% | Ensure not losing novel info |
| Delta Accuracy | >90% | Verify deltas correctly extracted |
| Classification Confidence | >0.7 avg | Monitor model certainty |
