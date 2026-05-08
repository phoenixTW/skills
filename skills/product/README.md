# Product Skills

These skills help with product planning, requirements gathering, and issue management. They transform ideas into actionable plans and break down complex features into manageable tasks.

## Setup

Before using these skills, run `/setup-phoenixtw-skills` once per repository to configure:

- **Issue tracker** - Where issues live (GitHub, GitLab, or local markdown)
- **Triage labels** - Label vocabulary for the triage state machine
- **Domain docs** - Location of `CONTEXT.md` and ADRs

This one-time setup ensures product skills can read and write to your chosen systems.

---

## Skills

### [to-issues](./to-issues/SKILL.md)

**Break down plans into independently-grabbable issues.**

Converts any plan, spec, or PRD into a set of issues using vertical slices (tracer bullets). Each issue is a thin vertical slice that cuts through ALL integration layers end-to-end.

**When to use:**
- Convert a plan into issues
- Create implementation tickets
- Break down work into issues
- Split a PRD into actionable tasks

**Workflow:**

1. **Gather context** - Work from whatever is already in the conversation context. If you pass an issue reference, it fetches the full body and comments from the issue tracker.

2. **Explore the codebase** (optional) - If not already explored, the agent understands the current state. Uses domain glossary vocabulary in titles and descriptions.

3. **Draft vertical slices** - Break the plan into **tracer bullet** issues. Each slice:
   - Delivers a narrow but COMPLETE path through every layer (schema, API, UI, tests)
   - Is demoable or verifiable on its own
   - Is either HITL (human-in-the-loop) or AFK (can be done without human interaction)
   - Prefer many thin slices over few thick ones

4. **Quiz the user** - Present the proposed breakdown as a numbered list. For each slice, show:
   - Title
   - Type: HITL / AFK
   - Blocked by: which slices must complete first
   - User stories covered

   Ask:
   - Does the granularity feel right?
   - Are dependency relationships correct?
   - Should any slices be merged or split?
   - Are the correct slices marked as HITL/AFK?

5. **Publish to issue tracker** - For each approved slice, publish a new issue with:
   - Parent reference (if applicable)
   - What to build (end-to-end description, not layer-by-layer)
   - Acceptance criteria
   - Blocked by references

   Apply the `needs-triage` label so each issue enters the normal triage flow.

**Issue template:**

```markdown
## Parent
A reference to the parent issue (if applicable).

## What to build
A concise description of this vertical slice. Describe the end-to-end
behavior, not layer-by-layer implementation.

## Acceptance criteria
- [ ] Criterion 1
- [ ] Criterion 2
- [ ] Criterion 3

## Blocked by
- A reference to the blocking ticket (if any)
Or "None - can start immediately" if no blockers.
```

**Vertical slice rules:**

- Each slice delivers a narrow but COMPLETE path through every layer
- A completed slice is demoable or verifiable on its own
- Prefer many thin slices over few thick ones
- Mark slices as HITL when they require human interaction (architectural decisions, design reviews)
- Mark slices as AFK when they can be implemented and merged without human interaction

**Example:**

```
User: Break this PRD into issues

Agent: I've analyzed the PRD. Here's the proposed breakdown:

1. Setup authentication database schema (AFK)
   - User stories: As a user, I want to create an account
   - Blocked by: None - can start immediately

2. Implement login API endpoint (AFK)
   - User stories: As a user, I want to log in with email/password
   - Blocked by: #1

3. Design login UI components (HITL)
   - User stories: As a user, I want a clean login form
   - Blocked by: #2

4. Implement JWT token validation (AFK)
   - User stories: As a developer, I want secure token validation
   - Blocked by: #2

5. Add logout functionality (AFK)
   - User stories: As a user, I want to log out
   - Blocked by: #4

Does this granularity feel right?

User: Yes, looks good. Merge 3 and 4.

Agent: Merged 3 and 4 into: "Implement login flow with UI and tokens" (HITL)

Publishing issues...

Created issues:
- #101: Setup authentication database schema
- #102: Implement login API endpoint
- #103: Implement login flow with UI and tokens
- #104: Add logout functionality
```

**Key principles:**

- **Vertical slices, not horizontal** - Each issue cuts through ALL layers
- **Independently-grabbable** - Anyone can pick up any issue (with blockers resolved)
- **Demoable** - Each slice produces something testable/demoable
- **Prefer AFK over HITL** - More AFK slices = more parallelizable work

---

### [to-prd](./to-prd/SKILL.md)

**Turn conversation context into a PRD.**

Synthesizes the current conversation context and codebase understanding into a Product Requirements Document (PRD). Does NOT interview the user - just organizes what you've already discussed.

**When to use:**
- User wants to create a PRD from the current context
- Need to document a feature you've been discussing
- Starting a new feature and want to capture requirements

**Workflow:**

1. **Explore the repo** - Understand the current state of the codebase, if not already done. Use the project's domain glossary vocabulary throughout the PRD, and respect any ADRs in the area you're touching.

2. **Sketch out modules** - Identify the major modules that will need to be built or modified. Actively look for opportunities to extract deep modules (small interface, deep implementation, testable in isolation).

3. **Check with user** - Confirm that these modules match expectations and ask which modules need tests.

4. **Write the PRD** - Use the template below to structure the PRD.

5. **Publish to issue tracker** - Submit the PRD as an issue and apply the `needs-triage` label so it enters the normal triage flow.

**PRD template:**

```markdown
## Problem Statement

The problem that the user is facing, from the user's perspective.

## Solution

The solution to the problem, from the user's perspective.

## User Stories

A LONG, numbered list of user stories. Each user story should be in the format:

1. As an <actor>, I want a <feature>, so that <benefit>

This list should be extremely extensive and cover all aspects of the feature.

## Implementation Decisions

A list of implementation decisions that were made. This can include:

- The modules that will be built/modified
- The interfaces of those modules that will be modified
- Technical clarifications from the developer
- Architectural decisions
- Schema changes
- API contracts
- Specific interactions

Do NOT include specific file paths or code snippets. They may end up being outdated very quickly.

## Testing Decisions

A list of testing decisions that were made. Include:

- A description of what makes a good test (only test external behavior, not implementation details)
- Which modules will be tested
- Prior art for the tests (i.e. similar types of tests in the codebase)

## Out of Scope

A description of the things that are out of scope for this PRD.

## Further Notes

Any further notes about the feature.
```

**Example:**

```
User: I want to add user authentication to the app. Users should be able to sign up with email, log in, and reset their password.

Agent: Let me explore the codebase first...

[Agent explores existing code, finds no auth system]

I've explored the codebase. Based on our discussion, here's what I'm planning:

## Modules to build

1. **AuthService** - Handles registration, login, password reset
2. **SessionService** - Manages JWT tokens and sessions
3. **AuthController** - HTTP endpoints for auth operations
4. **PasswordResetService** - Handles password reset flow

Do these match your expectations? Which modules need tests?

User: All of them. Add tests for AuthService and PasswordResetService.

Agent: Got it. Writing PRD...

[Agent creates comprehensive PRD with user stories, implementation decisions, testing decisions]

PRD created! I'll publish it as issue #100 with label needs-triage.

https://github.com/phoenixtw/project/issues/100
```

**Key principles:**

- **Synthesize, don't interview** - This skill organizes what you've already discussed
- **Use domain language** - Apply the project's glossary vocabulary throughout
- **Respect ADRs** - Check for existing decisions in the area you're touching
- **Look for deep modules** - Identify opportunities for small interfaces with deep implementation
- **No implementation details** - Keep it high-level (no file paths, no code snippets)

---

## Skill Dependencies

Both product skills require `/setup-phoenixtw-skills` to be run first:

| Skill | Requires setup-phoenixtw-skills? | Why |
|-------|--------------------------------|-----|
| `to-issues` | ✅ Yes | Needs issue tracker for publishing and triage labels for labeling |
| `to-prd` | ✅ Yes | Needs issue tracker for publishing and triage labels for labeling |

---

## Typical Workflow

Here's how product skills work together in a typical planning session:

```
1. Discuss feature idea
   → Back-and-forth conversation about requirements

2. Run /to-prd
   → Synthesize discussion into a formal PRD
   → Publish to issue tracker with needs-triage label

3. Review and refine PRD
   → Iterate on requirements if needed

4. Run /to-issues
   → Break PRD into vertical slices
   → Each slice is independently-grabbable
   → Mark slices as HITL or AFK
   → Publish all slices to issue tracker

5. Team picks up slices
   → Each slice can be worked on independently
   → HITL slices get design reviews first
   → AFK slices can be implemented in parallel
```

## Integration with Engineering Skills

Product skills integrate seamlessly with engineering skills:

```
Product Planning:
  to-prd → to-issues

  ↓

Engineering:
  grill → create-worktree → tdd → drop-worktree

  ↓

Issue Management:
  diagnose (if bugs appear)
  zoom-out (if confused)
```

**Example end-to-end flow:**

```
User: We need to add user authentication.

[Discussion about requirements]

User: /to-prd

Agent: Creating PRD from our discussion...

[Creates comprehensive PRD]

Agent: Should I break this into issues?

User: Yes.

User: /to-issues

Agent: Breaking into vertical slices...

[Creates 5 issues: database setup, API endpoints, UI components, JWT validation, password reset]

User: I'll take the first one.

User: /grill

Agent: Let me grill you on this database schema...

[Detailed alignment on implementation approach]

User: /create-worktree for #101

Agent: Creating worktree: feat/PROJ-101-auth-db

[Worktree created]

User: /tdd

Agent: Starting TDD for database schema...

[Red-green-refactor loop]

User: [Implementation complete]

User: /drop-worktree

Agent: Worktree removed. Ready for next issue!
```

---

## Vertical Slices Explained

**Vertical slices** are thin paths through ALL layers of the system:

```
A vertical slice for "user registration" includes:

┌─────────────────────────────────────┐
│  UI: Registration form component   │  ← Frontend layer
├─────────────────────────────────────┤
│  API: POST /auth/register          │  ← API layer
├─────────────────────────────────────┤
│  Service: AuthService.register()    │  ← Business logic
├─────────────────────────────────────┤
│  DB: users table schema             │  ← Data layer
├─────────────────────────────────────┤
│  Test: Integration test            │  ← Test layer
└─────────────────────────────────────┘
```

**Horizontal slices** (avoid these):

```
❌ Horizontal slice: "Build all APIs"
├── POST /auth/register
├── POST /auth/login
├── POST /auth/reset-password
└── GET /auth/me

This is NOT independently-grabbable - you can't ship
just the APIs without UI, DB, or tests.
```

**Why vertical slices work better:**

- **Independently-grabbable** - Anyone can pick up a slice and ship it
- **Demoable** - Each slice produces a complete feature
- **Less coordination** - Don't need to wait on other layers
- **Faster feedback** - Ship something end-to-end early
- **Risk mitigation** - Problems surface early, not at integration time

---

## HITL vs AFK

**HITL (Human-In-The-Loop)** slices require human interaction:

- Design reviews
- Architectural decisions
- UX/UI polish
- Stakeholder approvals

**AFK** slices can be done without human involvement:

- Database migrations
- API implementation
- Unit tests
- Integration tests

**Why it matters:**

- AFK slices can be done in parallel by agents
- HITL slices create synchronization points
- Maximize AFK slices for faster delivery
- Use HITL slices where human judgment is essential

---

## See Also

- [Engineering Skills](../engineering/README.md) - Skills for code work, debugging, testing
- [Root README](../../README.md) - Main documentation with quickstart guide
