# PhoenixTW Skills

Agent skills for real engineering - not vibe coding.

## Quickstart (30-second setup)

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

---

## What This Is

A collection of skills that help you build real software with AI agents.

Most coding workflows today are either too rigid (automation that takes away control) or too loose (random prompts that produce inconsistent results). These skills occupy the middle ground: they provide structure without automation, guidance without prescription.

Each skill is:
- **Small** - Does one thing well
- **Composable** - Works alongside other skills
- **Model-agnostic** - Works with any AI agent
- **Practical** - Based on real engineering challenges

They're not a framework. They're not a methodology. They're a toolkit you can pick from as needed.

---

## The Problems These Skills Solve

### Problem: Misalignment

You describe what you want. The agent builds something else.

This isn't an AI problem—it's a communication problem. The same issue existed before AI, when requirements were passed from product to engineering. The solution is the same: ask better questions up front.

**The fix**: Use `/grill` before you start coding. The skill interrogates your plan until every edge case is covered and every dependency is clear.

---

### Problem: Verbose Output

The agent writes paragraphs where a sentence would suffice.

Agents don't know your project's vocabulary. They invent terms. They over-explain concepts that are second nature to you. This wastes tokens and makes conversation tedious.

**The fix**: Build a shared language. Maintain a `CONTEXT.md` file that captures your project's domain concepts, jargon, and decisions. When the agent knows your vocabulary, it speaks your language.

---

### Problem: Code Doesn't Work

The plan was solid, but the implementation is buggy.

This happens when the agent lacks feedback. Without tests, without running code, without observing actual behavior, the agent is guessing. Fast iteration requires fast feedback loops.

**The fix**: Use `/tdd` to implement features test-first. Use `/diagnose` to debug systematically. Both skills enforce practices that give the agent immediate feedback on whether its code actually works.

---

### Problem: Codebase Becomes Unmaintainable

Each PR adds complexity. Over time, the codebase becomes harder to understand, harder to modify, harder to ship.

Agents amplify this. They can generate code faster than humans, which means they can generate complexity faster too. Without deliberate attention to design, entropy accelerates.

**The fix**: Skills that emphasize design at every step. `/to-prd` forces you to think about modules before implementation. `/zoom-out` provides system context before making local changes. `/coding-standards` keeps quality consistent across the team.

---

## How These Skills Work Together

A typical feature workflow:

```
1. Align on the plan
   /grill

2. Document requirements
   /to-prd

3. Break into implementable pieces
   /to-issues

4. Pick a piece and work on it
   /create-worktree
   /tdd

5. Debug when things break
   /diagnose

6. Clean up when done
   /drop-worktree
```

Each skill has a specific purpose. Combine them as needed.

---

## Reference

### Engineering Skills

For daily code work.

- **[caveman](skills/engineering/caveman/SKILL.md)** — Reduces verbosity. Drop filler words, keep technical meaning. Cuts token usage by ~75%.

- **[coding-standards](skills/engineering/coding-standards/SKILL.md)** — Reference for clean code patterns in Go, TypeScript, React, and Node.js. Naming, error handling, API design, testing.

- **[create-worktree](skills/engineering/create-worktree/SKILL.md)** — Create git worktrees for parallel development. Keeps branches isolated and organized.

- **[diagnose](skills/engineering/diagnose/SKILL.md)** — Systematic debugging workflow. Reproduce → minimize → hypothesize → instrument → fix → regression test.

- **[drop-worktree](skills/engineering/drop-worktree/SKILL.md)** — Safely remove worktrees and branches. Checks for open PRs before deletion.

- **[grill](skills/engineering/grill/SKILL.md)** — Grills your plan until every decision is explicit. Catches edge cases before coding.

- **[setup-phoenixtw-skills](skills/engineering/setup-phoenixtw-skills/SKILL.md)** — One-time per-repo setup. Configures issue tracker, triage labels, and documentation locations.

- **[tdd](skills/engineering/tdd/SKILL.md)** — Test-driven development with red-green-refactor loop. Emphasizes vertical slices, good test design, and testable interfaces. Bundled with resources on [deep modules](skills/engineering/tdd/deep-modules.md), [interface design](skills/engineering/tdd/interface-design.md), [mocking](skills/engineering/tdd/mocking.md), [refactoring](skills/engineering/tdd/refactoring.md), and [test quality](skills/engineering/tdd/tests.md).

- **[zoom-out](skills/engineering/zoom-out/SKILL.md)** — Get high-level context for unfamiliar code. Shows module map, data flow, and architectural decisions.

### Product Skills

For planning and issue management.

- **[to-issues](skills/product/to-issues/SKILL.md)** — Break plans into independently-grabbable issues using vertical slices. Each issue cuts through all layers and is deployable on its own.

- **[to-prd](skills/product/to-prd/SKILL.md)** — Synthesize conversation context into a PRD. Captures problem statement, user stories, implementation decisions, and scope.

---

## Usage Examples

### Starting a new feature

```
User: I want to add user authentication to my app.

Agent: Let me ask some questions about this plan...

[grill clarifies edge cases, dependencies, requirements]

User: [answers]

Agent: I'll create a PRD from what we discussed...

[to-prd generates PRD with user stories, modules, testing decisions]

Agent: Should I break this into issues?

User: Yes.

Agent: [to-issues creates vertical slices]

Created 5 issues:
- PROJ-124: Setup authentication database schema (AFK)
- PROJ-125: Implement login API endpoint (AFK)
- PROJ-126: Design login UI components (HITL)
- PROJ-127: Implement JWT token validation (AFK)
- PROJ-128: Add logout functionality (AFK)
```

### Debugging a bug

```
User: The login is throwing an error.

Agent: Let me diagnose this systematically.

[diagnose reproduces the issue]

Reproducing the error...
Found: Token validation fails for valid tokens.

[diagnose minimizes]

Confirmed: Issue only occurs with tokens created before today.

[diagnose hypothesizes]

Hypothesis: Token expiration logic changed but old tokens weren't invalidated.

[diagnose instruments]

Adding logging to token generation...

[diagnose fixes]

Fix: Use consistent expiration time for all tokens.

[diagnose adds regression test]

Added test: TestLogin_AcceptValidTokens.

Bug fixed.
```

### Understanding complex code

```
User: I don't understand this payment code.

Agent: [zoom-out provides context]

## Payment System Architecture

Flow:
  PaymentController → PaymentService → StripeAdapter → WebhookHandler

Entities:
  - Payment: Attempt to charge a payment method
  - Transaction: Individual transfer of funds
  - Refund: Money returned to customer

Related modules:
  - AccountService: Validates customer accounts
  - NotificationService: Sends payment confirmations
  - AuditLog: Records payment events

Decision history:
  - docs/adr/2024-01-payment-gateway.md: Chose Stripe over custom integration
```

---

## See Also

- [Engineering Skills](skills/engineering/README.md) — Detailed documentation for engineering skills
- [Product Skills](skills/product/README.md) — Detailed documentation for product skills

---

## License

MIT
