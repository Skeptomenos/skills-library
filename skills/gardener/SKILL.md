---
name: gardener
description: Maintain knowledge base health. Audits indexes, fixes broken links, detects orphans, and suggests promotions when entities outgrow their containers. Works with knowledge-capture and cross-linker.
---

# Gardener

**Core principle:** A healthy knowledge base has accurate indexes, no broken links, no orphan files, and entities in appropriate containers (files vs sections).

---

## Context Requirements (EXECUTE FIRST)

**Step 0 — Find KB Root:**

1. **Check if passed in context**: If `context.kb_root` exists, use it.
2. **If not passed**: Call `skill({ name: "path-discovery" })`.
3. **Store `KB_ROOT`** for all scans below.

**If discovery fails**: Stop and report error.

---

## When to Use

- Periodic KB maintenance (weekly)
- After bulk file operations or migrations
- When knowledge-capture suggests "run gardener"
- User asks to "check KB health" or "clean up"

**Do NOT use when:**
- Actively adding new content (use knowledge-capture)
- Looking for missing links (use cross-linker)

---

## Quick Reference

| Mode | Command | Action |
| ---- | ------- | ------ |
| Health check | `/gardener` or `/gardener check` | Scan and report |
| Index audit | `/gardener indexes` | Verify all `_index.md` files |
| Fix issues | `/gardener fix` | Apply repairs with approval |
| Promotions | `/gardener promotions` | Suggest entity promotions |

---

## Operating Modes

### Mode 1: Health Check

Full KB scan with severity-based reporting.

#### Checks Performed

| Check | Severity | Description |
| ----- | -------- | ----------- |
| Broken links | ERROR | `[[link]]` points to non-existent file |
| Missing index | WARNING | Folder has .md files but no `_index.md` |
| Stale index | WARNING | `_index.md` missing files that exist |
| Ghost entries | ERROR | `_index.md` lists files that don't exist |
| Orphan files | WARNING | File not linked from anywhere |
| Missing frontmatter | WARNING | File lacks required frontmatter fields |
| Stale files | INFO | Not updated in >90 days |

#### Report Format

```markdown
## KB Health Report

**Scanned:** 2026-01-18
**Files:** 142
**Health:** 🟡 NEEDS ATTENTION

### By Severity

| Severity | Count |
| -------- | ----- |
| ERROR | 3 |
| WARNING | 12 |
| INFO | 8 |

### Errors (Fix Soon)

| File | Issue |
| ---- | ----- |
| projects/apollo.md | Broken link: [[john-smith]] (file not found) |
| people/_index.md | Ghost entry: [[removed-person.md]] |

### Warnings (Fix When Convenient)

| File | Issue |
| ---- | ----- |
| decisions/ | Missing _index.md |
| people/sarah.md | Orphan: no incoming links |

### Recommendations

1. Run `/gardener fix` to repair 3 errors
2. Create missing indexes with `/gardener indexes`
3. Review 2 promotion candidates with `/gardener promotions`
```

---

### Mode 2: Index Audit

Verify every folder has accurate `_index.md`.

#### Process

1. **Find all folders** with .md files
2. **Check for `_index.md`** in each folder
3. **Compare contents:**
   - Files in folder but not in index → Add
   - Entries in index but file missing → Remove (ghost)
   - Summaries outdated → Update from frontmatter

#### Report Format

```markdown
## Index Audit

### Missing Indexes

| Folder | Files | Action |
| ------ | ----- | ------ |
| decisions/ | 5 | Create _index.md |
| projects/apollo/ | 3 | Create _index.md |

### Outdated Indexes

| Index | Issue |
| ----- | ----- |
| people/_index.md | Missing: sarah.md, john.md |
| projects/_index.md | Ghost: old-project.md |

**Fix all index issues?** [Awaiting approval]
```

#### Index Template

When creating missing `_index.md`:

```markdown
---
type: index
updated: {{DATE}}
---

# {{FOLDER_NAME}}

{{INFERRED_PURPOSE}}

## Contents

| File | Summary |
| ---- | ------- |
{{FOR_EACH_FILE}}
| [[{{filename}}]] | {{summary_from_frontmatter}} |
{{END_FOR}}
```

---

### Mode 3: Promotion Suggestions

Detect entities that have outgrown their container.

#### Promotion Triggers

| Trigger | From | To |
| ------- | ---- | -- |
| Section >200 words | Section in stakeholders.md | Own file in people/ |
| Mentioned 5+ times | Inline mention | Own file |
| Subfolder >10 files | Flat folder | Nested subfolders |
| Single topic >500 words | Section in file | Own subfile |

#### Process

1. **Scan for oversized sections:**
   - Find files with H2/H3 sections >200 words
   - Check if section topic could be its own file

2. **Count entity mentions:**
   - Track how often names/topics appear across KB
   - Flag if mentioned 5+ times without own file

3. **Check folder sizes:**
   - Folders with >10 files may need subfolders

#### Report Format

```markdown
## Promotion Candidates

### Sections → Files

| Source | Section | Words | Suggested |
| ------ | ------- | ----- | --------- |
| stakeholders.md | ## Sarah Chen | 245 | people/sarah.md |
| projects/apollo.md | ## Authentication | 380 | projects/apollo/authentication.md |

### Frequent Mentions → Files

| Entity | Mentions | Locations | Suggested |
| ------ | -------- | --------- | --------- |
| "Platform team" | 8 | 5 files | teams/platform.md |

### Oversized Folders

| Folder | Files | Suggestion |
| ------ | ----- | ---------- |
| people/ | 24 | Split by team or relationship type |

**Apply promotions?** (Select by number or 'all')
```

#### Promotion Execution

When user approves a promotion:

1. **Extract content** from source section
2. **Create new file** using appropriate template
3. **Replace section** with link: `See [[people/sarah]]`
4. **Update all mentions** across KB to use new path
5. **Update indexes** in affected folders
6. **Trigger cross-linker** on new file

---

### Mode 4: Fix Issues

Apply repairs for detected issues.

#### Auto-Fixable Issues

| Issue | Fix |
| ----- | --- |
| Missing index | Create from folder contents |
| Stale index | Sync with actual files |
| Ghost entries | Remove from index |
| Missing frontmatter | Add minimal frontmatter |

#### Requires Manual Review

| Issue | Why |
| ----- | --- |
| Broken links | May need redirect or deletion |
| Orphan files | May need linking or archiving |
| Promotions | Content decisions needed |

#### Approval Flow

```
Gardener: "Found 8 fixable issues. Apply?"
User: "show me"
Gardener: [Lists all fixes with before/after]
User: "fix 1,2,3,5, skip rest"
Gardener: [Applies selected fixes]
```

---

## Integration

### Pipeline Position

```
knowledge-capture → cross-linker → gardener
     (create)         (connect)     (maintain)
```

### Called After

- Bulk imports or migrations
- Manual file reorganization
- Periodic maintenance (weekly cron)

### Triggers

- Knowledge-capture: "Run gardener to check index"
- Cross-linker: "Gardener should verify these new links"

---

## Common Mistakes

| Mistake | Prevention |
| ------- | ---------- |
| Promoting too early | Wait for 200+ words or 5+ mentions |
| Deleting orphans | Orphans may be new; check created date |
| Over-nesting folders | Max 2 levels: `people/sarah.md` not `work/team/eng/sarah.md` |
| Ignoring stale files | Stale ≠ delete; may need archive |
| Fixing without approval | Always show changes before applying |

---

## Red Flags - STOP

- About to delete files (gardener repairs, doesn't delete)
- Promoting content user didn't create
- Creating deeply nested folder structures
- Modifying files outside the KB
- Applying fixes without user seeing them first

---

## Verification Checklist

- [ ] All folders have `_index.md`
- [ ] All index entries point to existing files
- [ ] No broken `[[wikilinks]]`
- [ ] Promotion candidates reviewed (not auto-applied)
- [ ] User approved all write operations
- [ ] Cross-linker notified of new files

---

## Severity Reference

| Severity | Symbol | Meaning | Action |
| -------- | ------ | ------- | ------ |
| ERROR | 🔴 | Navigation broken | Fix immediately |
| WARNING | 🟡 | Maintenance debt | Fix when convenient |
| INFO | 🔵 | Suggestions | Optional |

---

*Gardener v5.0 | Knowledge Base Health & Organic Growth*
