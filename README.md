# speckit

AI-driven spec generator for Claude Code. Produces structured specifications before implementation begins.

## The Problem

```
You: "Build a login page"
AI:  *starts coding immediately with vague assumptions*
Result: inconsistent quality, missing edge cases, rework
```

## With speckit

```
You: "Build a login page"

speckit analyzes your codebase:
  - Tech stack: Next.js + Tailwind + NextAuth
  - Design system: Inter font, blue-600 accent, 8px grid
  - Auth pattern: JWT with refresh tokens

speckit outputs a spec:
  - Functional: email/password input, validation rules, error handling
  - Visual: layout grid, typography tokens, component specs
  - Interaction: loading states, error states, success redirect
  - Constraint: LCP < 2.5s, WCAG AA, keyboard navigation

You review, correct if needed, then confirm to start building.
```

## Install

### One-liner (global)

```bash
curl -fsSL https://raw.githubusercontent.com/wthwang-iotrust/speckit/main/install.sh | bash
```

### One-liner (project-local)

```bash
curl -fsSL https://raw.githubusercontent.com/wthwang-iotrust/speckit/main/install.sh | bash -s -- --local
```

### Manual install

```bash
# Global (all projects)
git clone --depth 1 https://github.com/wthwang-iotrust/speckit.git ~/.claude/skills/speckit

# Project-local (this repo only)
git clone --depth 1 https://github.com/wthwang-iotrust/speckit.git .claude/skills/speckit
```

### Update

```bash
# Re-run the install command, or:
cd ~/.claude/skills/speckit && git pull
```

`presets/custom.json` is gitignored and preserved across updates.

### Activate

Add to your project's `CLAUDE.md`:

```markdown
## Skill routing

- Any implementation request (feature, bugfix, UI, API) → invoke spec
```

## Usage

speckit activates automatically when you request implementation work:

- "Add a payment form" → routes to `ui-component + feature` → full spec → spec → you confirm → build
- "Fix the login bug" → routes to `bugfix` → focused spec → fix
- "Build the landing page" → routes to `landing` → visual + interaction spec → build
- "Create a REST API for users" → routes to `api` → API spec → spec → you confirm → build

No questions asked. speckit reads your codebase, makes judgment calls, and shows reasoning. You correct what's wrong. **speckit only produces specs, it does not auto-implement.**

## Spec Attributes

| Attribute | What it covers | Example |
|-----------|---------------|---------|
| **functional** | I/O, business logic, edge cases, error handling | `POST /api/users → 201 { id, email }` |
| **visual** | Layout, typography, color, components | `Inter 14/22, #2563eb accent, 8px grid` |
| **interaction** | States, transitions, animations, gestures | `idle → loading → success → redirect` |
| **constraint** | Performance, security, accessibility | `LCP < 2.5s, WCAG AA, bcrypt cost 12` |
| **test-strategy** | Unit, integration, E2E test plan | `validateEmail('') → { valid: false }` |
| **acceptance** | Done criteria, sign-off checklist | `all edge cases handled, a11y audit passed` |
| **workflow** (design) | Pre-change agreement, reference-first, multi-viewport | `AI confirms structure in text before visual output` |
| **scope** (design) | Source-of-truth, inclusion, exclusion, copy fidelity | `source has 3 sections → output has 3 sections` |

Each attribute file includes BAD/GOOD examples to enforce specificity.

## Domains

speckit routes requests to the right domain automatically.

| Domain | When | Attributes |
|--------|------|-----------|
| **dev** | Code implementation, features, bugs, APIs | functional, visual, interaction, constraint, test-strategy, acceptance |
| **design** | UI design, branding, wireframes, visual audits | mood, layout, typography, color, hierarchy, constraint |
| strategy | Marketing, planning, campaigns | coming soon |
| process | Process improvement, workflows | coming soon |

### Dev Categories

| Category | When | Default attributes |
|----------|------|--------------------|
| `landing` | Marketing pages | visual, interaction, constraint |
| `feature` | New functionality | functional, constraint, test-strategy |
| `bugfix` | Bug fixes | functional, constraint |
| `refactor` | Code reorganization | functional, constraint |
| `ui-component` | Pages, modals, forms | visual, functional, interaction, constraint |
| `api` | Endpoints, webhooks | functional, constraint, test-strategy |

### Design Categories

| Category | When | Default attributes |
|----------|------|--------------------|
| `ui-design` | Screen/page design | workflow, scope, mood, layout, typography, color, hierarchy |
| `branding` | Logo, identity | mood, color, typography, constraint |
| `wireframe` | Mockups, prototypes | scope, layout, hierarchy, constraint |
| `visual-audit` | Design review, polish | workflow, color, typography, hierarchy, constraint |

speckit auto-detects domain and category. Multiple categories combine (union of attributes).

**Strict mode for designers:** copy `domains/design/presets/designer-strict.json` to `domains/design/presets/custom.json` to force `workflow` and `scope` attributes on every design spec — surfaces `REFERENCE_REQUIRED`, `SCOPE_AMBIGUOUS`, `COPY_MISSING`, and `MOBILE_VERIFICATION_PENDING` flags inline in the spec output instead of leaving them implicit. Default preset (above) preserves v0.5 output contract; strict mode is explicit opt-in. See `domains/design/pain-points.md` for the full list of designer frustrations this addresses.

## Team Presets

Customize which attributes apply to each category:

```bash
cp presets/example-team.json presets/custom.json
# Edit custom.json for your team's needs
```

`presets/custom.json` is gitignored. Each team member can have their own, or commit a shared preset.

## Structure

```
speckit/
├── SKILL.md                       # Router + common phases
├── domains/
│   ├── dev/                       # Development domain
│   │   ├── instructions.md
│   │   ├── attributes/ (6 files)
│   │   └── presets/
│   └── design/                    # Design domain (v0.6.0)
│       ├── instructions.md
│       ├── attributes/ (8 files — adds workflow, scope)
│       ├── presets/ (default + designer-strict)
│       └── pain-points.md         # 7 designer pain points mapped to attributes
├── attributes/                    # Legacy (v0.3.x compat)
├── presets/                       # Global presets (fallback)
├── VERSION
└── LICENSE
```

**v0.3.x users:** `git pull` works seamlessly. Legacy `attributes/` auto-detected.

## Scope

speckit works best with **web and frontend projects** where visual, interaction, and constraint attributes are all relevant. For backend-only, CLI, or library projects, visual and interaction attributes will be marked N/A automatically.

Supported stacks: any (detected via config files). Best experience with JavaScript/TypeScript web apps.

## Philosophy

> "Do it well" is not a spec.

The quality of AI output is directly proportional to the specificity of the input. speckit bridges this gap by producing explicit, attribute-level specifications automatically, based on your codebase context.

Every decision includes a `(reason: ...)` annotation. You see WHY each choice was made, and correct only what's wrong.

## License

MIT
