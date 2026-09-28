# Go testing

Actionable rules for Go ≥1.25, target 1.27. Behavior over coverage theater.

## Layout

- Tests next to source: `foo.go` → `foo_test.go`.
- Same package: white-box / unexported. `package foo_test`: black-box / examples.
- Split oversized files by concern still named from source (`handler_auth_test.go`), not by single function name.
- Order test funcs to match source order when practical.

## Tables

Prefer map-based tables (unique names, unordered iteration catches coupling). Slice + `name` field also fine if team uses it.

```go
tests := map[string]struct {
    in   string
    want []string
}{
    "simple": {"a/b", []string{"a", "b"}},
}
for name, tt := range tests {
    t.Run(name, func(t *testing.T) {
        got := Split(tt.in)
        if diff := cmp.Diff(tt.want, got); diff != "" {
            t.Errorf("Split() mismatch (-want +got):\n%s", diff)
        }
    })
}
```

Use `got` / `want`. Descriptive case names.

## Parallel / helpers

- Independent tests: `t.Parallel()` early in the test / subtest.
- Helpers: `t.Helper()`. Cleanup: `t.Cleanup`, not bare `defer`, for test-owned resources.
- Testify `assert.New(t)` / `require.New(t)`: build **inside** each `t.Run` from that subtest's `t`. Parent-scoped assert misattributes failures.

## Context / time / concurrency

- Prefer `t.Context()` for request-scoped test work (1.24+).
- Concurrent + timers: `testing/synctest.Test` (1.25+). Do **not** use deprecated `synctest.Run`.
- Packages with goroutines: `goleak.VerifyTestMain` and/or staging `/debug/pprof/goroutineleak` (1.27).

## Asserts / doubles

- Simple: stdlib. Complex structs: `cmp.Diff`.
- Prefer real deps / Testcontainers over heavy mocks. When needed: function-field fakes on consumer interfaces.
- Accept interfaces, return structs. Inject via constructors.

## Fixtures / artifacts

- Fixtures under `testdata/` (toolchain-ignored).
- Golden files with an `-update` flag pattern when useful.
- Persist inspectable outputs with `t.ArtifactDir()` (1.26+), not ad-hoc repo paths.

## Benchmarks / fuzz / examples

- Benchmarks: `b.Loop()` (1.24+). Compare with `benchstat`. `-benchmem` when allocs matter.
- Fuzz for parsers / codecs / invariants.
- `Example*` as executable docs (`// Output:`).

## Integration split

Either is fine:

```go
if os.Getenv("INTEGRATION") == "" {
    t.Skip("skipping integration test")
}
```

```go
//go:build integration
```

Keep unit suite fast. Race in CI: `go test -race ./...`.

## Coverage / tooling

- Aim ~70–80% meaningful coverage. Use `go test -cover` / `go tool cover -html` as gap finders.
- Go 1.27: `go test` runs `stdversion` by default — APIs must match module `go` directive. Fix directive or code; do not silence.

## Naming

`Test*`, `Benchmark*`, `Fuzz*`, `Example*` — capital letter after prefix.
