#!/bin/bash
# Minimal check to ensure skills exist in the correct location and are valid

SKILLS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/skills" && pwd)"

# Ensure the writing-plans skill specifically exists
if [ ! -f "$SKILLS_DIR/writing-plans/SKILL.md" ]; then
    echo "❌ writing-plans skill missing"
    exit 1
fi

echo "✅ writing-plans skill found at $SKILLS_DIR/writing-plans/SKILL.md"

# Additional check: ensure at least one skill is there
skill_count=$(find "$SKILLS_DIR" -maxdepth 2 -name "SKILL.md" | wc -l)
if [ "$skill_count" -lt 1 ]; then
    echo "❌ No skills found in $SKILLS_DIR"
    exit 1
fi

echo "✅ Found $skill_count skill(s) in the new skills directory"
exit 0
