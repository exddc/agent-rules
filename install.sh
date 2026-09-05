#!/bin/sh

set -eu

rules_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
source_file="$rules_dir/AGENTS.md"
user_home=${HOME:?HOME is not set}
timestamp=$(date +%Y%m%d-%H%M%S)

skill_names='create-technical-writing review-technical-writing my-code-review'
skill_host_dirs="
$user_home/.agents/skills
$user_home/.cursor/skills
$user_home/.codex/skills
$user_home/.claude/skills
$user_home/.grok/skills
"

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

link_skill() {
  source_dir=$1
  target_dir=$2
  target_parent=$(dirname -- "$target_dir")

  mkdir -p "$target_parent"

  if [ -L "$target_dir" ] && [ "$(readlink "$target_dir")" = "$source_dir" ]; then
    printf 'Already linked: %s\n' "$target_dir"
    return
  fi

  if [ -e "$target_dir" ] || [ -L "$target_dir" ]; then
    backup_file="$target_dir.backup-$timestamp"
    mv "$target_dir" "$backup_file"
    printf 'Backed up: %s\n' "$backup_file"
  fi

  ln -s "$source_dir" "$target_dir"
  printf 'Linked: %s -> %s\n' "$target_dir" "$source_dir"
}

check_link() {
  target_file=$1
  expected=$2

  if [ -L "$target_file" ] && [ "$(readlink "$target_file")" = "$expected" ]; then
    printf 'OK: %s\n' "$target_file"
    return 0
  fi

  printf 'Missing or incorrect: %s\n' "$target_file" >&2
  return 1
}

install_skills() {
  for skill_name in $skill_names; do
    source_dir="$rules_dir/skills/$skill_name"
    if [ ! -f "$source_dir/SKILL.md" ]; then
      printf 'Skill is missing SKILL.md: %s\n' "$source_dir" >&2
      exit 1
    fi

    for host_dir in $skill_host_dirs; do
      link_skill "$source_dir" "$host_dir/$skill_name"
    done
  done
}

check_skills() {
  failed=0
  for skill_name in $skill_names; do
    source_dir="$rules_dir/skills/$skill_name"
    for host_dir in $skill_host_dirs; do
      check_link "$host_dir/$skill_name" "$source_dir" || failed=1
    done
  done
  return "$failed"
}

if [ "${1:-}" = "--check" ]; then
  failed=0
  check_link "$user_home/.codex/AGENTS.md" "$source_file" || failed=1
  check_link "$user_home/.grok/AGENTS.md" "$source_file" || failed=1
  check_skills || failed=1
  exit "$failed"
fi

if [ ! -s "$source_file" ]; then
  printf 'Canonical rules file is missing or empty: %s\n' "$source_file" >&2
  exit 1
fi

link_rules "$user_home/.codex/AGENTS.md"
link_rules "$user_home/.grok/AGENTS.md"
install_skills

printf '\nCursor requires one manual step:\n'
printf 'Paste %s into Cursor Settings > Rules > User Rules.\n' "$rules_dir/CURSOR_USER_RULE.md"
printf '\nSkills are linked into ~/.agents/skills, ~/.cursor/skills, ~/.codex/skills, ~/.claude/skills, and ~/.grok/skills.\n'
printf 'Start a new agent session so create-technical-writing, review-technical-writing, and my-code-review load.\n'
