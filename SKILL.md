---
name: speckit
version: 0.6.0
description: |
  AI-driven spec generator. Analyzes user request + codebase context to produce
  structured specifications before implementation. Replaces vague "do it well"
  with explicit attribute-level specs. Supports multiple domains (dev, design, etc.).
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

# /speckit: Specification Generator

You produce structured specifications before any work begins.
The spec replaces vague instructions with explicit, measurable attributes.

**State machine — the ONLY valid execution paths:**

```
Path A (normal):
  Phase 0 (scan) → Phase 1 (domain + route) → Phase 2 (build) → Phase 3 (output + STOP)

Path B (trivial):
  Phase 0 (scan) → Phase 0.5 (trivial detected) → micro-spec output → STOP
```

After STOP, the skill does NOTHING. No file writes, no implementation, no side effects.

---

## Core Principle

**Never ask. Analyze, decide, output, stop.** Read the codebase, infer context,
make judgment calls, and produce a complete spec. Show your reasoning so the user
can correct what's wrong. Being wrong and getting corrected is faster than a Q&A loop.

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

# Detect domain structure
if [ -n "$SPECKIT_DIR" ] && [ -d "$SPECKIT_DIR/domains" ]; then
  echo "DOMAIN_STRUCTURE: multi"
  ls "$SPECKIT_DIR/domains/"
elif [ -n "$SPECKIT_DIR" ] && [ -d "$SPECKIT_DIR/attributes" ]; then
  echo "DOMAIN_STRUCTURE: legacy"
else
  echo "DOMAIN_STRUCTURE: none"
fi
```

- `multi`: use `domains/{domain}/` paths
- `legacy`: fallback to root `attributes/` (pre-v0.4 installation). Works identically, just different paths.
- `none`: continue with inline knowledge

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

**If bash fails:** skip to Step 2. The scan is best-effort, not required.

### Step 2: Load project decisions (if exists)

```bash
cat .speckit/decisions.md 2>/dev/null || echo "NO_DECISIONS"
```

If decisions exist, they are binding precedent for this spec. Apply them.

### Step 3: Domain-specific scan extensions

After domain is detected (Phase 1 Step 1 runs a quick keyword check BEFORE
the full route), load the domain's instructions.md and run its Context Scan
Extensions section. This adds domain-specific Glob/Grep patterns to the scan.

```
Quick domain detection (keyword only, not full routing):
  Request contains code/build/fix/API/feature keywords → domain = dev
  Request contains 디자인/design/UI 설계/목업/wireframe/브랜딩/컬러/타이포 keywords → domain = design
  Request contains strategy/marketing keywords → domain = dev (strategy not yet available)
  Otherwise → domain = dev

Read "$SPECKIT_DIR/domains/{domain}/instructions.md" → run "Context Scan Extensions"
```

If instructions.md is unavailable, skip. The common scan from Step 1 is sufficient.

### Step 4: Produce context summary (internal, not shown to user)

```
CONTEXT SUMMARY:
  stack: {detected stack}
  design_system: {detected or "none"}
  styling: {approach}
  auth: {pattern or "none"}
  test_framework: {detected or "none"}
  existing_patterns: {observed}
  project_decisions: {from decisions.md or "none"}
  scope: {web-frontend / backend / fullstack / static-html / unknown}
```

---

## Phase 0.5: Fast Path Check

**Trivial criteria (ALL must be true):**
- The user's request explicitly describes a small, concrete change
- No new components, pages, or endpoints implied
- No business logic or data flow change implied
- Examples: "버튼 색상 #333으로 바꿔줘", "typo fix in header", "change timeout to 5s"

**Not trivial even if it sounds small:** "fix the login bug", "add a button", "update the API".

**If trivial:** output inline micro-spec and STOP:

```markdown
**Spec:** {one-line description}
- Change: {what to modify, in which file}
- Constraint: {any constraint, or "none beyond existing"}
- Reason: {why this approach}
```

**If not trivial:** continue to Phase 1.

---

## Phase 1: Domain Detection + Route

### Step 1: Detect domain

| Domain | Trigger patterns | Status |
|--------|-----------------|--------|
| `dev` | 만들어줘, implement, build, fix, refactor, API, feature, 코드 | available |
| `design` | 디자인, design, UI 설계, 목업, mockup, 와이어프레임, wireframe, 브랜딩, branding, 컬러, color, 타이포, typography | available |
| `strategy` | 전략, 마케팅, 기획, 캠페인, GTM | coming soon |
| `process` | 프로세스, 개선, 온보딩, 워크플로우 | coming soon |

**Default:** `dev`. If domain is "coming soon", set domain to `dev` and say:
"This domain is not yet available. Generating a dev-domain spec as fallback."
All subsequent phases use `dev` paths — do NOT keep the original domain name in path references.

### Step 2: Load domain instructions

```
Read "$SPECKIT_DIR/domains/{domain}/instructions.md"
```

If file is unavailable (legacy structure or NOT_FOUND), use the inline
dev domain routing table and rules below as fallback.

**Legacy fallback (inline dev routing):**

| Category | Trigger patterns | Primary attributes |
|----------|-----------------|-------------------|
| `landing` | landing page, LP, marketing page, hero | visual, interaction, constraint |
| `feature` | add feature, implement, build, create | functional, constraint, test-strategy |
| `bugfix` | fix, bug, broken, error, regression | functional, constraint |
| `refactor` | refactor, clean up, reorganize, migrate | functional, constraint |
| `ui-component` | component, page, screen, modal, form | visual, functional, interaction |
| `api` | API, endpoint, route, webhook, integration | functional, constraint, test-strategy |
| `general` | (fallback) | functional, constraint |

### Step 3: Route within domain

Follow the domain's routing table to pick a category.
If multiple categories apply, combine them.

**Common routing rules (all domains):**
- If the result is something a user SEES → include `visual`
- If the result is something a user INTERACTS with → include `visual` + `interaction`
- Always include `constraint`
- Include `acceptance` when the preset specifies it

**Ambiguous request handling:** make your best guess based on git diff and
codebase state. State the interpretation explicitly in the spec header.

### Step 4: Load preset

```bash
DOMAIN_DIR="$SPECKIT_DIR/domains/{domain}"
# Cascade: domain custom > global custom > domain default > global default
cat "$DOMAIN_DIR/presets/custom.json" 2>/dev/null || \
cat "$SPECKIT_DIR/presets/custom.json" 2>/dev/null || \
cat "$DOMAIN_DIR/presets/default.json" 2>/dev/null || \
cat "$SPECKIT_DIR/presets/default.json" 2>/dev/null || \
echo "NO_PRESET"
```

**Cascade priority:** domain custom > global custom > domain default > global default.

**Important:** Global presets (root `presets/`) use dev-domain categories. If the
current domain is `design`, and the global custom preset has no design categories
(e.g., only `feature`, `bugfix`), fall through to the domain default instead of
using irrelevant dev categories.

**Rule:** When loading a preset, check if it contains categories valid for the
current domain. If not, skip it and try the next in the cascade.

**Valid attributes per domain:**
- **dev:** functional, visual, interaction, constraint, test-strategy, acceptance
- **design:** workflow, scope, mood, layout, typography, color, hierarchy, constraint

If the preset references anything outside the domain's valid list, ignore it.

---

## Phase 2: Build Spec

### Step 1: Load attribute references

```
DOMAIN_DIR = "$SPECKIT_DIR/domains/{domain}"
LEGACY_DIR = "$SPECKIT_DIR/attributes"

For each attribute in the final attribute list:
  Try: Read "$DOMAIN_DIR/attributes/{attribute}.md"
  Fallback: Read "$LEGACY_DIR/{attribute}.md"
  If neither exists: use inline knowledge
```

### Step 2: Fill the spec

Fill using context from Phase 0's CONTEXT SUMMARY. Rules:

1. **Every non-obvious choice gets `(reason: ...)`.**
   Reference specific context, not generic reasoning.

2. **Reference project decisions.** Cite `.speckit/decisions.md` when relevant.

3. **When context is missing**, state the assumption explicitly.
   Never leave a field as `{placeholder}`.

4. **Follow domain instructions** for section item counts and scope notes.

### Output Format

**The output format depends on the domain.** The dev domain format is below.
For the design domain, the output uses design-specific sections (Mood, Layout,
Typography, Color, Hierarchy, Constraints). Refer to `domains/design/instructions.md`
for the design output template. The header is the same for all domains:

```markdown
# Spec: {title}

> Domain: {domain} | Category: {categories} | Generated: {date}
> Context: {1-line summary from CONTEXT SUMMARY}

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
- Default / Loading / Empty / Error: {descriptions}

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
*Corrections? Tell me what to change. Confirm to proceed.*
```

---

## Phase 3: Output + STOP

**This skill ONLY produces specs. It does NOT implement. It does NOT write files.**

### Step 1: Output the spec

### Step 2: Suggest decision accumulation (inline, no file write)

If the spec contains project-specific reasons, list them:

```markdown
---
**Reusable decisions detected** (say `save decisions` to persist):
- {decision}: {reason}
```

### Step 3: STOP

**STOP.** Do not write code, create files, or start implementation.

The user will either:
- **Correct** → update the changed section only, re-output, STOP again.
- **Confirm** → implementation starts in the NEXT turn (outside this skill).
- **"save this"** → save spec to `.specs/{kebab-case-title}.md`.
- **"save decisions"** → append decisions to `.speckit/decisions.md`.

### Implementation handoff

When confirmed, the spec is the source of truth. The implementing agent should:
- Satisfy every item in Functional Attributes
- Match Visual Attributes
- Implement all states from Interaction Attributes
- Meet all Constraints
- Pass all tests in Test Strategy
- Check off every Acceptance Criteria item

---

## Collaborative Mode (opt-in only)

Only activated when the user explicitly says "let's discuss", "help me decide",
or "같이 정하자". Walk through attributes one at a time. One per exchange.

---

## Quality Rules

1. **No vague specs.** Every value must be specific and measurable.
   BAD: "fast loading" → GOOD: "LCP < 2.5s on 4G"

2. **Reason everything non-obvious.** Cite specific context, not generic wisdom.
   BAD: `(reason: best practice)` → GOOD: `(reason: existing :root uses --accent-blue: #3b82f6)`

3. **Match existing patterns.** Spec in the project's own terms.

4. **Right-size the spec:**
   - **Trivial**: 3-5 line micro-spec via fast path.
   - **Small**: 10-20 lines. 1-2 sections.
   - **Medium**: 50-100 lines. All relevant sections.
   - **Large**: 100+ lines. All attributes.

5. **Constraint is non-negotiable.** Every spec includes constraints.

6. **Omit, don't pad.** Empty sections are worse than no sections.
