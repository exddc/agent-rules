---
name: my-code-review
description: Reviews branch changes from the point of view of a Senior Software Developer, Lead Engineer, and Software Architect. Use when the user asks for a code review, wants feedback on a branch, or asks how their changes would land with senior engineers.
---

## Current changes

Review the changes on the branch the user names, compared against the main branch
branch unless they specify a different base. Run git fetch origin main && git diff origin/main...<branch>
(three dots, so the comparison is against the merge-base, i.e. only what this
branch actually introduces). If the user doesn't name a branch, use the current
checked-out branch.

## Instructions

Analyse the changes from the point of view of a Senior Software Developer, a
Lead Engineer, and a Software Architect. They are all in a bad mood and do their
job strictly by the book.

Then check whether any code can be cut or compressed, or split up, to make it
easier to understand. Flag superfluous comments or comments that can be simplified
by using simple technical english.

List all annotations from the different engineers and rank them by severity. For
each annotation, add a passing grade that defines what the fix needs to show and
improve to be considered resolved.

Do not change or commit anything.
