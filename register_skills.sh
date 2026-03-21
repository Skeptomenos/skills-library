#!/bin/bash

TARGET_DIR="${HOME}/.config/opencode/skills"
SOURCE_DIR="$(pwd)/skills"

echo "🔌 Registering skills from ${SOURCE_DIR} to ${TARGET_DIR}..."

mkdir -p "$TARGET_DIR"

for skill_path in "${SOURCE_DIR}"/*; do
    if [ -d "$skill_path" ]; then
        skill_name=$(basename "$skill_path")
        
        if [[ "$skill_name" == _* ]]; then
            continue
        fi

        target_path="${TARGET_DIR}/${skill_name}"
        
        ln -sfn "$skill_path" "$target_path"
        
        echo "✅ Linked: ${skill_name}"
    fi
done

echo "🎉 Done! Skills registered via symlink."

echo "📚 Updating Skill Catalog in README.md..."
mkdir -p scripts
python3 scripts/generate_catalog.py
