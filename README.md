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

Then implementation begins — with every attribute explicit.
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

- "Add a payment form" → routes to `ui-component + feature` → full spec → implementation
- "Fix the login bug" → routes to `bugfix` → focused spec → fix
- "Build the landing page" → routes to `landing` → visual + interaction spec → build
- "Create a REST API for users" → routes to `api` → API spec → implementation

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

Each attribute file in `attributes/` includes BAD/GOOD examples to enforce specificity.

## Categories

| Category | When | Default attributes |
|----------|------|--------------------|
| `landing` | Marketing pages, hero sections | visual, interaction, constraint |
| `feature` | New functionality | functional, constraint, test-strategy |
| `bugfix` | Bug fixes, regressions | functional, constraint |
| `refactor` | Code reorganization | functional, constraint |
| `ui-component` | Pages, modals, forms | visual, functional, interaction, constraint |
| `api` | Endpoints, webhooks | functional, constraint, test-strategy |
| `general` | Anything else (fallback) | functional, constraint |

speckit auto-detects the category. Multiple categories can combine (e.g., "login page" = `ui-component` + `feature`).

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
├── skill/spec/SKILL.md    # Main skill (router + spec generator)
├── attributes/            # Composable attribute blocks with BAD/GOOD examples
│   ├── functional.md
│   ├── visual.md
│   ├── interaction.md
│   ├── constraint.md
│   ├── test-strategy.md
│   └── acceptance.md
├── presets/                # Category → attribute mappings
│   ├── default.json
│   └── example-team.json
├── VERSION
└── LICENSE
```

## Scope

speckit works best with **web and frontend projects** where visual, interaction, and constraint attributes are all relevant. For backend-only, CLI, or library projects, visual and interaction attributes will be marked N/A automatically.

Supported stacks: any (detected via config files). Best experience with JavaScript/TypeScript web apps.

## Philosophy

> "Do it well" is not a spec.

The quality of AI output is directly proportional to the specificity of the input. speckit bridges this gap by producing explicit, attribute-level specifications automatically, based on your codebase context.

Every decision includes a `(reason: ...)` annotation. You see WHY each choice was made, and correct only what's wrong.

## License

MIT
