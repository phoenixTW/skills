# Generate executable checks from a blueprint

Save `qa-plan.md` under the supplied artifact destination. Read the blueprint as the expectation source; live application behavior helps choose executable actions and locators, not redefine correctness.

## Plan each required scenario

Record its ID, blueprint section/entry, repository revisions, fixture setup, actions, every expected outcome, runner, intended assertions and evidence. Preserve acceptance criteria and required unit/integration coverage from the audit. Separate exploratory additions from the required inventory.

Keep supplied IDs. For an unnumbered or locally numbered blueprint, derive IDs such as `happy-1`, `edge-2` and `failure-1` from section and ordinal. Record the blueprint content hash so a changed input cannot silently reuse old results. Do not edit the input blueprint.

## Generate or reuse

Reuse a test when its inspected assertions and fixture context prove the specified outcome. Generate missing acceptance checks using the installed runner that reaches the required interface. Map every expected outcome to explicit assertions and carry scenario IDs in test names or metadata.

For browser/API behavior, follow [playwright.md](playwright.md). For CLI or service-only behavior, use native executable checks that assert the required output, exit status and side effects. Use established language/framework guidance when authoring tests; do not copy its standards into this skill.

Keep generated tests, runner configuration, seed fixtures and logs outside application source. Configure the runner to use the correct candidate/service context explicitly. If a runner needs repository-local files, use a caller-authorized isolated test copy or overlay and record its relationship to the candidate. A test copy must exercise the same application revision, not a rewritten implementation.

Audit generated assertions against every Expected outcome before execution. A passing test that omitted one required outcome leaves that outcome unproven. In a multi-service scenario, verify the end-to-end effect and record participating revisions and substituted dependencies.

## Repair and rerun

Repair a test or fixture only when the defect is demonstrated. Record the original failure, artifact change and rerun. Preserve accepted expectations and application source. Required skips remain unresolved. Return application defects and missing repository unit/integration tests to the caller.

Record hashes of generated tests, plan and relevant fixture definitions with their executed checks. Changes after execution invalidate affected results until rerun. Promote useful generated tests into maintained repository suites through a separate implementation change.
