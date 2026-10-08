# Unit and integration coverage audit

Build the matrix from blueprint outcomes, acceptance criteria, and TDD seams. Inspect actual assertions and the implementation boundaries they exercise. Execute the mapped tests during verification. Test names and line coverage help discovery; adequacy requires assertions that can detect incorrect outcomes.

## Matrix

Record one row per expected outcome, splitting multi-outcome scenarios where necessary:

| Scenario and outcome | Unit tests | Integration tests | Acceptance checks | Gaps and rationale |
| --- | --- | --- | --- | --- |

For each applicable level, identify test file/name, asserted outcome, command and execution result. Account for every relevant existing assertion, including tests that cover only one outcome of a multi-outcome scenario. A level can contain several checks. Explain each nonapplicable level from the behavior and its boundaries. Preserve explicit blueprint test requirements even if another level also proves the final result.

- Unit checks should assert relevant business rules, validation boundaries, state transitions and error behavior through the project's established public test seams.
- Integration checks should exercise required database, protocol, service or worker interactions. Describe real and substituted dependencies. Verify persistence, rollback, authorization, idempotency or concurrency where the blueprint requires them.
- Acceptance checks should establish the scenario's Setup, execute its Action and observe its final Expected outcomes through the appropriate user/service/CLI interface.

Inspect whether assertions check values, failures and side effects rather than merely successful invocation. A mock replacing the boundary whose behavior is required leaves that behavior unverified. Available coverage metrics are supporting evidence; no percentage substitutes for the matrix.

## Coverage results

Use the report contract's coverage states. `covered` requires adequate assertions and current execution of the relevant checks. A check that detects an application defect still covers that outcome; its failed execution result independently prevents readiness. `gap` means an applicable outcome lacks adequate assertions. `unproven` means adequacy or execution could not be established. `not_applicable` requires a behavior-specific rationale; a missing test is not that rationale.

Any applicable gap for a required outcome blocks a readiness recommendation. Describe the missing assertion, affected scenario, appropriate test seam and how to demonstrate the gap. Return missing or weak repository unit/integration tests to the caller for TDD changes. Continue independent scenario checks where useful, then rerun affected checks at the revised candidate.

Document each coverage issue using the issue format in [input-and-report.md](input-and-report.md). Reproduction can be inspection and execution of the deficient test suite; do not invent a product defect when the demonstrated issue is missing test coverage.
