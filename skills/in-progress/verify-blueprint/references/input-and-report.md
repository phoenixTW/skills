# Input and report contract

Use this contract when the caller has not supplied an equivalent structured input or report format. Preserve caller-provided IDs and expectations.

## Input record

Collect these fields before verification:

| Field | Required content |
| --- | --- |
| Scenarios | ID, Setup, Action, Expected result, and source of the expectation |
| Revisions | Repository path and candidate revision for every repository under test; base revision when available |
| Services | Start, readiness, and shutdown commands; configuration and dependency notes; fixture setup and cleanup |
| Commands | Required test, build, lint, migration, or other regression commands and their working directories |
| Artifacts | Writable destination outside application source |
| Exploration | Explicit duration/action bound, or the ten-minute default |

When one field is absent, inspect available project documentation and scripts. Ask for information that is necessary to execute safely or determine the expected result. Mark a check blocked if the information cannot be obtained; never fill the gap with a guessed endpoint, credential, or expectation.

## Report

Write `qa-report.md` in the artifact destination, alongside retained command logs and other evidence. Include:

```markdown
# Verification report

- Repositories and candidate revisions:
- Base revisions, if supplied:
- Service and fixture context:
- Artifact directory:
- Verification time and environment:

## Scenario results

| ID | Setup | Action | Expected | Observed | Status | Evidence |
| --- | --- | --- | --- | --- | --- | --- |

## Regression checks

| Check | Command | Exit status | Status | Evidence or reason |
| --- | --- | --- | --- | --- |

## Exploration

- Bound and time used:
- Question / action / observation / evidence:

## Findings

- Finding, affected scenario or contract, reproduction, evidence, and impact:

## Limitations

- Blocked, skipped, or unproven checks and what would establish them:
```

For each command, retain the exact command, working directory, start and end time, exit status, and stdout/stderr or a path to them. Record service readiness and relevant final state. Link screenshots, traces, response captures, and logs by relative path. Keep sensitive values out of the report and logs; identify redactions.

Use only these result meanings:

- **Passed:** the check ran and evidence demonstrates the supplied expectation.
- **Failed:** the check ran and evidence contradicts the expectation or exposes a defect.
- **Blocked:** an unavailable prerequisite prevented the check from running or reaching the observation point.
- **Skipped:** the check was deliberately excluded by explicit scope or instruction. State who or what excluded it.
- **Unproven:** some execution occurred, but the available observation cannot establish pass or fail, including incomplete async work, ambiguous output, or missing evidence.

Do not convert a blocked, skipped, or unproven result into a pass. When a test or fixture repair is needed, describe the defect, the minimal repair, and the rerun result. State plainly that application source was outside the QA repair scope.
