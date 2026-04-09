# Functional Attributes

Guide: Every field must be specific and testable. If you can't write a test
for it, it's not specific enough.

## Input/Output
- Input: {what the user provides, triggers, or submits}
- Output: {what the system produces, returns, or renders}
- Side effects: {database writes, API calls, notifications, cache invalidation}

```
BAD:  Input: "user data"
GOOD: Input: email (string, RFC 5322), password (string, 8-72 chars, 1 upper + 1 number)

BAD:  Output: "success message"
GOOD: Output: JWT access token (15min TTL) + httpOnly refresh cookie (7d TTL)
```

## Business Logic
- {rule 1} (reason: ...)
- {rule 2} (reason: ...)

```
BAD:  "validate the form"
GOOD: "email must be unique in users table; if duplicate, show 'This email is
       already registered' with link to login page (reason: 12% of signup
       errors are duplicate emails per analytics)"
```

## Edge Cases
- {scenario}: {expected behavior} (reason: ...)
- Empty input: {behavior}
- Maximum length/size: {behavior}
- Concurrent access: {behavior}
- Stale data: {behavior}

```
BAD:  "handle edge cases"
GOOD: "Concurrent cart updates: last-write-wins with optimistic locking;
       if conflict, re-fetch cart and show 'Cart was updated' toast"
```

## Error Handling
- {error scenario}: {user-facing message + system behavior}
- Network failure: {behavior}
- Invalid input: {behavior}
- Auth failure: {behavior}
- Rate limit: {behavior}

```
BAD:  "show error message"
GOOD: "Network failure during payment: keep form state, show inline error
       'Connection lost. Your card was not charged. Please try again.',
       retry button, log to Sentry with correlation ID"
```

## Data Flow
```
{input source} → {validation} → {processing} → {storage} → {output}
```

```
BAD:  "data flows through the system"
GOOD: "POST /api/orders → validate(items, address, payment) → 
       stripe.charges.create() → INSERT orders + order_items → 
       emit OrderCreated event → return { orderId, status: 'confirmed' }"
```
