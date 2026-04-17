# Scope

Guide: Scope defines what the design MUST and MUST NOT include.
Protects against AI scope creep — invented features, fabricated copy,
"helpful" additions that weren't in the source.
When scope is ambiguous, spec emits markers inline (never interrupts with
questions). Designer sees markers, resolves, re-submits.

Principle (inherited from SKILL.md): **Never ask. Analyze, decide, output, stop.**

## Source of Truth
- {what defines the allowed scope} (reason: ...)

```
BAD:  "AI decides what features the design should include"
GOOD: "Source (wireframe / page / provided copy / existing design) is the
       ONLY allowed scope. If source has 3 sections, output has 3 sections —
       not 4, not 5. If source has no CTA, output has no CTA.
       If source is ambiguous, spec emits SCOPE_AMBIGUOUS flag (see workflow.md)
       and proceeds with the narrowest reasonable interpretation."
      (reason: designers have made deliberate decisions about what exists;
       AI adding 'helpful' extras silently overrides those decisions)
```

## Inclusion List
- {explicit enumeration of what MUST appear, verbatim from source} (reason: ...)

```
BAD:  "show all the content from the original"
GOOD: "Required elements (verbatim from source):
       1. Hero: headline '{exact text}' + subhead '{exact text}'
       2. Three feature cards: {title1/desc1}, {title2/desc2}, {title3/desc3}
       3. Footer: 4 links — {link1}, {link2}, {link3}, {link4}
       Copy is literal. No paraphrasing, no 'improvement.'
       Anything not on this list is not in the spec."
      (reason: explicit enumeration eliminates interpretation drift;
       paraphrased copy is one of the top AI hallucination patterns)
```

## Exclusion List
- {explicit anti-inclusion enumeration} (reason: ...)

```
BAD:  "avoid obvious bad additions"
GOOD: "Forbidden unless explicitly requested (by default, every design):
       - Newsletter signup / email capture
       - Trust badges / testimonials / social proof numbers ('10,000+ users')
       - Decorative icons beyond what source specifies
       - Secondary 'Learn more' / 'Get started' CTAs
       - AI-invented feature benefits or product descriptions
       - Placeholder Lorem ipsum — use [원본 카피 필요] marker instead
       If AI thinks any of these would 'help,' spec emits
       ADDITION_SUGGESTED marker (below) instead of adding them."
      (reason: these are the most common AI hallucinations in design;
       explicit banning is more reliable than relying on AI judgment)
```

## Addition Marker
- {how to represent 'seemingly missing' content without asking} (reason: ...)

```
BAD:  AI adds 'obviously missing' elements unilaterally
      (also BAD: AI interrupts flow with "원본에 X가 없는데 추가할까요?")
GOOD: "If AI believes something is missing or would improve the design,
       spec emits an inline marker instead of adding or asking:
       `ADDITION_SUGGESTED: {element} — 원본에 없음. 원하면 재요청.`
       Marker appears in the relevant section (e.g., under Hierarchy or Layout).
       AI never adds unilaterally. AI never interrupts. Designer re-submits
       with explicit inclusion if desired."
      (reason: 'missing' is a designer's judgment call;
       the omission may be deliberate — trust-minimal product, regulated
       market, single-CTA funnel. Markers preserve designer authority
       without dialogue overhead.)
```

## Modification Boundary
- {styling vs structural change classification} (reason: ...)

```
BAD:  AI freely restructures source material in response to styling requests
GOOD: "Styling layer (produced in spec directly):
       - Spacing, typography scale, color values (within design system)
       - Component-level styling, hover/focus states
       - Responsive behavior at declared breakpoints

       Structural layer (requires explicit request — otherwise emit flag):
       - Adding / removing / reordering sections
       - Changing copy (even minor rephrasing)
       - Restructuring information hierarchy
       - Adding / removing CTAs or navigation items
       - Changing interaction flows

       If spec would require structural change but request sounded like styling,
       emit MODIFICATION_BOUNDARY_CROSSED flag (see workflow.md) and produce
       the styling-only version by default."
      (reason: styling is the designer's implicit ask; structural changes
       are decisions the designer owns — spec cannot make them unilaterally)
```

## Copy Fidelity
- {rules for source copy handling} (reason: ...)

```
BAD:  "AI polishes copy for better UX"
GOOD: "Source copy is LITERAL. No paraphrasing, no shortening, no 'punchier.'
       Missing copy: use `[원본 카피 필요]` placeholder in the exact slot.
       Spec emits COPY_MISSING flag (see workflow.md) listing missing blocks.
       NEVER invent:
       - Product names
       - Feature descriptions
       - Metrics or numbers ('10,000 users', '99.9% uptime')
       - Testimonial content
       - Claims (security, compliance, performance)

       Regulated contexts (medical, finance, pharma): any copy change requires
       explicit written approval in the request."
      (reason: invented copy creates compliance risk and overrides
       carefully-written marketing/legal language)
```
