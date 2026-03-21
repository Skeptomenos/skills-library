# Migration Notes: Skills

**Old path:** `~/repos/ai-tooling/skills`
**New path:** `~/repos/ai-dev/_infra/skills/skills-library/` (public nested clone)
**GitHub:** `Skeptomenos/skills-library` (ACTIVE — public repo, still the source of truth)
**Type:** Public nested repo (wrapper + clone)

## Issues

### 1. Skill symlinks broken

All 35+ symlinks in `~/.config/opencode/skills/` point to the deleted path `~/repos/ai-tooling/skills/skills/`.

**Fix:**
```bash
cd ~/repos/ai-dev/_infra/skills/skills-library
./register_skills.sh
```

If `register_skills.sh` has issues, manually re-link:
```bash
cd ~/.config/opencode/skills
for link in */; do
  name=$(basename "$link")
  rm "$name"
  ln -s ~/repos/ai-dev/_infra/skills/skills-library/skills/"$name" "$name"
done
```

**Verify:**
```bash
ls -la ~/.config/opencode/skills/ | head -5
# Links should point to ~/repos/ai-dev/_infra/skills/skills-library/skills/
```

### 2. Wrapper vs clone distinction

- `_infra/skills/AGENTS.md` — private planning context (tracked by monorepo)
- `_infra/skills/skills-library/` — the actual public repo (gitignored)

Push code changes from inside `skills/skills-library/`:
```bash
cd ~/repos/ai-dev/_infra/skills/skills-library
git add . && git commit -m "..." && git push
```

Push private planning context via the monorepo:
```bash
cd ~/repos/ai-dev
git add _infra/skills/AGENTS.md && git commit -m "..." && git push
```
