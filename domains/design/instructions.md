# Design Domain Instructions

This file is loaded by SKILL.md when the router selects the `design` domain.

## Domain: design

Covers: UI design, branding, wireframing, visual audits, and any request
where the output is design decisions (not code).

## Context Layer Definition

- **Layer 1** = files in the repository (CSS, config, DESIGN.md, component styles)
- **Layer 2** = linked external references (Figma URL, brand guide) — future
- **Layer 3** = web search for industry trends — future

## Context Scan Extensions (Layer 1)

```
Glob("**/*.{css,scss,less}") | head -10                              → style files
Grep("--.*:|color:|font-|bg-|text-", glob="*.{css,html,tsx}", head_limit=10) → design tokens
Grep("theme|palette|typography|spacing", glob="*.{ts,js,json}", head_limit=5) → theme config
Read DESIGN.md (if exists)                                            → existing design system
Grep("tailwind|styled-components|emotion|css-modules", glob="*.{js,ts,json}", head_limit=3) → styling approach
```

**If no design context found:** use Default Values (below) and annotate with
`(reason: no design context found, using defaults)`.

## Categories

| Category | Trigger patterns | Primary attributes |
|----------|-----------------|-------------------|
| `ui-design` | UI 디자인, 화면 설계, 페이지 디자인 | mood, layout, typography, color, hierarchy |
| `branding` | 브랜딩, 로고, 아이덴티티 | mood, color, typography, constraint |
| `wireframe` | 와이어프레임, 목업, 프로토타입 | layout, hierarchy, constraint |
| `visual-audit` | 디자인 리뷰, 시각 감사, UI 개선 | color, typography, hierarchy, constraint |
| `general` | (fallback) | mood, layout, color, constraint |

**Multi-match rule:** multiple categories → union of attributes.

## Routing Rules

- If request is about a specific screen/page → include `layout` + `hierarchy`
- If request mentions brand/identity → include `mood` + `constraint`
- If request is about colors/theme → include `color`
- If request involves text content → include `typography`
- Always include `constraint`

## Default Values (no project context)

| Attribute | Default | Reason |
|-----------|---------|--------|
| Mood | neutral, professional, clean | safest starting point |
| Layout | 8px grid, max-width 1280px, single column mobile | web standard |
| Typography | system font stack, 16/24 body, 24/32 heading | no font dependency |
| Color | #111827 text, #ffffff bg, #2563eb accent, #dc2626 error | high contrast, Tailwind defaults |
| Hierarchy | title → body → supporting, accent CTA | basic information structure |
| Constraint | WCAG AA, 4.5:1 contrast, 44px touch target | accessibility minimum |

## Section Item Counts

- Mood: tone 3-5 adjectives, reference 1-2, anti-pattern 1-2
- Layout: grid + spacing + responsive + composition (1 line each)
- Typography: 2-3 levels (display, body, caption)
- Color: palette 3-7 colors, semantic 4-6, contrast ratios, mode strategy
- Hierarchy: primary + secondary + CTA + visual flow
- Constraint: accessibility + brand + technical + performance (1-2 lines each)

## Scope Note

Design specs describe VISUAL DECISIONS, not implementation code.
Output hex colors, px values, font names, spacing numbers.
Do NOT output CSS code, React components, or Tailwind classes.
The dev domain handles implementation. Design domain handles decisions.
