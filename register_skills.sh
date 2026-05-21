#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOURCE_DIR="${REPO_DIR}/skills"

usage() {
    cat <<'EOF'
Usage: ./register_skills.sh [install|list|github|legacy-opencode]

Commands:
  install          Install local skills with npx skills@latest (default).
  list             List skills discoverable by the skills CLI.
  github           Install from the public split repo so skills update can track them.
  legacy-opencode  Symlink skills directly into ~/.config/opencode/skills.

Environment:
  SKILLS_AGENTS    Space-separated skills CLI agent ids. Default: "codex opencode".
  SKILLS_NAMES     Space-separated skill names. Default: "*".

Examples:
  ./register_skills.sh
  SKILLS_AGENTS=codex SKILLS_NAMES="prd writing-plans" ./register_skills.sh
  ./register_skills.sh github
  npx skills@latest update -g -y
EOF
}

update_catalog() {
    echo "Updating skill catalog in README.md..."
    python3 "${REPO_DIR}/scripts/generate_catalog.py"
}

run_skills_cli_install() {
    local source="$1"
    read -r -a agents <<< "${SKILLS_AGENTS:-codex opencode}"
    read -r -a skills <<< "${SKILLS_NAMES:-*}"

    local cmd=(npx skills@latest add "$source" -g --full-depth -y)
    cmd+=(--agent "${agents[@]}")
    cmd+=(--skill "${skills[@]}")

    echo "Installing skills from ${source} for agents: ${agents[*]}"
    "${cmd[@]}"
}

legacy_opencode_symlinks() {
    local target_dir="${HOME}/.config/opencode/skills"

    echo "Registering skills from ${SOURCE_DIR} to ${target_dir} via symlink..."
    mkdir -p "$target_dir"

    for skill_path in "${SOURCE_DIR}"/*; do
        if [ -d "$skill_path" ]; then
            skill_name=$(basename "$skill_path")

            if [[ "$skill_name" == _* ]]; then
                continue
            fi

            ln -sfn "$skill_path" "${target_dir}/${skill_name}"
            echo "Linked: ${skill_name}"
        fi
    done

    echo "Done. Skills registered via symlink."
}

mode="${1:-install}"

case "$mode" in
    install)
        update_catalog
        run_skills_cli_install "$REPO_DIR"
        ;;
    list)
        npx skills@latest add "$REPO_DIR" --list --full-depth
        ;;
    github)
        update_catalog
        run_skills_cli_install "Skeptomenos/skills-library"
        ;;
    legacy-opencode)
        update_catalog
        legacy_opencode_symlinks
        ;;
    -h|--help|help)
        usage
        ;;
    *)
        usage >&2
        exit 2
        ;;
esac
