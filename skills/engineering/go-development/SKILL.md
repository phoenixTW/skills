---
name: golang-development
description: >
  MUST activate when working on Go projects — writing, reviewing, testing, or
  modernizing Go code. Covers context.Context, error handling, Go 1.27 idioms,
  and testing. When implementing from a spec or ticket, follow /implement
  internally (tdd → review → commit).
---

# Go development (1.27)

Distilled from [samber/cc-skills-golang](https://github.com/samber/cc-skills-golang) (MIT). Not full catalog fork. On Go idioms, this skill wins over `coding-standards`.

## Workflow

When user asks build/implement Go work from spec or ticket:

1. Load and follow [`../implement/SKILL.md`](../implement/SKILL.md) end-to-end.
2. Drive `/tdd` at pre-agreed seams.
3. Typecheck and single-package tests often; full suite once at end.
4. Close with `/code-review`, then commit on current branch.

Apply rules below at every coding and review step.

## Toolchain

- Verify `go` directive and installed toolchain. Target **1.27**. Never assume.
- Prefer `go fix ./...` + modernize analysis over ad-hoc rewrites. See `references/go-modernize-1.27.md`.
- Release builds: `-ldflags="-s -w"`. Skip for debug.
- Lint: project `.golangci.yml` or repo standard. Do not invent paths.

## Context

- `ctx context.Context` first param. Never store in struct.
- Propagate same ctx through request chain. No mid-stack `Background()`.
- `defer cancel()` after every `WithCancel` / `WithTimeout` / `WithDeadline` unless ownership returned.
- Nil ctx forbidden. Use `context.TODO()` when missing.
- `Background()` only at entry (main, init, tests).
- Values: request metadata only. Unexported key types. Never function params.
- Work that must outlive request: `context.WithoutCancel(parent)`.

Deep dive: `references/go-context.md`.

## Errors

- Always check. Never `_ = err`.
- Wrap: `fmt.Errorf("verb noun: %w", err)`. Lowercase, no trailing punct.
- Internal: `%w`. Public/system boundary: `%v` to hide chain.
- Match: `errors.Is`. Typed: `errors.AsType[T](err)` (1.26+); else `errors.As`.
- Independent failures: `errors.Join`.
- Log XOR return. Never both (single handling).
- Sentinel for expected conditions; custom types when data needed.
- No panic for expected failures. `slog` at log sites. No raw tech errors to users.

Deep dive: `references/go-errors.md`.

## Go 1.27 prefer / verify

**Prefer in new code:** generic methods for type-scoped helpers; stdlib `uuid` when enough; `errors.AsType`; `t.Context()`; `b.Loop()`; `synctest.Test` (not `Run`); `sync.WaitGroup.Go`; APIs compatible with module `go` directive (`stdversion` runs in `go test`).

**Verify before rewrite / upgrade:** JSON error-string tests (v1 API on v2 impl); HTTP clients that never reuse conns + body drain; removed `asynctimerchan`; `/debug/pprof/goroutineleak` for leak hunts.

**Separate migration:** `encoding/json/v2` API — not casual feature PRs.

Checklist: `references/go-modernize-1.27.md`.

## Testing

When writing or changing tests, read `references/go-testing.md`.

## Out of scope

Concurrency, DB, observability, DI, CLI frameworks: use upstream [samber/cc-skills-golang](https://github.com/samber/cc-skills-golang/tree/main/skills) skill for that area. Do not duplicate here.
