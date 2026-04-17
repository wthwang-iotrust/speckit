# Typography

Guide: Typography is information hierarchy made visible. Every level
must be distinguishable at a glance — if two levels look the same,
one is unnecessary.

## Scale
- {type scale definition} (reason: ...)

```
BAD:  "use appropriate font sizes"
GOOD: "Major third scale (1.25 ratio): 12 / 14 / 16 / 20 / 24 / 32 / 40.
       Body: 16px. UI labels: 12px. Page title: 32px."
      (reason: 1.25 ratio provides clear distinction between levels
       without excessive jumps; 16px body is WCAG AA minimum comfortable)
```

## Primary (Body)
- {body typeface specification} (reason: ...)

```
BAD:  "readable font"
GOOD: "Pretendard 16/24 (line-height 1.5) regular #f8fafc.
       Paragraph spacing: 16px. Max line length: 65ch."
      (reason: existing CDN link loads Pretendard; 24px line-height
       matches current body { line-height: 1.6 } closely)
```

## Display (Headings)
- {heading typeface specification} (reason: ...)

```
BAD:  "bold headings"
GOOD: "Pretendard semibold (600). H1: 32/40 letter-spacing -0.02em.
       H2: 24/32. H3: 20/28. Color: #f8fafc (same as body on dark bg)."
      (reason: existing h1 uses font-weight: 800 and letter-spacing: -0.02em,
       but 600 provides enough contrast without feeling heavy)
```

## Hierarchy Expression
- {how type sizes/weights express information priority} (reason: ...)

```
BAD:  "make titles bigger"
GOOD: "3 distinct levels visible without scrolling:
       1. Page title (32px semibold) — what screen am I on?
       2. Section label (14px uppercase 600 tracking +0.05em) — what group is this?
       3. Content body (16px regular) — the actual information.
       Never use size alone — combine with weight, color, or spacing."
      (reason: uppercase small labels with tracking is the existing
       pattern in .progress-text)
```

## AI Anti-patterns (what AI gets wrong)
- {common AI mistakes specific to typography} (reason: ...)

```
BAD:  AI uses inconsistent sizes for same-level content, forgets to distinguish
      hierarchy levels, introduces off-scale values, and defaults to ALL CAPS
      for "impact"
GOOD: "Reject in AI output:
       - Two pieces of same-level content with different sizes
         ('이 두개가 같은 레벨인데 전혀 다른 폰트 사이즈')
       - Off-scale values (17px, 19px, 22px when scale is 12/14/16/20/24)
       - Identical size + weight across two hierarchy levels
         ('if two levels look the same, one is unnecessary')
       - ALL CAPS used for body text or long copy (reduces readability)
       - Uppercase without positive letter-spacing
       - Line-height < 1.4 for body text (cramped reading)
       - Line length > 75ch (eye has to track too far)
       - Mixing 3+ font families without reason"
      (reason: these violations break information hierarchy — the single most
       common reason a design feels 'off' even when individual choices look fine)
```
