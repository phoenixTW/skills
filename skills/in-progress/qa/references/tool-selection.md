# Select the test tools

Choose tools from the scenario's observable behavior and the installed project environment. Reuse established tests when their assertions demonstrate the required outcomes. Audit applicable unit and integration suites independently of acceptance checks.

| Behavior | Initial choice |
| --- | --- |
| Unit/integration behavior | Existing language/framework suites and documented commands. For Go, use the project's established Go test suites and relevant Go testing guidance. |
| Browser or HTTP API acceptance | Playwright Test, with blueprint-derived test generation described in [playwright.md](playwright.md). |
| Compact HTTP-only assertions | Hurl when available and suitable; preserve the same expected outcomes and scenario mapping. |
| CLI/service-only acceptance | Installed native runner or repeatable command assertions that observe the specified final effects. |
| Captured-traffic regressions | Keploy when already configured, as supplementary evidence alongside independent blueprint assertions. |

Preflight test runner, generator/browser tools, service access and isolated fixtures. A supported route must both generate/reuse executable checks and observe the required outcomes. Keep model, harness and environment configuration with the caller.

Select an available equivalent when it proves the same interface and outcomes; record the route and any limitation. Required capabilities that remain unavailable block their scenarios. Tool installation or provider changes require caller authorization rather than an automatic fallback.

Keep secrets and production resources outside test fixtures. Follow supplied startup/readiness/cleanup commands and repository instructions. Report the exact missing prerequisite when a check cannot run.
