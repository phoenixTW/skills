# Go context

Distill of [samber golang-context](https://github.com/samber/cc-skills-golang/tree/main/skills/golang-context).

## Create

| Situation                | Use                               |
| ------------------------ | --------------------------------- |
| Entry (main, init, test) | `context.Background()`            |
| Need ctx, none yet       | `context.TODO()`                  |
| HTTP handler             | `r.Context()`                     |
| Manual cancel            | `context.WithCancel(parent)`      |
| Relative timeout         | `context.WithTimeout(parent, d)`  |
| Absolute deadline        | `context.WithDeadline(parent, t)` |

Never pass nil. Never invent mid-request `Background()`.

## Propagate

Same ctx through handler → service → DB → outbound HTTP. Break chain = work survives client cancel.

```go
// bad — detaches from caller deadline
s.db.ExecContext(context.Background(), q, args...)

// good
s.db.ExecContext(ctx, q, args...)
```

- First param: `ctx context.Context`.
- Never store ctx on struct (struct outlives request).
- Nested timeout: shorter deadline wins.

## Cancel ownership

Every `WithCancel` / `WithTimeout` / `WithDeadline`: call `cancel()` on all paths. Usual pattern: `defer cancel()` immediately.

```go
ctx, cancel := context.WithTimeout(ctx, 3*time.Second)
defer cancel()
return doWork(ctx)
```

Listen: `select` on `<-ctx.Done()`, or `ctx.Err()` in CPU loops. Return `ctx.Err()` (or wrap it).

`context.AfterFunc(ctx, fn)` — cleanup goroutine on cancel; stop with returned stop func if no longer needed.

## WithoutCancel

Background work that must finish after request returns (audit, enqueue):

```go
go h.audit.Log(context.WithoutCancel(ctx), order)
```

Keeps values (trace id). Detaches cancellation. Prefer over bare `Background()` for that case.

## Values

- Request-scoped metadata only (request id, user id, trace).
- Unexported key type per package — string keys collide across packages.
- Never hide required function params in `Value()`.

## HTTP / DB

- Server: start from `r.Context()`.
- Client: `http.NewRequestWithContext(ctx, ...)`.
- DB: always `QueryContext` / `ExecContext` / `*Context` variants.
