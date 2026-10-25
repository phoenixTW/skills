---
name: writing-for-humans
description: Explain what we are doing to a human, simple and visual first, deep later. Draft, diagrams, HTML page, and optional video.
disable-model-invocation: true
metadata:
  credits:
    skill: asd-ste100
    author: Dustin Yuchen Teng
    url: "https://github.com/danyuchn/asd-ste100-skill"
---

# Writing for humans

Turn what we are thinking about into an explanation a tired human reads in two minutes: what we are trying to do, why, and how we get to success. Simple and visual first. Technical depth comes last, folded away.

The reader is the user. They know the project but they missed the **premise**: the context that makes the rest make sense. A good **re-pitch** adds that premise, uses the **project nouns**, and stays warm. A **blunt** re-pitch only deletes words. Blunt is the failure this skill exists to prevent.

Every artifact (draft, HTML, video script) is written in full sentences with articles and verbs, whatever chat style is active.

## Writing rules

Write in STE-flavored English from [references/ste100-rules.md](references/ste100-rules.md). Structural rules apply in full: active voice, one idea per sentence, about 25 words per descriptive sentence, noun clusters of 3 words or fewer, no semicolons, lists for sequences. Word-choice rules are a direction, not a lock. Use strict mode only for numbered steps.

Apply [unslop](../unslop/SKILL.md) rules while you draft, not as a second pass. Rules 11, 13, 27, and 33 matter most here: one name per thing, no em dashes, say what it does, and whole sentences over compressed fragments.

Keep the natural tone. Talk to the reader as "you" and about the team as "we". Connecting words such as "so", "because", and "this means" stay, because they carry the reasoning. Keep every hedge at its original strength: "may have failed" never becomes "failed".

## Project nouns

Read the project's own words before you write anything, in this order:

1. `CONTEXT-MAP.md`, if present, to find the right `CONTEXT.md`.
2. `CONTEXT.md`. This wins on any conflict.
3. `GLOSSARY.md`, if present.
4. `CLAUDE.md` and `AGENTS.md`, for project and product names only.

Use those terms exactly. When the source material uses an invented name for something the glossary already names, use the glossary name. When you need a term no file defines, use it, define it once in plain words, and list it in a **New terms** footer with a suggestion to run `/domain-modeling`. Leave the domain files unchanged.

## Process

Output goes to `.scratch/explain/<slug>/`, where `<slug>` is a short kebab-case name for the topic.

### 1. Gather

Find the material to explain, in this order: a file the user named, the current conversation, then the latest `/research` note or `/wayfinder` map for this topic.

- When facts are missing, run `/research` and wait for its note.
- When open decisions block the explanation, stop. Ask the user to run `/wayfinder` (it is user-invoked) and to come back with its map.

**Done when:** you can state the goal in one sentence and every fact you plan to use has a source.

### 2. Write

Write `draft.md` with these sections, in this order. Skip a section that has nothing true to say.

1. **Where we are.** One or two sentences of premise.
2. **What we are trying to do.** The goal in plain words.
3. **Why it matters.**
4. **How we get there.** Numbered steps.
5. **How we know it worked.** Observable success signals.
6. **Open questions and risks.**
7. **Deeper.** The technical detail, for readers who want it.
8. **New terms.** Only when you used a term no project file defines.

Run the [self-check](#self-check) before you show the draft.

**Done when:** every self-check line passes.

### 3. Diagrams

Draw the ideas that are faster to see than to read: the flow of steps, the parts and how they connect, before and after.

- Mermaid by default. Save each one to `diagrams/<name>.mmd` and embed it in `draft.md` beside the paragraph it explains.
- `/pr-lens` when the topic is a code change.
- `/diagram` when the user wants an editable picture.

Diagram labels use the project nouns. A diagram that needs a paragraph to make sense gets redrawn.

**Done when:** each of sections 1, 4, and 5 has a diagram or a reason it reads better as text.

Show the draft with its diagrams. Ask the user whether to build the HTML page.

### 4. HTML page

Only after the user says yes. Build `index.html` with [references/html-explainer.md](references/html-explainer.md). Open it for the user.

**Done when:** the page opens in a browser with no console errors, every diagram renders, and "Deeper" is folded by default.

### 5. Video

Only when the user asks for one. Follow [references/video.md](references/video.md).

**Done when:** `video/<slug>.mp4` and `video/<slug>.srt` exist and the user has watched a preview.

## Self-check

Compare the draft with the source material. Each line must be true.

- **Shorter and clearer.** A reader gets the goal from section 1 and 2 alone. Length dropped because sentences got plain, not because facts left.
- **Premise added.** The draft states at least one piece of context the source assumed the reader knew.
- **Project nouns back.** Every concept that has a name in `CONTEXT.md` or `GLOSSARY.md` uses that name. Every other term is in "New terms".
- **Every fact kept.** Each claim, number, condition, and hedge in the source survives, or sits in "Deeper".
- **Whole sentences.** No sentence drops its article, subject, or verb. No arrows or symbol-speak in prose.

## Second pass

When the user runs this skill on a draft it already wrote, the input is a re-pitch, not raw material. A second pass may add missing premise, swap a leftover invented name for a project noun, or split a sentence a reader stumbled on. Every section and every fact from the first pass stays. If nothing needs one of those three changes, say the draft already passes and leave it as is.
