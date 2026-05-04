---
name: drop-worktree
description: Safely remove a git worktree and its branch. Use when user asks to delete, remove, drop, or clean up a worktree, or says "I'm done with branch X". Checks for open GitHub PRs before destroying — prompts user if an active PR exists.
---

# Drop Worktree

**Destructive — always confirm path before removing.**

## Workflow

### Step 1 — Identify target

If user provided a branch name → skip to Step 2.

If no branch given, list all worktrees:
```bash
git worktree list
```
Present the list (excluding main worktree). Ask user which one to drop.

### Step 2 — Resolve worktree path

```bash
git worktree list --porcelain | grep -A2 "<branch-name>"
```
Extract the `worktree` path line. If no match → tell user branch has no worktree.

### Step 3 — Check PR status

```bash
gh pr list --head <branch-name> --json number,title,state --limit 1
```

| Result | Action |
|--------|--------|
| Empty (no PR) | Proceed directly |
| `state: MERGED` or `state: CLOSED` | Proceed directly |
| `state: OPEN` | **Stop — show PR number + title, ask user to confirm deletion** |

If user says no → abort.

### Step 4 — Remove the worktree

```bash
git worktree remove <path>
```

If the worktree has uncommitted changes, `remove` will fail. In that case:
- **Do not silently force.** Tell the user there are uncommitted changes.
- Ask: "Force remove anyway? (all uncommitted changes will be lost)"
- If yes: `git worktree remove --force <path>`

### Step 5 — Delete the branch (optional)

After worktree removal, ask:
> "Also delete the local branch `<branch-name>`?"

If yes, check what exists first:
```bash
git show-ref --heads refs/heads/<branch-name>
```

- **Local ref found** → `git branch -d <branch-name>`. If fails (not fully merged), ask user before `-D`.
- **No local ref** → only a remote tracking ref remains. Delete it:
  ```bash
  git branch -dr origin/<branch-name>
  ```
  Do not attempt `git branch -d` — it will fail with "not found".

### Step 6 — Confirm

```bash
git worktree list
```
Show updated list so user sees it's gone.

## Edge cases

- **Branch is current HEAD**: Cannot remove — tell user to switch branches first.
- **Path already gone (stale worktree)**: Use `git worktree prune` to clean metadata.
- **Multiple PRs on branch**: Show all, warn user, still require explicit confirmation.
