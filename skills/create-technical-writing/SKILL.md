---
name: create-technical-writing
description: >-
  Draft technical prose (API docs, design docs, READMEs, papers, runbooks,
  commit messages, postmortems, proposals) using 21 literature-backed writing
  rules. Use when creating or rewriting documentation or other technical
  writing. Does not require installing the agent-style CLI.
license: CC-BY-4.0
---

# Creating Technical Writing

Write technical prose that reads like a careful engineer, not like an LLM default.

Based on *The Elements of Agent Style* (https://github.com/yzhao062/agent-style) v0.4.2, CC BY 4.0. Do not `pip`/`npm`/`npx` install `agent-style`. The full BAD/GOOD catalog is [RULES.md](RULES.md).

This skill writes. To audit existing prose, use `review-technical-writing`.

## Scope

In: API docs, design docs, research papers, grant proposals, READMEs, runbooks, commit messages, error messages, technical blog posts, postmortems, issue reports.

Out: fiction, poetry, marketing copy, non-English prose, and chat replies to the user (those follow `AGENTS.md`).

## Before You Write

1. Name the intended reader in one phrase (junior engineer, on-call engineer, adjacent-field graduate student, grant panelist, release reader).
2. Name the document type.
3. Apply the 21 compact rules below. When a rule is ambiguous, read that rule's directive and BAD/GOOD block in [RULES.md](RULES.md).

## The 21 Rules (Compact)

Canonical (Strunk & White 1959, Orwell 1946, Pinker 2014, Gopen & Swan 1990):

- **RULE-01 Curse of knowledge (critical).** Name the reader. Do not assume they share tacit knowledge. Define a term on first use if that reader would pause.
- **RULE-02 Passive voice.** Prefer active voice when the agent is known and worth naming.
- **RULE-03 Concrete language.** Prefer a specific term, number, name, or date over abstract words like "factors" or "aspects".
- **RULE-04 Needless words.** Cut filler: "in order to", "due to the fact that", "it is important to note", "may potentially".
- **RULE-05 Dying metaphors.** Delete clichés: "pushes the boundaries", "paradigm shift", "state of the art", "paves the way", "groundbreaking".
- **RULE-06 Plain English.** Prefer "use" over "leverage"/"utilize", "method" over "methodology", "feature" over "functionality". Keep jargon that carries distinct meaning.
- **RULE-07 Positive form.** Prefer "trivial" to "not important". Do not stage "not just X, but Y" antithesis for emphasis.
- **RULE-08 Claim calibration.** Match the verb to the evidence. Do not write "proves" when the evidence "suggests".
- **RULE-09 Parallel structure.** Express coordinate ideas in the same grammatical form.
- **RULE-10 Related words together.** Keep subject close to verb and modifier close to the modified word.
- **RULE-11 Stress position.** Place new or important information at the end of the sentence.
- **RULE-12 Long sentences.** Split sentences over 30 words. Vary length across a paragraph.

Field-observed (LLM failure modes, 2022-2026):

- **RULE-A Bullet overuse.** Keep connected ideas in paragraphs. Bullets only for genuine parallel lists. Do not force 3-item triads.
- **RULE-B Dash overuse.** Do not use em or en dashes as casual sentence punctuation. Prefer commas, semicolons, colons, parentheses. Numeric ranges and hyphens in compounds stay.
- **RULE-C Same-starts.** Do not open two or more consecutive sentences with the same word.
- **RULE-D Transitions.** Do not open sentences with "Additionally", "Furthermore", "Moreover", "In addition", "What's more", "Notably".
- **RULE-E Summary closers.** Do not end every paragraph with a sentence that restates its point.
- **RULE-F Term consistency.** Once you define a term or abbreviation, keep using it. Do not alternate synonyms.
- **RULE-G Title case.** Title case for section headings; articles and short prepositions stay lowercase. If the target repo already uses sentence-case headings, keep that convention.
- **RULE-H Citation discipline (critical).** Support factual claims with a named source, number, date, or artifact. Never fabricate citations. If you cannot verify a source, omit it or mark `[UNVERIFIED]`.
- **RULE-I Contractions.** In formal technical prose prefer "it is" / "does not" / "cannot". Informal surfaces (commit messages, some release notes) may keep contractions if the register is consistent.

## Escape Hatch

Break any of these rules sooner than say anything outright barbarous. Orwell 1946, Rule 6.

## Self-Check Before Delivering

Scan the draft against all 21 rules and fix violations in the document. Do not attach a scorecard unless asked.

## Self-Verification

When asked whether this skill is active, reply on one line:

`create-technical-writing active: 21 rules (RULE-01..12 canonical + RULE-A..I field-observed); full bodies in RULES.md; no CLI.`
