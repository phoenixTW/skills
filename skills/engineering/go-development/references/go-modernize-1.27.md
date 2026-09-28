# Go modernize (target 1.27)

Sources: [Go 1.27 release notes](https://go.dev/doc/go1.27), [samber golang-modernize](https://github.com/samber/cc-skills-golang/tree/main/skills/golang-modernize).

Check module `go` directive first. Suggest bump when behind. Never use APIs newer than the directive (`go test` runs `stdversion` by default on 1.27).

## Prefer in new code

| Prefer                                | Instead of                    | Since       |
| ------------------------------------- | ----------------------------- | ----------- |
| `any`                                 | `interface{}`                 | 1.18        |
| `min` / `max`                         | manual compare                | 1.21        |
| `slices` / `maps` / `cmp`             | hand-rolled                   | 1.21+       |
| `log/slog`                            | `log.Printf` for structure    | 1.21        |
| `errors.Is` / `As` / `AsType`         | `==` / bare assert            | 1.13 / 1.26 |
| `math/rand/v2`                        | `math/rand`                   | 1.22        |
| `range n`                             | `i := 0; i < n; i++`          | 1.22        |
| `cmp.Or`                              | nested zero defaults          | 1.22        |
| iterators / `slices` seq helpers      | awkward loops                 | 1.23+       |
| `t.Context()`                         | ad-hoc test ctx               | 1.24        |
| `b.Loop()`                            | `for i := 0; i < b.N; i++`    | 1.24        |
| `runtime.AddCleanup`                  | `SetFinalizer`                | 1.24        |
| `synctest.Test`                       | `synctest.Run` / sleep flakes | 1.25        |
| `sync.WaitGroup.Go`                   | manual `Add`/`Done`           | 1.25        |
| `t.ArtifactDir()`                     | ad-hoc artifact paths         | 1.26        |
| generic methods (type-scoped helpers) | package-level generic only    | 1.27        |
| stdlib `uuid`                         | `google/uuid` for simple IDs  | 1.27        |
| promoted field selectors in literals  | awkward nesting               | 1.27        |

## Verify on 1.27 upgrade (do not blind-rewrite)

| Risk                                      | Action                                                                                                                        |
| ----------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------- |
| `encoding/json` now on v2 impl            | Re-run tests that assert JSON **error strings**; behavior preserved, message text may differ. Escape: `GOEXPERIMENT=nojsonv2` |
| `encoding/json/v2` API                    | Separate migration. Stricter defaults (invalid UTF-8, duplicate keys). Not in casual feature PRs                              |
| Timer channels always sync                | `asynctimerchan` removed. Fix code that assumed buffered timer chans                                                          |
| HTTP/1 `Response.Body.Close` drains       | Improves reuse. Pathological: `MaxIdleConns=0` or new `Client` per request can get slower — fix client reuse                  |
| Stale `GODEBUG` / `//go:debug` old values | Build fails on removed settings pinned to old value. Clear or set final default                                               |
| `crypto/tls.Config.Rand`                  | Prefer `testing/cryptotest.SetGlobalRandom` in tests                                                                          |
| Goroutine leaks                           | Use `/debug/pprof/goroutineleak` (and goleak in tests) under real load                                                        |
| Traceback labels                          | `go 1.27+` modules include pprof labels in traceback headers; audit sensitive labels (`tracebacklabels=0` opt-out)            |

## Commands

```bash
go version
go fix ./...
go run golang.org/x/tools/gopls/internal/analysis/modernize/cmd/modernize@latest -fix -test ./...
go test ./...
govulncheck ./...
```

Prefer project golangci-lint `modernize` when configured. Large sweeps: isolated branch/worktree; do not bury unrelated feature diffs.
