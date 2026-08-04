# Shared agent rules

`AGENTS.md` is the single source of truth for personal instructions used by Codex, Grok, and Cursor on this Mac.

## Install

Run:

```sh
./install.sh
```

The installer creates these symbolic links:

```text
~/.codex/AGENTS.md -> ./AGENTS.md
~/.grok/AGENTS.md  -> ./AGENTS.md
```

Existing files are moved to timestamped backup files before links are created. Running the installer again is safe.

Cursor stores global User Rules in its settings rather than a supported `~/.cursor/AGENTS.md` file. Paste the contents of `CURSOR_USER_RULE.md` into **Cursor Settings > Rules > User Rules** once. That bridge instructs Cursor to read the canonical file at the start of each local task.

## Update

Edit only `AGENTS.md`, then start a new agent session. Codex and Grok usually load instructions when a session starts.

## Verify

Run:

```sh
./install.sh --check
grok inspect
```

For Cursor, start a new local chat and confirm that the canonical path appears in the active rules or context view.

## Project rules

Keep repository-specific commands, architecture, and conventions in each project's own tracked `AGENTS.md`. They are layered with these personal defaults and should not be copied into this repository.
