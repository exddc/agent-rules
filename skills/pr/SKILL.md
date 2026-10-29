---
name: pr
description: Create a pull request and see it through until it is ready to merge. Self-review, commit, push, and open the PR, then fix valid review comments, failing CI, and merge conflicts until all checks are green. Use when the user says "create a PR", "commit and create the PR", "check the review comments, fix if valid, push when done", or reports a failed CI run, a failed build, or merge conflicts on a PR.
---

# PR

Take the work from local changes to a PR that is ready to merge. The task is done only when all of these hold on the PR's head commit:

- Every check has finished and passed, including review-bot checks such as pullfrog.
- Every review finding has a verdict: fixed, skipped with a reason, or waiting for the user's call.
- The PR has no merge conflicts.

Never claim "ready to merge" while any of these is open.

## Boundaries

- Commit and push without asking first. "Push when done" is the default.
- Never merge or close the PR, open it as a draft, or change its reviewers or labels.
- Never reply to, resolve, react to, or dismiss review comments or reviews. Bots resolve their own threads.
- Never force-push, except `--force-with-lease` after a rebase that steps 2 or 6 require.
- Never commit screenshots, logs, or scratch files. Keep them outside the repository.
- Commit only files that belong to this work. Mention other uncommitted changes in one line.
- Change only what the task, a finding, or a failure needs. Note unrelated problems in one line.
- If the user only asks to check ("check the review comments"), stop after step 5 and report.

Explicit user instructions override these boundaries.

## Where to start

- **No PR exists for this work yet:** start at step 1.
- **A PR exists:** start at step 4. Target the PRs the user names, otherwise the PR for the current branch (`gh pr view`). "All PRs" means every open PR by the user in this repo (`gh pr list --author @me`).

If the host offers a PR link tool, such as T3 Code's `link_pull_request`, link every PR you create or work on.

## 1. Self-review

Run the `my-code-review` skill on the changes, in a subagent if the host supports one. Judge and fix its findings as in step 7.

Skip this step if the change is trivial, such as a version bump, a link, or a copy edit. Also skip it if this thread already reviewed the current changes, or the user says to skip it.

**Done when:** every self-review finding has a verdict, and each valid one is fixed.

## 2. Prepare the branch

1. Run `git fetch origin`. If you are on the default branch, create a branch. Use the branch name the ticket suggests, otherwise `feature/<slug>` or `fix/<slug>`, with the ticket ID first in the slug when there is one.
2. Base the branch on the latest `origin/<base>`. If the work depends on an unmerged PR, base it on that PR's branch instead and say so in the PR body.
3. Check `git diff --stat origin/<base>...HEAD`. It must show only this work. If it shows changes from an earlier PR that was squash-merged, rebase onto `origin/<base>`.
4. Run the checks CI runs for the touched area, plus the repo's own gates, such as lint, format, and version checks.
5. Stage only the files of this work. Commit with a message under 10 words, with no co-author trailer or tool attribution. Push with `git push -u origin <branch>`.

**Done when:** the branch is pushed and its diff against the base holds only this work.

## 3. Open the PR

Write the body to a temporary file and run `gh pr create --base <base> --title "<title>" --body-file <file>`.

- **Title:** short and imperative. Put the ticket ID first when there is one, for example `TW-569: Request reviews after positive moments`.
- **Body:** no headings. Start with one or two sentences on the problem the PR solves and why it matters. Follow with 2 to 5 bullets on the changes. Example:

  ```markdown
  Every timed-out or cancelled child waited out the full grace period, even when it exited on SIGTERM. During `chime-webd` shutdown, that added up to 2 s per in-flight apply step.

  - After SIGTERM, `PosixRunner` checks the group leader with `waitid(..., WEXITED | WNOHANG | WNOWAIT)` on each 20 ms tick. When the leader has exited, it sends SIGKILL to the group right away, then reaps and returns.
  - `WNOWAIT` leaves the leader unreaped, so the process-group ID stays reserved until SIGKILL has gone out. No group signal is sent after the reap.
  - Trade-off, documented in `platform/README.md`: descendants still running when the leader exits get SIGKILL without the rest of their grace period.
  - New test: a SIGTERM-responsive child with a 2 s grace period returns in about 125 ms (it took 2.1 s before).
  ```

  - Bullets cover what a reviewer must know: behavior changes, trade-offs, and new tests that prove the fix.
  - Leave out routine changes such as version or build-number bumps, regenerated files, and formatting.
  - With a ticket, end with `Fixes [TW-569](<ticket URL>).`
  - Add no test or verification section, no tool attribution, and no images. Give before and after screenshots to the user in chat instead.

**Done when:** a non-draft PR exists and is linked in the host.

## 4. Collect feedback

1. Run `git fetch origin`, check out the PR's head branch, and run `git pull --ff-only`. If the branch is checked out in another worktree, work on a detached HEAD at `origin/<branch>` and push with `git push origin HEAD:<branch>`. If uncommitted changes you did not make block the checkout, stop and ask.
2. Read all of these sources. Review bodies can hold findings that have no inline comment, such as a mismatch with the PR description.

   ```sh
   gh api graphql -F owner='{owner}' -F repo='{repo}' -F pr=<N> -f query='
     query($owner:String!,$repo:String!,$pr:Int!){repository(owner:$owner,name:$repo){pullRequest(number:$pr){
       reviewThreads(first:100){nodes{isResolved isOutdated path line
         comments(first:20){nodes{author{login} body createdAt url}}}}}}}'
   gh api 'repos/{owner}/{repo}/pulls/<N>/reviews' --paginate \
     --jq '.[] | select(.body != "") | {user: .user.login, state, commit_id, submitted_at, body}'
   gh api 'repos/{owner}/{repo}/issues/<N>/comments' --paginate \
     --jq '.[] | {user: .user.login, created_at, body}'
   ```

   Also read anything the user gives you in chat: pasted text, screenshots of comments, or inline notes on the diff.

3. Keep:
   - unresolved threads
   - review-body findings not yet addressed on the current head
   - every comment from the user
4. Drop:
   - resolved threads, and threads whose last reply says the finding was addressed
   - bot noise: Linear links, deploy previews, GitGuardian or Vercel status
   - progress checklists from a review that is still running

If GitHub shows nothing but the user says comments exist, list what you checked and ask them to paste the comments.

**Done when:** you have one list of open findings with source, file, and line.

## 5. Check CI and mergeability

1. Run `gh pr checks <N>`. For each failed check, read the log with `gh run view <run-id> --log-failed`.
2. Before blaming the PR, check whether the same check fails on the base branch. Then classify each failure:
   - **Caused by the PR:** fix it in step 7.
   - **External:** runner or bot quota, usage limit, expired secret, or a flake that passes on rerun. Change no code. Report the action the user must take, such as "re-run the job after 12:49".
   - **Expected:** the user or the PR says this check fails for now. Report it and leave it.
3. Run `gh pr view <N> --json mergeable,mergeStateStatus`. `UNKNOWN` means GitHub is still computing; retry a few seconds later. On `CONFLICTING`, or when the user says other PRs merged, do step 6.

**Done when:** every failed check has a cause and a class, and the merge state is known.

## 6. Resolve conflicts

Skip this step when the PR merges cleanly and the user did not ask for the latest base.

- **Default:** merge `origin/<base>` into the PR branch, resolve, and keep the intent of both sides. Push normally.
- **Squash-merged parent:** if the branch still carries the original commits of a parent PR that was squash-merged, run `git rebase --onto origin/<base> <old-parent-tip>` and push with `--force-with-lease`. Say so in the report.
- **Repo gates:** re-run any version-bump check or generated file that the base branch changed, so the PR stays above base.
- **Stacked PRs:** resolve bottom up, then merge each fixed branch into the PR above it.

**Done when:** the PR branch contains the base branch with no conflict markers and builds.

## 7. Judge and fix each finding

Read the code each finding points at on the current head, then give it one verdict:

- **Valid:** a real bug, regression, missing test, or nit that improves the code. Fix it. Valid nits are in scope.
- **Already fixed:** cite the commit.
- **Invalid or intentional:** skip it with one sentence that cites code, a requirement, or the ticket.
- **Question:** a comment such as "why did this change?" gets an answer in the report. Change code only if the answer reveals a problem.
- **Needs your call:** a product decision, or a conflict with earlier user instructions. Fix everything else first, then ask one question.

Fix the root cause with the smallest change. Add a regression test when the finding is a behavior bug and the repo tests that area. If a fix changes what the PR does, update the PR body to match. For UI changes, follow the screenshot rules in AGENTS.md.

**Done when:** every finding and every PR-caused CI failure has a verdict, and each valid one is fixed.

## 8. Verify, commit, push

1. Run what CI runs for the touched area, plus the repo's gates. Long suites may run in the background, but push only after they pass. If a check cannot run locally, say which and why.
2. Commit with a message under 10 words that names the fix, with no co-author trailer or tool attribution.
3. Push with a fast-forward `git push`, unless step 6 required `--force-with-lease`.

**Done when:** the push succeeded and you have the new head SHA.

## 9. Wait and repeat

Opening the PR or pushing to it starts CI and review bots. Wait for them, then repeat steps 4 to 8 for new findings and new failures only.

- **The host can watch the PR** (for example T3 Code's `watch_pull_request`): watch it and end your turn. The host wakes you on new checks and comments. Do not use `gh pr checks --watch` or sleep loops there.
- **No watch tool:** run `gh pr checks <N> --watch`. Review bots that run as checks, such as pullfrog, finish with it.

Bots do not review every push. A passing bot check with no new comments counts as a clean review.

Stop and hand back when:

- the done conditions at the top hold: report "Ready to merge"
- 3 fix rounds have passed since the PR was opened or picked up: report what is still open
- only items that need the user remain, such as an external CI failure or a finding that needs their call

Unwatch the PR before you hand back.

## Report

1. Lead with the state: "PR #N is ready to merge", "PR #N: <what is still open>", or "Nothing to fix, nothing pushed". Include the PR link and head SHA.
2. Give one table row per finding: `Source | Finding | Verdict | Action`. Action is "Fixed in `<sha>`", "Skipped: <reason>", or "Needs your call". With several PRs, add a PR column.
3. List checks as passed, failed with cause, or pending.
4. Add up to 3 bullets on what now works.
5. State that review threads were left untouched.
6. If anything remains, end with one next action under 2 minutes, such as "Merge PR #N" or "Re-run pullfrog after 12:49".
