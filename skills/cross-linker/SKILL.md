---
name: cross-linker
description: Discover and create [[wikilinks]] between knowledge base files. Uses evidence-based confidence tiers. Updates frontmatter related field. Works with knowledge-capture and gardener.
---

# Cross-Linker

**Core principle:** A link should exist if a reader of file A would benefit from knowing about file B. Don't guess—use evidence.

---

## Context Requirements (EXECUTE FIRST)

**Step 0 — Find KB Root:**

1. **Check if passed in context**: If `context.kb_root` exists, use it.
2. **If not passed**: Call `skill({ name: "path-discovery" })`.
3. **Store `KB_ROOT`** for all scans below.

**If discovery fails**: Stop and report error.

---

## When to Use

- After knowledge-capture creates/updates files
- When manually adding new content to KB
- Periodic full scan for link coverage
- User asks to "connect" or "link" files

**Do NOT use when:**
- Just browsing/reading the KB
- Files are in archive or template folders

---

## Quick Reference

| Mode | Command | Action |
| ---- | ------- | ------ |
| Single file | `/cross-linker file <path>` | Analyze one file, suggest links |
| Folder scan | `/cross-linker scan <path>` | Scan specific folder |
| Full scan | `/cross-linker scan` | Scan entire KB |
| Apply | `/cross-linker apply` | Apply approved suggestions |

---

## Confidence Tiers

**Count evidence signals, don't guess percentages.**

| Tier | Evidence Required | Action |
| ---- | ----------------- | ------ |
| **CERTAIN** | Explicit name match OR reciprocal missing | Auto-apply recommended |
| **STRONG** | 2+ signals | Suggest with review |
| **MEDIUM** | 1 signal | List for consideration |
| **WEAK** | Semantic only | Ignore |

### Evidence Signals

```
□ EXPLICIT_MENTION   File A contains exact title/name from File B
□ RECIPROCAL_MISSING File B links to A, but A doesn't link to B
□ RELATED_FRONTMATTER File A's related: mentions B (no [[link]] in body)
□ SHARED_TAGS        Files share ≥2 tags
□ SAME_FOLDER        Files in same project folder
□ PERSON_MENTION     Content mentions person name matching a person file
□ PROJECT_MENTION    Content mentions project name matching a project file
```

**Scoring:**
- EXPLICIT_MENTION or RECIPROCAL_MISSING alone → CERTAIN
- RELATED_FRONTMATTER alone → STRONG
- 2+ other signals → STRONG
- 1 signal → MEDIUM
- 0 signals → WEAK (ignore)

---

## Process

### Phase 1: Build Entity Registry

Scan all .md files and extract:

```yaml
file: "people/sarah.md"
title: "Sarah Chen"           # From H1 or filename
type: person                  # From frontmatter
tags: ["platform", "engineering"]
related: ["projects/apollo"]  # From frontmatter
existing_links: ["[[apollo]]", "[[john]]"]
summary: "Platform team lead"
```

**Skip:**
- `_templates/`, `archive/`, `tmp/`
- Files matching `*-template.md`

### Phase 2: Build Lookup Tables

```
PEOPLE: {
  "sarah chen" → "people/sarah.md",
  "sarah" → "people/sarah.md",  # If unambiguous
}

PROJECTS: {
  "apollo" → "projects/apollo.md",
  "project apollo" → "projects/apollo.md",
}
```

### Phase 3: Scan for Missing Links

For each file, check:

1. **Content mentions:** Does body contain entity names without [[links]]?
2. **Related field:** Does `related:` list files not linked in body?
3. **Reciprocal:** Do files linking TO this file have return links?
4. **Tag clusters:** Are there files with 2+ shared tags, unlinked?

### Phase 4: Score and Report

```markdown
## Cross-Link Report

**Scanned:** 2026-01-18
**Files:** 42
**Suggestions:** 15

### CERTAIN (12) - Apply recommended

| Source | Target | Evidence |
| ------ | ------ | -------- |
| meeting-jan-15.md | [[sarah]] | "Sarah Chen" on line 8 |
| projects/apollo.md | [[john]] | Reciprocal: john.md links here |

### STRONG (3) - Review recommended

| Source | Target | Evidence |
| ------ | ------ | -------- |
| hiring.md | [[recruiting]] | Shared tags: hiring, process |
```

---

## Link Application

### Inline Links

Replace entity mentions with wikilinks:

**Before:**
```markdown
Met with Sarah Chen about the Apollo timeline.
```

**After:**
```markdown
Met with [[sarah|Sarah Chen]] about the [[apollo|Apollo]] timeline.
```

### Frontmatter Related Field

After adding inline links, update `related:` in frontmatter:

```yaml
---
type: note
related:
  - people/sarah
  - projects/apollo    # ← Add new relationships
---
```

### Reciprocal Links

Ensure bidirectional linking:

1. If A links to B, check if B links to A
2. If not, add to B's "Related" or "Referenced By" section:

```markdown
## Referenced By

- [[meeting-jan-15]] - Discussed timeline concerns
```

---

## Integration

### Called by knowledge-capture

After creating/updating files:

```
knowledge-capture creates: people/sarah.md, projects/apollo.md
→ Calls cross-linker with: { files: ["people/sarah.md", "projects/apollo.md"] }
→ Cross-linker scans those files + files that mention them
→ Applies CERTAIN links automatically
→ Reports STRONG links for review
```

### Works with gardener

| Cross-Linker | Gardener |
| ------------ | -------- |
| Creates missing links | Fixes broken links |
| Proactive (opportunities) | Reactive (problems) |
| Run after adding content | Run after migrations |

---

## Common Mistakes

| Mistake | Prevention |
| ------- | ---------- |
| Linking common words | Only link entity names from registry |
| Duplicate links | Check existing_links before adding |
| Breaking sentences | Use alias syntax: `[[file\|Display Text]]` |
| Forgetting related: | Always update frontmatter after linking |
| Mass changes without approval | Batch operations require user approval |

---

## Red Flags - STOP

- Creating links without evidence signals
- Modifying content meaning (only add links)
- Linking to files in `_templates/` or `archive/`
- Applying STRONG/MEDIUM links without approval
- Not updating frontmatter `related:` field

---

## Verification Checklist

- [ ] Entity registry built from current KB state
- [ ] Evidence signals counted (not guessed)
- [ ] Inline links use alias when text differs from filename
- [ ] Frontmatter `related:` updated
- [ ] Reciprocal links added where missing
- [ ] User approved batch operations
- [ ] No broken links created (file exists check)

---

*Cross-Linker v2.0 | Evidence-Based Linking*
