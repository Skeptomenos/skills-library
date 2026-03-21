---
name: path-discovery
description: Discover the filesystem context of the Knowledge Base, including KB root, operating mode (dual/single), and current hemisphere.
triggers: 
created: 2026-01-21
updated: 2026-01-21
---

<!--
ARCHITECTURE REFERENCE: docs/concepts/skill-architecture.md
This is a low-level "BIOS" skill. It is typically called by identity-discovery or by filesystem-only skills.
-->

# Path Discovery

**Core principle:** Resolve "Where am I?" by identifying the Knowledge Base root or the current functional hemisphere, prioritizing heuristic detection over rigid folder naming.

---

## Quick Reference

| Task | Method |
|------|-----|
| Find KB Context | Config -> Markers -> Heuristics -> Ask User |
| Determine mode | Root/Kernel = **dual**; Hemisphere = **single** |
| Floating Hemisphere | Directories with `AGENTS.md` + `Stakeholders/` or `projects/` |

---

## Discovery Algorithm

### Step 1: Check Explicit Config (Fastest)
Check `~/.config/opencode/thoth.json` for `{ "kb_root": "/path/to/thoth-kb" }`. 

### Step 2: Heuristic Detection (Smart)
If config is missing, check if the CWD (or any parent) has a **Hemisphere Signature**:
- **Signature:** Folder contains `AGENTS.md` AND (`Stakeholders/` OR `projects/` OR `registry.md`).
- **If found:** This folder is the functional root for this session. Set `mode: single`, `kb_root: parent_of_this_folder`, `hemisphere: folder_name`.

### Step 3: Walk Up for KB Markers (Standard)
Check parents for standard Thoth markers:
1. `.opencode/thoth.json` with `"type": "thoth-kb"`
2. `.thoth-root` marker file
3. Presence of `kernel/` folder.

### Step 4: Fallback - Ask the User (Safety)
If no markers or signatures are found:
1. Use `find` or `glob` to look for siblings named `thoth-kb` or `work`.
2. If multiple candidates exist, **stop and ask the user**: "I found multiple potential Knowledge Bases at [Path A] and [Path B]. Which one should I use?"
3. If none found, ask user for the path.

---

## Output Context Object

```json
{
  "kb_root": "/absolute/path/to/kb",
  "mode": "single|dual",
  "hemisphere": "work|life|coding|cos|...", 
  "is_floating": true|false,
  "ready": true
}
```

---

*Path Discovery v1.0 | Filesystem Navigator*
