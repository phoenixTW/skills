# Go errors

Distill of [samber golang-error-handling](https://github.com/samber/cc-skills-golang/tree/main/skills/golang-error-handling).

## Create

- Message: lowercase, no trailing punctuation, say what failed — not what caller should do.
- Sentinel: `var ErrNotFound = errors.New("not found")` for expected conditions.
- Custom type when error carries fields callers need (`Field`, `Code`, …).
- Package-level sentinels for stable compare sites.

## Wrap / inspect

```go
return nil, fmt.Errorf("getting user %s: %w", id, err)
```

| Layer                    | Verb                  |
| ------------------------ | --------------------- |
| Inside module            | `%w` — keep chain     |
| Public / system boundary | `%v` — hide internals |

```go
// bad — breaks on wrapped errors
if err == sql.ErrNoRows { ... }
if ve, ok := err.(*ValidationError); ok { ... }

// good
if errors.Is(err, sql.ErrNoRows) { ... }
if ve, ok := errors.AsType[*ValidationError](err); ok { ... } // Go 1.26+
// Go <1.26: var ve *ValidationError; errors.As(err, &ve)
```

Independent failures: `errors.Join(errs...)` (nil if empty). `errors.Is` / `As` walk joined trees.

## Single handling

Error is **logged OR returned**, never both. Log-and-return duplicates noise in aggregators.

- Library / mid layers: wrap and return.
- Process edge (main, worker top, HTTP middleware that owns response): log once, then map to user-facing outcome.

## Panic

Reserve for truly unrecoverable programmer mistakes. Expected I/O, validation, not-found: returned errors. Recover only at goroutine / process boundaries if you must keep the process alive — then log and continue carefully.

## Logging

- Prefer `log/slog` with stable low-cardinality messages; IDs and paths as attributes.
- Never put high-cardinality values in the message template used for grouping.
- Translate internal errors for users; log technical detail separately.

## Optional: samber/oops

Need stack traces, tenant/user attrs, or rich structured error payloads in production? Consider [`samber/oops`](https://github.com/samber/oops). Not required for idiomatic Go.
