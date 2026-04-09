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
