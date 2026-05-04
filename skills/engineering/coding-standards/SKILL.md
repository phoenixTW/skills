---
name: coding-standards
description: Universal coding standards, best practices, and patterns for Go services and APIs.
origin: ECC
---

# Coding Standards & Best Practices

Universal standards for clean, maintainable Go code.

## When to Activate

- Starting a new service, package, or module
- Reviewing code quality and maintainability
- Refactoring legacy code to consistent conventions
- Enforcing naming, formatting, or structural consistency
- Setting up linting, formatting, and static checks
- Onboarding contributors to shared standards

## Code Quality Principles

### 1. Readability First

- Code read more than written
- Use clear names for variables, functions, and types
- Prefer self-documenting code over excessive comments
- Keep formatting and style consistent

### 2. KISS (Keep It Simple, Stupid)

- Choose simplest solution that works
- Avoid over-engineering
- Skip premature optimization
- Clear code beats clever code

### 3. DRY (Don't Repeat Yourself)

- Extract shared logic into functions or packages
- Reuse abstractions across modules
- Centralize common validation and helpers
- Avoid copy-paste development

### 4. YAGNI (You Aren't Gonna Need It)

- Build features when needed, not before
- Avoid speculative abstractions
- Add complexity only when justified
- Start simple, refactor with evidence

## Go Standards

### Variable Naming

```go
// ✅ GOOD: Descriptive names
marketSearchQuery := "election"
isUserAuthenticated := true
totalRevenue := 1000.0

// ❌ BAD: Unclear names
q := "election"
flag := true
x := 1000.0
```

### Function Naming

```go
// ✅ GOOD: Verb-noun pattern
func FetchMarketData(ctx context.Context, marketID string) (*Market, error) {
	return nil, nil
}

func CalculateSimilarity(a []float64, b []float64) float64 {
	return 0
}

func IsValidEmail(email string) bool {
	return strings.Contains(email, "@")
}

// ❌ BAD: Unclear or noun-only
func Market(id string) {}
func Similarity(a, b []float64) {}
func Email(e string) {}
```

### Immutability Pattern (CRITICAL)

```go
type User struct {
	ID   string
	Name string
}

// ✅ GOOD: Copy before changing when sharing state
func UpdatedUserName(user User, newName string) User {
	updated := user
	updated.Name = newName
	return updated
}

// ✅ GOOD: Copy slice before append when caller may retain original
func AppendItem(items []string, newItem string) []string {
	copied := append([]string(nil), items...)
	return append(copied, newItem)
}

// ❌ BAD: Mutating shared references unexpectedly
func MutateUser(user *User) {
	user.Name = "New Name" // BAD when called on shared object
}

func MutateSlice(items []string, newItem string) []string {
	items = append(items, newItem) // BAD if ownership unclear
	return items
}
```

### Error Handling

```go
// ✅ GOOD: Wrap context and return typed errors
var ErrNotFound = errors.New("market not found")

func FetchData(ctx context.Context, client *http.Client, url string) ([]byte, error) {
	req, err := http.NewRequestWithContext(ctx, http.MethodGet, url, nil)
	if err != nil {
		return nil, fmt.Errorf("build request: %w", err)
	}

	resp, err := client.Do(req)
	if err != nil {
		return nil, fmt.Errorf("do request: %w", err)
	}
	defer resp.Body.Close()

	if resp.StatusCode == http.StatusNotFound {
		return nil, ErrNotFound
	}
	if resp.StatusCode < 200 || resp.StatusCode >= 300 {
		return nil, fmt.Errorf("unexpected status: %d", resp.StatusCode)
	}

	body, err := io.ReadAll(resp.Body)
	if err != nil {
		return nil, fmt.Errorf("read response body: %w", err)
	}
	return body, nil
}

// ❌ BAD: Ignore errors
func FetchDataBad(client *http.Client, url string) []byte {
	resp, _ := client.Get(url) // BAD
	defer resp.Body.Close()
	body, _ := io.ReadAll(resp.Body) // BAD
	return body
}
```

### Concurrency Best Practices

```go
// ✅ GOOD: Parallel work with errgroup and context
func LoadDashboard(ctx context.Context) error {
	g, ctx := errgroup.WithContext(ctx)

	g.Go(func() error { return fetchUsers(ctx) })
	g.Go(func() error { return fetchMarkets(ctx) })
	g.Go(func() error { return fetchStats(ctx) })

	return g.Wait()
}

// ❌ BAD: Sequential work when independent
func LoadDashboardBad(ctx context.Context) error {
	if err := fetchUsers(ctx); err != nil {
		return err
	}
	if err := fetchMarkets(ctx); err != nil {
		return err
	}
	if err := fetchStats(ctx); err != nil {
		return err
	}
	return nil
}
```

### Type Safety

```go
// ✅ GOOD: Strong domain types
type MarketStatus string

const (
	MarketStatusActive   MarketStatus = "active"
	MarketStatusResolved MarketStatus = "resolved"
	MarketStatusClosed   MarketStatus = "closed"
)

type Market struct {
	ID        string
	Name      string
	Status    MarketStatus
	CreatedAt time.Time
}

func GetMarket(ctx context.Context, id string) (Market, error) {
	return Market{}, nil
}

// ❌ BAD: Weak typing with interface{}
func GetMarketBad(ctx context.Context, id interface{}) (interface{}, error) {
	return nil, nil
}
```

## API Design Standards

### REST API Conventions

```
GET    /api/markets              # List all markets
GET    /api/markets/{id}         # Get specific market
POST   /api/markets              # Create new market
PUT    /api/markets/{id}         # Update market (full)
PATCH  /api/markets/{id}         # Update market (partial)
DELETE /api/markets/{id}         # Delete market

# Query parameters for filtering
GET /api/markets?status=active&limit=10&offset=0
```

### Response Format

```go
// ✅ GOOD: Consistent response envelope
type APIResponse[T any] struct {
	Success bool    `json:"success"`
	Data    *T      `json:"data,omitempty"`
	Error   string  `json:"error,omitempty"`
	Meta    *Meta   `json:"meta,omitempty"`
}

type Meta struct {
	Total int `json:"total"`
	Page  int `json:"page"`
	Limit int `json:"limit"`
}

func writeJSON(w http.ResponseWriter, status int, v any) {
	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(status)
	_ = json.NewEncoder(w).Encode(v)
}

// Success response
func writeMarkets(w http.ResponseWriter, markets []Market) {
	resp := APIResponse[[]Market]{
		Success: true,
		Data:    &markets,
		Meta:    &Meta{Total: 100, Page: 1, Limit: 10},
	}
	writeJSON(w, http.StatusOK, resp)
}

// Error response
func writeBadRequest(w http.ResponseWriter, message string) {
	resp := APIResponse[any]{
		Success: false,
		Error:   message,
	}
	writeJSON(w, http.StatusBadRequest, resp)
}
```

### Input Validation

```go
type CreateMarketRequest struct {
	Name        string   `json:"name" validate:"required,min=1,max=200"`
	Description string   `json:"description" validate:"required,min=1,max=2000"`
	EndDate     string   `json:"endDate" validate:"required,datetime=2006-01-02T15:04:05Z07:00"`
	Categories  []string `json:"categories" validate:"required,min=1,dive,required"`
}

func CreateMarketHandler(validate *validator.Validate) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		var req CreateMarketRequest
		if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
			writeBadRequest(w, "invalid JSON payload")
			return
		}

		if err := validate.Struct(req); err != nil {
			writeJSON(w, http.StatusBadRequest, APIResponse[any]{
				Success: false,
				Error:   "validation failed",
			})
			return
		}

		writeJSON(w, http.StatusCreated, APIResponse[string]{
			Success: true,
			Data:    ptr("created"),
		})
	}
}

func ptr[T any](v T) *T { return &v }
```

## File Organization

### Project Structure

```
cmd/
├── api/                    # Main app entrypoint
internal/
├── market/                 # Domain logic
│   ├── handler/            # HTTP handlers
│   ├── service/            # Business logic
│   └── repository/         # Data access
├── auth/                   # Auth module
pkg/
├── httpx/                  # Shared HTTP helpers
├── config/                 # Config loading
└── logger/                 # Logging adapters
migrations/                 # SQL migrations
```

### File Naming

```
internal/market/handler/create_market.go
internal/auth/service/token_service.go
pkg/httpx/response.go
pkg/config/config.go
```

## Comments & Documentation

### When to Comment

```go
// ✅ GOOD: Explain WHY, not WHAT
// Use exponential backoff to avoid hammering dependency during partial outages.
delay := min(1000*int(math.Pow(2, float64(retryCount))), 30000)

// Deliberately mutating buffer in place to avoid large allocations on hot path.
buf = append(buf, chunk...)

// ❌ BAD: Stating the obvious
// Increment counter by 1
count++

// Set name to user's name
name = user.Name
```

### GoDoc for Public APIs

```go
// SearchMarkets finds markets using semantic similarity.
//
// query is a natural language search string.
// limit controls max number of results (default: 10).
//
// Returns markets sorted by similarity score.
// Returns error when embedding provider or cache is unavailable.
//
// Example:
//
//		results, err := SearchMarkets(ctx, "election", 5)
//		if err != nil {
//			log.Fatal(err)
//		}
//		fmt.Println(results[0].Name)
func SearchMarkets(ctx context.Context, query string, limit int) ([]Market, error) {
	return nil, nil
}
```

## Performance Best Practices

### Allocation Control

```go
// ✅ GOOD: Preallocate when size known
func BuildIDs(markets []Market) []string {
	ids := make([]string, 0, len(markets))
	for _, m := range markets {
		ids = append(ids, m.ID)
	}
	return ids
}

// ❌ BAD: Repeated growth reallocations
func BuildIDsBad(markets []Market) []string {
	var ids []string
	for _, m := range markets {
		ids = append(ids, m.ID)
	}
	return ids
}
```

### Caching Expensive Work

```go
type ScoreCache struct {
	mu   sync.RWMutex
	data map[string]float64
}

func (c *ScoreCache) GetOrCompute(key string, compute func() float64) float64 {
	c.mu.RLock()
	if v, ok := c.data[key]; ok {
		c.mu.RUnlock()
		return v
	}
	c.mu.RUnlock()

	v := compute()

	c.mu.Lock()
	c.data[key] = v
	c.mu.Unlock()
	return v
}
```

### Database Queries

```go
// ✅ GOOD: Select only needed columns and use context timeout
func ListMarkets(ctx context.Context, db *sql.DB) ([]Market, error) {
	ctx, cancel := context.WithTimeout(ctx, 2*time.Second)
	defer cancel()

	rows, err := db.QueryContext(ctx, `
		SELECT id, name, status
		FROM markets
		ORDER BY created_at DESC
		LIMIT 10
	`)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var out []Market
	for rows.Next() {
		var m Market
		if err := rows.Scan(&m.ID, &m.Name, &m.Status); err != nil {
			return nil, err
		}
		out = append(out, m)
	}
	return out, rows.Err()
}

// ❌ BAD: SELECT * with no limits
func ListMarketsBad(ctx context.Context, db *sql.DB) (*sql.Rows, error) {
	return db.QueryContext(ctx, "SELECT * FROM markets")
}
```

## Testing Standards

### Test Structure (AAA Pattern)

```go
func TestCalculateSimilarity(t *testing.T) {
	// Arrange
	vector1 := []float64{1, 0, 0}
	vector2 := []float64{0, 1, 0}

	// Act
	similarity := CalculateCosineSimilarity(vector1, vector2)

	// Assert
	if similarity != 0 {
		t.Fatalf("expected 0, got %v", similarity)
	}
}
```

### Test Naming

```go
// ✅ GOOD: Descriptive test names
func TestSearchMarkets_ReturnsEmpty_WhenNoMatch(t *testing.T) {}
func TestSearchMarkets_ReturnsError_WhenAPIKeyMissing(t *testing.T) {}
func TestSearchMarkets_FallbackToSubstring_WhenCacheDown(t *testing.T) {}

// ❌ BAD: Vague test names
func TestWorks(t *testing.T) {}
func TestSearch(t *testing.T) {}
```

## Code Smell Detection

Watch for these anti-patterns:

### 1. Long Functions

```go
// ❌ BAD: Function > 50 lines
func processMarketData() error {
	// 100 lines of code
	return nil
}

// ✅ GOOD: Split into smaller functions
func processMarketData() error {
	validated, err := validateData()
	if err != nil {
		return err
	}

	transformed, err := transformData(validated)
	if err != nil {
		return err
	}

	return saveData(transformed)
}
```

### 2. Deep Nesting

```go
// ❌ BAD: 5+ nesting levels
if user != nil {
	if user.IsAdmin {
		if market != nil {
			if market.IsActive {
				if hasPermission {
					// Do something
				}
			}
		}
	}
}

// ✅ GOOD: Early returns
if user == nil {
	return
}
if !user.IsAdmin {
	return
}
if market == nil {
	return
}
if !market.IsActive {
	return
}
if !hasPermission {
	return
}

// Do something
```

### 3. Magic Numbers

```go
// ❌ BAD: Unexplained numbers
if retryCount > 3 {
	return
}
time.Sleep(500 * time.Millisecond)

// ✅ GOOD: Named constants
const (
	MaxRetries      = 3
	DebounceDelayMS = 500
)

if retryCount > MaxRetries {
	return
}
time.Sleep(time.Duration(DebounceDelayMS) * time.Millisecond)
```

## **Remember**: Code quality not negotiable. Clear, maintainable code enables faster delivery and safer refactoring.

name: coding-standards
description: Universal coding standards, best practices, and patterns for TypeScript, JavaScript, React, and Node.js development.
origin: ECC

---

# Coding Standards & Best Practices

Universal coding standards applicable across all projects.

## When to Activate

- Starting a new project or module
- Reviewing code for quality and maintainability
- Refactoring existing code to follow conventions
- Enforcing naming, formatting, or structural consistency
- Setting up linting, formatting, or type-checking rules
- Onboarding new contributors to coding conventions

## Code Quality Principles

### 1. Readability First

- Code is read more than written
- Clear variable and function names
- Self-documenting code preferred over comments
- Consistent formatting

### 2. KISS (Keep It Simple, Stupid)

- Simplest solution that works
- Avoid over-engineering
- No premature optimization
- Easy to understand > clever code

### 3. DRY (Don't Repeat Yourself)

- Extract common logic into functions
- Create reusable components
- Share utilities across modules
- Avoid copy-paste programming

### 4. YAGNI (You Aren't Gonna Need It)

- Don't build features before they're needed
- Avoid speculative generality
- Add complexity only when required
- Start simple, refactor when needed

## TypeScript/JavaScript Standards

### Variable Naming

```typescript
// ✅ GOOD: Descriptive names
const marketSearchQuery = "election";
const isUserAuthenticated = true;
const totalRevenue = 1000;

// ❌ BAD: Unclear names
const q = "election";
const flag = true;
const x = 1000;
```

### Function Naming

```typescript
// ✅ GOOD: Verb-noun pattern
async function fetchMarketData(marketId: string) {}
function calculateSimilarity(a: number[], b: number[]) {}
function isValidEmail(email: string): boolean {}

// ❌ BAD: Unclear or noun-only
async function market(id: string) {}
function similarity(a, b) {}
function email(e) {}
```

### Immutability Pattern (CRITICAL)

```typescript
// ✅ ALWAYS use spread operator
const updatedUser = {
  ...user,
  name: "New Name",
};

const updatedArray = [...items, newItem];

// ❌ NEVER mutate directly
user.name = "New Name"; // BAD
items.push(newItem); // BAD
```

### Error Handling

```typescript
// ✅ GOOD: Comprehensive error handling
async function fetchData(url: string) {
  try {
    const response = await fetch(url);

    if (!response.ok) {
      throw new Error(`HTTP ${response.status}: ${response.statusText}`);
    }

    return await response.json();
  } catch (error) {
    console.error("Fetch failed:", error);
    throw new Error("Failed to fetch data");
  }
}

// ❌ BAD: No error handling
async function fetchData(url) {
  const response = await fetch(url);
  return response.json();
}
```

### Async/Await Best Practices

```typescript
// ✅ GOOD: Parallel execution when possible
const [users, markets, stats] = await Promise.all([
  fetchUsers(),
  fetchMarkets(),
  fetchStats(),
]);

// ❌ BAD: Sequential when unnecessary
const users = await fetchUsers();
const markets = await fetchMarkets();
const stats = await fetchStats();
```

### Type Safety

```typescript
// ✅ GOOD: Proper types
interface Market {
  id: string;
  name: string;
  status: "active" | "resolved" | "closed";
  created_at: Date;
}

function getMarket(id: string): Promise<Market> {
  // Implementation
}

// ❌ BAD: Using 'any'
function getMarket(id: any): Promise<any> {
  // Implementation
}
```

## React Best Practices

### Component Structure

```typescript
// ✅ GOOD: Functional component with types
interface ButtonProps {
  children: React.ReactNode
  onClick: () => void
  disabled?: boolean
  variant?: 'primary' | 'secondary'
}

export function Button({
  children,
  onClick,
  disabled = false,
  variant = 'primary'
}: ButtonProps) {
  return (
    <button
      onClick={onClick}
      disabled={disabled}
      className={`btn btn-${variant}`}
    >
      {children}
    </button>
  )
}

// ❌ BAD: No types, unclear structure
export function Button(props) {
  return <button onClick={props.onClick}>{props.children}</button>
}
```

### Custom Hooks

```typescript
// ✅ GOOD: Reusable custom hook
export function useDebounce<T>(value: T, delay: number): T {
  const [debouncedValue, setDebouncedValue] = useState<T>(value);

  useEffect(() => {
    const handler = setTimeout(() => {
      setDebouncedValue(value);
    }, delay);

    return () => clearTimeout(handler);
  }, [value, delay]);

  return debouncedValue;
}

// Usage
const debouncedQuery = useDebounce(searchQuery, 500);
```

### State Management

```typescript
// ✅ GOOD: Proper state updates
const [count, setCount] = useState(0);

// Functional update for state based on previous state
setCount((prev) => prev + 1);

// ❌ BAD: Direct state reference
setCount(count + 1); // Can be stale in async scenarios
```

### Conditional Rendering

```typescript
// ✅ GOOD: Clear conditional rendering
{isLoading && <Spinner />}
{error && <ErrorMessage error={error} />}
{data && <DataDisplay data={data} />}

// ❌ BAD: Ternary hell
{isLoading ? <Spinner /> : error ? <ErrorMessage error={error} /> : data ? <DataDisplay data={data} /> : null}
```

## API Design Standards

### REST API Conventions

```
GET    /api/markets              # List all markets
GET    /api/markets/:id          # Get specific market
POST   /api/markets              # Create new market
PUT    /api/markets/:id          # Update market (full)
PATCH  /api/markets/:id          # Update market (partial)
DELETE /api/markets/:id          # Delete market

# Query parameters for filtering
GET /api/markets?status=active&limit=10&offset=0
```

### Response Format

```typescript
// ✅ GOOD: Consistent response structure
interface ApiResponse<T> {
  success: boolean;
  data?: T;
  error?: string;
  meta?: {
    total: number;
    page: number;
    limit: number;
  };
}

// Success response
return NextResponse.json({
  success: true,
  data: markets,
  meta: { total: 100, page: 1, limit: 10 },
});

// Error response
return NextResponse.json(
  {
    success: false,
    error: "Invalid request",
  },
  { status: 400 },
);
```

### Input Validation

```typescript
import { z } from "zod";

// ✅ GOOD: Schema validation
const CreateMarketSchema = z.object({
  name: z.string().min(1).max(200),
  description: z.string().min(1).max(2000),
  endDate: z.string().datetime(),
  categories: z.array(z.string()).min(1),
});

export async function POST(request: Request) {
  const body = await request.json();

  try {
    const validated = CreateMarketSchema.parse(body);
    // Proceed with validated data
  } catch (error) {
    if (error instanceof z.ZodError) {
      return NextResponse.json(
        {
          success: false,
          error: "Validation failed",
          details: error.errors,
        },
        { status: 400 },
      );
    }
  }
}
```

## File Organization

### Project Structure

```
src/
├── app/                    # Next.js App Router
│   ├── api/               # API routes
│   ├── markets/           # Market pages
│   └── (auth)/           # Auth pages (route groups)
├── components/            # React components
│   ├── ui/               # Generic UI components
│   ├── forms/            # Form components
│   └── layouts/          # Layout components
├── hooks/                # Custom React hooks
├── lib/                  # Utilities and configs
│   ├── api/             # API clients
│   ├── utils/           # Helper functions
│   └── constants/       # Constants
├── types/                # TypeScript types
└── styles/              # Global styles
```

### File Naming

```
components/Button.tsx          # PascalCase for components
hooks/useAuth.ts              # camelCase with 'use' prefix
lib/formatDate.ts             # camelCase for utilities
types/market.types.ts         # camelCase with .types suffix
```

## Comments & Documentation

### When to Comment

```typescript
// ✅ GOOD: Explain WHY, not WHAT
// Use exponential backoff to avoid overwhelming the API during outages
const delay = Math.min(1000 * Math.pow(2, retryCount), 30000);

// Deliberately using mutation here for performance with large arrays
items.push(newItem);

// ❌ BAD: Stating the obvious
// Increment counter by 1
count++;

// Set name to user's name
name = user.name;
```

### JSDoc for Public APIs

````typescript
/**
 * Searches markets using semantic similarity.
 *
 * @param query - Natural language search query
 * @param limit - Maximum number of results (default: 10)
 * @returns Array of markets sorted by similarity score
 * @throws {Error} If OpenAI API fails or Redis unavailable
 *
 * @example
 * ```typescript
 * const results = await searchMarkets('election', 5)
 * console.log(results[0].name) // "Trump vs Biden"
 * ```
 */
export async function searchMarkets(
  query: string,
  limit: number = 10,
): Promise<Market[]> {
  // Implementation
}
````

## Performance Best Practices

### Memoization

```typescript
import { useMemo, useCallback } from "react";

// ✅ GOOD: Memoize expensive computations
const sortedMarkets = useMemo(() => {
  return markets.sort((a, b) => b.volume - a.volume);
}, [markets]);

// ✅ GOOD: Memoize callbacks
const handleSearch = useCallback((query: string) => {
  setSearchQuery(query);
}, []);
```

### Lazy Loading

```typescript
import { lazy, Suspense } from 'react'

// ✅ GOOD: Lazy load heavy components
const HeavyChart = lazy(() => import('./HeavyChart'))

export function Dashboard() {
  return (
    <Suspense fallback={<Spinner />}>
      <HeavyChart />
    </Suspense>
  )
}
```

### Database Queries

```typescript
// ✅ GOOD: Select only needed columns
const { data } = await supabase
  .from("markets")
  .select("id, name, status")
  .limit(10);

// ❌ BAD: Select everything
const { data } = await supabase.from("markets").select("*");
```

## Testing Standards

### Test Structure (AAA Pattern)

```typescript
test("calculates similarity correctly", () => {
  // Arrange
  const vector1 = [1, 0, 0];
  const vector2 = [0, 1, 0];

  // Act
  const similarity = calculateCosineSimilarity(vector1, vector2);

  // Assert
  expect(similarity).toBe(0);
});
```

### Test Naming

```typescript
// ✅ GOOD: Descriptive test names
test("returns empty array when no markets match query", () => {});
test("throws error when OpenAI API key is missing", () => {});
test("falls back to substring search when Redis unavailable", () => {});

// ❌ BAD: Vague test names
test("works", () => {});
test("test search", () => {});
```

## Code Smell Detection

Watch for these anti-patterns:

### 1. Long Functions

```typescript
// ❌ BAD: Function > 50 lines
function processMarketData() {
  // 100 lines of code
}

// ✅ GOOD: Split into smaller functions
function processMarketData() {
  const validated = validateData();
  const transformed = transformData(validated);
  return saveData(transformed);
}
```

### 2. Deep Nesting

```typescript
// ❌ BAD: 5+ levels of nesting
if (user) {
  if (user.isAdmin) {
    if (market) {
      if (market.isActive) {
        if (hasPermission) {
          // Do something
        }
      }
    }
  }
}

// ✅ GOOD: Early returns
if (!user) return;
if (!user.isAdmin) return;
if (!market) return;
if (!market.isActive) return;
if (!hasPermission) return;

// Do something
```

### 3. Magic Numbers

```typescript
// ❌ BAD: Unexplained numbers
if (retryCount > 3) {
}
setTimeout(callback, 500);

// ✅ GOOD: Named constants
const MAX_RETRIES = 3;
const DEBOUNCE_DELAY_MS = 500;

if (retryCount > MAX_RETRIES) {
}
setTimeout(callback, DEBOUNCE_DELAY_MS);
```

**Remember**: Code quality is not negotiable. Clear, maintainable code enables rapid development and confident refactoring.
