---
name: review-technical-writing
description: >-
  Review technical prose against 21 literature-backed style rules and, on
  confirmation, write a polished copy beside the original. Use when reviewing
  docs, READMEs, papers, design docs, or writing style. Does not require the
  agent-style CLI.
license: CC-BY-4.0
---

# Reviewing Technical Writing

Post-hoc audit of prose that already exists. This skill does not draft new documents (that is `create-technical-writing`) and does not review code.

Based on *The Elements of Agent Style* (https://github.com/yzhao062/agent-style) v0.4.2, CC BY 4.0. Do not `pip`/`npm`/`npx` install `agent-style`. Do not shell out to `agent-style review`. Judge with the host model plus the mechanical lists below. Full directives and BAD/GOOD pairs: [RULES.md](RULES.md).

## Invocation

| Shape | Behavior |
| --- | --- |
| one file | Audit it. Print the scorecard. Ask: produce a polished draft at `FILE.reviewed.md`? On yes, write beside the original and print a diff. |
| two files | A/B compare. Per-rule delta table. No polish, no ask. |
| pasted prose / a selection | Same as one file. If there is no path, skip the `.reviewed.md` write unless the user names an output path. |

## Hard Rules

1. Never install or invoke the `agent-style` CLI.
2. Never edit the source file. Polish writes `FILE.reviewed.md` only.
3. No new facts, metrics, citations, links, or code behavior. If RULE-H fires, leave the claim flagged. Do not invent support.
4. Preserve Markdown structure (fences, tables, frontmatter, links, heading levels, list nesting) unless the violation *is* the structure (RULE-A).
5. Revise only flagged violations. Do not rewrite clean paragraphs.

## Workflow (One File)

1. Read the source. Skip fenced code, inline code, and YAML/JSON/TOML blocks when scoring prose rules. Still score surrounding prose.
2. Read [RULES.md](RULES.md).
3. Mechanical pass using the lists below (RULE-05, 06, 12, A, B, C, D, E, G, I).
4. Semantic pass for RULE-01, 02, 03, 04, 07, 08, 09, 10, 11, F, H. Also catch novel clichés and jargon the lists miss.
5. Merge into the scorecard. Cite `file:line` and a short excerpt for each finding.
6. If total count is zero, say so and stop.
7. Ask whether to write `FILE.reviewed.md`. Wait.
8. On yes: revise only flagged spans, honor the hard rules, write beside the source, re-audit, show before → after counts, print `diff FILE FILE.reviewed.md`.

## Mechanical First Pass

Flag these on sight (except inside code spans/fences):

**RULE-05 clichés (case-insensitive):** pushes the boundaries, paradigm shift, state of the art, state-of-the-art, paves the way, groundbreaking, industry-leading, unlock the full potential, new era, cutting-edge, significant improvements, game-changer, at the end of the day, in today's landscape, seamless experience, robust solution.

**RULE-06 jargon substitutions:** leverage → use; utilize → use; methodology → method; functionality → feature or function; operationalize → start or build. Keep a word if it carries distinct technical meaning.

**RULE-04 filler:** in order to; due to the fact that; it is important to note; it is worth noting that; may potentially; could possibly.

**RULE-12:** any sentence over 30 words.

**RULE-A:** a list of 3+ items that reads as sentence shards (items start with Because / Which / And / Rather, or a causal chain split across bullets). Genuine checklists, endpoint lists, and config enumerations are clean.

**RULE-B:** `—` or `–` used as sentence punctuation. Keep en dashes in numeric ranges and paired names. Keep hyphens in compounds (`zero-shot`).

**RULE-C:** two or more consecutive sentences that share the same first word.

**RULE-D:** sentence-initial Additionally / Furthermore / Moreover / In addition / What's more / Notably. Allow one per Markdown block; flag the second.

**RULE-E:** last sentence of a paragraph that only restates the paragraph.

**RULE-G:** section headings in sentence case, unless they are questions, full-sentence titles, or the repo already uses sentence-case headings.

**RULE-I:** contractions in formal technical prose (`it's`, `doesn't`, `don't`, `won't`, `can't`, `I'm`, `you're`, `we're`, `they're`, `that's`, `shouldn't`, `isn't`, `we've`). Informal registers may keep them if consistent.

## Required Output Format

### Part 1 — Scorecard

One row per rule that fired. Omit clean rules.

| Rule | Severity | Location | Excerpt | Fix |
| --- | --- | --- | --- | --- |

Severity: **critical** (RULE-01, RULE-H), **high** (02, 05, 12), **medium** (03, 04, 06, 07, 08, 09, 10, 11, A–F), **low** (G, I).

Then a one-line tally: `N violations across M rules`.

### Part 2 — Verdict

- **Block** if any critical finding remains (undefined terms for the named reader, unsupported or fabricated claims).
- **Approve** if no critical findings and remaining items are polish.

Close with the polish question when a source path exists.

## Self-Verification

When asked whether this skill is active, reply on one line:

`review-technical-writing active: 21-rule scorecard (mechanical: 05, 06, 12, A, B, C, D, E, G, I; semantic: 01, 02, 03, 04, 07, 08, 09, 10, 11, F, H); no CLI; polish writes FILE.reviewed.md only.`
