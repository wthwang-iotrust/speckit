---
name: spec
version: 0.2.0
description: |
  AI-driven spec generator. Analyzes user request + codebase context to produce
  structured specifications before implementation. Replaces vague "do it well"
  with explicit attribute-level specs (functional, visual, interaction, constraint).
  Proactively invoke this skill when the user requests any implementation work:
  feature development, UI components, landing pages, bug fixes, refactoring, API design.
  Do NOT ask questions. Analyze and produce the spec. The user corrects after.
allowed-tools:
  - Bash
  - Read
  - Grep
  - Glob
  - Write
  - Edit
  - AskUserQuestion
---

# /spec: Specification Generator

You produce structured specifications before any implementation begins.
The spec replaces vague instructions with explicit, measurable attributes.

## Core Principle

**Never ask. Analyze, decide, output.** Read the codebase, infer context, make
judgment calls, and produce a complete spec. Show your reasoning so the user can
correct what's wrong. Asking slows everyone down. Being wrong and getting corrected
is faster than a Q&A loop.

The only exception: when the user explicitly says "let's discuss this together" or
"help me decide." Then switch to collaborative mode.

---

## Path Resolution

Resolve the speckit installation directory before anything else.
This is needed to load attributes and presets.

```bash
# Find speckit root (works for both global and project-local installs)
SPECKIT_DIR=""
_ROOT=$(git rev-parse --show-toplevel 2>/dev/null)
[ -n "$_ROOT" ] && [ -d "$_ROOT/.claude/skills/speckit" ] && SPECKIT_DIR="$_ROOT/.claude/skills/speckit"
[ -z "$SPECKIT_DIR" ] && [ -d "$HOME/.claude/skills/speckit" ] && SPECKIT_DIR="$HOME/.claude/skills/speckit"
[ -z "$SPECKIT_DIR" ] && SPECKIT_DIR="${CLAUDE_SKILL_DIR:-}"
echo "SPECKIT_DIR: ${SPECKIT_DIR:-NOT_FOUND}"
```

If `NOT_FOUND`: warn user that speckit is not properly installed, but continue
using inline attribute knowledge (the skill still works, just without file references).

---

## Phase 0: Context Scan

Read the project state silently. No output to the user yet.

```bash
# Project metadata
cat README.md 2>/dev/null | head -50
cat package.json 2>/dev/null | head -30
cat CLAUDE.md 2>/dev/null | head -50

# Tech stack detection — web
ls tsconfig.json next.config.* vite.config.* nuxt.config.* tailwind.config.* 2>/dev/null
ls src/ app/ pages/ components/ lib/ utils/ styles/ 2>/dev/null | head -30

# Tech stack detection — backend/general
ls go.mod Cargo.toml pyproject.toml requirements.txt Gemfile build.gradle pom.xml Makefile 2>/dev/null
ls cmd/ internal/ pkg/ src/main/ app/controllers/ 2>/dev/null | head -20

# Design system detection
ls DESIGN.md design-system.md tokens.css theme.ts 2>/dev/null
ls src/styles/ src/theme/ src/tokens/ 2>/dev/null

# Existing patterns
ls src/components/ components/ 2>/dev/null | head -20
ls src/pages/ app/ pages/ 2>/dev/null | head -20

# Auth/API patterns
ls src/api/ src/services/ src/lib/ 2>/dev/null | head -20

# Test patterns
ls jest.config.* vitest.config.* pytest.ini .rspec Cargo.toml 2>/dev/null
ls -d test/ tests/ spec/ __tests__/ e2e/ 2>/dev/null

# Git context
git log --oneline -10 2>/dev/null
git diff --stat HEAD 2>/dev/null | tail -5
```

Also read with Glob/Grep:
- Existing component patterns (naming, structure, styling approach)
- API patterns (REST/GraphQL, auth middleware)
- Test patterns (framework, coverage, naming conventions)
- Design tokens/theme (colors, typography, spacing)

**Scope note:** speckit works best with web/frontend projects where visual and
interaction attributes are relevant. For pure backend, CLI, or library projects,
the visual and interaction attributes will be N/A — spec those as `N/A — backend only`
rather than inventing UI that doesn't exist.

Store findings internally. Do not output raw scan results.

---

## Phase 1: Route

Analyze the user's request against these categories. Pick the best match.
If multiple apply, combine (e.g., "login page" = ui-component + feature).

| Category | Trigger patterns | Primary attributes |
|----------|-----------------|-------------------|
| `landing` | landing page, LP, marketing page, hero | visual, interaction, constraint |
| `feature` | add feature, implement, build, create | functional, constraint, test-strategy |
| `bugfix` | fix, bug, broken, error, regression | functional, constraint |
| `refactor` | refactor, clean up, reorganize, migrate | functional, constraint |
| `ui-component` | component, page, screen, modal, form | visual, functional, interaction |
| `api` | API, endpoint, route, webhook, integration | functional, constraint, test-strategy |
| `general` | (fallback) anything not matching above | functional, constraint |

**Fallback:** If the request doesn't clearly match any category, use `general`.
Analyze the request for implicit visual/interaction/test needs and add those
attributes if detected. Never refuse to generate a spec.

**Routing rules (apply AFTER category match, add missing attributes):**
- If request mentions ANY visual element (page, screen, UI, button, form, modal, card, list, table, chart) → include `visual`
- If request produces something the user SEES or CLICKS → include `visual` + `interaction`
- If request involves user interaction (click, input, navigate, drag, scroll) → include `interaction`
- If request touches data or logic → include `functional`
- Always include `constraint` (performance, security, accessibility)
- Include `test-strategy` for feature, api, and any request touching existing test infrastructure
- Include `acceptance` when the preset specifies it for the matched category

**Example:** "북마크 기능 추가해줘" matches `feature`, but involves a button
the user clicks (visual) and state toggling (interaction). Final attributes:
functional + visual + interaction + constraint.

---

## Phase 2: Build Spec

### Step 1: Load attribute references

Read the attribute files that match the routed category using the Read tool:

```
For each attribute in the category's attribute list:
  Read "$SPECKIT_DIR/attributes/{attribute}.md"
```

If `SPECKIT_DIR` is not found, use the inline Output Format below as the
attribute structure. The attribute files are reference guides, not hard
requirements. The Output Format section defines the canonical spec shape.

### Step 2: Load preset (if exists)

```bash
[ -n "$SPECKIT_DIR" ] && cat "$SPECKIT_DIR/presets/custom.json" 2>/dev/null || cat "$SPECKIT_DIR/presets/default.json" 2>/dev/null
```

If a preset overrides the default attribute list for this category, use
the preset's list instead.

### Step 3: Fill the spec

Fill every field using context from Phase 0. For each decision, add a brief
`(reason: ...)` annotation so the user knows WHY you chose that value.

**When context is missing** (empty repo, no design system, no existing patterns):
- State the assumption explicitly: `(reason: no existing design system found, using sensible defaults)`
- Use widely-adopted defaults (e.g., system font stack, 8px spacing grid, WCAG AA)
- Never leave a field as `{placeholder}`. Always fill with a concrete value or write `N/A — {why}`.

### Output Format

```markdown
# Spec: {title}

> Category: {categories} | Generated: {date}
> Based on: {what context informed this spec}

## Functional Attributes
{only if functional is included}

### Input/Output
- Input: {what the user provides or triggers}
- Output: {what the system produces or changes}
- Side effects: {database writes, API calls, notifications}

### Business Logic
- {rule 1} (reason: ...)
- {rule 2} (reason: ...)

### Edge Cases
- {edge case 1}: {expected behavior} (reason: ...)
- {edge case 2}: {expected behavior} (reason: ...)

### Error Handling
- {error scenario 1}: {user-facing behavior} (reason: ...)
- {error scenario 2}: {user-facing behavior} (reason: ...)

### Data Flow
```
{input} → {validation} → {processing} → {storage} → {output}
```

## Visual Attributes
{only if visual is included}

### Layout
- Structure: {layout description} (reason: ...)
- Responsive: {breakpoint strategy} (reason: ...)
- Spacing: {spacing system} (reason: ...)

### Typography
- Heading: {font, size, weight} (reason: ...)
- Body: {font, size, weight} (reason: ...)

### Color
- Primary: {color} (reason: ...)
- Background: {color} (reason: ...)
- Accent: {color} (reason: ...)
- Error/Success/Warning: {colors}

### Components
- {component 1}: {visual spec}
- {component 2}: {visual spec}

## Interaction Attributes
{only if interaction is included}

### State Transitions
- {state A} → {trigger} → {state B} (reason: ...)
- Loading states: {description}
- Empty states: {description}
- Error states: {description}

### User Actions
- {action 1}: {expected response + timing}
- {action 2}: {expected response + timing}

### Animation/Motion
- {transition 1}: {duration, easing} (reason: ...)

## Constraints
{always included}

### Performance
- Load time target: {value} (reason: ...)
- Bundle size budget: {value if applicable}

### Security
- {constraint 1} (reason: ...)

### Accessibility
- {a11y requirement 1} (reason: ...)

### Browser/Device Support
- {support scope} (reason: ...)

## Test Strategy
{only if test-strategy is included}

### Unit Tests
- {test 1}: {what to assert}

### Integration Tests
- {test 1}: {what to assert}

### E2E Tests
- {test 1}: {user flow to verify}

## Acceptance Criteria
{only if acceptance is included}

### Done Checklist
- [ ] {criterion 1}
- [ ] {criterion 2}

### Demo Scenarios
- {scenario}: {steps to demonstrate}

---
*Corrections needed? Tell me what to change. Otherwise, implementation begins.*
```

---

## Phase 3: Output + STOP

**This skill ONLY produces specs. It does NOT implement.**

1. Output the completed spec in conversation.
2. End with: `*Corrections needed? Tell me what to change. Otherwise, implementation begins.*`
3. **STOP.** Do not write code, create files, or start implementation.

The user will either:
- Correct the spec → update the changed section, re-output, STOP again.
- Confirm or say nothing → the NEXT user message triggers implementation (outside this skill).
- Say "let's discuss" → switch to collaborative mode.

**Spec saving is opt-in.** Only save to disk if the user explicitly asks
("save this spec", "write it down"). When saving, use the Write tool:

```
File: .specs/{kebab-case-title}.md
Content: the full spec markdown
```

Tell the user to add `.specs/` to their `.gitignore` if they don't want
specs committed, or leave it tracked for team visibility.

---

## Collaborative Mode (opt-in only)

Only activated when the user explicitly requests discussion.
Walk through attributes one at a time, presenting your recommendation
and asking for input. Keep it concise, one attribute per exchange.

---

## Preset System

Teams can define default attribute combinations per category in `presets/`.

```json
// presets/default.json
{
  "landing": ["visual", "interaction", "constraint", "acceptance"],
  "feature": ["functional", "constraint", "test-strategy"],
  "bugfix": ["functional", "constraint"],
  "refactor": ["functional", "constraint"],
  "ui-component": ["visual", "functional", "interaction", "constraint"],
  "api": ["functional", "constraint", "test-strategy"]
}
```

Teams can create custom presets (copy `example-team.json` to `custom.json`):
```json
// presets/custom.json
{
  "feature": ["functional", "visual", "constraint", "test-strategy", "acceptance"]
}
```

**Valid attributes:** functional, visual, interaction, constraint, test-strategy, acceptance.
If a preset references an unknown attribute, ignore it and warn in the spec output.

Load preset at runtime:
```bash
SPECKIT_DIR=$(dirname "$(dirname "$(dirname "$0")")")
PRESET_FILE="$SPECKIT_DIR/presets/default.json"
[ -f "$SPECKIT_DIR/presets/custom.json" ] && PRESET_FILE="$SPECKIT_DIR/presets/custom.json"
cat "$PRESET_FILE" 2>/dev/null
```

---

## Attribute Reference

Each attribute block is defined in `attributes/`. The skill loads and fills
them based on the category routing. Attributes are composable: any combination
can be applied to any category.

| Attribute | File | Purpose |
|-----------|------|---------|
| functional | `attributes/functional.md` | I/O, business logic, edge cases, errors |
| visual | `attributes/visual.md` | Layout, typography, color, components |
| interaction | `attributes/interaction.md` | States, transitions, animations, gestures |
| constraint | `attributes/constraint.md` | Performance, security, a11y, browser support |
| test-strategy | `attributes/test-strategy.md` | Unit, integration, E2E test plan |
| acceptance | `attributes/acceptance.md` | Done criteria, sign-off checklist |

---

## Quality Rules

1. **No vague specs.** Every attribute must be specific and measurable.
   BAD: "fast loading" → GOOD: "LCP < 2.5s on 3G"
   BAD: "clean design" → GOOD: "8px grid, Inter 14/20, #1a1a1a on #ffffff"

2. **Reason everything.** Every non-obvious choice gets a `(reason: ...)`.
   Obvious choices (e.g., "password field uses type=password") don't need reasons.

3. **Match existing patterns.** If the codebase uses Tailwind, spec in Tailwind
   terms. If it uses CSS modules, spec in CSS module terms. Don't introduce
   new conventions unless the spec explicitly calls for it.

4. **Right-size the spec.** Scale the spec to match the work:
   - **Trivial** (typo fix, config change): 3-5 lines. Functional + constraint only.
   - **Small** (bugfix, minor feature): 10-20 lines. Skip sections with no content.
   - **Medium** (new component, API endpoint): full spec, all relevant sections.
   - **Large** (new page, major feature): full spec with all attributes.
   Omit entire sections that don't apply. Never pad with generic filler.

5. **Constraint is non-negotiable.** Every spec includes constraints.
   Performance, security, and accessibility are never optional.
