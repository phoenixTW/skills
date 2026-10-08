# Tool selection

Choose tools from the behavior and service context in the input. Use the project's existing test framework for direct behavioral checks. Use browser automation when the expected behavior depends on a browser, and use HTTP-level checks when they exercise the relevant public contract without browser state. Avoid adding a second tool for a check the first tool can prove.

## Defaults

- **Existing Go tests:** prefer the repository's established Go test commands for unit, integration, and service-level behavior. Run focused packages first, then the required affected suite. Preserve command output and exit status.
- **Playwright Test:** use for browser-visible behavior, navigation, forms, accessibility-relevant interaction, and asynchronous UI state. See [playwright.md](playwright.md) for assertions and evidence.
- **Hurl:** optional for concise, repeatable HTTP requests and response assertions when an HTTP exchange is the right seam. Use it only if present or explicitly available in the environment.
- **Keploy:** supplementary record/replay evidence when already configured. It does not replace assertions against the supplied expected outcomes or affected tests.

Do not install a new QA framework just to run this verification. Report a missing tool as blocked only when it prevents a required check; otherwise choose an available tool and explain the coverage boundary.

## Selection process

1. Identify the observable public interface: Go package/service, HTTP contract, or browser flow.
2. Select the existing tool that reaches that interface with the least setup and clearest assertion.
3. Map every scenario to a check and evidence item. Add regression checks only where changed behavior or a traced contract makes them relevant.
4. For service checks, verify readiness before execution and final state after asynchronous work. A successful process exit or accepted request is not enough when the expected result occurs later.
5. If a tool cannot observe the expected state, report the limitation as unproven and state the cheapest observation that would prove it.

Use isolated test data and supplied non-production configuration. Record fixture identity and cleanup. Never substitute production credentials or invent a live endpoint.
