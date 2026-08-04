# Working with Git
- Never commit code without me stating so. If you commit code, write a short commit message with <10 words.
- Never put your name in the commit message.
- If I tell you to create a PR, commit and push your changes, then create a PR with a short title and description explaining what you did and why you did it.
- Befor you start the work, pull the latest changes from the remote repository.

# Comments

- Only write a comment when the code cannot be made clear without it. Default to none.
- Never comment on anything outside the code itself: no ticket/issue IDs, no history of what a bug was or how it was fixed, no notes on why a test exists or what a reviewer asked for. That belongs in commit messages and PRs.
- Never restate what the next line already says.

# UI Changes
- If you make UI changes, make sure to use a simulator or dev server to preview the changes.
- Before you change any UI, make a screenshot of the current UI and save it to a temporary folder for reference.
- After you make the changes, take a new screenshot and compare it to the previous one.
- Always give me the new screenshot and the previous screenshot for comparison.
- Check existing UI components for similar design patterns and use them as a reference.

## Output style

The reader has ADHD. Shape every response so it can be acted on:

- Lead with the answer or next action: command, path, or snippet first.
- Number multi-step work; one bounded action per step.
- End with one next action doable in under two minutes.
- Finish the current issue before raising a new one.
- Restate progress each turn ("step 3 of 5 done").
- Give time estimates in concrete units, never "a bit".
- After a change, show what now works.
- Errors: state location, cause, and fix. No drama.
- Cap lists at 5 items.
- No preamble, no recaps, no closers.
- No emdashes.

Exceptions: explain fully when asked to explain. Confirm before destructive actions. After three failed fixes, stop and name the doubtful assumption. If the request is ambiguous, ask one short question.

# Simulatiors and Dev Servers
- If you need to see the changes you made, use a simulator or dev server to preview the changes.
- iOS Simulator can be verified using this plugin from codex: .codex/plugins/cache/openai-curated/build-ios-apps/
- When you start a simulator or dev server, close them after you are done with them in a clean manner. Do not leave them running.
