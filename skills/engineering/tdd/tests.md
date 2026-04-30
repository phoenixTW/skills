# Good and Bad Tests

## Good Tests

**Integration-style**: Test through real interfaces, not mocks of internal parts.

```go
// GOOD: Tests observable behavior
func TestCheckout_WithValidCart_ConfirmsOrder(t *testing.T) {
	cart := NewCart()
	cart.Add(product)

	result, err := Checkout(cart, paymentMethod)
	if err != nil {
		t.Fatalf("checkout failed: %v", err)
	}
	if result.Status != "confirmed" {
		t.Fatalf("expected confirmed status, got %q", result.Status)
	}
}
```

Characteristics:

- Tests behavior users/callers care about
- Uses public API only
- Survives internal refactors
- Describes WHAT, not HOW
- One logical assertion per test

## Bad Tests

**Implementation-detail tests**: Coupled to internal structure.

```go
// BAD: Tests implementation details
func TestCheckout_CallsPaymentProcess(t *testing.T) {
	mockPayment := &MockPaymentService{}
	_, _ = Checkout(cart, mockPayment)

	if !mockPayment.ProcessCalledWith(cart.Total()) {
		t.Fatal("expected process to be called with cart total")
	}
}
```

Red flags:

- Mocking internal collaborators
- Testing private methods
- Asserting on call counts/order
- Test breaks when refactoring without behavior change
- Test name describes HOW not WHAT
- Verifying through external means instead of interface

```go
// BAD: Bypasses interface to verify
func TestCreateUser_SavesToDatabase(t *testing.T) {
	_, _ = CreateUser(CreateUserInput{Name: "Alice"})

	row := db.QueryRow("SELECT name FROM users WHERE name = ?", "Alice")
	var name string
	if err := row.Scan(&name); err != nil {
		t.Fatalf("expected row for Alice: %v", err)
	}
}

// GOOD: Verifies through interface
func TestCreateUser_MakesUserRetrievable(t *testing.T) {
	user, err := CreateUser(CreateUserInput{Name: "Alice"})
	if err != nil {
		t.Fatalf("create user failed: %v", err)
	}

	retrieved, err := GetUser(user.ID)
	if err != nil {
		t.Fatalf("get user failed: %v", err)
	}
	if retrieved.Name != "Alice" {
		t.Fatalf("expected name Alice, got %q", retrieved.Name)
	}
}
```
