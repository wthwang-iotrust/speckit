# Information Hierarchy

Guide: Hierarchy answers "what do I look at first?" If everything
has equal weight, nothing has weight. Squint at the screen — what
stands out? That's your hierarchy.

## Primary
- {the single most important element on screen} (reason: ...)

```
BAD:  "the main content"
GOOD: "The current question text — largest text block, centered,
       highest contrast (#f8fafc on #0a0f1d), no competing elements."
      (reason: CBT app's core purpose is reading and answering questions)
```

## Secondary
- {supporting elements} (reason: ...)

```
BAD:  "navigation and other stuff"
GOOD: "Answer options — slightly smaller than question, card-based,
       each with hover state for affordance. Visually grouped below
       the question with 24px gap."
      (reason: after reading the question, the next action is selecting an answer)
```

## CTA (Call to Action)
- {primary action element} (reason: ...)

```
BAD:  "add a button"
GOOD: "Submit/Next button — full-width on mobile, accent color (#3b82f6),
       positioned at bottom of answer group. Only button with filled
       background — all other buttons are outline/ghost."
      (reason: one primary action per screen, filled vs outline
       creates clear visual hierarchy between primary and secondary actions)
```

## Visual Flow
- {how the eye moves through the interface} (reason: ...)

```
BAD:  "logical flow"
GOOD: "Top-down single column:
       1. Progress indicator (top bar) — where am I?
       2. Question text (center) — what do I need to answer?
       3. Answer options (below question) — what are my choices?
       4. Navigation (bottom) — what's next?
       No sidebar, no competing panels. One column, one task."
      (reason: mobile-first, user-scalable=no — this is a focused
       task app, not a dashboard)
```

## Scope Guard
- {what hierarchy decisions are off-limits without source authorization} (reason: ...)

```
BAD:  AI invents a CTA because "every page should have a primary action"
GOOD: "Hierarchy elements MUST come from the source:
       - CTAs: only if source has them. No inventing 'Learn More' / 'Get Started'
       - Badges / trust signals: only if source has them
       - Secondary nav links: only if source has them
       - Icons beside text: only if source specifies them
       If source has no clear primary element, AI asks:
       '이 화면의 primary action이 뭔가요? 없으면 hierarchy 재설계 필요합니다.'
       AI never assigns primary status to an invented element."
      (reason: hierarchy invention is the #1 way AI silently expands scope —
       adding CTAs and prominence to elements the designer never wanted
       emphasized. See scope.md for full scope rules.)
```

## AI Anti-patterns (what AI gets wrong)
- {common AI mistakes specific to hierarchy} (reason: ...)

```
BAD:  AI creates equal visual weight across all elements, decorates secondary
      content with the same prominence as primary, and buries the main action
GOOD: "Reject in AI output:
       - Everything bold or everything medium weight (no hierarchy)
       - Primary CTA same color/weight as secondary actions
         (filled button + 4 outline buttons competing for attention)
       - Decorative icons drawing the eye away from content
       - Multiple 'primary' actions visible at once (pick one)
       - Hero section with 3 equally-sized side-by-side elements and no focal point
       - Equal spacing above/below primary content making it blend with sections
       - Section labels larger than section content (inverted hierarchy)
       - Every card having the same visual treatment regardless of importance"
      (reason: squint test failure — when everything has equal weight,
       nothing has weight, and users don't know what to look at first)
```
