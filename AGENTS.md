# Working with Git
- Never commit code without me stating so.
- Every commit message must strictly follow the Conventional Commits v1.0.0 specification: `<type>[optional scope][!]: <description>`.
  - Allowed types: `feat`, `fix`, `docs`, `style`, `refactor`, `perf`, `test`, `build`, `ci`, `chore`.
  - Description: imperative, lowercase, no trailing period, under 10 words. Example: `fix(auth): refresh token before expiry`.
  - Mark breaking changes with `!` after the type or scope and a `BREAKING CHANGE:` footer.
- Never put ticket IDs (such as `HC-12` or `TW-34`) in commit messages, PR titles, or PR descriptions. The branch name (`hc-12/<slug>`, `tw-34/<slug>`) already links the ticket.
- Never put your name or a Co-Authored-By trailer in the commit message.
- If I tell you to create a PR, commit and push your changes, then create a non-draft PR with a short title and description explaining what you did and why you did it.
- When I ask you to create a PR, or to handle a PR's review comments, failing CI, or merge conflicts, follow the `pr` skill.
- Keep PR descriptions short. Skip verification and test sections that only say the change was verified or tests passed.
- Never add a "Generated with Claude Code" line or any other tool attribution to a PR description.
- Never reply to, resolve, or react to review comments on a PR.
- Before you start work on the default branch with a clean working tree, run `git pull --ff-only`. If it fails, continue and tell me in one line.

# Comments

- Only write a comment when the code cannot be made clear without it. Default to none.
- Never comment on anything outside the code itself: no ticket/issue IDs, no history of what a bug was or how it was fixed, no notes on why a test exists or what a reviewer asked for. That belongs in commit messages and PRs.

# UI Changes
- If you make UI changes, make sure to use a simulator or dev server to preview the changes.
- Before you change any UI, make a screenshot of the current UI and save it to a temporary folder for reference.
- After you make the changes, take a new screenshot and compare it to the previous one.
- Always give me the new screenshot and the previous screenshot for comparison.
- Check existing UI components for similar design patterns and use them as a reference.

## Output style

The reader has ADHD. Shape every chat response so it can be acted on. Files, commits, PRs, and subagent reports keep their normal format.

- Lead with the answer or next action: command, path, or snippet first.
- Number multi-step work; one bounded action per step.
- When work remains, end with one next action doable in under two minutes.
- Finish the current issue before working on a new one. Note unrelated problems in one line.
- In multi-step work, restate progress each turn ("step 3 of 5 done").
- Give time estimates in concrete units, never "a bit".
- After a change, show what now works.
- Errors: state location, cause, and fix.
- Cap lists at 5 items. If more exist, show the top 5 and say how many remain.
- No preamble, no recaps, no closers.
- No emdashes.

Exceptions: explain fully when asked to explain. Confirm before destructive actions. After three failed fixes, stop and name the doubtful assumption. If an ambiguity would change the result, ask one short question; otherwise pick the sensible default and say which one.

# Simulators and Dev Servers
- If you need to see the changes you made, use a simulator or dev server to preview the changes.
- For the iOS Simulator, use the `ios-debugger-agent` skill from the Codex plugin at `~/.codex/plugins/cache/openai-curated/build-ios-apps/*/skills/`.
- When you start a simulator or dev server, close them after you are done with them in a clean manner. Do not leave them running.
