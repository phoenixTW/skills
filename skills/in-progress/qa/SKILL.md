---
name: qa
description: Generate and run tests from an implementation blueprint, audit unit and integration coverage, and report issues with reproducible steps and fix-verification tests. Use when verifying happy, edge, and failure scenarios or when another workflow needs evidence-based QA.
---

# QA from a blueprint

Turn the supplied blueprint into executable scenario checks. Verify its expected behavior and the sufficiency of applicable unit and integration tests. Return evidence and exact issues the caller can reproduce and retest.

## Inputs and authority

Use the blueprint or an equivalent explicit scenario set, repository revisions, service and fixture context, test commands, and an artifact destination outside application source. Preserve accepted expectations. Read [input-and-report.md](references/input-and-report.md) for input details and the output contract.

Discover missing facts from repository instructions, tests and scripts. Ask the caller only for unresolved information that changes expected behavior or prevents execution. In unattended use, record those blockers and finish with an incomplete report.

Keep application source unchanged. Create or repair generated tests and isolated fixtures in the artifact destination. Return application defects and missing repository tests to the caller for implementation. Preserve unexpected source changes for reconciliation; invalidate affected evidence instead of resetting them. Repository adoption of generated tests belongs to the caller.

The caller controls agent selection, environments, execution budgets and follow-up actions. The skill produces QA evidence; it does not publish or merge changes.

## Procedure

### 1. Account for every scenario

Read every Happy path, Edge case and Failure scenario, plus acceptance criteria and TDD seams. Preserve Setup, Action and Expected outcomes. Keep supplied IDs; otherwise assign section-and-ordinal IDs without editing the blueprint. Record its identity, repository revisions and initial source state.

**Done when:** every required outcome has a traceable scenario ID and an executable expectation, or a recorded input blocker.

### 2. Audit unit and integration coverage

Read [coverage-audit.md](references/coverage-audit.md). Inspect relevant implementation and test assertions, then map outcomes to unit, integration and acceptance checks. Identify missing boundaries, weak assertions and mocked-away contracts. Record applicable gaps even when existing suites pass. Explain nonapplicable levels.

**Done when:** each required outcome has applicable test levels, exact test references and commands, or an actionable coverage gap.

### 3. Generate the scenario checks

Read [test-generation.md](references/test-generation.md) and select tools using [tool-selection.md](references/tool-selection.md). Write `qa-plan.md` from the blueprint. Reuse sufficient checks and generate missing executable tests. Use Playwright for browser/API behavior; read [playwright.md](references/playwright.md) for its generation and execution workflow. Select an appropriate installed runner for other behavior.

**Done when:** every required scenario maps to runnable checks with faithful assertions, or an explicit capability blocker. Generation alone does not establish a pass.

### 4. Execute and inspect outcomes

Establish each scenario's Setup, perform its Action and assert its Expected outcomes. Run the mapped unit/integration suites and affected regressions. Verify final async state and cross-service effects where required. Save commands, working directories, exit statuses, observations and evidence. Repair demonstrably broken test artifacts without weakening expectations, record the repair and rerun affected checks.

**Done when:** every required scenario and applicable check has a current result with evidence or a reason it remains blocked, skipped or unproven.

### 5. Explore within the bound

Probe plausible adjacent behavior within the caller's exploration limit, defaulting to ten minutes. Record time used and keep exploratory findings separate from blueprint requirements. Required verification is governed by the caller's execution budget, not the exploration limit.

**Done when:** exploration has a recorded scope and duration, including zero when unavailable or explicitly excluded.

### 6. Report issues and readiness

Compare final source, test and fixture identities with the recorded inputs. Invalidate affected evidence when they change. Write `qa-report.json` and a Markdown summary using [input-and-report.md](references/input-and-report.md). For every issue include the exact expected/observed difference, prerequisites, reproducible steps, evidence and a concrete way to verify the fix. State when reproduction could not complete.

Recommend readiness only when all required outcomes pass at current revisions, all applicable coverage is adequate, and no blocking finding remains. Report required skips, unresolved gaps and missing evidence as incomplete verification. Do not invent confidence probabilities.

**Done when:** every required scenario and applicable test level is accounted for, issue reports can be reproduced and retested, and report references resolve to retained evidence.
