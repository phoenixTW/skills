# Playwright Test

Use this reference when a scenario depends on browser behavior. Follow the repository's installed Playwright version and configuration. Keep browser artifacts in the caller's artifact destination.

## Assertions

- Write assertions from the scenario's Expected result, using user-visible roles, labels, text, or other stable public behavior.
- Assert the final state after asynchronous work settles. Prefer retrying Playwright assertions over fixed sleeps; wait on a specific visible state or response only when that event is part of the expected behavior.
- For delayed workflows, assert the resulting state and relevant persisted or rendered value, not merely that a request was accepted or a spinner appeared.
- Use isolated fixtures and explicit setup/cleanup. Record when setup is shared, unavailable, or nondeterministic.
- Repair a broken test or isolated fixture only when its defect is clear. Preserve the supplied expected result, record the repair, and rerun the scenario. Do not alter application source or weaken assertions to make a run green.

## Evidence

Retain the exact test command, working directory, exit status, and complete relevant output. Save screenshots, traces, or video for failures and for scenarios where visual state is the evidence. Reference files by path in the report. Capture enough evidence to identify the browser/project and the final state without recording secrets or personal data.

If the browser, service, or fixture cannot start, record the failed prerequisite and classify the affected scenario as blocked. If the test runs but does not observe the final expected state, classify it as failed when evidence contradicts the expectation, or unproven when the observation is incomplete or ambiguous.
