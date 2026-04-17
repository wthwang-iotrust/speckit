# Workflow

Guide: Workflow surfaces **decision gates** within the spec itself.
speckit never interrupts with questions — instead, the spec embeds explicit
flags when triggers are detected. Designer sees the flags, decides, re-submits.
Answers: "what must the designer resolve before this spec can be implemented?"

Principle (inherited from SKILL.md): **Never ask. Analyze, decide, output, stop.**
This attribute enforces the principle by making ambiguity visible in the output
instead of handled through dialogue.

## Decision Gate Flags

Emitted at the top of the spec under `## Decision Gates`. One line each.
Flag is present → spec is produced with best-guess decisions marked `(tentative)`.
Flag is absent → spec is committed decisions, ready to implement.

### REFERENCE_REQUIRED
- {trigger + flag format} (reason: ...)

```
BAD:  designer writes "좀 더 모던하게" → AI invents → 5 rounds of "not like that"
GOOD: "Trigger: subjective visual adjectives with no reference
       Keywords: 모던하게, 세련되게, 깔끔하게, 트렌디한, premium, bold, clean, minimalist
       Flag: `REFERENCE_REQUIRED: '{word}' 감지 — 레퍼런스 이미지/URL 없이는 방향 확정 불가`
       Spec behavior: produce best-guess mood/visual with every decision marked
       `(tentative — depends on reference)`. Designer attaches reference → re-submits."
      (reason: subjective adjectives don't converge through text;
       a visible flag lets the designer resolve in one round instead of five)
```

### SCOPE_AMBIGUOUS
- {trigger + flag format} (reason: ...)

```
BAD:  "이 페이지 좀 개선해줘" → AI rewrites everything including FAQ, hero, nav
GOOD: "Trigger: modification request without explicit scope boundary
       Keywords: 개선, 수정, 바꿔, refactor, update, enhance, polish, tweak
       Flag: `SCOPE_AMBIGUOUS: '{request}' 범위 불명확 — 예상 영향: {list}.
              좁게 해석해 진행. 넓히려면 재지시.`
       Spec behavior: treat scope as the narrowest reasonable interpretation
       (usually the most recently mentioned section). Touches beyond that
       scope are listed under the flag."
      (reason: 'update' is ambiguous by default; surfacing the interpretation
       prevents silent collateral edits)
```

### MOBILE_VERIFICATION_PENDING
- {trigger + flag format} (reason: ...)

```
BAD:  spec shows desktop layout only; mobile is "TBD" or missing
GOOD: "Trigger: layout decision produced without simultaneous mobile spec
       Flag: `MOBILE_VERIFICATION_PENDING: 모바일(375px) 스펙 미산출 —
              데스크톱 구조 확정 전 반드시 추가.`
       Enforcement: layout attribute MUST produce both desktop and mobile
       specs in the same output (see layout.md Responsive VERIFICATION RULE).
       This flag exists as a failsafe — if it appears, the spec is incomplete."
      (reason: mobile bugs discovered after desktop is finalized require
       restructuring desktop, doubling the work)
```

### CONSOLIDATION_SUGGESTED
- {trigger + flag format} (reason: ...)

```
BAD:  designer drips 5 issues across 5 turns → AI patches 5 times → code rot
GOOD: "Trigger: current spec is a refinement of a prior spec AND prior spec
       has 3+ unresolved corrections within the same component
       Flag: `CONSOLIDATION_SUGGESTED: 이 컴포넌트 누적 이슈 {n}건 —
              개별 패치 누적보다 통째 재작성 권장.`
       Spec behavior: produce rewrite-oriented spec (fresh structure based on
       consolidated feedback) instead of patch-oriented spec (diff against prior)."
      (reason: patching flawed structure 5 times produces a worse result than
       one clean rewrite informed by consolidated feedback)
```

### COPY_MISSING
- {trigger + flag format} (reason: ...)

```
BAD:  source copy is incomplete → AI invents marketing claims, metrics, or CTAs
GOOD: "Trigger: source material has missing copy blocks for required slots
       Flag: `COPY_MISSING: [원본 카피 필요] 블록 {n}개 — 카피 입력 전 구현 불가.`
       Spec behavior: use literal `[원본 카피 필요]` placeholder inline wherever
       copy is missing. NEVER invent product descriptions, numbers, testimonials."
      (reason: invented copy creates compliance risk in regulated markets
       and overrides legal/marketing-approved language)
```

### MODIFICATION_BOUNDARY_CROSSED
- {trigger + flag format} (reason: ...)

```
BAD:  request sounds like styling tweak → AI restructures sections/hierarchy
GOOD: "Trigger: spec requires a structural change (add/remove/reorder sections,
       change copy, restructure hierarchy, add/remove CTAs) that was not
       explicitly requested
       Flag: `MODIFICATION_BOUNDARY_CROSSED: {change type} 필요 — 구조 변경
              권한 미확인. 스타일만 진행하거나 디자이너 승인 후 구조 진행.`
       Spec behavior: produce styling-only spec by default. Structural changes
       listed under the flag for designer decision."
      (reason: styling is designer's implicit ask; structural changes are
       decisions the designer owns — spec cannot make them unilaterally)
```

## Checklist Output
- {explicit assumption list embedded in spec, not asked about} (reason: ...)

```
BAD:  AI produces spec without listing what it assumed
GOOD: "Large design spec headers include an explicit assumption block:
       ```
       > Assumptions:
       > - Tokens in use: --accent-blue, --bg-primary, --text-primary
       > - Breakpoints: 375 / 768 / 1280 (verified)
       > - Scope: hero + feature-cards only; footer/FAQ untouched
       > - Deliverables: layout + hierarchy + responsive spec
       ```
       Designer scans → corrects any wrong line → re-submits.
       No dialogue needed — the checklist is self-describing."
      (reason: making assumptions visible is faster than asking about them;
       designer edits one line of checklist instead of answering 5 questions)
```

## Multi-viewport Verification
- {requirement — not a flag, a hard output rule} (reason: ...)

```
BAD:  spec contains desktop layout only; mobile listed as "TBD" or "see later"
GOOD: "Every layout-producing spec contains BOTH breakpoints in the SAME output:
       - Desktop (≥1024px): {full layout spec}
       - Mobile (375px): {full layout spec, not just 'stack vertically'}
       If either is missing, spec must emit MOBILE_VERIFICATION_PENDING flag
       and be treated as incomplete."
      (reason: enforcement-by-output makes mobile a first-class deliverable
       instead of a 'check later' task that accumulates bugs)
```

## Iteration Prevention
- {how spec structure discourages patch-on-patch} (reason: ...)

```
BAD:  spec framed as "here's v1, give feedback" → feedback comes in drips →
      each drip gets a small patch → 5 patches later the structure is
      incoherent even though each patch seemed reasonable
GOOD: "When prior spec has 3+ outstanding corrections on one component,
       emit CONSOLIDATION_SUGGESTED flag and produce a rewrite-oriented spec
       rather than a patch-oriented one. Signal to designer:
       consolidated feedback → clean rewrite beats dripped patches."
      (reason: structural integrity degrades faster than individual fixes
       can restore it; resetting is cheaper than patching past a threshold)
```
