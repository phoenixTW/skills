# QA input and report contract

## Input

Accept the blueprint or an equivalent explicit scenario set, its expectation source, repository paths/revisions, service startup/readiness/cleanup context, isolated fixtures, relevant test commands, artifact destination and execution/exploration bounds. Discover factual omissions from repository documentation and scripts. Preserve expected behavior and caller-supplied IDs.

Record an input snapshot/content hash. Include all participating repository revisions, including unchanged services needed by cross-service checks. Record observed HEAD and source state before and after QA; HEAD alone cannot identify uncommitted or untracked application changes. Exclude only explicitly designated external artifacts and known runtime outputs from the application comparison. Unknown or mismatched revisions make affected evidence unproven.

Keep generated QA files outside application source. Record fixture identity, dependency substitutions, actual service/application revision and generated test hashes. Later changes to source, expectations, executable tests or fixture definitions invalidate affected results until repeated verification.

## Outputs

Write `qa-plan.md`, retained tests/logs/evidence, `qa-report.json` and `qa-report.md` in the artifact destination. The [JSON schema](../assets/qa-report.schema.json) defines the versioned report fields and status values. Load it when producing the machine report. Markdown summarizes the same data with scenario results, coverage matrix, issues and limitations; it must not disagree with the JSON. Store steps as unnumbered strings in JSON and render them as numbered lists in Markdown.

Result meanings:

- `passed`: execution and evidence establish every required expected outcome.
- `failed`: observed behavior contradicts the expectation or demonstrates a defect.
- `blocked`: an unavailable prerequisite prevented execution or the required observation.
- `skipped`: explicit instruction excluded the check; record the reason/source of exclusion.
- `unproven`: execution or observation cannot establish pass/fail, including missing evidence or incomplete async observation.

Coverage levels and their applicability are defined in [coverage-audit.md](coverage-audit.md). Report coverage per scenario; use separate checks when one scenario has several expected outcomes. A `covered` level requires exact test references, adequate assertions and current execution. Keep coverage adequacy separate from execution status: an adequate check can detect a defect and fail. An applicable gap or inconclusive level prevents readiness for a required scenario.

For commands record exact invocation with secret placeholders identified, working directory, start/end time, exit status and stdout/stderr evidence. Link artifacts by path relative to the artifact destination, with content hashes. Capture actual results; a generator's successful exit is not a successful scenario test.

## Exact issue reports

Every defect, required coverage gap, unavailable prerequisite or broken test artifact needs a finding containing:

1. A stable issue ID, kind, concise summary, impact/blocking classification and affected scenario IDs.
2. The exact expected outcome and observed difference, including response/exit/value details when available.
3. Repository revision, environment and fixture prerequisites needed to reproduce it. Refer to existing report context where sufficient.
4. Numbered reproduction steps with concrete inputs, commands, working directories or UI actions. Identify redacted configuration references instead of leaking credentials.
5. Evidence links and reproduction status: reproduced, blocked or not reproduced. For incomplete attempts state what prevented reproduction; never invent a result.
6. A way to test the correction: exact existing/generated test or proposed missing assertion, its command and working directory or concrete manual actions, and the expected successful outcome. Distinguish a proposed future test from one already executed.

For a coverage gap, reproduce the gap by inspecting the named tests and executing the relevant suite; identify the missing assertion and the public test seam for adding it. Do not claim missing coverage proves an application bug. Return application fixes and repository unit/integration additions to the caller, then verify them at the new revision.

## Report consistency and readiness

Before reporting, check:

- Required scenario inventory matches the input; IDs are unique; every outcome maps to its executed checks and observations.
- All referenced check, finding and artifact IDs exist; evidence files exist and match their hashes; executed checks record the final test/fixture revisions.
- Every applicable `covered` level references inspected adequate assertions and actually executed checks, even when they detected a defect. Nonapplicable levels have behavior-specific reasons and do not omit a relevant existing assertion. Checks needed by required scenarios are marked required; readiness also requires them to pass.
- Every issue contains reproduction and fix-verification steps, with actual reproduction status.
- Repository/source identities match the execution context; changed or uncertain inputs invalidate affected results.

Use `ready` only when every required scenario passes, applicable coverage is covered, referenced checks pass, source/evidence identities remain valid and no blocking finding remains. Otherwise use `not_ready` with specific limitations. Nonblocking exploratory findings remain separate from approved scope. JSON schema validation catches structural errors; perform the consistency checks above as well, because a schema cannot verify files, cross-references or the truth of observations.

The report remains generic. Do not require tracker IDs, factory run/candidate IDs, scheduling state or publication metadata. The caller can normalize evidence into its own workflow.
