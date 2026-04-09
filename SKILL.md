---
name: spec
version: 0.3.0
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

**State machine — the ONLY valid execution paths:**

```
Path A (normal):
  Phase 0 (scan) → Phase 1 (route) → Phase 2 (build) → Phase 3 (output + STOP)

Path B (trivial):
  Phase 0 (scan) → Phase 0.5 (trivial detected) → micro-spec output → STOP
```

After STOP, the skill does NOTHING. No file writes, no implementation, no side effects.
Decision accumulation happens INSIDE Phase 3 (before STOP), not after.

---

## Core Principle

**Never ask. Analyze, decide, output, stop.** Read the codebase, infer context,
make judgment calls, and produce a complete spec. Show your reasoning so the user
can correct what's wrong. Asking slows everyone down. Being wrong and getting
corrected is faster than a Q&A loop.

The only exception: the user explicitly says "let's discuss this together" or
"help me decide." Then switch to collaborative mode.

---

## Path Resolution

```bash
SPECKIT_DIR=""
_ROOT=$(git rev-parse --show-toplevel 2>/dev/null)
[ -n "$_ROOT" ] && [ -d "$_ROOT/.claude/skills/speckit" ] && SPECKIT_DIR="$_ROOT/.claude/skills/speckit"
[ -z "$SPECKIT_DIR" ] && [ -d "$HOME/.claude/skills/speckit" ] && SPECKIT_DIR="$HOME/.claude/skills/speckit"
[ -z "$SPECKIT_DIR" ] && SPECKIT_DIR="${CLAUDE_SKILL_DIR:-}"
echo "SPECKIT_DIR: ${SPECKIT_DIR:-NOT_FOUND}"
```

If `NOT_FOUND`: continue without file references. The skill works with inline
knowledge alone. Do not warn the user or block execution.

---

## Phase 0: Context Scan

Read the project state silently. No output to the user yet.

### Step 1: Run detection commands

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

# Test patterns
ls jest.config.* vitest.config.* pytest.ini .rspec 2>/dev/null
ls -d test/ tests/ spec/ __tests__/ e2e/ 2>/dev/null

# Git context
git log --oneline -10 2>/dev/null
git diff --stat HEAD 2>/dev/null | tail -5
```

**If bash fails** (permissions, not a git repo, etc.): skip to Step 2.
The scan is best-effort, not required.

### Step 2: Targeted code reading

Use Glob and Grep to extract specific patterns. Run web OR backend
patterns based on what Phase 0 Step 1 detected.

**Web/frontend projects:**
```
Glob("src/components/**/*.{tsx,jsx,vue,svelte}") | head -10   → component naming
Glob("src/pages/**/*") | head -10                             → page structure
Glob("**/*.test.*") | head -10                                → test conventions
Grep("className=|class=", glob="*.{tsx,jsx,html}", head_limit=5) → styling approach
Grep("fetch(|axios|useSWR|useQuery", glob="*.{ts,tsx,js}", head_limit=5) → data fetching
Grep("color:|--.*color|bg-|text-", glob="*.{css,scss,ts}", head_limit=5) → color tokens
```

**Backend/general projects:**
```
Glob("**/*.{go,rs,py,rb,java}") | head -10                   → language files
Grep("func |def |class ", glob="*.{go,py,rb}", head_limit=5) → code structure
Grep("router|handler|endpoint|@app", glob="*.{go,py,rb,java}", head_limit=5) → API patterns
Grep("test|spec|assert", glob="**/*test*", head_limit=5)     → test patterns
```

**If no matches:** note the absence as context. Don't invent patterns.

### Step 3: Load project decisions (if exists)

```bash
cat .speckit/decisions.md 2>/dev/null || echo "NO_DECISIONS"
```

If decisions exist, they are binding precedent for this spec. Apply them.

### Step 4: Produce context summary (internal, not shown to user)

After all scans complete, synthesize a structured summary. This summary
drives all decisions in Phase 2. Write it in your reasoning, not in output.

```
CONTEXT SUMMARY:
  stack: {e.g., Next.js 14 + TypeScript + Tailwind}
  design_system: {e.g., CSS variables in :root, Pretendard font, dark theme}
  styling: {e.g., Tailwind utility classes / CSS modules / inline styles}
  auth: {e.g., JWT via NextAuth / no auth detected}
  data_fetching: {e.g., SWR / fetch / no client data fetching}
  test_framework: {e.g., Vitest + Testing Library / none detected}
  existing_patterns: {e.g., functional components, kebab-case files}
  project_decisions: {e.g., "auth always JWT+httpOnly" from decisions.md}
  scope: {web-frontend / backend / fullstack / static-html / unknown}
```

**Scope note:** For pure backend, CLI, or library projects, mark visual and
interaction attributes as `N/A — {scope}` rather than inventing UI.

---

## Phase 0.5: Fast Path Check

Before routing, check if this is a trivial task.

**Trivial criteria (ALL must be true):**
- The user's request explicitly describes a small, concrete change
- No new components, pages, or endpoints implied
- No business logic or data flow change implied
- Examples: "버튼 색상 #333으로 바꿔줘", "typo fix in header", "change timeout to 5s"

**Not trivial even if it sounds small:** "fix the login bug" (needs investigation),
"add a button" (needs visual + interaction spec), "update the API" (needs contract spec).

**If trivial:** skip Phase 1-2, output inline micro-spec:

```markdown
**Spec:** {one-line description}
- Change: {what to modify, in which file}
- Constraint: {any constraint, or "none beyond existing"}
- Reason: {why this approach}
```

Then STOP. Do not generate a full spec for trivial work.

**If not trivial:** continue to Phase 1.

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

**Fallback:** If the request doesn't clearly match, use `general`.
State your interpretation: "Interpreted '{request}' as {category} because {reason}."
Never refuse to generate a spec.

**Routing rules (apply AFTER category match, add missing attributes):**
- If the result is something a user SEES → include `visual`
- If the result is something a user INTERACTS with → include `visual` + `interaction`
- If request touches data or logic → include `functional`
- Always include `constraint`
- Include `test-strategy` when test infrastructure exists (detected in Phase 0)
- Include `acceptance` when the preset specifies it

**Ambiguous request handling:** If the request is too vague to determine scope
(e.g., "이거 좀 고쳐줘"), make your best guess based on recent git diff and
current codebase state. State the interpretation explicitly in the spec header.

### Load preset

```bash
[ -n "$SPECKIT_DIR" ] && cat "$SPECKIT_DIR/presets/custom.json" 2>/dev/null || \
[ -n "$SPECKIT_DIR" ] && cat "$SPECKIT_DIR/presets/default.json" 2>/dev/null || \
echo "NO_PRESET"
```

If a preset overrides attributes for this category, use the preset's list.
**Valid attributes:** functional, visual, interaction, constraint, test-strategy, acceptance.
If the preset references anything else, ignore it.

---

## Phase 2: Build Spec

### Step 1: Load attribute references

Read the attribute files for guidance on quality and structure:

```
For each attribute in the final attribute list:
  Read "$SPECKIT_DIR/attributes/{attribute}.md"
```

If files are unavailable, use the Output Format below as the structure guide.
The attribute files provide BAD/GOOD examples. The Output Format defines the
canonical spec shape.

### Step 2: Fill the spec

Fill using context from Phase 0's CONTEXT SUMMARY. Rules:

1. **Every non-obvious choice gets `(reason: ...)`.**
   Reference specific context: `(reason: existing tokens.css uses 8px grid)`,
   not generic reasoning: `(reason: common practice)`.

2. **Reference project decisions.** If `.speckit/decisions.md` has a relevant
   precedent, cite it: `(reason: project decision — JWT+httpOnly, see decisions.md:5)`.

3. **When context is missing**, state the assumption:
   `(reason: no design system detected, using system font stack as default)`.
   Never leave a field as `{placeholder}`.

4. **Section item counts:**
   - Business Logic: 1-3 rules (only non-obvious ones)
   - Edge Cases: 2-5 (focus on likely scenarios, not exhaustive)
   - Error Handling: 2-4 (user-facing errors only)
   - Test Strategy: 3-7 test cases (cover happy + error + edge)
   - Acceptance: 3-6 criteria (measurable, not generic)
   Fewer is better than padding. Omit entire sections with no content.

### Output Format

```markdown
# Spec: {title}

> Category: {categories} | Generated: {date}
> Context: {1-line summary from CONTEXT SUMMARY, e.g., "Next.js + Tailwind, dark theme, no auth"}

## Functional Attributes
{only if functional is included}

### Input/Output
- Input: {what the user provides or triggers}
- Output: {what the system produces or changes}
- Side effects: {database writes, API calls, notifications}

### Business Logic
- {rule} (reason: ...)

### Edge Cases
- {scenario}: {expected behavior} (reason: ...)

### Error Handling
- {error scenario}: {user-facing behavior} (reason: ...)

### Data Flow
```
{input} → {validation} → {processing} → {storage} → {output}
```

## Visual Attributes
{only if visual is included}

### Layout
- Structure: {description} (reason: ...)
- Responsive: {breakpoint strategy} (reason: ...)
- Spacing: {system} (reason: ...)

### Typography
- Heading: {font, size, weight, color} (reason: ...)
- Body: {font, size, weight, color} (reason: ...)

### Color
- {role}: {value} (reason: ...)

### Components
- {component}: {spec}

## Interaction Attributes
{only if interaction is included}

### State Machine
```
{state A} --{trigger}--> {state B} --{trigger}--> {state C}
```

### States
- Default: {description}
- Loading: {description}
- Empty: {description}
- Error: {description}

### User Actions
- {action}: {response + timing}

### Animation/Motion
- {transition}: {duration, easing} (reason: ...)
- prefers-reduced-motion: {behavior}

## Constraints
{always included}

### Performance
- {metric}: {target} (reason: ...)

### Security
- {constraint} (reason: ...)

### Accessibility
- {requirement} (reason: ...)

### Browser/Device Support
- {scope} (reason: ...)

## Test Strategy
{only if test-strategy is included}

### Tests
- {test description}: {assertion}

## Acceptance Criteria
{only if acceptance is included}

### Done Checklist
- [ ] {measurable criterion}

### Demo Scenario
- {steps to demonstrate}

---
*Corrections? Tell me what to change. Confirm to proceed with implementation.*
```

---

## Phase 3: Output + STOP

**This skill ONLY produces specs. It does NOT implement. It does NOT write files.**

### Step 1: Output the spec

Output the completed spec in conversation.

### Step 2: Suggest decision accumulation (inline, no file write)

If the spec contains project-specific reasons (not generic best practices),
list them at the bottom of the spec output:

```markdown
---
**Reusable decisions detected** (run `save decisions` to persist):
- auth: JWT + httpOnly cookie
- spacing: 8px grid from tokens.css
```

**Criteria:** project-specific = YES, generic wisdom = NO.
- YES: "auth uses JWT + httpOnly cookie" (project-specific)
- NO: "passwords should be hashed" (universal)

The user can then say "save decisions" to persist them. This keeps
all file writes opt-in.

### Step 3: STOP

**STOP.** Do not write code, create files, or start implementation.
Do not write to `.speckit/decisions.md` unless the user explicitly asks.

The user will either:
- **Correct** → update the changed section only, re-output, STOP again.
- **Confirm** → implementation starts in the NEXT turn (outside this skill).
- **"save this"** → save spec to `.specs/{kebab-case-title}.md`.
- **"save decisions"** → append decisions to `.speckit/decisions.md`.

### Implementation handoff

When the user confirms and implementation begins (outside this skill), the spec
is the source of truth. The implementing agent should:
- Satisfy every item in Functional Attributes
- Match Visual Attributes
- Implement all states from Interaction Attributes
- Meet all Constraints
- Pass all tests in Test Strategy
- Check off every Acceptance Criteria item

---

## Collaborative Mode (opt-in only)

Only activated when the user explicitly says "let's discuss", "help me decide",
or "같이 정하자". Walk through attributes one at a time, presenting your
recommendation and asking for input. One attribute per exchange.

---

## Attribute Reference

| Attribute | File | Purpose |
|-----------|------|---------|
| functional | `attributes/functional.md` | I/O, business logic, edge cases, errors, data flow |
| visual | `attributes/visual.md` | Layout, typography, color, components, imagery |
| interaction | `attributes/interaction.md` | States, transitions, animations, gestures |
| constraint | `attributes/constraint.md` | Performance, security, a11y, browser, i18n, legal |
| test-strategy | `attributes/test-strategy.md` | Unit, integration, E2E, visual regression |
| acceptance | `attributes/acceptance.md` | Done criteria, demo scenarios, sign-off |

**Valid attributes:** functional, visual, interaction, constraint, test-strategy, acceptance.
These are the ONLY valid values. Presets referencing anything else are ignored.

---

## Quality Rules

1. **No vague specs.** Every value must be specific and measurable.
   BAD: "fast loading" → GOOD: "LCP < 2.5s on 4G"
   BAD: "clean design" → GOOD: "8px grid, Inter 14/20, #1a1a1a on #ffffff"

2. **Reason everything non-obvious.** Cite specific context, not generic wisdom.
   BAD: `(reason: best practice)` → GOOD: `(reason: existing :root uses --accent-blue: #3b82f6)`

3. **Match existing patterns.** Spec in the project's own terms.
   Tailwind project → spec with Tailwind classes.
   CSS variables → spec with variable names.
   Never introduce conventions the project doesn't use.

4. **Right-size the spec:**
   - **Trivial** (typo, config): 3-5 line micro-spec via fast path.
   - **Small** (bugfix, minor tweak): 10-20 lines. 1-2 sections.
   - **Medium** (component, endpoint): 50-100 lines. All relevant sections.
   - **Large** (page, major feature): 100+ lines. All attributes.

5. **Constraint is non-negotiable.** Every spec includes constraints.
   Performance, security, and accessibility are never optional.

6. **Omit, don't pad.** If a section has nothing meaningful, omit it entirely.
   An empty "Edge Cases" section is worse than no section.
