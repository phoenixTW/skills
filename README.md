# PhoenixTW Skills

Personal skills hub for day-to-day agent work. It combines Phoenix-custom skills with local copies of [Matt Pocock's skills](https://github.com/mattpocock/skills), organized into installable buckets.

This repo is **not** an official release of Matt's skills, and it is **not** a drop-in replacement for installing from [`mattpocock/skills`](https://github.com/mattpocock/skills) or the Claude Code plugin `mattpocock-skills`. Prefer upstream if you want his managed updates. Prefer this hub if you want a single local set that includes Phoenix customs and curated copies.

## Attribution

A large part of this hub is copied from Matt Pocock's [skills](https://github.com/mattpocock/skills) collection (MIT). Those skills remain his work; this repo keeps owned copies so the hub can evolve independently.

- Upstream: [github.com/mattpocock/skills](https://github.com/mattpocock/skills)
- Site / newsletter: [aihero.dev](https://www.aihero.dev/s/skills-newsletter)
- Install upstream (optional): `npx skills@latest add mattpocock/skills` or `claude plugins install mattpocock-skills`

Phoenix-authored skills in this hub include (among others) `delegate`, `caveman`, `coding-standards`, `create-worktree`, `drop-worktree`, `zoom-out`, and `setup-phoenixtw-skills`.

When you change a skill that originated upstream, treat upstream as the reference and keep attribution intact.

## Quickstart

1. Run the installer:

```bash
bash install.sh
```

Or via npx:

```bash
npx phoenixtw-skills
```

2. Pick the skills you want and which coding agents to install them on.

3. Run `/setup-phoenixtw-skills` once per target repo. It configures:
   - Issue tracker (GitHub, GitLab, or local files)
   - Triage label vocabulary
   - Where documentation is saved

   Use `/setup-phoenixtw-skills` for this hub. `/setup-matt-pocock-skills` is included as a faithful upstream copy; do not run both in the same repo unless you know you need that.

4. Done.

Maintainers linking promoted skills into local harness dirs:

```bash
bash scripts/link-skills.sh
```

## Buckets

| Bucket                                                  | Role                     | Installed?                 |
| ------------------------------------------------------- | ------------------------ | -------------------------- |
| [`skills/engineering/`](skills/engineering/README.md)   | Daily code work          | yes                        |
| [`skills/productivity/`](skills/productivity/README.md) | Daily non-code workflow  | yes                        |
| [`skills/in-progress/`](skills/in-progress/README.md)   | Beta / feedback          | yes (via `link-skills.sh`) |
| [`skills/misc/`](skills/misc/README.md)                 | Rarely used              | **no**                     |
| [`skills/deprecated/`](skills/deprecated/README.md)     | Retired reference copies | **no**                     |

`install.sh` and `scripts/link-skills.sh` skip `deprecated/` and `misc/`.

## Reference

### Engineering

See [Engineering Skills](skills/engineering/README.md) for the full list. Highlights:

- **[grill-with-docs](skills/engineering/grill-with-docs/SKILL.md)** - Grill a plan while updating domain docs.
- **[tdd](skills/engineering/tdd/SKILL.md)** - Test-driven development, red-green-refactor.
- **[diagnosing-bugs](skills/engineering/diagnosing-bugs/SKILL.md)** - Disciplined diagnosis loop.
- **[code-review](skills/engineering/code-review/SKILL.md)** - Standards + Spec review since a fixed point.
- **[to-spec](skills/engineering/to-spec/SKILL.md)** / **[to-tickets](skills/engineering/to-tickets/SKILL.md)** - Spec then tracer-bullet tickets.
- **[delegate](skills/engineering/delegate/SKILL.md)** - Sub-agent driven development (Phoenix).
- **[create-worktree](skills/engineering/create-worktree/SKILL.md)** / **[drop-worktree](skills/engineering/drop-worktree/SKILL.md)** - Parallel branch worktrees (Phoenix).
- **[setup-phoenixtw-skills](skills/engineering/setup-phoenixtw-skills/SKILL.md)** - One-time per-repo hub setup.

### Productivity

See [Productivity Skills](skills/productivity/README.md). Highlights:

- **[grill-me](skills/productivity/grill-me/SKILL.md)** / **[grilling](skills/productivity/grilling/SKILL.md)** - Relentless design interview.
- **[handoff](skills/productivity/handoff/SKILL.md)** - Compact a conversation for another agent.

### In progress / misc / deprecated

- [In progress](skills/in-progress/README.md) - beta skills, linked locally.
- [Misc](skills/misc/README.md) - rarely used; not installed.
- [Deprecated](skills/deprecated/README.md) - retired Phoenix forks kept for reference only.

## Typical flow

```
1. Align on the plan
   /grill-me  or  /grill-with-docs

2. Document requirements
   /to-spec

3. Break into implementable pieces
   /to-tickets

4. Pick a piece and work on it
   /create-worktree
   /tdd
   /implement

   OR delegate the whole plan
   /delegate

5. Debug when things break
   /diagnosing-bugs

6. Review and clean up
   /code-review
   /drop-worktree
```

## License

MIT.

- Phoenix-authored material: Copyright (c) 2026 Kaustav Chakraborty (see [`LICENSE`](LICENSE)).
- Skills copied from [mattpocock/skills](https://github.com/mattpocock/skills): Copyright (c) 2026 Matt Pocock, MIT, with attribution above.
