#!/usr/bin/env bash
#
# Links this repo's skills/ folder into ~/.claude/skills so Claude Code
# discovers them from every project.
#
# Claude Code only auto-discovers skills from fixed locations (personal:
# ~/.claude/skills, project: .claude/skills). This repo keeps its skills
# under version control on this drive, so a symlink is used to make
# ~/.claude/skills *be* this repo's skills/ folder without moving it.
#
# Safe to re-run: if the symlink already points at this repo's skills/
# folder, it's a no-op. If ~/.claude/skills exists as something else
# (a real directory with content, or a link elsewhere), the script stops
# without touching it so nothing is silently clobbered.

set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
target="$repo_root/skills"
link_path="$HOME/.claude/skills"

if [[ ! -d "$target" ]]; then
    echo "Expected skills folder not found at: $target" >&2
    exit 1
fi

if [[ -e "$link_path" || -L "$link_path" ]]; then
    if [[ -L "$link_path" ]]; then
        existing_target="$(readlink "$link_path")"
        if [[ "$existing_target" == "$target" ]]; then
            echo "Already linked: $link_path -> $target"
            exit 0
        else
            echo "$link_path is a symlink pointing elsewhere ($existing_target). " \
                 "Remove it manually first if you want to relink it here." >&2
            exit 1
        fi
    else
        echo "$link_path already exists and is not a symlink created by this script. " \
             "Refusing to overwrite it - move or remove it manually first, then re-run." >&2
        exit 1
    fi
fi

mkdir -p "$(dirname "$link_path")"
ln -s "$target" "$link_path"
echo "Linked: $link_path -> $target"
