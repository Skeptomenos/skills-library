---
name: move-session
description: |
  Migrate OpenCode sessions from one project directory path to another in the OpenCode SQLite
  database. Use when a project folder has been moved or renamed (e.g. workspace/ → domain/),
  and you want past sessions to appear under the new path in the session picker. Always backs
  up the database before writing. Does NOT create projects, rename files, or move Git branches
  (load github-workflow or move-project for those).
license: MIT
compatibility: opencode
created: 2026-06-11
updated: 2026-06-11
---

# move-session — Migrate OpenCode Sessions to a New Path

## When to use

- A project directory was moved or renamed and existing sessions no longer appear in the session picker
- You completed a `move-project` or `workspace/ → domain/` migration and want the session history to follow

## Database location

OpenCode stores all sessions in a single SQLite file:

```
~/.local/share/opencode/opencode.db
```

Sessions are associated with a project via the `session.directory` column (absolute path to the CWD when the session was created).

## Workflow

### 1. Identify source and target paths

Find all distinct `directory` values that need rewriting:

```bash
sqlite3 ~/.local/share/opencode/opencode.db \
  "SELECT DISTINCT directory FROM session WHERE directory LIKE '%<old-fragment>%';"
```

Confirm the count of rows to be updated:

```bash
sqlite3 ~/.local/share/opencode/opencode.db \
  "SELECT COUNT(*) FROM session WHERE directory LIKE '%<old-fragment>%';"
```

### 2. Back up the database

**Always do this first.** The database is 2–5 GB; the backup takes ~30 s.

```bash
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
cp ~/.local/share/opencode/opencode.db \
   ~/.local/share/opencode/opencode.db.bak.${TIMESTAMP}
echo "Backup: opencode.db.bak.${TIMESTAMP}"
```

### 3. Run the UPDATE

Use `REPLACE()` for a precise substring swap — this preserves any sub-paths (e.g. `project/ramsay`):

```bash
sqlite3 ~/.local/share/opencode/opencode.db "
UPDATE session
SET directory = REPLACE(
    directory,
    '<absolute-old-path>',
    '<absolute-new-path>'
)
WHERE directory LIKE '%<old-fragment>%';
"
```

### 4. Verify

```bash
# Old path should be 0
sqlite3 ~/.local/share/opencode/opencode.db \
  "SELECT COUNT(*) FROM session WHERE directory LIKE '%<old-fragment>%';"

# New path should match the pre-update count
sqlite3 ~/.local/share/opencode/opencode.db \
  "SELECT COUNT(*) FROM session WHERE directory LIKE '%<new-fragment>%';"

# Spot-check 5 rows
sqlite3 ~/.local/share/opencode/opencode.db \
  "SELECT id, title, directory FROM session
   WHERE directory LIKE '%<new-fragment>%'
   ORDER BY time_created DESC LIMIT 5;"
```

### 5. Reload OpenCode

Restart OpenCode (or switch projects and back) so it re-reads the updated paths from the database.

## Revert

```bash
cp ~/.local/share/opencode/opencode.db.bak.<TIMESTAMP> \
   ~/.local/share/opencode/opencode.db
```

## Example — workspace/ → domain/ migration

```bash
# Back up
cp ~/.local/share/opencode/opencode.db \
   ~/.local/share/opencode/opencode.db.bak.$(date +%Y%m%d_%H%M%S)

# Rewrite
sqlite3 ~/.local/share/opencode/opencode.db "
UPDATE session
SET directory = REPLACE(
    directory,
    '/Users/me/repos/repo/workspace/infrastructure/my-project',
    '/Users/me/repos/repo/domain/it-services/infrastructure/my-project'
)
WHERE directory LIKE '%workspace/infrastructure/my-project%';
"

# Verify
sqlite3 ~/.local/share/opencode/opencode.db \
  "SELECT COUNT(*) FROM session WHERE directory LIKE '%workspace/infrastructure/my-project%';"
# → 0

sqlite3 ~/.local/share/opencode/opencode.db \
  "SELECT COUNT(*) FROM session WHERE directory LIKE '%domain/it-services/infrastructure/my-project%';"
# → <expected count>
```

## Notes

- The `project` table (which maps a project `id` to its `worktree`) does not need updating for same-repo moves — the `worktree` is the repo root, not the subdirectory.
- If the target project has never been opened in OpenCode, a new `project` row will be created automatically on first open — no manual INSERT needed.
- The `-shm` and `-wal` files alongside the `.db` are SQLite journal files; they are safe to ignore during a closed-database backup but copy them too if OpenCode is running.
