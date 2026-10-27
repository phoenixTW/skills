---
name: github-review
description: "Review a GitHub pull request on the user's behalf and post only the critical findings as inline comments directly on the PR: no review summary, no severity badges, each comment a bold title, a short explanation, and either a GitHub suggestion block or a collapsible How to fix. Reuses code-review's Standards and Spec axes, ranks findings by security, correctness, performance and similar risk, and drafts everything for approval before posting. Use whenever the user shares a PR URL or number and wants it reviewed on GitHub, says 'review this PR and post', 'leave comments on #123', 'do a quick review for X', 'post review on GitHub', or someone asked them for a review they want the agent to handle."
---

Review someone's pull request as the user and leave **inline comments only** on GitHub. The comments go out under the user's name, so every one of them has to be correct, critical, and worth a colleague's attention. A short review of three real bugs beats a long one with ten opinions.

The analysis reuses the two axes from the `code-review` skill (sibling `../code-review/SKILL.md`): **Standards** and **Spec**. This skill adds a risk lens, a strict ranking gate, a GitHub comment format, and a draft → approve → post loop.

`scripts/gh_review.py` handles the mechanical parts: listing existing threads, checking line anchors against the diff, rendering the draft, and posting. GitHub rejects a whole review with a 422 error if any comment points at a line outside the diff, so let the script validate anchors instead of guessing.

## Process

### 1. Resolve the PR

Accept a URL, `owner/repo#N`, or a bare number (bare number = repo in the current directory). Then fetch:

```bash
gh pr view <N> -R <owner/repo> --json url,title,body,headRefOid,baseRefName,headRefName,closingIssuesReferences,files
```

Record `headRefOid`. Every comment anchors to this SHA.

**Code access.** If the current directory is a clone of the same repo (`gh repo view --json nameWithOwner`), run `git fetch origin pull/<N>/head` and work from `git diff origin/<base>...FETCH_HEAD`. Read full files with `git show <sha>:<path>`. Otherwise use `gh pr diff <N> -R <repo>` and read files with `gh api -H "Accept: application/vnd.github.raw" "repos/<repo>/contents/<path>?ref=<sha>"`. Don't check out the branch or touch the user's working tree.

**Existing threads.** Run `scripts/gh_review.py existing <owner/repo> <N>`. Anything already raised on the same issue by Greptile, another bot, or a human gets dropped from your draft. Don't repeat what's already on the PR.

### 2. Gather the spec and standards

- **Spec:** PR title and body, linked issues (`closingIssuesReferences`), and any ticket ID in the title such as `[PROJ-123]`. Fetch the ticket only if a tracker tool is available. If none of these say what the change should do, skip the Spec axis.
- **Standards:** the repo's documented standards (`CODING_STANDARDS.md`, `CONTRIBUTING.md`, `AGENTS.md`, `CLAUDE.md`, linter configs) at the PR's head, plus code-review's smell baseline (code-review step 3).

### 3. Run both axes in parallel

Spawn two sub-agents, as code-review step 4 does, with these changes to the briefs:

**Standards + Risk sub-agent.** Include the diff access commands, the standards files, and code-review's smell baseline. Add the risk lenses: **security** (injection, authz/authn gaps, secret or PII exposure, unsafe deserialization), **correctness** (wrong logic, broken edge cases, nil/null paths, off-by-one), **data integrity** (lost writes, bad migrations, missing transactions), **concurrency** (races, deadlocks, leaked goroutines/promises), **reliability** (swallowed errors, missing timeouts or retries, unbounded resources), **performance** (N+1 queries, hot-path allocations, unbounded loops over user data), and **API contract** (breaking changes to callers, schemas, or wire formats).

**Spec sub-agent.** Same brief as code-review, using the spec gathered in step 2.

Ask both sub-agents to read the surrounding code, not just the hunk, and to return structured findings instead of prose. Each finding needs:

- `path`, plus `line` (and `start_line` for a range) in the **new** file, on lines the PR added or touched where possible
- `category`: one of the lenses above, `spec`, or `standards`
- the quoted code
- the trigger: the concrete input or sequence that causes the problem
- the consequence: what breaks, and for whom
- the fix
- confidence: `high`, `medium`, or `low`

Keep each finding under 80 words. Drop code-review's 400-word cap here, because the ranking step needs every candidate.

### 4. Verify, rank, gate

Treat sub-agent output as candidates, not conclusions. For each one:

1. **Verify it yourself.** Open the code at the head SHA and trace the trigger. If you can't show how the problem actually happens, drop it. A wrong comment posted under the user's name costs more than a missed one.
2. **Rank it** as **critical**, **major**, or **minor**.

A finding is **critical** only when a realistic trigger exists in this PR's code **and** the consequence is one of:

- a security hole (exploitable, or leaks secrets or PII)
- data loss, corruption, or a wrong persisted state
- wrong results, a crash, or a panic on a normal path, not a contrived one
- a race or deadlock reachable in production
- a breaking change for existing callers, clients, or stored data
- a performance regression that matters at production scale (on a hot path, or unbounded in data size)
- a spec requirement that is missing or implemented wrongly
- a breach of a documented repo standard that causes one of the above

Everything else is major or minor and **is not posted**. That covers smells, naming, readability, missing tests on their own, misleading comments, speculative risks, and style. There is no count cap: post every critical finding and nothing below that bar. If nothing is critical, say so and post nothing. An empty review is a valid outcome.

Merge duplicates. When both axes flag the same root cause, write one comment at the line where the fix goes.

### 5. Write the comments

Every comment has this shape. Use no severity badges, no labels like "nit"/"P1"/"critical", no emojis, no AI or tool mentions, and no sign-off.

````markdown
**<Problem as a short sentence-case statement>**

<2–4 sentences, neutral voice: what the code does → what goes wrong and for whom → what to do. Name identifiers in `code`.>

```suggestion
<replacement lines>
```
````

or, when a suggestion can't express the fix:

```markdown
**<Problem as a short sentence-case statement>**

<2–4 sentences as above.>

<details><summary>How to fix</summary>

<Concrete steps a human follows: which function, what to check or change, in what order. Short code snippets are fine. Mention other files that need the same change.>

</details>
```

**Choosing between the two forms:**

- Use a `suggestion` block when the whole fix fits in the anchored lines. The block **replaces lines `start_line`..`line` exactly**, so include every replaced line, keep the original indentation, and make it compile. Suggestions only work on the RIGHT (new) side.
- Use **How to fix** when the fix spans other lines or files, needs a design choice, or can't be written as a verbatim replacement. Don't add How to fix when a suggestion already exists, because it would be redundant.

**Voice:** plain, neutral, third person about the code ("`validateSession` accepts tokens that…"), never "I think" or "you should". Use full sentences in normal English: caveman or compressed styles never go into posted text.

**Example: explanation plus How to fix**

```markdown
**Expired sessions pass validation**

`validateSession` checks `s.ExpiresAt.Before(time.Now())` and returns `nil` when it is true, so an expired session is accepted and a live one is rejected. Stolen tokens stay usable forever, and every user is logged out right after login.

<details><summary>How to fix</summary>

In `validateSession`, return `ErrSessionExpired` when `time.Now().After(s.ExpiresAt)` and `nil` otherwise. Add a table test in `session_test.go` with one expired and one live session so the inversion can't come back.

</details>
```

**Example: explanation plus suggestion**

````markdown
**Shared cache map written without a lock**

`refresh` writes `c.entries` from the ticker goroutine while `Get` reads it from request handlers. Concurrent map read and write panics the process under load.

```suggestion
	c.mu.Lock()
	c.entries[key] = value
	c.mu.Unlock()
```
````

### 6. Draft and wait

Write the draft to `/tmp/github-review/<owner>-<repo>-<N>.json`:

```json
{
  "repo": "owner/repo",
  "pr": 123,
  "commit_id": "<headRefOid>",
  "comments": [
    {"path": "pkg/x.go", "line": 42, "start_line": 40, "side": "RIGHT", "body": "<markdown>"}
  ],
  "held_back": ["minor · pkg/y.go:10 · Helper name hides that it mutates input"]
}
```

`start_line` is optional (single-line comments omit it). `held_back` lists major and minor findings in one line each. They are shown to the user and never posted.

Then run:

```bash
scripts/gh_review.py validate <draft>
scripts/gh_review.py render <draft>
```

Fix any anchor errors, either by moving the comment to a line in the diff or dropping it. Show the user the rendered draft verbatim and stop. **Do not post until the user explicitly says to post** ("post", "ship it", "go"). Approval covers this draft only.

If the user asks for edits (drop #2, reword #1, promote a held-back item), update the JSON, re-run `render`, show it again, and wait.

### 7. Post

When the user says to post:

```bash
scripts/gh_review.py post <draft>
```

This re-validates and refuses to post if the PR head moved. In that case, re-check each finding against the new head, update `commit_id` and the anchors, show the user what changed, and wait for approval again. The script posts one `COMMENT` review with no body, so nothing approves or blocks the PR and no summary appears. Report the review URL it prints.
