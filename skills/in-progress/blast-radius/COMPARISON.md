# Claude/Codex comparison

Use this optional branch when the user requests model comparison, or when a broad or high-risk change would benefit from independent reasoning. Continue using the current agent for the main review and fixes.

1. Check whether the `claude` and `codex` CLIs are installed and authenticated through the user's existing subscriptions. Read their current `--help` and local instructions to choose supported noninteractive, read-only review options. Check the selected models: two CLI brands alone do not establish independent model review. Use available authenticated access; if one is unavailable, record that limitation and complete the core review with the current agent. Installing tools, changing authentication, or adding paid API access is a separate task.
2. Give fresh Claude and Codex review sessions the same reviewed scope, base/revision, intended behavior, affected contracts, and safety facts. Include relevant repository instructions. Ask each to independently inspect the code and return source-backed failure paths, missing proof, and the cheapest executable check. Keep sessions read-only and leave fixes with the primary agent. Use an isolated snapshot if the tooling cannot reliably review the final working-tree state. Both reviews must cover the same snapshot.
3. Compare the findings, not which model sounds most confident. Reproduce plausible failures with real code, clear false positives with evidence, and investigate disagreements. Agreement does not replace executable proof. Bring verified findings back to the fix/recheck step in `SKILL.md`.

**Done when:** the compared snapshot and actual model identities are recorded, every material lead is verified or marked unproven, and any resulting changes are included in the final rechecks.
