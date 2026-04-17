# Mood & Direction

Guide: Mood sets the emotional foundation for every visual decision.
Every other attribute (color, typography, layout) flows from this.

## Tone
- {3-5 adjectives describing the visual feeling} (reason: ...)

```
BAD:  "modern and clean"
GOOD: "minimal, confident, technical, slightly warm — not sterile"
      (reason: existing dark theme with blue/purple accents suggests
       tech-forward but not cold; Pretendard font choice adds warmth)
```

## Reference Direction
- {1-2 reference directions or inspiration sources} (reason: ...)

```
BAD:  "like Apple"
GOOD: "Linear's information density + Vercel's monochrome confidence.
       Dense but not cluttered — every element earns its space."
      (reason: dashboard context requires high information density,
       existing dark theme aligns with dev-tool aesthetic)
```

## Anti-pattern
- {1-2 things to explicitly avoid} (reason: ...)

```
BAD:  "don't make it ugly"
GOOD: "Avoid: gradient-heavy hero sections, decorative illustrations,
       rounded-everything softness. This is a tool, not a marketing site."
      (reason: CBT app context — users are studying, not browsing)
```

## Reference Requirement
- {when a visual reference is required vs optional} (reason: ...)

```
BAD:  designer says "좀 더 모던하게" → AI invents → 5 rounds of "not like that"
GOOD: "If the brief uses subjective adjectives without a reference —
       '모던한', '세련된', '깔끔한', '트렌디한', 'premium', 'bold' —
       AI requests a reference BEFORE producing output:
       '레퍼런스 이미지나 URL 하나만 주세요. 없으면 방향 3개를 말로 먼저 제시할게요.'
       No 'let me try something and see.'"
      (reason: subjective adjectives mean different things to different people;
       without a visual anchor AI cannot converge on designer intent through text.
       One reference = 1-round approval. Zero references = 5-round miss cycle.)
```

## AI Anti-patterns (what AI gets wrong)
- {common AI mistakes specific to mood/direction} (reason: ...)

```
BAD:  AI generates "clean modern dashboard" aesthetic regardless of brand
GOOD: "Common AI mood failures to reject in output:
       - Generic 'startup landing' aesthetic (gradient purple, floating cards)
         when brand is enterprise/regulated
       - 'Friendly illustration' style when brand is technical/serious
       - Over-indexing on current trend (glassmorphism, neumorphism)
         when brand is timeless
       - Neutral/bland when designer explicitly asked for bold
       - Inventing brand personality from the component name alone"
      (reason: these are the most common 'default AI look' that designers
       have to manually steer away from)
```
