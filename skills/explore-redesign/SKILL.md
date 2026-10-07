---
name: explore-redesign
description: Explore a redesign of an existing app screen or feature before implementation. Inspect the running app, identify the user's goal and usability problems, and generate visual alternatives grounded in the app's design language. Use for redesign exploration and proposed solution images, not implementation or a standalone UI audit.
---

# Explore a redesign

Help the user choose a design direction by showing why the current screen fails their goal and how alternative designs would work in the existing app.

## Boundaries

- This is exploration. Leave application files and persistent data unchanged. An issue ID or suggested branch name is context, not permission to implement, branch, commit, or update the issue.
- Save screenshots and concept images in a temporary folder outside the working tree.
- Deliver what was asked. If image generation is unavailable or fails, say so and agree on another visual format with the user before substituting one.
- Stop only the processes you started, including before pausing to wait for an answer.

Explicit user instructions override these boundaries.

## 1. Clarify the goal

Extract the target screen, current frustration, desired outcome, and constraints from the request. Treat a suggested layout as one possible solution, not the goal: "organize the next months" is a goal; "month/quarter/year sections" is one approach.

If the target screen or purpose is missing or too vague to guide alternatives, ask one short question, such as: "What should this screen help you do, and what gets in your way today?" Bundle it with any question about image generation availability. You may inspect the app while waiting, but do not choose directions until answered.

**Done when:** target screen, desired outcome, and constraints are known.

## 2. Inspect the current experience

1. Record `git status` if the project is under version control.
2. Start the app with its existing dev setup and open it in a browser or simulator. If startup is blocked, report the blocker; do not repair the app or install dependencies without permission. Without any visual reference of the current screen, ask for screenshots before continuing.
3. Navigate to the target screen through the app's navigation, not a deep link. Prefer existing populated states; use disposable sample data only if it cannot touch real records.
4. Capture the screen, its entry point, and a few neighboring screens that define the design language.
5. Note layout, navigation, typography, spacing, density, color roles, surfaces, radii, icons, and component patterns. Read components or tokens when useful.
6. Assess the screen against the goal: grouping, ordering, discoverability, space, and whether the representation matches the objects and their lifecycle. Separate observed problems, user-reported problems, and hypotheses.

Example: a recurring schedule shown with permanent strikethrough reads as a finished one-off task.

**Done when:** baseline and navigation screenshots are saved and the problems are listed against the goal.

## 3. Develop alternatives

Develop two or three directions that differ in organizing principle, hierarchy, or entry point; color-only variants do not help the user choose. Include the user's proposed idea, and add another approach if it could serve the goal better.

For each direction, note the problem it solves, its main tradeoff, how the key action works, and whether it needs new data or behavior. Keep adjacent navigation visible when discoverability or space is part of the problem.

**Done when:** each direction is structurally distinct and traces back to the goal.

## 4. Generate concept images

1. Use the available image-generation tool. Supply the baseline screenshots as references, plus the observed design language, viewport, layout, essential labels, realistic content, and intended interaction.
2. Keep viewport, theme, and sample content consistent across concepts. Include a lifecycle or edge state when the complaint depends on it.
3. Inspect each result for fidelity to the app, readable labels, believable states, and a clear structural difference. Regenerate when a mismatch obscures the idea.
4. Label each image as a mockup. Explain interactions in text when a static image cannot show them.

**Done when:** every direction has a labeled image that matches the app's design language.

## 5. Deliver the decision

1. Show the baseline screenshot and every concept image with its benefit and tradeoff.
2. Recommend a direction against the goal and name any assumption or new capability it depends on.
3. End with one focused question that helps the user pick or refine a direction. Picking one does not authorize implementation.
4. Stop the processes you started. Compare `git status` with the initial record and report unexpected changes without discarding them.

**Done when:** baseline, concepts, tradeoffs, and recommendation are delivered and cleanup is complete.
