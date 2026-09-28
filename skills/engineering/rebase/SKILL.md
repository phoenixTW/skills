---
name: rebase
description: Rebase the current branch onto origin/<base> (usually origin/main), then force-with-lease push. Use when the user says /rebase, "rebase onto main", "update my branch with main", or "rebase origin/main".
---

# Rebase

Rebase current branch onto `origin/<base>`. Push with lease after.

## Steps

### 1 — Dirty check

```bash
git status --porcelain
```

Any output → stop. User clean or stash first.

### 2 — Fetch

```bash
git fetch origin
```

### 3 — Resolve base

User named a base (`/rebase develop`, "onto staging") → use that.

Else:

1. PR base: `gh pr view --json baseRefName -q .baseRefName` (if PR exists)
2. Remote default: `basename "$(git symbolic-ref refs/remotes/origin/HEAD)"`
3. Fallback: `main`

### 4 — Rebase

```bash
git rebase origin/<base>
```

Conflict → follow `/resolving-merge-conflicts` until rebase done. Then continue step 5.

### 5 — Push

Upstream set:

```bash
git push --force-with-lease
```

No upstream:

```bash
git push --force-with-lease -u origin HEAD
```

Lease rejected → stop. Never bare `--force` unless user explicitly orders it.

### 6 — Confirm

Report: current branch, base used, push result.

## Edge cases

- **Detached HEAD**: stop. Checkout branch first.
- **Already up to date**: report clean; push only if local/remote diverge.
- **No `gh` / no PR**: skip PR step; use remote default or `main`.
