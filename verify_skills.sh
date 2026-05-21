#!/usr/bin/env bash
set -euo pipefail

SKILLS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/skills" && pwd)"

python3 - "$SKILLS_DIR" <<'PY'
import os
import re
import sys
from pathlib import Path

try:
    import yaml
except ImportError:
    print("PyYAML is required for skill verification. Install with: python3 -m pip install PyYAML")
    sys.exit(1)

skills_dir = Path(sys.argv[1])
issues = []
skill_count = 0

for skill_path in sorted(path for path in skills_dir.iterdir() if path.is_dir()):
    skill_name = skill_path.name
    if skill_name.startswith("_"):
        continue

    skill_count += 1
    entries = set(os.listdir(skill_path))
    if "skill.md" in entries:
        issues.append((skill_name, "lowercase skill.md exists; main file must be SKILL.md"))

    if "SKILL.md" not in entries:
        issues.append((skill_name, "missing SKILL.md"))
        continue

    text = (skill_path / "SKILL.md").read_text()
    if not text.startswith("---\n"):
        issues.append((skill_name, "missing opening YAML frontmatter delimiter"))
        continue

    try:
        _, frontmatter, _body = text.split("---", 2)
    except ValueError:
        issues.append((skill_name, "missing closing YAML frontmatter delimiter"))
        continue

    try:
        data = yaml.safe_load(frontmatter) or {}
    except Exception as exc:
        issues.append((skill_name, f"invalid YAML frontmatter: {exc}"))
        continue

    actual_name = data.get("name")
    description = data.get("description")

    if actual_name != skill_name:
        issues.append((skill_name, f"name frontmatter must be {skill_name!r}, got {actual_name!r}"))

    if not isinstance(description, str) or not description.strip():
        issues.append((skill_name, "description frontmatter must be a non-empty string"))
    elif len(description) > 1024:
        issues.append((skill_name, f"description is {len(description)} chars; maximum is 1024"))

    if not re.fullmatch(r"[a-z0-9]+(?:-[a-z0-9]+)*", skill_name):
        issues.append((skill_name, "directory name must be lowercase alphanumeric with single hyphen separators"))

if skill_count == 0:
    print(f"No skills found in {skills_dir}")
    sys.exit(1)

if issues:
    for skill_name, issue in issues:
        print(f"{skill_name}: {issue}")
    print(f"Found {len(issues)} skill issue(s).")
    sys.exit(1)

print(f"Found {skill_count} valid skill(s) in {skills_dir}")
PY
