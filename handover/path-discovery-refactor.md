# Handover: path-discovery Skill Refactor

**Created:** 2026-01-23
**Priority:** Medium
**Skill:** `skills/path-discovery/SKILL.md`

---

## Problem

The current path-discovery algorithm is too reliant on marker files (`.thoth-root`, `.opencode/thoth.json`). This causes failures when:

1. User migrates KB to a new location without copying markers
2. KB structure is valid but markers are missing
3. User explicitly states location but agent still searches for markers

## Current Algorithm (Flawed)

```
1. Check ~/.config/opencode/thoth.json for kb_root
2. Walk up from CWD looking for:
   - .opencode/thoth.json with "type": "thoth-kb"
   - .thoth-root file
   - kernel/ + work/ + life/ folders
3. Determine mode from relative path
```

**Issue:** Step 2 prioritizes marker files over content-based evidence.

## Proposed Algorithm

```
1. Check explicit config (~/.config/opencode/thoth.json) — if valid, use it
2. Content-based discovery (NEW — prioritize this):
   a. Check CWD for AGENTS.md with "hemisphere:" frontmatter
   b. Check CWD for digital-identity.md (confirms hemisphere context)
   c. Check parent for multiple hemisphere folders (work/, life/, coding/)
3. Marker-based discovery (fallback only):
   a. Walk up for .thoth-root or .opencode/thoth.json
4. User override: If user states "X is kb-root", trust it immediately
```

## Evidence-Based Detection

A valid hemisphere folder contains ANY of:
- `AGENTS.md` with `hemisphere:` in frontmatter
- `digital-identity.md` with identity config
- `_index.md` with `hemisphere:` in frontmatter
- `dashboard.md` + `registry.md` (operational structure)

A valid KB root contains:
- 2+ of: `work/`, `life/`, `coding/`, `kernel/`
- OR a single hemisphere folder when running in single-mode

## Files to Modify

1. `skills/path-discovery/SKILL.md` — Update algorithm documentation
2. Consider adding `skills/path-discovery/examples.md` with test cases

## Test Cases

| Scenario | Expected Result |
|----------|-----------------|
| CWD has `AGENTS.md` with `hemisphere: work` | Detect as work hemisphere |
| Parent has `work/` + `life/` folders | Parent is KB root, dual mode |
| No markers, but `digital-identity.md` exists | Still detect hemisphere |
| User says "parent is KB root" | Trust user, skip discovery |

## Acceptance Criteria

- [ ] path-discovery works without any marker files
- [ ] Content-based detection is primary method
- [ ] Marker files become optional fallback
- [ ] Algorithm documented with examples
