# Layout

Guide: Layout defines spatial relationships. Every measurement must be
a specific number, not a feeling.

## Grid
- {grid system definition} (reason: ...)

```
BAD:  "use a grid layout"
GOOD: "12-column grid, 24px gutter, 16px margin on mobile.
       Content area max-width 1280px, centered."
      (reason: existing .container uses max-width: 720px — narrow
       single-column, expand to 1280px for dashboard multi-panel)
```

## Spacing
- {spacing scale definition} (reason: ...)

```
BAD:  "consistent spacing"
GOOD: "8px base unit. Scale: 4/8/12/16/24/32/48/64.
       Section gaps: 48px. Card internal padding: 24px.
       Inline element gaps: 8px."
      (reason: existing CSS uses padding: 24px 16px on .container,
       suggesting 8px base grid)
```

## Responsive
- {breakpoint strategy} (reason: ...)

```
BAD:  "make it responsive"
GOOD: "Mobile-first. Breakpoints: 375px (phone), 768px (tablet), 1024px (desktop).
       Phone: single column, full-width cards.
       Tablet: 2-column where content allows.
       Desktop: sidebar + main, or 3-column grid."
      (reason: existing meta viewport has user-scalable=no,
       mobile is primary target)
```

## Composition
- {core visual structure} (reason: ...)

```
BAD:  "clean layout"
GOOD: "Z-pattern for landing: logo top-left → CTA top-right → hero center →
       secondary actions bottom. Dashboard: fixed sidebar nav + scrollable main."
      (reason: F-pattern for content-heavy, Z-pattern for action-oriented)
```
