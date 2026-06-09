#!/usr/bin/env python3
import os
import re

import yaml

REPO_ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
SKILLS_DIR = os.path.join(REPO_ROOT, "skills")
README_PATH = os.path.join(REPO_ROOT, "README.md")

MARKER_START = "<!-- SKILLS_LIST_START -->"
MARKER_END = "<!-- SKILLS_LIST_END -->"


def parse_skill(skill_dir):
    skill_file = os.path.join(SKILLS_DIR, skill_dir, "SKILL.md")
    if not os.path.exists(skill_file):
        return None

    with open(skill_file, "r") as f:
        content = f.read()

    match = re.search(r"^---\n(.*?)\n---", content, re.DOTALL)
    if not match:
        return None

    frontmatter = match.group(1)
    try:
        data = yaml.safe_load(frontmatter) or {}
    except Exception:
        return None

    name = data.get("name")
    desc = data.get("description") or "No description provided."
    if not name:
        return None

    if not isinstance(desc, str):
        desc = "Detailed description (see skill file)"
    desc = re.sub(r"\s+", " ", desc).strip()

    return {"name": name, "description": desc, "path": f"skills/{skill_dir}/SKILL.md"}


def generate_table(skills):
    lines = ["| Skill | Description |", "|-------|-------------|"]
    for skill in sorted(skills, key=lambda x: x["name"]):
        link = f"[`{skill['name']}`]({skill['path']})"
        desc = skill["description"].replace("|", "\\|")
        lines.append(f"| {link} | {desc} |")
    return "\n".join(lines)


def update_readme():
    if not os.path.exists(README_PATH):
        print(f"Error: README.md not found at {README_PATH}")
        return

    with open(README_PATH, "r") as f:
        content = f.read()

    if MARKER_START not in content or MARKER_END not in content:
        print("Error: Markers not found in README.md")
        return

    skills = []
    if os.path.exists(SKILLS_DIR):
        for root, dirs, files in os.walk(SKILLS_DIR):
            dirs[:] = [
                d for d in dirs if not d.startswith(".") and not d.startswith("_")
            ]
            if "SKILL.md" not in files:
                continue
            skill_dir = os.path.relpath(root, SKILLS_DIR)
            if skill_dir == ".":
                continue
            skill_data = parse_skill(skill_dir)
            if skill_data:
                skills.append(skill_data)

    table = generate_table(skills)

    pattern = re.compile(
        f"{re.escape(MARKER_START)}.*?{re.escape(MARKER_END)}", re.DOTALL
    )
    new_content = pattern.sub(f"{MARKER_START}\n{table}\n{MARKER_END}", content)

    with open(README_PATH, "w") as f:
        f.write(new_content)

    print(f"✅ Updated README.md with {len(skills)} skills.")


if __name__ == "__main__":
    update_readme()
