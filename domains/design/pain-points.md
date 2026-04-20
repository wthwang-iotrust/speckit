# Designer Pain Points — Why v0.6 Added What It Added

This document explains the real frustrations designers experience when working
with AI tools, and which speckit attributes address each one. If you're a
designer feeling like "the AI never gets it right," this is the map.

> "잘 해줘"는 명세가 아니다. — 그리고 "이런 느낌으로"도 아니다.

---

## The 7 recurring pain points

### 1. The 5-to-10 round revision loop

**Symptom:** One section requires 5 to 10 rounds of corrections before it lands.
The AI produces something, designer says "not quite," AI produces another
variant, designer says "closer but..." — and the cycle eats the day.

**Root cause:** AI starts producing visual output before confirming
interpretation. Misalignment at the interpretation stage compounds into
structural issues that require more rework each round.

**Addressed by:** `workflow.md` → Checklist Output, Iteration Prevention, CONSOLIDATION_SUGGESTED flag

---

### 2. "Originals had 3 sections — AI shipped 5"

**Symptom:** Designer asks for a page update. AI adds "helpful" things — a
newsletter signup, trust badges, a secondary CTA, invented feature benefits.
None of these were in the source. The designer deliberately excluded them.

**Root cause:** AI treats scope as a suggestion. Sees "landing page" and fills
in what a generic landing page usually has, regardless of what this specific
source specified.

**Addressed by:** `scope.md` → Inclusion List, Exclusion List, Addition Marker (+ `ADDITION_SUGGESTED` inline marker)

---

### 3. Mobile-as-afterthought

**Symptom:** AI produces desktop layout that looks great. Designer checks
mobile and finds it broken — text overflow, cards stacked weirdly, CTAs
below the fold at 375px. Fixing mobile requires restructuring the desktop.

**Root cause:** AI defaults to desktop-first. Mobile is treated as a
"check later" task. By the time it's checked, the desktop structure is
locked in.

**Addressed by:** `layout.md` → strengthened Responsive section,
`workflow.md` → Multi-viewport Verification

---

### 4. "이런 느낌으로" produces 5 wrong feels

**Symptom:** Designer uses subjective language ("모던하게," "깔끔하게,"
"좀 더 trendy하게"). AI interprets and outputs — usually missing the mark.
Designer tries to describe the target in more words. More rounds of misses.

**Root cause:** Subjective adjectives mean different things to different
people. Without a visual anchor (reference image/URL), AI cannot converge
on the designer's intent through text alone.

**Addressed by:** `mood.md` → Reference Requirement,
`workflow.md` → `REFERENCE_REQUIRED` flag (emits `(tentative)` annotation on related decisions)

---

### 5. Design tokens drift

**Symptom:** Project has a design system with specific hex values and spacing
units. AI produces output with slightly different values — `#3a82f6` instead
of `#3b82f6`, `padding: 22px` instead of `24px`. Small drifts accumulate
into a visibly inconsistent design.

**Root cause:** AI pattern-matches from its training rather than reading the
actual design system file. Nobody told the AI "only use these exact tokens."

**Addressed by:** `constraint.md` → strengthened Brand / Technical sections,
Anti-pattern additions

---

### 6. Copy hallucination

**Symptom:** Source copy is "Secure your digital assets." AI outputs "Protect
your crypto with military-grade encryption, trusted by 10,000+ users."
None of those claims exist in the source. The "10,000 users" is made up.
In a regulated market, this creates compliance risk.

**Root cause:** AI treats copy as creative material to improve. Does not
distinguish between "make this visually better" and "leave the words alone."

**Addressed by:** `scope.md` → Copy Fidelity

---

### 7. Incremental feedback without consolidation

**Symptom:** Designer gives feedback piece by piece ("also fix this,"
"and this too," "oh and this"). Each fix is a patch on the previous patch.
After 5 patches, the code is a mess even though each individual change
seemed reasonable.

**Root cause:** Neither the designer nor the AI pauses to say "we have 5
issues — let's rewrite this section once instead of patching it 5 times."
The patch-on-patch pattern produces worse results than consolidated rework.

**Addressed by:** `workflow.md` → Iteration Prevention

---

## How to use this

### For the designer

1. **Use the `designer-strict` preset** if you've experienced these pain
   points. It forces `workflow` and `scope` attributes into every design spec,
   which enables the flag/marker system below.

   ```bash
   cp domains/design/presets/designer-strict.json domains/design/presets/custom.json
   ```

2. **State your source of truth explicitly** at the start of any request.
   "Source: Figma file X, current page Y, these 3 sections only."

3. **Give references for subjective requests.** If you say "모던하게,"
   include a reference. If you don't have one, state it — the spec will mark
   mood decisions as `(tentative)` and emit `REFERENCE_REQUIRED` flag.

4. **Consolidate feedback.** When multiple issues appear, collect them.
   After 3+ issues on one component the spec will emit `CONSOLIDATION_SUGGESTED`
   and switch to rewrite-oriented output.

### For the AI (behavior encoded in the attributes)

speckit **never interrupts with questions** — the core principle
"Never ask. Analyze, decide, output, stop." is preserved. Instead, ambiguity
becomes visible as **inline flags and markers in the spec output**:

1. `## Decision Gates` section lists any triggered flags
   (`REFERENCE_REQUIRED`, `SCOPE_AMBIGUOUS`, `MOBILE_VERIFICATION_PENDING`,
   `CONSOLIDATION_SUGGESTED`, `COPY_MISSING`, `MODIFICATION_BOUNDARY_CROSSED`).
2. Tentative decisions are annotated `(tentative — depends on {gate})`.
3. Missing source copy uses `[원본 카피 필요]` placeholder in situ.
4. Seemingly-missing elements use `ADDITION_SUGGESTED: {element}` marker
   in the relevant section — never added unilaterally.
5. Layout specs include desktop AND mobile; if mobile missing,
   `MOBILE_VERIFICATION_PENDING` fires.
6. Copy is literal from source — never paraphrased, never invented.

Designer reads flags, resolves, re-submits. One round of correction beats
a five-round dialogue loop.

---

## Relation to existing speckit principles

These additions **preserve** speckit's core principle —
"Never ask. Analyze, decide, output, stop." — by routing all ambiguity
into visible output artifacts (flags, markers, tentative annotations)
rather than interactive dialogue.

| Speckit principle | v0.6 addition |
|---|---|
| Analyze silently | same |
| Make decisions | same — with `(tentative)` annotation when gated |
| Output spec | same — with new `## Decision Gates` section when triggered |
| Stop | same — no follow-up questions, ever |

In short: speckit still doesn't ask. It makes its assumptions and gates
visible so the designer can correct them in one pass.
