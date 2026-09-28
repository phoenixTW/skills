---
name: blueprint
description: "Turn a ticket or requirement into a detailed implementation blueprint for a fresh session. Plan only — never implement."
disable-model-invocation: true
---

<what-to-do>

Your **sole deliverable** is a **blueprint** at `.scratch/<feature-slug>/BLUEPRINT.md`. Analyse the ticket or requirement. Do not edit source. Do not implement. Do not commit the blueprint (or anything under `.scratch/`).

Write **explicit scenarios** (Setup / Action / Expected) for happy path, edges, and failures. Write **file-level and method-level** implementation steps a cold `/implement` agent can follow. Plan every change against `/coding-standards`.

Present the blueprint. Iterate until the user accepts. Then stop.

</what-to-do>

## Process

### 1. Orient

Read the ticket, requirement, or conversation. Explore the codebase for facts (no edits). Use glossary and ADRs when present. Sketch the touch list: files and methods likely to change.

**Done when:** goal, constraints, and candidate touch list fit one short block.

### 2. Load standards

Call the Skill tool for `coding-standards`. Hold those rules while drafting every implementation step. Note intentional deviations under Constraints.

**Done when:** standards are in context.

### 3. Blocker clarify

Ask only decisions that would change the plan — at most 1–2 at a time. Look up facts yourself; never ask what tools can discover.

**Done when:** no open blockers, or the user said proceed with stated assumptions.

### 4. Write the blueprint

Create `.scratch/<feature-slug>/` if needed. Write `BLUEPRINT.md` using the template below. Open the file with the never-commit banner. Slug from the ticket or feature name.

If the user asks to commit the blueprint, refuse and remind: `.scratch/` is local scratch.

**Done when:** every scenario is explicit, every implementation step cites files + methods, and standards are named.

### 5. Present

Show the plan. Iterate on feedback. When the user accepts, stop. Next session: `/implement` against this blueprint; QA runs Edge + Failure end to end.

## Explicit scenarios

Every Happy / Edge / Failure entry is an **explicit scenario**. Each must include:

- **Setup** — preconditions / data state
- **Action** — what actor or system does
- **Expected** — observable outcome (UI, API, logs, DB, error)

Vague labels like "handle empty list" fail this step. QA should be able to execute each scenario as written.

## File and method detail

Touch list and Implementation steps must be concrete enough for a cold `/implement` agent:

- **File level** — exact paths to create, modify, or delete (including tests)
- **Method level** — functions / methods / types to add or change (name, responsibility, signature sketch when non-obvious)
- **Call flow** — which method calls which across those files for the happy path
- **TDD seams** — which method/file owns the failing test first

<blueprint-template>

```markdown
<!-- NEVER COMMIT: local scratch under .scratch/ — do not git add or commit this file -->

# Blueprint: <feature-slug>

## Goal

<what done looks like>

**Context:** <pointers to ticket / spec / conversation>

## Constraints / Out of scope

- <hard bound>
- <coding-standards deviation, if any — else omit>

## Standards

Planned against `/coding-standards`.

## Happy path

1. **<name>**
   - Setup: …
   - Action: …
   - Expected: …

## Edge cases

1. **<name>**
   - Setup: …
   - Action: …
   - Expected: …

## Failure scenarios

1. **<name>**
   - Setup: …
   - Action: …
   - Expected: …

## Touch list

| Path                   | Action | Methods / types |
| ---------------------- | ------ | --------------- |
| `path/to/file.go`      | modify | `Foo()`, `Bar`  |
| `path/to/file_test.go` | create | `TestFoo_…`     |

## Call flow

`<Entrypoint>` → `<MethodA>` → `<MethodB>` → …

## Implementation steps

1. **<step>** — files: …; methods: …; TDD seam: …; unlocks scenarios: …
2. …

## Acceptance criteria

- [ ] <criterion mapped to scenario(s)>

## Next session

- Implement: `/implement` against this blueprint
- QA: run Edge cases + Failure scenarios end to end
```

</blueprint-template>
