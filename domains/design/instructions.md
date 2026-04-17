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

**Note:** `workflow` and `scope` are opt-in via `designer-strict` preset or via
context-based Routing Rules below. Defaults above preserve v0.5.0 output contract.

**Multi-match rule:** multiple categories → union of attributes.

**Valid attributes (design domain):** workflow, scope, mood, layout, typography, color, hierarchy, constraint

## Routing Rules

- If request is about a specific screen/page → include `layout` + `hierarchy`
- If request mentions brand/identity → include `mood` + `constraint`
- If request is about colors/theme → include `color`
- If request involves text content → include `typography`
- Always include `constraint`
- **Subjective language trigger** ("이런 느낌", "모던하게", "trendy", "premium") → include `workflow` (forces Reference-first Rule)
- **Modification / audit / enhancement trigger** ("수정", "개선", "audit", "폴리싱") → include `workflow` + `scope` (prevents uninvited expansion)
- **Source material provided** (wireframe, existing page, source copy) → include `scope` (enforces fidelity)

## Default Values (no project context)

| Attribute | Default | Reason |
|-----------|---------|--------|
| Workflow | assumptions embedded as checklist in spec header; flags emitted inline when triggers fire | surfaces decisions without dialogue |
| Scope | source is the only allowed scope; ADDITION_SUGGESTED inline marker for proposed additions | scope creep visible in spec, not patched silently |
| Mood | neutral, professional, clean | safest starting point |
| Layout | 8px grid, max-width 1280px, single column mobile | web standard |
| Typography | system font stack, 16/24 body, 24/32 heading | no font dependency |
| Color | #111827 text, #ffffff bg, #2563eb accent, #dc2626 error | high contrast, Tailwind defaults |
| Hierarchy | title → body → supporting, accent CTA | basic information structure |
| Constraint | WCAG AA, 4.5:1 contrast, 44px touch target; only system tokens | accessibility minimum + token discipline |

## Section Item Counts

- Workflow: decision gate flags (6 triggers: REFERENCE_REQUIRED / SCOPE_AMBIGUOUS / MOBILE_VERIFICATION_PENDING / CONSOLIDATION_SUGGESTED / COPY_MISSING / MODIFICATION_BOUNDARY_CROSSED) + checklist output + multi-viewport verification + iteration prevention (1 line each)
- Scope: source-of-truth + inclusion-list + exclusion-list + addition-marker + modification-boundary + copy-fidelity (1 line each)
- Mood: tone 3-5 adjectives, reference 1-2, anti-pattern 1-2, reference-requirement 1
- Layout: grid + spacing + responsive + composition + AI anti-patterns (1 line each)
- Typography: 2-3 levels (display, body, caption) + AI anti-patterns
- Color: palette 3-7 colors, semantic 4-6, contrast ratios, mode strategy + AI anti-patterns
- Hierarchy: primary + secondary + CTA + visual flow + scope guard + AI anti-patterns
- Constraint: accessibility + brand + technical + performance + token adherence + AI anti-patterns (1-2 lines each)

## Output Template

```markdown
# Design Spec: {title}

> Domain: design | Category: {categories} | Generated: {date}
> Context: {design system summary, e.g., "CSS variables dark theme, Pretendard font"}

## Decision Gates
{ONLY if any gate fires — omit entire section if no gates active}
{ONLY applies when workflow or scope attributes are in the spec}
- REFERENCE_REQUIRED: {detected keyword} — 레퍼런스 미제공, 관련 결정은 (tentative)
- SCOPE_AMBIGUOUS: {request} — 해석: {narrowest}, 확장 원하면 재지시
- MOBILE_VERIFICATION_PENDING: 모바일(375px) 스펙 미산출
- CONSOLIDATION_SUGGESTED: 누적 이슈 {n}건 — 통째 재작성 권장
- COPY_MISSING: [원본 카피 필요] 블록 {n}개
- MODIFICATION_BOUNDARY_CROSSED: {change} — 구조 변경 권한 미확인

## Workflow
{only if workflow is included}
- Assumptions (checklist): tokens / breakpoints / scope / deliverables made visible (reason: ...)
- Multi-viewport: desktop AND mobile produced in same output (reason: ...)
- Iteration prevention: rewrite-oriented when 3+ issues accumulate (reason: ...)
- Flag emission: see Decision Gates above for triggered flags (reason: ...)

## Scope
{only if scope is included}
- Source of truth: {what defines allowed scope} (reason: ...)
- Inclusion list: {verbatim elements that MUST appear} (reason: ...)
- Exclusion list: {what MUST NOT appear} (reason: ...)
- Addition marker: ADDITION_SUGGESTED inline marker instead of asking (reason: ...)
- Modification boundary: styling direct / structural via MODIFICATION_BOUNDARY_CROSSED flag (reason: ...)
- Copy fidelity: literal from source; missing copy uses [원본 카피 필요] placeholder (reason: ...)

## Mood & Direction
- Tone: {3-5 adjectives} (reason: ...)
- Reference direction: {1-2 references} (reason: ...)
- Anti-pattern: {what to avoid} (reason: ...)
- Reference requirement: {required | not required — if subjective language detected without reference, mood decisions marked (tentative) and REFERENCE_REQUIRED flag emitted} (reason: ...)
- AI anti-patterns: {common AI mood failures to reject in output} (reason: ...)

## Layout
- Grid: {system} (reason: ...)
- Spacing: {scale} (reason: ...)
- Responsive: {strategy, with BOTH desktop ≥1024px AND mobile 375px specs inline — if mobile missing, MOBILE_VERIFICATION_PENDING flag fires} (reason: ...)
- Composition: {structure} (reason: ...)
- AI anti-patterns: {common AI layout failures to reject — desktop-only output, off-grid spacing, invented containers} (reason: ...)

## Typography
- Scale: {ratio and sizes} (reason: ...)
- Primary: {body typeface + specs} (reason: ...)
- Display: {heading typeface + specs} (reason: ...)
- Hierarchy: {how levels are distinguished} (reason: ...)
- AI anti-patterns: {common AI typography failures — same-level size mismatch, off-scale values, ALL CAPS misuse, line length > 75ch} (reason: ...)

## Color
- Palette: {colors with roles} (reason: ...)
- Semantic: {meaning-based assignments} (reason: ...)
- Contrast: {ratios for key combinations} (reason: ...)
- Dark/Light: {mode strategy} (reason: ...)
- AI anti-patterns: {common AI color failures — off-palette hex drift (#3a82f6 vs #3b82f6), unsourced grays, accent overuse, low-contrast "subtle" text} (reason: ...)

## Information Hierarchy
- Primary: {most important element} (reason: ...)
- Secondary: {supporting elements} (reason: ...)
- CTA: {call to action} (reason: ...)
- Visual flow: {eye movement path} (reason: ...)
- Scope guard: {hierarchy elements MUST come from source — no invented CTAs / badges / icons; missing primary triggers ADDITION_SUGGESTED marker} (reason: ...)
- AI anti-patterns: {common AI hierarchy failures — equal visual weight, competing CTAs, decorative distractions, inverted hierarchy} (reason: ...)

## Constraints
### Accessibility
- {WCAG level, contrast, touch targets} (reason: ...)
### Brand
- {brand rules or "no brand constraints"} (reason: ...)
### Technical
- {technical limits affecting design} (reason: ...)
### Performance
- {performance constraints affecting design — font loading, image sizes, animation} (reason: ...)
### Design System Token Adherence
- {when tokens exist: only system values allowed; missing tokens emit inline note rather than inventing values} (reason: ...)
### AI Anti-patterns
- {common AI constraint violations — inline hex when tokens exist, hardcoded px, framework mismatch, missing focus indicators, touch target < 44px} (reason: ...)

---
*Corrections? Tell me what to change. Confirm to proceed.*
```

## Scope Note

Design specs describe VISUAL DECISIONS, not implementation code.
Output hex colors, px values, font names, spacing numbers.
Do NOT output CSS code, React components, or Tailwind classes.
The dev domain handles implementation. Design domain handles decisions.
