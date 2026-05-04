---
name: create-worktree
description: Use when user wants to create a git worktree for a ticket, feature, fix, or branch. Triggers on "create worktree", "start work on ticket X", "new worktree for TICKET-123", "set up branch for fix/feat/chore". Builds branch name from conventional commit type + ticket ID + title, places worktree inside the project root (not as a sibling).
---

# Create Worktree

Creates a git worktree inside the project root, named after a conventional commit type and ticket ID.

## Gather inputs

If not provided by the user, ask for:

| Input | Example |
|-------|---------|
| Commit type | `feat`, `fix`, `chore`, `refactor`, `docs`, `test` |
| Ticket ID | `PROJ-123`, `GH-42`, `#99` |
| Short title | `user-auth-flow`, `fix-login-redirect` |

Slugify the title: lowercase, replace spaces/underscores with hyphens, strip special chars.

## Construct names

```
branch:   <type>/<ticket-id>-<slugified-title>
path:     <git-root>/<type>/<ticket-id>-<slugified-title>
```

**Examples:**
- `feat/PROJ-123-user-auth-flow` → path `<root>/feat/PROJ-123-user-auth-flow`
- `fix/GH-42-login-redirect` → path `<root>/fix/GH-42-login-redirect`

## Steps

### Step 1 — Find project root

```bash
git rev-parse --show-toplevel
```

All paths are relative to this. Never place the worktree outside it.

### Step 2 — Check branch doesn't exist

```bash
git show-ref --heads refs/heads/<branch-name>
```

If branch already exists → ask user: "Branch already exists. Checkout existing or pick a new name?"

### Step 3 — Create the worktree

```bash
git worktree add -b <branch-name> <git-root>/<branch-name>
```

This creates both the branch and the worktree directory in one command.

### Step 4 — Gitignore the worktree dir (first time per type)

Check if the type prefix is already gitignored:

```bash
grep -qF "/<type>/" <git-root>/.gitignore 2>/dev/null || echo "missing"
```

If missing, append to `.gitignore` automatically:

```
/<type>/
```

### Step 5 — Confirm

```bash
git worktree list
```

Show output so user sees the new worktree. Print the path so they can `cd` to it.

Tell user: `cd <path>` to start working.

## Edge cases

- **Dirty working tree in main**: Worktrees are independent — creation is safe regardless of main state.
- **Type directory already exists** (e.g. `feat/` has another worktree): Fine — multiple worktrees can share the same parent dir.
- **Branch name contains uppercase ticket IDs** (e.g. `PROJ-123`): Keep as-is — do not lowercase ticket IDs.
- **No ticket ID**: If user has no ticket, use a short slug only: `<type>/<slugified-title>`.
