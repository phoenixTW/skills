# Interface Design for Testability

Good interfaces make testing natural:

1. **Accept dependencies, don't create them**

   ```go
   // Testable
   func ProcessOrder(order Order, paymentGateway PaymentGateway) error {
   	return paymentGateway.Charge(order.Total)
   }

   // Hard to test
   func ProcessOrderHard(order Order) error {
     gateway := NewStripeGateway()
     return gateway.Charge(order.Total)
   }
   ```

2. **Return results, don't produce side effects**

   ```go
   // Testable
   func CalculateDiscount(cart Cart) Discount {
   	// pure function: easy to assert in tests
   	return Discount{Amount: cart.Total * 0.1}
   }

   // Hard to test
   func ApplyDiscount(cart *Cart) {
     cart.Total -= CalculateDiscount(*cart).Amount
   }
   ```

3. **Small surface area**
   - Fewer methods = fewer tests needed
   - Fewer params = simpler test setup
