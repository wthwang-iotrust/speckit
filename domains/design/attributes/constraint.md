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
