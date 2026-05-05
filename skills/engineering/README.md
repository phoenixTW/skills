# Engineering Skills

These skills are for daily code work - from debugging and testing to code review and architecture.

## Setup

Before using any of these skills, run `/setup-phoenixtw-skills` once per repository to configure:

- **Issue tracker** - Where issues live (GitHub, GitLab, or local markdown)
- **Triage labels** - Label vocabulary for the triage state machine
- **Domain docs** - Location of `CONTEXT.md` and ADRs

This one-time setup ensures all engineering skills can read and write to your chosen systems.

---

## Core Skills

### [caveman](./caveman/SKILL.md)

**Ultra-compressed communication mode.**

Cuts token usage by ~75% by dropping filler, articles, and pleasantries while keeping full technical accuracy.

**When to use:**
- When the agent is being too verbose
- When you want faster responses
- When running low on token budget
- Invoke with "caveman mode", "talk like caveman", "use caveman", "less tokens", or "be brief"

**Example:**

```
User: caveman mode

Agent: Need fix. Where code?
```

---

### [coding-standards](./coding-standards/SKILL.md)

**Universal coding standards, best practices, and patterns.**

Provides comprehensive standards for Go, TypeScript, JavaScript, React, and Node.js development. Covers naming conventions, error handling, API design, testing standards, and code quality principles.

**When to use:**
- Starting a new service, package, or module
- Reviewing code for quality and maintainability
- Refactoring legacy code to follow conventions
- Enforcing naming, formatting, or structural consistency
- Setting up linting, formatting, or type-checking rules
- Onboarding contributors to shared standards

**Key principles covered:**
- **Readability First** - Clear names, self-documenting code
- **KISS** (Keep It Simple, Stupid) - Simplest solution that works
- **DRY** (Don't Repeat Yourself) - Extract shared logic
- **YAGNI** (You Aren't Gonna Need It) - Build when needed

**Topics:**
- Variable and function naming
- Immutability patterns (CRITICAL)
- Error handling best practices
- Concurrency patterns
- Type safety
- REST API conventions
- File organization
- When to comment (explain WHY, not WHAT)
- Performance best practices
- Testing standards (AAA pattern)
- Code smell detection

---

### [create-worktree](./create-worktree/SKILL.md)

**Create git worktrees for parallel feature development.**

Creates isolated git worktrees for tickets, features, or branches. Uses conventional commit type + ticket ID + title naming convention.

**When to use:**
- Need to work on multiple features simultaneously
- Starting work on a ticket or feature
- Setting up branches for fixes, features, or chores

**Triggers on:**
- "create worktree"
- "start work on ticket X"
- "new worktree for TICKET-123"
- "set up branch for fix/feat/chore"

**Naming convention:**

```bash
feat/PROJ-123-user-auth-flow    # New feature
fix/GH-42-login-redirect        # Bug fix
chore/PROJ-100-update-deps      # Maintenance
```

**Workflow:**

1. Agent gathers: commit type, ticket ID, short title
2. Creates branch: `<type>/<ticket-id>-<slugified-title>`
3. Creates worktree at: `<git-root>/<type>/<ticket-id>-<slugified-title>`
4. Auto-updates `.gitignore` for the type prefix
5. Confirms with `git worktree list`

**Example:**

```
User: Create a worktree for ticket PROJ-100

Agent: What type? (feat, fix, chore, refactor, docs, test)
User: feat
Agent: What's the short title?
User: user authentication flow

Creating worktree: feat/PROJ-100-user-auth-flow
Path: /project/feat/PROJ-100-user-auth-flow

Created! cd /project/feat/PROJ-100-user-auth-flow to start.
```

---

### [diagnose](./diagnose/SKILL.md)

**Systematic debugging workflow for hard bugs.**

A disciplined loop for diagnosing hard bugs and performance regressions: reproduce → minimise → hypothesise → instrument → fix → regression-test.

**When to use:**
- User says "diagnose this" / "debug this"
- Reports a bug
- Says something is broken/throwing/failing
- Describes a performance regression

**Workflow:**

1. **Reproduce** - Get the bug to happen consistently
2. **Minimise** - Strip away unnecessary context
3. **Hypothesise** - Formulate a theory about the cause
4. **Instrument** - Add logging, tracing, or breakpoints
5. **Fix** - Implement the fix
6. **Regression-test** - Add test to prevent recurrence

**Key principles:**
- Don't skip phases unless explicitly justified
- Use the project's domain glossary for clarity
- Check ADRs in the area you're touching
- Always add regression tests

---

### [drop-worktree](./drop-worktree/SKILL.md)

**Safely remove git worktrees and branches.**

Removes a git worktree and its branch after checking for open PRs. Prevents accidental deletion of work with active PRs.

**When to use:**
- Finished work on a branch
- Need to clean up worktrees
- Says "I'm done with branch X"
- Asks to delete, remove, drop, or clean up a worktree

**Safety checks:**

1. Lists all worktrees (excluding main)
2. Checks for open GitHub PRs on the branch
3. **Stops and asks for confirmation** if PR is open
4. Warns about uncommitted changes
5. Asks before force-deleting uncommitted work
6. Offers to delete both worktree and branch

**Example:**

```
User: I'm done with feat/PROJ-100-user-auth-flow

Agent: Checking for open PRs...

Found open PR: #123 "Add user authentication flow"
Delete anyway? (all uncommitted changes will be lost)
User: No

Aborted. Please close or merge PR #123 first.
```

---

### [roast-my-plan](./roast-my-plan/SKILL.md)

**Design grilling for alignment.**

Grills the user relentlessly on every part of a plan until shared understanding is reached. Walks each branch of the design tree and resolves decision dependencies one by one.

**When to use:**
- User wants stress test of a plan
- Design grilling before implementation
- Says "roast my plan"
- Starting a new feature or major change

**Workflow:**

1. Asks questions one at a time
2. Provides recommended answers
3. Inspects codebase first if it can answer the question
4. Resolves dependencies systematically
5. Continues until all branches are covered

**Benefits:**
- Catches edge cases early
- Uncovers hidden dependencies
- Aligns understanding before coding
- Saves time by finding problems upfront

---

### [setup-phoenixtw-skills](./setup-phoenixtw-skills/SKILL.md)

**Per-repo configuration for engineering skills.**

Scaffolds the per-repo configuration that other engineering skills consume. Run once per repository before using `to-issues`, `to-prd`, `diagnose`, `tdd`, or `zoom-out`.

**When to use:**
- First time using PhoenixTW skills in a repo
- After skills appear missing context about issue tracker, triage labels, or domain docs
- When switching issue trackers

**What it sets up:**

1. **Issue tracker** - Where issues live
   - GitHub (uses `gh` CLI)
   - GitLab (uses `glab` CLI)
   - Local markdown (files under `.scratch/`)
   - Other (custom workflow)

2. **Triage labels** - Label vocabulary
   - `needs-triage` - Needs evaluation
   - `needs-info` - Waiting on reporter
   - `ready-for-agent` - AFK-ready
   - `ready-for-human` - Needs human
   - `wontfix` - Won't action

3. **Domain docs** - Layout and location
   - Single-context (one `CONTEXT.md` at root)
   - Multi-context (monorepo with `CONTEXT-MAP.md`)

**Bundled resources:**
- [issue-tracker-github.md](./setup-phoenixtw-skills/issue-tracker-github.md) - GitHub configuration template
- [issue-tracker-gitlab.md](./setup-phoenixtw-skills/issue-tracker-gitlab.md) - GitLab configuration template
- [issue-tracker-local.md](./setup-phoenixtw-skills/issue-tracker-local.md) - Local markdown configuration template
- [triage-labels.md](./setup-phoenixtw-skills/triage-labels.md) - Triage label mapping
- [domain.md](./setup-phoenixtw-skills/domain.md) - Domain doc consumer rules

**Process:**

1. Explores the repo to understand current state
2. Presents findings and asks questions one at a time
3. Confirms configuration with user
4. Writes `docs/agents/` files
5. Updates `CLAUDE.md` or `AGENTS.md` with agent skills section

---

### [tdd](./tdd/SKILL.md)

**Test-driven development with red-green-refactor loop.**

Encourages test-first development through a disciplined red-green-refactor cycle. Builds features or fixes bugs one vertical slice at a time.

**When to use:**
- Building features using TDD
- Fixing bugs with regression tests
- Mentions "red-green-refactor"
- Wants integration tests
- Asks for test-first development

**Core philosophy:**

> Tests should verify behavior through public interfaces, not implementation details. Code can change entirely; tests shouldn't.

**Anti-pattern: Horizontal Slices**

❌ **DON'T** write all tests first, then all implementation. This produces crap tests that test imagined behavior, not actual behavior.

✅ **DO** use vertical slices via tracer bullets: one test → one implementation → repeat.

**Workflow:**

1. **Planning**
   - Confirm interface changes needed
   - Confirm which behaviors to test
   - Identify deep module opportunities
   - Design interfaces for testability
   - List behaviors to test (not implementation steps)

2. **Tracer Bullet**
   - Write ONE test for ONE behavior
   - Test fails (RED)
   - Write minimal code to pass (GREEN)

3. **Incremental Loop**
   - Repeat for remaining behaviors
   - One test at a time
   - Only enough code to pass current test
   - Don't anticipate future tests

4. **Refactor**
   - Extract duplication
   - Deepen modules
   - Apply SOLID principles where natural
   - Run tests after each refactor step

**Checklist per cycle:**

```
[ ] Test describes behavior, not implementation
[ ] Test uses public interface only
[ ] Test would survive internal refactor
[ ] Code is minimal for this test
[ ] No speculative features added
```

**Bundled resources:**

- [deep-modules.md](./tdd/deep-modules.md) - Small interface, deep implementation
- [interface-design.md](./tdd/interface-design.md) - Designing testable interfaces
- [mocking.md](./tdd/mocking.md) - Guidelines for when to mock
- [refactoring.md](./tdd/refactoring.md) - Refactoring candidates
- [tests.md](./tdd/tests.md) - Good vs bad test examples

**Good tests:**

- Integration-style, test through real interfaces
- Test observable behavior, not implementation
- Use public API only
- Survive internal refactors
- Describe WHAT, not HOW

**Bad tests:**

- Mock internal collaborators
- Test private methods
- Assert on call counts/order
- Break when refactoring without behavior change
- Verify through external means instead of interface

---

### [zoom-out](./zoom-out/SKILL.md)

**High-level context for unfamiliar code.**

Tells the agent to zoom out and provide broader context or a higher-level perspective on an unfamiliar section of code.

**When to use:**
- Unfamiliar with a section of code
- Need to understand how something fits into the bigger picture
- Say "zoom out" or "give me context on X"

**Output:**

The agent provides:
- A map of all relevant modules
- Callers and callees
- How the code fits into the system
- Uses the project's domain glossary vocabulary

**Example:**

```
User: zoom out on this payment code

Agent: Here's the payment processing system architecture:

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

## Skill Dependencies

Some skills depend on `/setup-phoenixtw-skills` being run first:

| Skill | Requires setup-phoenixtw-skills? | Why |
|-------|--------------------------------|-----|
| `to-issues` | ✅ Yes | Needs issue tracker and triage labels |
| `to-prd` | ✅ Yes | Needs issue tracker and triage labels |
| `diagnose` | ✅ Yes | Reads domain glossary from CONTEXT.md |
| `tdd` | ✅ Yes | Uses domain vocabulary in test names |
| `zoom-out` | ✅ Yes | Uses domain glossary for explanations |

**Other skills work standalone:**
- `roast-my-plan` - No setup needed
- `coding-standards` - No setup needed
- `create-worktree` - No setup needed
- `drop-worktree` - No setup needed
- `caveman` - No setup needed

---

## Typical Workflow

Here's how these skills work together in a typical development session:

```
1. Start with /roast-my-plan
   → Align on what to build

2. Use /to-prd
   → Create a PRD from the aligned plan

3. Use /to-issues
   → Break the PRD into vertical slices

4. Run /create-worktree for the first issue
   → Set up isolated working environment

5. Use /tdd to implement the first slice
   → Test-first development with red-green-refactor

6. Use /diagnose if bugs appear
   → Systematic debugging

7. Use /zoom-out when confused
   → Get high-level context

8. Run /drop-worktree when done
   → Clean up the worktree

9. Repeat for remaining issues
```

---

## See Also

- [Product Skills](../product/README.md) - Skills for planning and issue management
- [Root README](../../README.md) - Main documentation with quickstart guide
