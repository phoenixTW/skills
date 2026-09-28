# When to Mock

Mock at **system boundaries** only:

- External APIs (payment, email, etc.)
- Databases (sometimes - prefer test DB)
- Time/randomness
- File system (sometimes)

Don't mock:

- Your own classes/modules
- Internal collaborators
- Anything you control

## Designing for Mockability

At system boundaries, design interfaces that are easy to mock:

**1. Use dependency injection**

Pass external dependencies in rather than creating them internally:

```go
// Easy to mock
func ProcessPayment(order Order, paymentClient PaymentClient) error {
	return paymentClient.Charge(order.Total)
}

// Hard to mock
func ProcessPaymentHard(order Order) error {
	client := stripe.NewClient(os.Getenv("STRIPE_KEY"))
	return client.Charge(order.Total)
}
```

**2. Prefer SDK-style interfaces over generic fetchers**

Create specific functions for each external operation instead of one generic function with conditional logic:

```go
// GOOD: Each function is independently mockable
type API interface {
	GetUser(ctx context.Context, id string) (User, error)
	GetOrders(ctx context.Context, userID string) ([]Order, error)
	CreateOrder(ctx context.Context, input CreateOrderInput) (Order, error)
}

// BAD: Mocking requires conditional logic inside the mock
type API interface {
	Do(ctx context.Context, method string, path string, payload any) ([]byte, error)
}
```

The SDK approach means:

- Each mock returns one specific shape
- No conditional logic in test setup
- Easier to see which endpoints a test exercises
- Type safety per endpoint
