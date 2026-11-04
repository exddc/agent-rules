# Shared agent rules

`AGENTS.md` is the single source of truth for personal instructions used by Codex, Grok, Claude Code, and Cursor on this Mac.

Technical-writing skills live here too. They vendor [The Elements of Agent Style](https://github.com/yzhao062/agent-style) v0.4.2 as markdown. No pip or npm install.

## Install

Run:

```sh
./install.sh
```

The installer creates these symbolic links:

```text
~/.codex/AGENTS.md  -> ./AGENTS.md
~/.grok/AGENTS.md   -> ./AGENTS.md
~/.claude/CLAUDE.md -> ./AGENTS.md

~/.agents/skills/create-technical-writing -> ./skills/create-technical-writing
~/.agents/skills/review-technical-writing -> ./skills/review-technical-writing
~/.agents/skills/my-code-review           -> ./skills/my-code-review
~/.agents/skills/peer-review              -> ./skills/peer-review
~/.agents/skills/explore-redesign         -> ./skills/explore-redesign
~/.agents/skills/pr                       -> ./skills/pr
```

The same skill directories are also linked into `~/.cursor/skills`, `~/.codex/skills`, `~/.claude/skills`, and `~/.grok/skills`.

Existing files are moved to timestamped backup files before links are created. Running the installer again is safe.

The installer also sets `"attribution": { "commit": "", "pr": "" }` in `~/.claude/settings.json` so Claude Code adds no attribution lines to commits or PRs. Other settings in that file are kept. This step needs `python3`.

Cursor stores global User Rules in its settings rather than a supported `~/.cursor/AGENTS.md` file. Paste the contents of `CURSOR_USER_RULE.md` into **Cursor Settings > Rules > User Rules** once. That bridge instructs Cursor to read the canonical file at the start of each local task.

## Skills

| Skill | When to use |
| --- | --- |
| `create-technical-writing` | Draft docs, READMEs, design docs, papers, runbooks |
| `review-technical-writing` | Audit existing prose; optional `FILE.reviewed.md` beside the original |
| `my-code-review` | Review branch changes as a strict Senior Dev, Lead Engineer, and Architect; ranked findings with pass criteria |
| `peer-review` | Review a teammate's PR; verified must-fix and worth-suggesting comments, each with a GitHub line link and paste-ready text |
| `explore-redesign` | Inspect an existing app and generate redesign concepts in its design language before implementation |
| `pr` | Create a PR the way you like it, then fix valid review comments, failing CI, and merge conflicts until it is ready to merge |

The two technical-writing skills follow the 21-rule catalog in `vendor/agent-style/RULES.md`. Chat replies still follow `AGENTS.md`.

Based on *The Elements of Agent Style* (https://github.com/yzhao062/agent-style), CC BY 4.0. See `vendor/agent-style/NOTICE.md`.

## Update

Edit only `AGENTS.md` for chat/work rules, then start a new agent session. Codex, Grok, and Claude Code usually load instructions when a session starts.

To refresh the writing ruleset, replace files under `vendor/agent-style/` from a newer upstream tag and keep the PINNED.md note in sync.

## Verify

Run:

```sh
./install.sh --check
grok inspect
```

For Cursor, start a new local chat and confirm that the canonical path appears in the active rules or context view.

## Project rules

Keep repository-specific commands, architecture, and conventions in each project's own tracked `AGENTS.md`. They are layered with these personal defaults and should not be copied into this repository.
