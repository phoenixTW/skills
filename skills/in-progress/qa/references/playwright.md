# Playwright generation and execution

Use the installed Playwright Test version and repository fixture/configuration conventions. Keep generated files and artifacts in the caller's destination. Discover available browser/generator tools before choosing the route.

## Generate from the plan

Playwright's generator agent converts a Markdown plan into executable tests and verifies selectors/assertions against the running app. Supply the blueprint-derived `qa-plan.md`, seed setup and fixture/service context. Preserve scenario IDs and expected outcomes in generated tests. The tests then run through Playwright Test without an LLM interpreting each replay. [Official test agents](https://playwright.dev/docs/test-agents).

Native agent definitions require a compatible installed integration. The documented integration list includes VS Code, Claude Code, Codex and OpenCode. Do not infer native Pi support from that list. Where native definitions cannot run, a configured coding agent with usable Playwright tools can generate equivalent tests from the plan. Record the route; report unavailable required capabilities as blocked. Do not switch agents/providers or install tools without caller authorization.

## Browser and API checks

Use role/label locators and explicit user-visible assertions for browser behavior. For HTTP behavior use Playwright's request context; it can also establish fixtures or verify server-side effects after browser actions. [API testing](https://playwright.dev/docs/api-testing).

Execute Setup, Action and every Expected outcome. Assert final persisted/rendered values, validation errors and side effects required by the scenario. Use bounded retrying assertions or polling for async completion; request acceptance and spinner appearance are intermediate observations. Honor blueprint deadlines. Classify contradictory results as failed and inconclusive observations as unproven.

Start isolated services/fixtures, confirm readiness and record cleanup. A cross-service scenario must identify each application revision and dependency substitution. Browser-only mocks cannot prove a backend contract they replace.

## Repairs and evidence

Check generated tests for skipped cases and assertions weakened to match a broken app. Playwright's healer can skip a test when it considers functionality broken; a required skip cannot establish readiness. Repair only demonstrated test/fixture defects, preserve expectations and rerun.

Retain command/cwd, start/end time, exit status, runner results and generated test hashes. Save relevant response captures, screenshots and traces, particularly for failures. Protect credentials and sensitive fixture data. Record missing browser/service readiness as blocked, and keep evidence traceable to scenario IDs and final revisions.
