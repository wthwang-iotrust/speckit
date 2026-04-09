# Color

Guide: Color is meaning, not decoration. Every color must have a job.
If two colors serve the same purpose, one must go.

## Palette
- {color definitions with roles} (reason: ...)

```
BAD:  "blue theme with some accents"
GOOD: "Background: #0a0f1d (deep navy). Surface: rgba(30, 41, 59, 0.6).
       Card: rgba(15, 23, 42, 0.5). Border: rgba(255, 255, 255, 0.08).
       Text primary: #f8fafc. Text secondary: #94a3b8."
      (reason: extracted from existing :root CSS variables)
```

## Semantic Colors
- {meaning-based color assignments} (reason: ...)

```
BAD:  "green for good, red for bad"
GOOD: "Accent (interactive): #3b82f6 (blue-500).
       Success (correct answer): #10b981 (emerald-500).
       Error (wrong answer): #ef4444 (red-500).
       Warning (time running out): #f59e0b (amber-500).
       Info (hint): #8b5cf6 (purple-500)."
      (reason: maps to existing --accent-blue, --accent-green,
       --accent-red, --accent-yellow, --accent-purple variables)
```

## Contrast
- {contrast ratios for key combinations} (reason: ...)

```
BAD:  "make sure it's readable"
GOOD: "Primary text on background: #f8fafc on #0a0f1d = 15.4:1 (AAA).
       Secondary text on background: #94a3b8 on #0a0f1d = 7.2:1 (AAA).
       Accent on background: #3b82f6 on #0a0f1d = 5.1:1 (AA).
       Accent on card: #3b82f6 on rgba(15,23,42) ≈ 4.8:1 (AA)."
      (reason: WCAG AA requires 4.5:1 for normal text, 3:1 for large text)
```

## Dark/Light Mode
- {mode strategy} (reason: ...)

```
BAD:  "support dark mode"
GOOD: "Dark-only for v1. If light mode needed later:
       swap --bg-primary to #f8fafc, --text-primary to #0f172a,
       keep accent colors unchanged (sufficient contrast both ways).
       Use prefers-color-scheme media query for auto-detection."
      (reason: current app is dark-only, light mode is a future decision)
```
