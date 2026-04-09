# Acceptance Criteria

Guide: Every criterion must be binary (pass/fail) and verifiable without
subjective judgment. If two people could disagree on whether it's met, it's
not specific enough.

## Done Checklist
- [ ] {criterion 1}
- [ ] {criterion 2}

```
BAD:  "code is clean and well-tested"
GOOD: "- [ ] All business logic functions have unit tests with >80% branch coverage
       - [ ] No TypeScript errors (strict mode)
       - [ ] Lighthouse accessibility score >= 90
       - [ ] All form fields have visible error states for invalid input
       - [ ] Loading states render within 200ms of action trigger"
```

## Demo Scenarios
- {scenario}: {steps to demonstrate}

```
BAD:  "demo the feature to the team"
GOOD: "Scenario: Bookmark a question
       1. Start a quiz in practice mode
       2. On question 3, tap the bookmark icon
       3. Verify: icon turns yellow, count badge updates
       4. Navigate to bookmark list
       5. Verify: question 3 appears in the list
       6. Tap question 3 in the list
       7. Verify: navigates to question 3 with bookmark icon filled"
```

## Sign-off — omit from spec output unless team preset includes it
Roles are optional. Include only those that apply to your team.
In the spec output, fold sign-off items into the Done Checklist if needed.

- Developer: {self-review checklist, e.g., "ran locally on mobile viewport"}
- Designer: {visual approval criteria, e.g., "matches Figma within 2px"}
- QA: {test matrix, e.g., "tested on Chrome, Safari, iOS Safari"}
- Product: {business requirement verification}

```
BAD:  "get approval from stakeholders"
GOOD: "Developer: tested on Chrome + Safari, both mobile and desktop viewports.
       No sign-off needed from designer (no new visual components).
       QA: manual test on iOS Safari 17 (primary mobile target)."
```
