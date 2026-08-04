#!/bin/sh

set -eu

rules_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
source_file="$rules_dir/AGENTS.md"
user_home=${HOME:?HOME is not set}
timestamp=$(date +%Y%m%d-%H%M%S)

link_rules() {
  target_file=$1
  target_dir=$(dirname -- "$target_file")

  mkdir -p "$target_dir"

  if [ -L "$target_file" ] && [ "$(readlink "$target_file")" = "$source_file" ]; then
    printf 'Already linked: %s\n' "$target_file"
    return
  fi

  if [ -e "$target_file" ] || [ -L "$target_file" ]; then
    backup_file="$target_file.backup-$timestamp"
    mv "$target_file" "$backup_file"
    printf 'Backed up: %s\n' "$backup_file"
  fi

  ln -s "$source_file" "$target_file"
  printf 'Linked: %s -> %s\n' "$target_file" "$source_file"
}

check_link() {
  target_file=$1

  if [ -L "$target_file" ] && [ "$(readlink "$target_file")" = "$source_file" ]; then
    printf 'OK: %s\n' "$target_file"
    return
  fi

  printf 'Missing or incorrect: %s\n' "$target_file" >&2
  return 1
}

if [ "${1:-}" = "--check" ]; then
  check_link "$user_home/.codex/AGENTS.md"
  check_link "$user_home/.grok/AGENTS.md"
  exit
fi

if [ ! -s "$source_file" ]; then
  printf 'Canonical rules file is missing or empty: %s\n' "$source_file" >&2
  exit 1
fi

link_rules "$user_home/.codex/AGENTS.md"
link_rules "$user_home/.grok/AGENTS.md"

printf '\nCursor requires one manual step:\n'
printf 'Paste %s into Cursor Settings > Rules > User Rules.\n' "$rules_dir/CURSOR_USER_RULE.md"
