# PhoenixTW Skills

Agent skills hub for real engineering. Owned copies of skills used day to day (Matt Pocock's set plus Phoenix customs), organized into installable buckets.

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

3. Run `/setup-phoenixtw-skills` in your agent. It will:
   - Ask which issue tracker to use (GitHub, GitLab, or local files)
   - Ask what labels you apply when triaging tickets
   - Ask where to save documentation

4. Done. You're ready to ship.

Maintainers linking every promoted skill into local harness dirs:

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

- **[grill-with-docs](skills/engineering/grill-with-docs/SKILL.md)** — Grill a plan while updating domain docs.
- **[tdd](skills/engineering/tdd/SKILL.md)** — Test-driven development, red-green-refactor.
- **[diagnosing-bugs](skills/engineering/diagnosing-bugs/SKILL.md)** — Disciplined diagnosis loop.
- **[code-review](skills/engineering/code-review/SKILL.md)** — Standards + Spec review since a fixed point.
- **[to-spec](skills/engineering/to-spec/SKILL.md)** / **[to-tickets](skills/engineering/to-tickets/SKILL.md)** — Spec then tracer-bullet tickets.
- **[delegate](skills/engineering/delegate/SKILL.md)** — Sub-agent driven development (Phoenix).
- **[create-worktree](skills/engineering/create-worktree/SKILL.md)** / **[drop-worktree](skills/engineering/drop-worktree/SKILL.md)** — Parallel branch worktrees (Phoenix).
- **[setup-phoenixtw-skills](skills/engineering/setup-phoenixtw-skills/SKILL.md)** — One-time per-repo hub setup.

### Productivity

See [Productivity Skills](skills/productivity/README.md). Highlights:

- **[grill-me](skills/productivity/grill-me/SKILL.md)** / **[grilling](skills/productivity/grilling/SKILL.md)** — Relentless design interview.
- **[handoff](skills/productivity/handoff/SKILL.md)** — Compact a conversation for another agent.

### In progress / misc / deprecated

- [In progress](skills/in-progress/README.md) — beta skills, linked locally.
- [Misc](skills/misc/README.md) — rarely used; not installed.
- [Deprecated](skills/deprecated/README.md) — retired Phoenix forks kept for reference only.

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

MIT
