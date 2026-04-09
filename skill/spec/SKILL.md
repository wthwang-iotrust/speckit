---
name: spec
version: 0.1.0
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

# Tech stack detection
ls tsconfig.json next.config.* vite.config.* nuxt.config.* tailwind.config.* 2>/dev/null
ls src/ app/ pages/ components/ lib/ utils/ styles/ 2>/dev/null | head -30

# Design system detection
ls DESIGN.md design-system.md tokens.css theme.ts 2>/dev/null
ls src/styles/ src/theme/ src/tokens/ 2>/dev/null

# Existing patterns
ls src/components/ components/ 2>/dev/null | head -20
ls src/pages/ app/ pages/ 2>/dev/null | head -20

# Auth/API patterns
ls src/api/ src/services/ src/lib/ 2>/dev/null | head -20

# Git context
git log --oneline -10 2>/dev/null
git diff --stat HEAD 2>/dev/null | tail -5
```

Also read with Glob/Grep:
- Existing component patterns (naming, structure, styling approach)
- API patterns (REST/GraphQL, auth middleware)
- Test patterns (framework, coverage)
- Design tokens/theme (colors, typography, spacing)

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

**Routing rules:**
- If request mentions visual elements (page, screen, UI) → include `visual`
- If request involves user interaction (click, input, navigate) → include `interaction`
- If request touches data or logic → include `functional`
- Always include `constraint` (performance, security, accessibility)
- Include `test-strategy` for feature and api categories

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

---
*Corrections needed? Tell me what to change. Otherwise, implementation begins.*
```

---

## Phase 3: Output + Proceed

1. Output the completed spec in conversation
2. Save a copy to the project:

```bash
SPEC_DIR=".specs"
mkdir -p "$SPEC_DIR"
FILENAME=$(echo "{title}" | tr '[:upper:]' '[:lower:]' | tr ' ' '-' | tr -cd '[:alnum:]-')
echo "Spec saved to $SPEC_DIR/$FILENAME.md"
```

3. Wait briefly for corrections. If the user says nothing or confirms,
   proceed to implementation using the spec as the source of truth.

**If the user corrects something:** Update the spec, re-output the changed
section only, and proceed.

**If the user says "let's discuss":** Switch to collaborative mode.
Ask about the specific attributes they want to discuss, one at a time.

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

Teams can create custom presets:
```json
// presets/my-team.json
{
  "landing": ["visual", "interaction", "constraint", "acceptance", "seo"],
  "feature": ["functional", "constraint", "test-strategy", "monitoring"]
}
```

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

4. **Right-size the spec.** A one-liner bugfix gets a 5-line spec. A full
   landing page gets a full spec. Don't over-spec trivial work.

5. **Constraint is non-negotiable.** Every spec includes constraints.
   Performance, security, and accessibility are never optional.
