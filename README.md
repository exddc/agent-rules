# agent-rules

One set of instructions and skills for every coding agent (Claude Code, Codex, Cursor, and Grok) on every machine I work on. Clone it on each machine and run the installer to get the same setup everywhere.

- `AGENTS.md` holds the personal rules: git conventions, comment style, UI workflow, and output style.
- `skills/` holds reusable skills that any agent supporting the skills format can load.

Fork it, edit `AGENTS.md` to match how you work, and run the installer.

## Install

```sh
./install.sh          # link rules and skills into each agent's config
./install.sh --check  # verify the links
```

The installer symlinks `AGENTS.md` to `~/.claude/CLAUDE.md`, `~/.codex/AGENTS.md`, and `~/.grok/AGENTS.md`, and links every skill into `~/.agents`, `~/.claude`, `~/.codex`, `~/.cursor`, and `~/.grok` under `skills/`. Existing files are moved to timestamped backups, so it is safe to run again. It also turns off Claude Code's commit and PR attribution in `~/.claude/settings.json` (needs `python3`).

Cursor has no global rules file. The installer prints a one-line rule to paste into **Cursor Settings > Rules > User Rules**.

Edits to `AGENTS.md` or a skill take effect in the next agent session.

## Skills

| Skill | Use it to |
| --- | --- |
| `pr` | Open a PR, then fix review comments, failing CI, and merge conflicts until it is ready to merge |
| `my-code-review` | Review your own branch as a senior engineer, lead, and architect |
| `peer-review` | Review a teammate's PR and get verified, paste-ready comments linked to exact lines |
| `create-technical-writing` | Draft docs, READMEs, design docs, and runbooks |
| `review-technical-writing` | Audit existing prose against the same rules |
| `explore-redesign` | Generate redesign concepts for an existing app screen before building them |
| `tactile-design` | Build or review UI with layered, tactile surfaces in light and dark mode |

## Project rules

Keep repository-specific commands and conventions in that repository's own `AGENTS.md`. Agents layer them on top of these personal defaults.

## Credits

- The technical-writing skills use [The Elements of Agent Style](https://github.com/yzhao062/agent-style) v0.4.2, CC BY 4.0. See `vendor/agent-style/`.
- `tactile-design` is vendored from [kosta4a/tactile-design](https://github.com/kosta4a/tactile-design), MIT. See `vendor/tactile-design/`.
