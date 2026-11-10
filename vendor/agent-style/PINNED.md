# Vendored agent-style rules

Pinned from [yzhao062/agent-style](https://github.com/yzhao062/agent-style) at tag **v0.4.2**.

This directory holds the CC BY 4.0 ruleset only. The pip/npm CLI is not vendored and is not required.

## What was adapted

The original project installs adapters into each repo (`agent-style enable …`) and a `style-review` skill that shells out to `agent-style review`. This repository uses two local skills instead:

- `skills/create-technical-writing` (generation-time)
- `skills/review-technical-writing` (second-pass audit; host-model only, no CLI)

Both skills read `RULES.md` from this directory.

## Attribution

> Based on *The Elements of Agent Style* (https://github.com/yzhao062/agent-style), CC BY 4.0.

See [NOTICE.md](NOTICE.md) and [LICENSES/CC-BY-4.0.txt](LICENSES/CC-BY-4.0.txt).
