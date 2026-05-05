# PhoenixTW Skills

Agent skills for real engineering - not vibe coding.

Developing real applications is hard. Approaches like GSD, BMAD, and Spec-Kit try to help by owning the process. But while doing so, they take away your control and make bugs in the process hard to resolve.

These skills are designed to be small, easy to adapt, and composable. They work with any model. They're based on decades of engineering experience. Hack around with them. Make them your own. Enjoy.

## Quickstart (30-second setup)

1. Run the installer:

```bash
bash install.sh
```

Or via npx:

```bash
npx phoenixtw-skills
```

2. Pick which skills you want, and which coding agents you want to install them on.

3. Run `/setup-phoenixtw-skills` in your agent. It will:
   - Ask you which issue tracker you want to use (GitHub, GitLab, or local files)
   - Ask you what labels you apply to tickets when you triage them
   - Ask you where you want to save any docs we create

4. Bam - you're ready to go.

---

## Why These Skills Exist

I built these skills as a way to fix common failure modes I see with coding agents.

### #1: The Agent Didn't Do What I Want

> "No-one knows exactly what they want"
>
> David Thomas & Andrew Hunt, [The Pragmatic Programmer](https://www.amazon.co.uk/Pragmatic-Programmer-Anniversary-Journey-Mastery/dp/B0833F1T3V)

**The Problem**. The most common failure mode in software development is misalignment. You think the dev knows what you want. Then you see what they've built - and you realize it didn't understand you at all.

This is just the same in the AI age. There is a communication gap between you and the agent. The fix for this is a **grilling session** - getting the agent to ask you detailed questions about what you're building.

**The Fix** is to use:

- [`roast-my-plan`](skills/engineering/roast-my-plan/SKILL.md) - Grill yourself on plans and designs

These skills help you align with the agent before you get started, and think deeply about the change you're making. Use them _every_ time you want to make a change.

### #2: The Agent Is Way Too Verbose

> With a ubiquitous language, conversations among developers and expressions of the code are all derived from the same domain model.
>
> Eric Evans, [Domain-Driven-Design](https://www.amazon.co.uk/Domain-Driven-Design-Tackling-Complexity-Software/dp/0321125215)

**The Problem**: At the start of a project, devs and the people they're building the software for (the domain experts) are usually speaking different languages.

I felt the same tension with my agents. Agents are usually dropped into a project and asked to figure out the jargon as they go. So they use 20 words where 1 will do.

**The Fix** for this is a shared language. It's a document that helps agents decode the jargon used in the project.

<details>
<summary>
Example
</summary>

Here's an example [`CONTEXT.md`](https://example.com/CONTEXT.md). Which one is easier to read?

- **BEFORE**: "There's a problem when a lesson inside a section of a course is made 'real' (i.e. given a spot in the file system)"
- **AFTER**: "There's a problem with the materialization cascade"

This concision pays off session after session.

</details>

> [!TIP]
> A shared language has many other benefits than reducing verbosity:
>
> - **Variables, functions and files are named consistently**, using the shared language
> - As a result, the **codebase is easier to navigate** for the agent
> - The agent also **spends fewer tokens on thinking**, because it has access to a more concise language

### #3: The Code Doesn't Work

> "Always take small, deliberate steps. The rate of feedback is your speed limit. Never take on a task that's too big."
>
> David Thomas & Andrew Hunt, [The Pragmatic Programmer](https://www.amazon.co.uk/Pragmatic-Programmer-Anniversary-Journey-Mastery/dp/B0833F1T3V)

**The Problem**: Let's say that you and the agent are aligned on what to build. What happens when the agent _still_ produces crap?

It's time to look at your feedback loops. Without feedback on how the code it produces actually runs, the agent will be flying blind.

**The Fix**: You need the usual tranche of feedback loops: static types, browser access, and automated tests.

For automated tests, a red-green-refactor loop is critical. This is where the agent writes a failing test first, then fixes the test. This helps give the agent a consistent level of feedback that results in far better code.

I've built a **[`tdd`](skills/engineering/tdd/SKILL.md)** skill you can slot into any project. It encourages red-green-refactor and gives the agent plenty of guidance on what makes good and bad tests.

For debugging, I've also built a **[`diagnose`](skills/engineering/diagnose/SKILL.md)** skill that wraps best debugging practices into a simple loop.

### #4: We Built A Ball Of Mud

> "Invest in the design of the system _every day_."
>
> Kent Beck, [Extreme Programming Explained](https://www.amazon.co.uk/Extreme-Programming-Explained-Embrace-Change/dp/0321278658)

> "The best modules are deep. They allow a lot of functionality to be accessed through a simple interface."
>
> John Ousterhout, [A Philosophy Of Software Design](https://www.amazon.co.uk/Philosophy-Software-Design-2nd/dp/173210221X)

**The Problem**: Most apps built with agents are complex and hard to change. Because agents can radically speed up coding, they also accelerate software entropy. Codebases get more complex at an unprecedented rate.

**The Fix** for this is a radical new approach to AI-powered development: caring about the design of the code.

This is built in to every layer of these skills:

- [`to-prd`](skills/product/to-prd/SKILL.md) quizzes you about which modules you're touching before creating a PRD
- [`zoom-out`](skills/engineering/zoom-out/SKILL.md) tells the agent to explain code in the context of the whole system
- [`coding-standards`](skills/engineering/coding-standards/SKILL.md) provides universal coding standards for maintainable code

## Summary

Software engineering fundamentals matter more than ever. These skills are my best effort at condensing these fundamentals into repeatable practices, to help you ship the best apps of your career. Enjoy.

---

## Reference

### Engineering

Skills for daily code work.

- **[caveman](skills/engineering/caveman/SKILL.md)** — Ultra-compressed communication mode. Cuts token usage ~75% by dropping filler while keeping full technical accuracy.
- **[coding-standards](skills/engineering/coding-standards/SKILL.md)** — Universal coding standards, best practices, and patterns for Go, TypeScript, JavaScript, React, and Node.js development.
- **[create-worktree](skills/engineering/create-worktree/SKILL.md)** — Creates a git worktree for a ticket, feature, or branch using conventional commit type + ticket ID + title naming.
- **[diagnose](skills/engineering/diagnose/SKILL.md)** — Disciplined diagnosis loop for hard bugs and performance regressions: reproduce → minimise → hypothesise → instrument → fix → regression-test.
- **[drop-worktree](skills/engineering/drop-worktree/SKILL.md)** — Safely removes a git worktree and its branch, checking for open PRs before destruction.
- **[roast-my-plan](skills/engineering/roast-my-plan/SKILL.md)** — Grill user hard on plan/design until shared understanding. Walk every branch in decision tree, resolve each dependency.
- **[setup-phoenixtw-skills](skills/engineering/setup-phoenixtw-skills/SKILL.md)** — Scaffold the per-repo config (issue tracker, triage label vocabulary, domain doc layout) that the other engineering skills consume. Run once per repo before using `to-issues`, `to-prd`, `diagnose`, `tdd`, or `zoom-out`.
- **[tdd](skills/engineering/tdd/SKILL.md)** — Test-driven development with red-green-refactor loop. Builds features or fixes bugs one vertical slice at a time. Bundled with resources on [deep modules](skills/engineering/tdd/deep-modules.md), [interface design](skills/engineering/tdd/interface-design.md), [mocking guidelines](skills/engineering/tdd/mocking.md), [refactoring](skills/engineering/tdd/refactoring.md), and [test quality](skills/engineering/tdd/tests.md).
- **[zoom-out](skills/engineering/zoom-out/SKILL.md)** — Tell the agent to zoom out and give broader context or a higher-level perspective on an unfamiliar section of code.

### Product

Skills for product planning and issue management.

- **[to-issues](skills/product/to-issues/SKILL.md)** — Break any plan, spec, or PRD into independently-grabbable issues using vertical slices (tracer bullets).
- **[to-prd](skills/product/to-prd/SKILL.md)** — Turn the current conversation context into a PRD and submit it as an issue. No interview — just synthesizes what you've already discussed.

---

## Usage Examples

### Starting a New Feature

```
User: I want to add user authentication to my app.

Agent: Let me grill you on this plan first...

[roast-my-plan kicks in, asks detailed questions]

User: [answers questions]

Agent: Got it. Now let me turn this into a PRD...

[to-prd creates a PRD with user stories and implementation decisions]

Agent: I've created PRD #123. Should I break it into issues?

User: Yes.

Agent: [to-issues breaks PRD into vertical slices]

I've created 5 issues:
- PROJ-124: Setup authentication database schema (AFK)
- PROJ-125: Implement login API endpoint (AFK)
- PROJ-126: Design login UI components (HITL)
- PROJ-127: Implement JWT token validation (AFK)
- PROJ-128: Add logout functionality (AFK)
```

### Debugging a Bug

```
User: The login is throwing an error when I try to log in.

Agent: Let me diagnose this systematically...

[diagnose follows: reproduce → minimise → hypothesise → instrument → fix → regression-test]

Reproducing the error...
Found the issue in the token validation logic.
Hypothesis: JWT secret is not being loaded correctly.
Instrumenting to verify...

[agent adds logging, tests hypothesis]

Hypothesis confirmed. Fixing now...

[agent fixes the issue]

Writing regression test...
Regression test added.

Bug fixed! Added test in tests/auth/login_test.go.
```

### Working on Multiple Features

```
User: I need to work on two different features at once.

Agent: Let me create worktrees for you.

[create-worktree creates two isolated working directories]

Created worktrees:
- feat/PROJ-100-user-profile at /project/feat/PROJ-100-user-profile
- fix/PROJ-101-login-bug at /project/fix/PROJ-101-login-bug

You can now work on both features independently without stashing changes.

User: I'm done with the login bug.

Agent: [drop-worktree checks for PRs, removes worktree and branch]

Worktree removed. Branch fix/PROJ-101-login-bug deleted.

Worktrees remaining:
- feat/PROJ-100-user-profile
```

### Understanding Complex Code

```
User: I don't understand this payment processing code.

Agent: [zoom-out expands to show full context]

Here's the payment processing system architecture:

## Module Map

Payment Flow:
  - PaymentController (entry point)
    ↓
  - PaymentService (business logic)
    ↓
  - StripeAdapter (payment gateway)
    ↓
  - WebhookHandler (async events)

Key entities:
  - Payment: Represents a payment attempt
  - Transaction: Individual money transfer
  - Refund: Money returned to customer

Related modules:
  - AccountService: Validates customer accounts
  - NotificationService: Sends payment confirmations
  - AuditLog: Records all payment events

See docs/adr/2024-01-payment-gateway.md for why we chose Stripe.
```

---

## Changelog

### v1.0.0 (2025-05-05)

**Initial release**

#### Engineering Skills
- `roast-my-plan` - Design grilling for alignment
- `coding-standards` - Universal coding standards for Go, TypeScript, React, Node.js
- `create-worktree` / `drop-worktree` - Git worktree management
- `diagnose` - Systematic debugging workflow
- `setup-phoenixtw-skills` - Per-repo configuration
- `tdd` - Test-driven development with bundled resources
- `zoom-out` - High-level code context
- `caveman` - Token-efficient communication

#### Product Skills
- `to-issues` - Break down plans into vertical slices
- `to-prd` - Create PRDs from conversation context

#### Installation
- Added `install.sh` script for interactive skill installation
- Added `package.json` for npx support
- Support for multiple agent directories (Claude, Pi, Cursor, etc.)

---

## See Also

- [Engineering Skills](skills/engineering/README.md) - Detailed documentation for engineering skills
- [Product Skills](skills/product/README.md) - Detailed documentation for product skills

---

## License

MIT
