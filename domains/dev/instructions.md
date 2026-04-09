# Dev Domain Instructions

This file is loaded by SKILL.md when the router selects the `dev` domain.
It contains dev-specific context scanning, routing, and output guidance.

## Domain: dev

Covers: feature development, UI components, landing pages, bug fixes,
refactoring, API design, and any code implementation work.

## Context Scan Extensions

In addition to the common scan (Phase 0 Step 1), run these dev-specific checks:

### Web/frontend projects
```
Glob("src/components/**/*.{tsx,jsx,vue,svelte}") | head -10   → component naming
Glob("src/pages/**/*") | head -10                             → page structure
Glob("**/*.test.*") | head -10                                → test conventions
Grep("className=|class=", glob="*.{tsx,jsx,html}", head_limit=5) → styling approach
Grep("fetch(|axios|useSWR|useQuery", glob="*.{ts,tsx,js}", head_limit=5) → data fetching
Grep("color:|--.*color|bg-|text-", glob="*.{css,scss,ts}", head_limit=5) → color tokens
```

### Backend/general projects
```
Glob("**/*.{go,rs,py,rb,java}") | head -10                   → language files
Grep("func |def |class ", glob="*.{go,py,rb}", head_limit=5) → code structure
Grep("router|handler|endpoint|@app", glob="*.{go,py,rb,java}", head_limit=5) → API patterns
Grep("test|spec|assert", glob="**/*test*", head_limit=5)     → test patterns
```

**If no matches:** note the absence as context. Don't invent patterns.

## Categories

| Category | Trigger patterns | Primary attributes |
|----------|-----------------|-------------------|
| `landing` | landing page, LP, marketing page, hero | visual, interaction, constraint |
| `feature` | add feature, implement, build, create | functional, constraint, test-strategy |
| `bugfix` | fix, bug, broken, error, regression | functional, constraint |
| `refactor` | refactor, clean up, reorganize, migrate | functional, constraint |
| `ui-component` | component, page, screen, modal, form | visual, functional, interaction |
| `api` | API, endpoint, route, webhook, integration | functional, constraint, test-strategy |
| `general` | (fallback) anything not matching above | functional, constraint |

## Routing Rules (apply AFTER category match)

- If the result is something a user SEES → include `visual`
- If the result is something a user INTERACTS with → include `visual` + `interaction`
- If request touches data or logic → include `functional`
- Always include `constraint`
- Include `test-strategy` when test infrastructure exists (detected in Phase 0)
- Include `acceptance` when the preset specifies it

## Scope Note

For pure backend, CLI, or library projects, mark visual and interaction attributes
as `N/A — backend only` rather than inventing UI that doesn't exist.

## Section Item Counts

- Business Logic: 1-3 rules (only non-obvious ones)
- Edge Cases: 2-5 (focus on likely scenarios, not exhaustive)
- Error Handling: 2-4 (user-facing errors only)
- Test Strategy: 3-7 test cases (cover happy + error + edge)
- Acceptance: 3-6 criteria (measurable, not generic)

Fewer is better than padding. Omit entire sections with no content.
