---
name: knowledge-capture
description: Extract entities from conversation (people, projects, decisions, topics) and organize them into knowledge base files. Creates files using templates, maintains folder indexes, and triggers cross-linking.
triggers:
  - "dump:"
  - "capture:"
  - "quick thought"
  - "route this"
---

# Knowledge Capture

**Core principle:** When the user shares information about people, projects, or decisions, extract entities and persist them as structured files in the knowledge base.

---

## When to Use

- User mentions people, projects, or organizations
- User shares meeting notes or conversation summaries
- User makes or discusses decisions
- User describes tasks or action items
- User shares knowledge about tools, processes, or concepts
- User says "dump: [thought]", "capture: [idea]", or "quick thought"

**Do NOT use when:**
- User is asking questions (not providing information)
- User is working on code (use normal coding workflow)
- Information is transient/not worth persisting

---

## Quick Reference

| Entity Type | Location | Template |
| ----------- | -------- | -------- |
| Person | `people/{name}.md` | `_templates/person.md` |
| Project | `projects/{name}.md` | `_templates/project.md` |
| Decision | `decisions/{date}-{topic}.md` | `_templates/decision.md` |
| Task | `tasks/{name}.md` | `_templates/task.md` |
| Knowledge | `knowledge/{topic}.md` | `_templates/knowledge.md` |
| Index | `{folder}/_index.md` | `_templates/index.md` |

---

## Operating Modes

### Mode 1: Standard Capture (Default)

Deep extraction from structured conversation or meeting notes.

**Process:**
1. Parse user input for entities (people, projects, decisions)
2. Check if files exist vs need creation
3. Create/update files using templates
4. Update indexes and trigger cross-linker

### Mode 2: Quick Capture (Triggered by "dump:", "capture:")

Fast routing of unstructured thoughts.

**Process:**
1. **Decompose**: Break input into atomic items.
   - "Remind Sarah about Apollo and schedule dentist."
   - → Item 1: "Remind Sarah about Apollo"
   - → Item 2: "Schedule dentist"

2. **Route**: Find the best home for each item.
   - Search for entity names (grep "Sarah", "Apollo")
   - If found → Append to that file's "Notes" or "Tasks" section
   - If not found → Append to `inbox/dump.md` (or create it)

3. **Smart Merge**:
   - Always append with timestamp: `> YYYY-MM-DD: [Thought]`
   - Never overwrite existing content

---

## Process (Standard Mode)

### Phase 1: Entity Extraction

Parse user input for entities:

```
Input: "I met with Sarah from Platform team about Apollo. She's worried about the Q2 timeline."

Entities:
- Person: Sarah (Platform team)
- Project: Apollo
- Topic: Q2 timeline concern
- Event: Meeting (implicit)
```

**Entity Detection Signals:**

| Signal | Entity Type |
| ------ | ----------- |
| Names (proper nouns) | Person |
| "project", "initiative", "working on" | Project |
| "decided", "agreed", "chose" | Decision |
| "need to", "should", "action item" | Task |
| "how to", "process for", "the way we" | Knowledge |

### Phase 2: File Resolution

For each entity, determine if file exists:

```
1. Check: people/sarah.md exists?
   - Yes → Update existing file
   - No → Check if mentioned elsewhere (stakeholders section, inline)
   
2. If new entity:
   - Is it significant enough for own file?
   - Or should it be a section in another file?
```

**Significance Thresholds:**

| Entity | Gets Own File When... | Otherwise... |
| ------ | --------------------- | ------------ |
| Person | Named + role/context known | Add to project stakeholders section |
| Project | Has objective + stakeholders | Add to notes/daily log |
| Decision | Explicit decision made | Add to project decisions section |
| Task | Has clear deliverable | Add to project action items |

### Phase 3: File Creation/Update

**Creating New File:**

1. Read template from `_templates/{type}.md`
2. Fill placeholders with extracted information
3. Set frontmatter:
   - `type`: Entity type
   - `created`: Today's date
   - `updated`: Today's date
   - `summary`: One-line description
   - `related`: Empty array (cross-linker will populate)
4. Write file to appropriate location

**Updating Existing File:**

1. Read existing file
2. Update `updated:` date in frontmatter
3. Add new information to appropriate section:
   - People: Add to "Notes" or "Active Initiatives"
   - Projects: Add to "Progress Log" with timestamp
   - Decisions: Usually don't update (create new decision instead)
4. Write file

### Phase 4: Index Maintenance

After creating/updating files, update `_index.md` in affected folders:

```markdown
## Contents

| File | Summary |
| ---- | ------- |
| [[sarah.md]] | Platform team, Apollo project |  ← ADD NEW ROW
| [[john.md]] | Engineering lead |
```

**Index Rules:**
- Every folder with .md files must have `_index.md`
- Index lists all files with one-line summaries
- Summaries come from file's `summary:` frontmatter
- Alphabetical order within each section

### Phase 5: Trigger Cross-Linker

After files are created/updated, invoke cross-linker:

```
skill({ name: "cross-linker", context: { files: ["people/sarah.md", "projects/apollo.md"] } })
```

---

## Organic Growth Pattern

**Stage 1: Inline Mention**
```
User mentions "Sarah" in passing
→ Add to project stakeholders table: "| Sarah | Platform | Timeline concerns |"
```

**Stage 2: Repeated Mention**
```
Sarah mentioned 3+ times across files
→ Gardener suggests: "Promote Sarah to people/sarah.md?"
```

**Stage 3: Dedicated File**
```
User has focused conversation about Sarah
→ Create people/sarah.md immediately (significant enough)
```

**Stage 4: File Expansion**
```
Sarah's file grows, mentions "authentication" 10 times
→ Gardener suggests: "Create people/sarah/authentication-expertise.md?"
```

---

## Frontmatter Schema

All files must have this frontmatter structure:

```yaml
---
type: person|project|decision|task|knowledge|index
created: YYYY-MM-DD
updated: YYYY-MM-DD
tags: []
summary: "One-line description for index"
related: []
---
```

**Additional fields by type:**

| Type | Extra Fields |
| ---- | ------------ |
| project | `status: active\|on-hold\|completed\|cancelled` |
| task | `status: pending\|in-progress\|done`, `priority: P0\|P1\|P2`, `due: YYYY-MM-DD` |
| decision | `status: active\|superseded\|deprecated` |
| knowledge | `category: process\|tool\|concept\|reference` |

---

## Common Mistakes

| Mistake | Prevention |
| ------- | ---------- |
| Creating file for every mention | Use significance thresholds; start inline |
| Forgetting to update index | Always update `_index.md` after file changes |
| Leaving placeholder text | Replace ALL `{{PLACEHOLDER}}` values |
| Not setting frontmatter | Every file needs complete frontmatter |
| Duplicate files | Search for existing files before creating |

---

## Red Flags - STOP

- Creating files without user providing substantive information
- Overwriting existing content instead of appending
- Creating deeply nested folders (max 2 levels: `people/sarah.md` not `work/team/engineering/sarah.md`)
- Leaving `{{PLACEHOLDER}}` text in final files
- Not triggering cross-linker after file creation

---

## Verification Checklist

- [ ] Entities correctly identified from user input
- [ ] Existing files checked before creating new ones
- [ ] Template used with all placeholders filled
- [ ] Frontmatter complete with type, created, updated, summary
- [ ] `_index.md` updated in affected folders
- [ ] Cross-linker triggered on new/updated files
- [ ] User informed of what was created/updated

---

## Integration

**Works with:**
- **cross-linker**: Called after file creation to add [[wikilinks]]
- **gardener**: Monitors for promotion opportunities and index accuracy

**Triggered by:**
- User sharing information conversationally
- Post-meeting notes processing
- Email/message triage extracting action items
- "dump:" or "capture:" commands

---

*Knowledge Capture v2.0 | Organic Knowledge Growth + Quick Capture*
