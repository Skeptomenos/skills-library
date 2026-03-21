---
name: librarian
description: Knowledge maintenance skill for compacting, archiving, and organizing the knowledge base. Preserves wisdom while reducing noise.
triggers:
  - "compact:"
  - "archive:"
  - "clean up"
  - "organize knowledge"
created: 2026-02-01
updated: 2026-02-01
---

# Librarian Skill

**Core Principle:** A healthy knowledge base requires pruning. Compact facts into patterns, move logs to archives, but never destroy wisdom.

---

## When to Use

- User asks to "compact", "clean up", or "archive" an entity (Project, Person).
- File size exceeds ~50KB or ~1000 lines (context bloat).
- Interaction Log covers > 3 months of detailed notes.

---

## Capabilities

### 1. Compaction (`/compact [entity]`)

**Goal:** Transform detailed logs into high-level history and patterns.

**Algorithm:**
1.  **Read Target File**: `read work/Stakeholders/tom-jansson.md`
2.  **Parse Sections**:
    *   `## Interaction Log`
    *   `## Progress Log`
    *   `## Notes`
3.  **Identify Old Entries**:
    *   Filter entries older than 30 days.
4.  **Synthesize Wisdom**:
    *   **Extract Themes:** "Discussions focused on training delays."
    *   **Identify Patterns:** "Tom consistently flags risks 2 weeks early."
    *   **Summarize:** Create a narrative paragraph for the period.
5.  **Restructure File**:
    *   Update `## Context` with new summary.
    *   Update `## Inferences` with confirmed patterns.
    *   Append summary to `## History`.
    *   **Clear** the old raw entries from the logs (keep last 30 days).
6.  **Archive (Optional)**:
    *   If raw logs are valuable, move them to `_archive/{entity}/{entity}-{date}.md`.

### 2. Archiving (`/archive [project]`)

**Goal:** Move a completed/cancelled project to the archive.

**Algorithm:**
1.  **Move File**: `mv work/projects/alpha.md work/_archive/projects/alpha.md`
2.  **Update Index**:
    *   Remove from `work/projects/_index.md`
    *   Add to `work/_archive/projects/_index.md`
3.  **Update Status**: Set frontmatter `status: archived`.

---

## Common Patterns

### Compaction Example

**Before:**
```markdown
## Interaction Log
- 2025-11-01: Met to discuss training. Tom worried.
- 2025-11-08: Training still blocking.
- 2025-11-15: Escalated training risk.
```

**After:**
```markdown
## History
- **Nov 2025:** The month was dominated by training risks, which Tom flagged early (Nov 1) and escalated by mid-month.

## Inferences
- **Pattern:** Tom forecasts resource gaps 2 weeks ahead of crisis.

## Interaction Log
(Empty / Recent entries only)
```

---

## Verification

- [ ] **No Data Loss**: Did we summarize before deleting?
- [ ] **Pattern Extraction**: Did we capture *why* things happened?
- [ ] **Link Integrity**: Did archiving break any wikilinks? (Gardener check)
