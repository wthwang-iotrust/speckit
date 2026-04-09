# Test Strategy Attributes

Guide: Every test must specify exact inputs, expected outputs, and the
assertion type. A test description you can't implement in 5 minutes is
too vague.

## Unit Tests
- {function/module}: {input → expected output}
- {function/module}: {edge case → expected behavior}
- Coverage target: {percentage}

```
BAD:  "test the validation"
GOOD: "validateEmail('') → { valid: false, error: 'Email is required' }
       validateEmail('not-an-email') → { valid: false, error: 'Invalid email format' }
       validateEmail('user@example.com') → { valid: true }
       validateEmail('a'.repeat(255) + '@test.com') → { valid: false, error: 'Email too long' }"
```

## Integration Tests
- {flow}: {components involved, expected outcome}
- API contract: {request → response shape}
- Database: {migration, seed data, cleanup}

```
BAD:  "test the API"
GOOD: "POST /api/users { email, password } → 201 { id, email, createdAt }
       POST /api/users { duplicate email } → 409 { error: 'Email already exists' }
       POST /api/users { missing password } → 400 { error: 'Password is required' }
       Seed: empty users table. Cleanup: truncate after each test."
```

## E2E Tests
- {user flow}: {steps → expected result}
- Happy path: {primary scenario}
- Error path: {failure scenario → recovery}
- Cross-browser: {browsers to test}

```
BAD:  "test signup flow"
GOOD: "1. Navigate to /signup
       2. Fill email: test@example.com, password: Test1234!
       3. Click 'Create Account'
       4. Assert: redirect to /dashboard within 3s
       5. Assert: welcome toast visible
       6. Assert: user appears in /api/users (verify DB write)"
```

## Visual Regression
- {component/page}: {screenshot comparison}
- Responsive: {breakpoints to capture}
- Tool: {Chromatic/Percy/Playwright screenshots}

## Performance Tests
- {endpoint/page}: {metric → threshold}
- Load test: {concurrent users, response time target}

## Test Data
- Fixtures: {mock data strategy}
- Seeds: {database seed approach}
- Cleanup: {teardown strategy}
