# Visual Attributes

Guide: Every visual spec must be concrete enough that two developers would
produce visually identical results without needing to "interpret" the spec.

## Layout
- Structure: {grid/flex/composition description}
- Responsive breakpoints: {mobile/tablet/desktop values}
- Spacing system: {base unit, scale}
- Max width: {container constraint}

```
BAD:  "responsive layout"
GOOD: "CSS Grid 2-column (sidebar 280px fixed + main fluid), gap 24px.
       Collapses to single column below 768px, sidebar becomes top nav.
       Max container width 1280px, centered with auto margins."
```

## Typography
- Heading: {font-family, size, weight, line-height, color}
- Body: {font-family, size, weight, line-height, color}
- Caption/Label: {font-family, size, weight, color}
- Code/Mono: {font-family, size}

```
BAD:  "use a nice font"
GOOD: "Heading: Inter 24/32 semibold #1a1a1a. Body: Inter 14/22 regular #374151.
       Caption: Inter 12/16 medium #6b7280. Code: JetBrains Mono 13/20."
```

## Color
- Background: {hex/token}
- Surface: {hex/token}
- Primary text: {hex/token}
- Secondary text: {hex/token}
- Accent/CTA: {hex/token}
- Error: {hex/token}
- Success: {hex/token}
- Warning: {hex/token}
- Border: {hex/token}

```
BAD:  "blue theme"
GOOD: "Background #ffffff, Surface #f9fafb, Primary text #111827,
       Secondary #6b7280, Accent #2563eb, Error #dc2626, Success #16a34a,
       Border #e5e7eb. Dark mode: Background #0f172a, Surface #1e293b."
```

## Components
- {component name}: {size, padding, border-radius, shadow, states}
- Buttons: {primary/secondary/ghost variants}
- Inputs: {height, padding, border, focus state}
- Cards: {padding, shadow, border-radius}

```
BAD:  "styled buttons"
GOOD: "Primary button: h-10 px-4 bg-blue-600 text-white rounded-lg
       hover:bg-blue-700 active:bg-blue-800 disabled:opacity-50
       focus:ring-2 focus:ring-blue-500 focus:ring-offset-2
       transition-colors duration-150"
```

## Iconography
- Style: {outline/filled/duotone}
- Size: {default px}
- Source: {icon library or custom}

## Imagery
- Style: {photography/illustration/abstract}
- Aspect ratios: {values}
- Placeholder: {behavior while loading}

```
BAD:  "add images"
GOOD: "Hero image: 16:9 aspect ratio, object-fit cover, skeleton pulse
       placeholder (#e5e7eb animated) while loading. Max file size 200KB
       (WebP preferred, JPEG fallback)."
```
