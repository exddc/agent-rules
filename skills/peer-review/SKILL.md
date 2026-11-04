---
name: peer-review
description: Review a teammate's pull request and prepare the review comments for the user to post. Finds issues as a strict Senior Developer, Lead Engineer, and Software Architect, verifies each one, keeps only what must be fixed or is worth suggesting, and drops nits. Output links each comment to its exact line on GitHub, with the comment text ready to copy. Use when the user asks to review someone else's PR, gives a PR URL or number to review, or asks which comments to leave on a PR.
---

# Peer review

Review a pull request that someone else wrote. The result is a verdict and a short list of comments. Each comment has a link to the diff line it belongs on and the text to paste there. The user posts everything; you post nothing.

## Boundaries

- Read-only. Never post, approve, request changes, react, resolve, push, or edit the PR, through `gh` or the API.
- Never check out the PR branch in the user's working tree. Read code at the head commit through a temporary worktree, and remove it at the end.
- Never run anything against real infrastructure. Local tests and linters are fine.
- Follow the repo's own agent rules (`AGENTS.md`, `CLAUDE.md`) for what you may run.

## 1. Collect context

The user gives a PR URL or number. With a number only, use the repo of the current directory.

```sh
gh pr view <N> --repo <owner>/<repo> --json number,title,url,author,baseRefName,headRefOid,body,files
gh pr view <N> --repo <owner>/<repo> --json commits --jq '.commits[] | .oid[0:7] + " " + .messageHeadline'
gh pr diff <N> --repo <owner>/<repo> > <scratch>/pr-<N>.diff
gh pr checks <N> --repo <owner>/<repo>
gh api graphql -F owner=<owner> -F repo=<repo> -F pr=<N> -f query='
  query($owner:String!,$repo:String!,$pr:Int!){repository(owner:$owner,name:$repo){pullRequest(number:$pr){
    reviewThreads(first:100){nodes{isResolved path line comments(first:20){nodes{author{login} body}}}}}}}'
gh api 'repos/<owner>/<repo>/pulls/<N>/reviews' --jq '.[] | select(.body != "") | {user: .user.login, state, body}'
gh api 'repos/<owner>/<repo>/issues/<N>/comments' --jq '.[] | {user: .user.login, body}'
```

1. Read the PR description, the commit headlines, and the linked ticket. Read a commit body with `git log -1 <sha>` only when its headline matters; bodies can be huge. Ticket bots such as Linear or Jira post the ticket text as an issue comment. Note the acceptance criteria.
2. Create the worktree: `git fetch origin pull/<N>/head`, then `git worktree add --detach <scratch>/pr-<N> <headRefOid>`. If the current directory is not a clone of the repo, clone it into the scratch directory first.
3. Read the repo's agent rules and contribution docs at the head commit. Their rules are review criteria.

**Done when:** you know what the PR claims to do, what the ticket asks for, what CI reports, and what other reviewers already said.

## 2. Find issues

Review the diff, and the code around it, as a Senior Software Developer, a Lead Engineer, and a Software Architect. All three are in a bad mood and work strictly by the book.

- **Senior Developer:** correctness, edge cases, error handling, tests that prove the change.
- **Lead Engineer:** repo rules and conventions, CI gates, rollout and operational risk, PR hygiene such as unrelated changes.
- **Architect:** design, coupling, consistency with the rest of the system, docs that now say something false.

Also check:

- The PR against its ticket and its own description: missing parts, scope creep, and claims the diff does not back up.
- Every changed value against the places that read it. Follow names, hosts, and keys outside the diff. Most real bugs sit where the diff meets unchanged code.
- Generated files, such as lockfiles, snapshots, and test baselines: use them as evidence that behavior changed as intended. Do not comment on their lines. Look for a repo tool that explains their diff before writing your own.

**Done when:** you have a list of candidate findings, each with a file, a line, and the concrete failure it causes.

## 3. Verify and triage

For each candidate, read the code at the head commit and try to disprove it. Drop it when:

- the code or a test disproves it,
- another reviewer already raised it (list it under "Already raised"),
- it predates the PR and the PR does not make it worse (list it under "Pre-existing").

Sort the rest into three classes:

- **Must fix:** wrong behavior, a regression, a security or data risk, a broken deploy or rollout, a violated repo rule or CI gate, a missed acceptance criterion, or docs that now mislead. A ticket item that lives outside the repo, or that the PR description defers to a later PR, is not missed. These block approval.
- **Worth suggesting:** a real gain with a clear payoff, such as simpler code, a missing test for an edge case, or a name that prevents a misread. These do not block.
- **Nit:** style, formatting, wording, anything a linter or formatter owns, taste, and any "might" without a concrete failure. Drop nits. Report only their count.

If you cannot state the concrete failure or cost in one sentence, the finding is not "must fix".

Some findings depend on state outside the repo, such as a running server, a past deploy, or a dashboard. The user may already know the answer. If the user can settle the finding in 1 or 2 steps, such as one command or one page, mark it **check first**. Write down those steps and the result that means the comment should be posted. If settling it takes more steps, ask the author in a normal comment.

**Done when:** every candidate is dropped, or sorted as "must fix" or "worth suggesting", each one that needs it is marked "check first", and you have checked each survivor against the code.

## 4. Place each comment

GitHub takes inline comments only on lines inside a diff hunk. Get each link from the helper script next to this file:

```sh
python3 <skill-dir>/scripts/pr_lines.py <pr-url> <path>:<line> [<path>:L<line> ...] < <scratch>/pr-<N>.diff
```

- `path:N` is line N of the new file. `path:LN` is line N of the old file; use it only for a deleted line.
- Run it without locations to list each file's commentable line ranges.
- When it answers "outside the diff", either use the nearest line it suggests, if the comment still reads naturally there, or anchor on the changed line that causes the problem.
- When a finding spans several lines, anchor on the last one and name the range in the comment.
- When no changed line fits, such as for a missing file, put the finding in the review summary instead.

Never build a link by hand. The anchor is a SHA-256 hash of the file path.

**Done when:** every comment has a link from the script, or has moved into the review summary.

## 5. Write the comments

Write as the user, talking to a colleague: direct, friendly, and plain. The author should get the point on the first read.

- Open with the problem or the question in one sentence.
- Give the reason in at most 2 more sentences, or at most 3 bullets when it has several steps. One fact per sentence or bullet.
- Keep each sentence under 20 words. Split any sentence that chains clauses with "so", "which", or "and then".
- Cut what the author already knows, such as what their own PR changes.
- Keep every fact the author needs to act, such as the file, host, value, or PR that proves the point. Shorten the wording, never the evidence.
- Ask instead of assert when the finding depends on intent you cannot see, such as a firewall rule or a ticket decision.
- Start each "worth suggesting" comment with `Non-blocking:`.
- When the fix replaces the commented lines exactly, add a GitHub `suggestion` block. The author can then apply it with one click.
- Write in the language of the PR. No emdashes, no severity labels, no mention of reviewer roles.

Example:

````markdown
`parse_date` now returns `None` for a bad string, but `invoice_total()` in `billing.py:88` still calls `.year` on the result. One malformed row will crash the whole export. Raise here, or skip the row in `invoice_total()`?
````

The review summary is what the user pastes into the "Submit review" box. Write at most 2 sentences and 40 words on the overall state. Then add one bullet for each finding that had no line to sit on.

## 6. Report

Remove the worktree (`git worktree remove <scratch>/pr-<N>`), then reply in exactly this shape. The reply itself is plain markdown, not fenced. Wrap only the texts the user will paste, each in a four-backtick `markdown` fence, so that a nested `suggestion` block survives.

`````markdown
**Verdict: Request changes** (or **Approve with suggestions**, or **Approve**). One sentence on why.

[PR #<N>: <title>](<url>) by <author> · head `<sha7>` · CI: <passed | n failed: names>

**Review summary**

````markdown
<text for the Submit review box>
````

## Check yourself first (<n>)

### 1. <short title>

1. <first step: a command in backticks, or a page to open>
2. <optional second step>

Post the comment below only if <result>.

[`<path>:<line>`](<link from the script>)

````markdown
<comment>
````

## Must fix (<n>)

### 1. <short title>

[`<path>:<line>`](<link from the script>) · Checked: <how you confirmed it, one line>

````markdown
<comment>
````

## Worth suggesting (<n>)

### 2. <short title>

<same shape as above>

---

Dropped: <n> nits. Already raised: <one line per item, or "none">. Pre-existing: <one line per item, or "none">.
`````

- Use "Request changes" when any "must fix" exists, "Approve with suggestions" when only "worth suggesting" items exist, and "Approve" when nothing survived.
- Base the verdict on the other findings only. If a failed "check first" item would make it "Request changes", add "unless check #<n> fails".
- Keep each title under 8 words and each "Checked" line under 15 words.
- Number findings straight through all sections, so the user can refer to "#3". Summary bullets stay unnumbered.
- Leave out an empty section.
