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
| `ui-design` | UI 디자인, 화면 설계, 페이지 디자인, UI design, page design, screen design | mood, layout, typography, color, hierarchy |
| `branding` | 브랜딩, 로고, 아이덴티티, branding, logo, identity, brand | mood, color, typography, constraint |
| `wireframe` | 와이어프레임, 목업, 프로토타입, wireframe, mockup, prototype | layout, hierarchy, constraint |
| `visual-audit` | 디자인 리뷰, 시각 감사, UI 개선, design review, visual audit, UI polish | color, typography, hierarchy, constraint |
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

## Output Template

```markdown
# Design Spec: {title}

> Domain: design | Category: {categories} | Generated: {date}
> Context: {design system summary, e.g., "CSS variables dark theme, Pretendard font"}

## Mood & Direction
- Tone: {3-5 adjectives} (reason: ...)
- Reference direction: {1-2 references} (reason: ...)
- Anti-pattern: {what to avoid} (reason: ...)

## Layout
- Grid: {system} (reason: ...)
- Spacing: {scale} (reason: ...)
- Responsive: {strategy} (reason: ...)
- Composition: {structure} (reason: ...)

## Typography
- Scale: {ratio and sizes} (reason: ...)
- Primary: {body typeface + specs} (reason: ...)
- Display: {heading typeface + specs} (reason: ...)
- Hierarchy: {how levels are distinguished} (reason: ...)

## Color
- Palette: {colors with roles} (reason: ...)
- Semantic: {meaning-based assignments} (reason: ...)
- Contrast: {ratios for key combinations} (reason: ...)
- Dark/Light: {mode strategy} (reason: ...)

## Information Hierarchy
- Primary: {most important element} (reason: ...)
- Secondary: {supporting elements} (reason: ...)
- CTA: {call to action} (reason: ...)
- Visual flow: {eye movement path} (reason: ...)

## Constraints
### Accessibility
- {WCAG level, contrast, touch targets} (reason: ...)
### Brand
- {brand rules or "no brand constraints"} (reason: ...)
### Technical
- {technical limits affecting design} (reason: ...)
### Performance
- {performance constraints affecting design — font loading, image sizes, animation} (reason: ...)

---
*Corrections? Tell me what to change. Confirm to proceed.*
```

## Scope Note

Design specs describe VISUAL DECISIONS, not implementation code.
Output hex colors, px values, font names, spacing numbers.
Do NOT output CSS code, React components, or Tailwind classes.
The dev domain handles implementation. Design domain handles decisions.
