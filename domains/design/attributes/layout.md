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
- {breakpoint strategy with simultaneous verification rule} (reason: ...)

```
BAD:  "make it responsive"
      (also BAD: "desktop now, mobile later" — mobile-as-afterthought pattern)
GOOD: "Mobile-first. Breakpoints: 375px (phone), 768px (tablet), 1024px (desktop).
       Phone: single column, full-width cards.
       Tablet: 2-column where content allows.
       Desktop: sidebar + main, or 3-column grid.
       VERIFICATION RULE: every layout decision must be verified at
       375px AND ≥1024px in the SAME output. No 'I'll check mobile next.'"
      (reason: mobile bugs discovered after desktop is finalized require
       re-deciding desktop structure — doubling the work. Simultaneous
       verification catches breaks before they compound.)
```

## Composition
- {core visual structure} (reason: ...)

```
BAD:  "clean layout"
GOOD: "Z-pattern for landing: logo top-left → CTA top-right → hero center →
       secondary actions bottom. Dashboard: fixed sidebar nav + scrollable main."
      (reason: F-pattern for content-heavy, Z-pattern for action-oriented)
```

## AI Anti-patterns (what AI gets wrong)
- {common AI mistakes specific to layout} (reason: ...)

```
BAD:  AI generates layout that works on desktop only, with 5+ violations of
      the declared spacing scale, and invented section containers not in source
GOOD: "Reject in AI output:
       - Desktop-only layout — no mobile consideration shown
       - Off-grid spacing (17px, 23px, arbitrary values not from the scale)
       - Centered max-width applied to content that was never centered in source
       - 'Helper' containers / wrappers that weren't in the wireframe
       - Horizontal scroll on mobile from fixed-width desktop components
       - Sidebar layout forced onto content that doesn't need navigation
       - Hero-sized whitespace where the design was meant to be dense"
      (reason: these are the most common layout drift patterns in AI output;
       calling them out explicitly makes them easier to catch in review)
```
