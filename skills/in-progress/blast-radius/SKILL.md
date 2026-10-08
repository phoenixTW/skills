---
name: blast-radius
description: Trace what a change breaks beyond the diff, prove its safety facts, fix clear bugs, and assess readiness before a PR or merge.
disable-model-invocation: true
metadata:
  credits:
    skill: blast-radius
    author: Lauren Tan
    organisation: PStack
    url: "https://github.com/cursor/plugins/blob/main/pstack/skills/blast-radius/SKILL.md"
---

# Blast radius

Find what a change breaks somewhere else, before it ships. Use before raising a PR or merging one, for "blast radius of X", "what could this break", or reviewing a small diff you don't trust yet.

The job is the breakage grep won't show you. Find the one or two facts the whole thing depends on and prove them by running code. For changes with independent affected areas, identify the safety facts for each area; one proven fact cannot clear unrelated risks.

Use the current agent and model for the investigation and fixes. Return a report in the conversation; save Markdown only when requested. This review does not authorize committing, publishing, merging, or deploying.

## Steps

### 1. Establish the change and intent

Record the working-tree state, the reviewed revision, and the comparison base. Use the PR's actual base, an explicitly supplied reference, or the repository's configured target branch and its merge-base. Include relevant staged, unstaged, and untracked changes for a pre-PR review. If the intended scope remains ambiguous after inspecting the repository, ask which change to review. Preserve unrelated work.

Read the diff, the symbols it adds, changes, and deletes, and what it now does differently, including the part the diff doesn't spell out. Recover intent from the conversation, originating ticket or spec, relevant ADRs, and git/PR history. Cite the artifact behind a claimed requirement; mark inferred intent as inferred.

When a changed module's interface, invariants, or seams are unclear, use the [codebase-design reference](../../engineering/codebase-design/SKILL.md). Existing specs and history establish intent; creating a new planning or domain-modeling session is a separate task.

**Done when:** every changed area is accounted for, the reviewed scope and base are explicit, and intended behavior is sourced or marked unknown.

### 2. Trace the blast radius

Look where grep stops. Read the source of the library you call, and check its pinned version and any local patch. Work out when things run: microtasks, unmount and teardown, startup and shutdown. Follow what a symbol search misses: the JSON an API returns, a DB column, a wire format, another language reading the same bytes, a feature flag, code three hops downstream.

For each affected area, trace the changed behavior to its consumers and user flows. Check the contracts the change touches: authorization, persisted data and migrations, serialization, caching, concurrency, error handling, dependency/configuration changes, and rollout or rollback compatibility. Investigate applicable contracts; name the evidence that bounds the affected consumers rather than treating an empty search as proof of safety.

Find the facts the change is safe because of. Most changes that look risky are safe because of a single fact, like "this call only drops already-dead cache entries and does nothing else". If it holds, several risky cases may be cleared at once. Spend your time here, not on a long list of maybes.

**Done when:** every changed area has its affected contracts and consumers traced, with safety facts and plausible failure paths identified, or the missing evidence named.

### 3. Prove the safety facts

For each fact the change's safety depends on, get it as far down this list as is practical, and say where it stopped.

1. **Assertion.** You said so. Worthless on its own.
2. **Source.** You pointed at the line. A real `file:line`, or the library's own source at the shipped version.
3. **Failure path.** You walked the bad case step by step and showed why it cannot reach the failure.
4. **Executable proof.** You ran a script or test that calls the real code and fails loud if you're wrong.
5. **Running app.** You reproduced the scenario in the running app and checked the actual behavior.

Step 4 is usually one small script that imports the same library the app ships and calls the exact function you're worried about. Assert the relevant outcome, including the failure or edge case; a passing mock or "didn't crash" is not proof of the real contract. Keep useful reproductions or regression tests; remove throwaway instrumentation.

Be honest about each risk. Give it a practical likelihood and a real cost if it happens; explain the conditions rather than inventing percentages. Separate confirmed findings, investigated and cleared cases, and unresolved hypotheses. Cite real code and show the command and relevant result. If you couldn't prove it, write **unproven** and say what evidence would resolve it.

**Done when:** each safety fact has a stated proof level and evidence, and every material risk is confirmed, cleared by evidence, or explicitly unproven.

### 4. Run the repository checks

Discover required checks from repository instructions, scripts, and CI configuration. Run those available in the review environment, plus the integration, UI, migration, compatibility, or performance checks justified by the traced risks. Choose checks from the change, not a language-specific checklist.

Record each relevant check as passed, failed, or not run with a reason. Investigate failures enough to distinguish regressions from existing failures or environment problems. A pre-existing failure still belongs in the report; it is not a passing check. Use an isolated baseline comparison when needed without discarding the user's work.

**Done when:** required checks and checks covering the identified failure paths have results, or their missing prerequisites and next commands are explicit.

### 5. Fix findings and recheck

Fix confirmed bugs whose correction is clear and stays within the intended change. For a reproducible failure that needs deeper investigation, use [diagnosing-bugs](../../engineering/diagnosing-bugs/SKILL.md). Add a regression test when it can exercise the actual failure at an appropriate seam; otherwise retain an executable reproduction and explain the gap.

For fixes that need a product or architecture decision, or exceed the intended scope, prepare a concrete plan: the decision needed, affected files or contracts, proposed correction, and verification command. Continue independent checks while that decision remains open.

After fixes, inspect the new diff, trace any newly affected contracts, rerun the reproductions and affected checks, and complete required checks against the final state. Previous results apply only where their inputs remain unchanged. A new change or finding reopens the relevant earlier step.

**Done when:** every confirmed finding is fixed and verified or has a concrete remaining plan, and the evidence covers the final reviewed state.

### 6. Get a second review when useful

The current agent is the default. Delegate same-model review work only when the user requests it. For an unusually broad or high-risk change where independent model review would improve assurance, or when the user requests comparison, follow [Claude/Codex comparison](COMPARISON.md). A second opinion supplies leads; the primary agent must verify them through the same evidence standard.

**Done when:** any second-review findings are reconciled and verified, with resulting fixes rechecked, or the review remains with the current agent.

### 7. Report readiness

Return:

- **What changed.** Intended and actual behavior, reviewed scope/base/revision, and implications outside the diff.
- **Safety facts.** Each fact, proof level, exact command and relevant result. Mark unproven facts plainly.
- **Findings and fixes.** Failure path, `file:line`, likelihood, impact, and fix evidence. Give concrete plans for unresolved findings.
- **Cleared cases.** What you investigated and why the evidence clears it.
- **Checks.** Passed, failed, and not run, including environment limitations and applicable remote CI status if available.
- **Before merge.** The readiness verdict and the cheapest remaining test, reproduction, or decision that resolves each blocker or material uncertainty. Include saved reproduction paths.

Use **ready** only when relevant required checks pass, material safety facts have executable proof, and no blocking findings or decisions remain. List minor nonblocking findings even when ready. Use **blocked** for confirmed blocking findings, failed required checks, or unresolved decisions needed for correctness. Use **unproven** when there is no confirmed blocker but missing checks, access, CI results, or proof prevent a readiness claim. A blocker takes precedence over uncertainty. A fix plan alone does not make a change ready.

Apply [unslop](../unslop/SKILL.md) to the final writeup. Preserve proof, citations, and uncertainty while editing. Redact private data and secrets in quoted commands and output; publishing the report requires its own authorization.

**Done when:** the report accounts for every material finding and missing check, names the final reviewed state, and supports its readiness verdict with evidence.

## Attribution

Adapted from Lauren Tan's [PStack blast-radius](https://github.com/cursor/plugins/blob/main/pstack/skills/blast-radius/SKILL.md), with wording retained. This version adds repository checks, fixes and re-verification, and a merge-readiness verdict; replaces `how`/`why` with local references and project artifacts; and makes Claude/Codex comparison optional. Upstream MIT terms are preserved in [LICENSE](LICENSE).
