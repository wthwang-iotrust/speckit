# Design Constraints

Guide: Constraints are boundaries that protect the design from
drift. They are non-negotiable rules, not suggestions.

## Accessibility
- {WCAG level and specific requirements} (reason: ...)

```
BAD:  "make it accessible"
GOOD: "WCAG 2.1 AA minimum.
       Text contrast: 4.5:1 (normal), 3:1 (large text/UI components).
       Touch targets: 44x44px minimum on all interactive elements.
       Focus indicators: 2px solid ring, visible on both dark and light bg.
       No information conveyed by color alone — use icons or text labels too."
      (reason: AA is the practical standard for web apps;
       touch targets matter because mobile is primary)
```

## Brand
- {brand guidelines that constrain design decisions} (reason: ...)

```
BAD:  "follow the brand"
GOOD: "No brand guidelines exist. Design decisions are unconstrained
       by external brand requirements. Internal consistency is the
       only brand rule: use existing CSS variables as the source of truth."
      (reason: no DESIGN.md or brand guide detected in project)

GOOD (when brand exists):
      "Logo must appear on start screen. Brand colors: primary #3b82f6,
       secondary #8b5cf6. Font: Pretendard (mandated by brand guide).
       No gradient usage on brand elements."
      (reason: extracted from DESIGN.md brand section)
```

## Technical
- {technical constraints that affect design choices} (reason: ...)

```
BAD:  "works on all devices"
GOOD: "Single HTML file — no build step, no CSS preprocessor.
       All styles inline in <style> tag. No external CSS files.
       CSS variables for theming. No CSS-in-JS.
       Animations: CSS only, no JS animation libraries.
       Images: inline SVG or emoji only (no asset pipeline)."
      (reason: project is a single index.html with no build tooling)
```

## Performance
- {performance constraints specific to design} (reason: ...)

```
BAD:  "should load fast"
GOOD: "No custom font files — use CDN link (existing Pretendard CDN).
       No images > 100KB. Prefer SVG/emoji over raster images.
       CSS animations use transform/opacity only (GPU composited).
       No layout shift from font loading — use font-display: swap."
      (reason: static HTML app, every KB counts for initial load)
```

## Design System Token Adherence
- {rules for using existing design system vs introducing new values} (reason: ...)

```
BAD:  AI introduces ad-hoc values "close to" the design system
      (padding: 22px when system has 24px; #3a82f6 when system has #3b82f6)
GOOD: "If a design system (CSS variables, tokens.css, design-system.md,
       theme.ts, tailwind.config) exists:
       - ONLY use values from the system. No ad-hoc hex / px / spacing.
       - If a needed value doesn't exist in the system, ASK before inventing.
         '{X}이 system에 없는데 추가할까요 아니면 기존 토큰 {Y}로 대체할까요?'
       - Every color, spacing, radius, shadow, font size must reference
         a named token — not a literal value.
       - Exceptions (allowed literals): opacity, transform values, z-index."
      (reason: designers invest heavily in tokens to prevent drift;
       AI-introduced 'almost right' values degrade the system silently.
       One off-token value per page compounds into dozens in a few sprints.)
```

## AI Anti-patterns (what AI gets wrong)
- {common AI mistakes specific to constraints} (reason: ...)

```
BAD:  AI produces output that technically works but ignores project rules:
      wrong framework primitives, off-token values, missing a11y
GOOD: "Reject in AI output:
       - Inline hex values when system has named tokens
         (#3b82f6 instead of var(--accent-blue))
       - Hardcoded px spacing when system uses a scale
         (padding: 14px instead of var(--space-3))
       - Framework mismatch (raw CSS when project uses Tailwind;
         tailwind classes when project uses CSS modules)
       - Added dependencies (animation libraries, icon packs) when project
         constraint forbids them
       - Missing focus indicator on interactive elements
       - Touch target < 44x44px on mobile
       - Info conveyed by color alone (no icon/label for color-blind users)
       - Animations without prefers-reduced-motion respect"
      (reason: constraint violations are invisible to the designer until the
       code review — by then the design is 'done' and fixing it feels like
       scope creep. Catching these at spec time prevents that trap.)
```
