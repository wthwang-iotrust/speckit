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
