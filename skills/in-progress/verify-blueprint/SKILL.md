---
name: verify-blueprint
description: Verify explicit behavioral scenarios against repository revisions, run affected regressions, and report reproducible evidence.
---

# Verify a blueprint

Verify an approved set of behavioral scenarios against the supplied repository revisions. Work from explicit inputs and report evidence another person can reproduce. The skill is independent of any ticket tracker, scheduler, runner, or deployment system.

## Inputs

Before running checks, identify:

- **Scenarios:** stable IDs, each with Setup, Action, and Expected outcomes.
- **Repository revisions:** repository paths, base revisions when supplied, and candidate revisions to verify.
- **Service context:** commands to start and inspect services, required configuration, fixtures, and dependency availability.
- **Artifact destination:** a writable directory outside application source for logs, screenshots, traces, and the report.
- **Relevant checks:** commands for existing tests and other required checks, or enough repository context to discover them.
- **Exploration bound:** the time or action limit for exploratory QA. If none is supplied, use ten minutes.

If a required input is missing, determine whether the repository or supplied service context answers it. Ask for missing information that blocks safe execution. Do not invent endpoints, credentials, expected behavior, or commands that could affect production.

## Procedure

1. Read repository instructions and the supplied scenario sources. Confirm each scenario's Setup, Action, and Expected result, and map it to the candidate revision and service it exercises. Preserve the approved expectations.
2. Inspect available QA tools and choose the smallest reliable set for the scenario. Read [tool-selection.md](references/tool-selection.md); read [playwright.md](references/playwright.md) when browser interaction or UI behavior is involved.
3. Prepare isolated fixtures and services using the supplied context. Record their revisions, start commands, readiness evidence, and any unavailable prerequisite. Keep generated artifacts in the supplied destination.
4. Run each required scenario through its public interface. Assert the final expected state, including after asynchronous work settles; an intermediate response or successful command alone does not prove completion.
5. Run tests and checks affected by the changed behavior. Trace changed contracts and failure paths to find the relevant regression checks. Record every check as passed, failed, skipped, blocked, or unproven, with a reason when it did not run or did not establish the expected result.
6. Use the remaining exploration bound to probe plausible adjacent failure cases related to the scenarios. Record the question, action, result, and elapsed exploration time. Stop at the bound.
7. Preserve exact executed commands, exit statuses, relevant output, and evidence paths. Write the report described in [input-and-report.md](references/input-and-report.md). Redact secrets while preserving enough detail to reproduce the check.

**Done when:** every supplied scenario and relevant regression check has a result or an explicit reason it could not be established; bounded exploration is recorded; and the report names the exact revisions and points to retained evidence.

## Boundaries

- Never edit application source or change an expected outcome. Report application defects with a minimal reproduction and evidence.
- You may repair tests or isolated fixtures when they are demonstrably broken. Keep the original expectation intact, record the repair, and rerun the affected check.
- A missing prerequisite is **blocked** when it prevents execution. A check deliberately omitted by scope or instruction is **skipped**. **Unproven** means execution or observation did not establish either success or failure. Do not count any of these as a pass.
- Keep this report independent of the system that invoked the skill. Report scenario IDs and repository revisions as supplied; do not add orchestration-specific identifiers or schemas.
