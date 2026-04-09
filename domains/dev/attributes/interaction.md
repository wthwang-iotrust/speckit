# Interaction Attributes

Guide: Every interaction must define what the user sees at each state,
how they transition between states, and what happens when things go wrong.

## State Machine
```
{state A} --{trigger}--> {state B}
{state B} --{trigger}--> {state C}
{state C} --{trigger}--> {state A}
```

```
BAD:  "handle loading"
GOOD: "idle --[click submit]--> loading --[200 OK]--> success --[3s]--> redirect(/dashboard)
                                        --[4xx]--> error(show message, keep form)
                                        --[timeout 10s]--> error('Taking too long, try again')"
```

## States
- Default: {description}
- Loading: {skeleton/spinner/progress bar, duration expectation}
- Empty: {message, illustration, CTA}
- Error: {message, retry option, recovery path}
- Success: {feedback type, duration, next action}
- Disabled: {visual treatment, tooltip explanation}
- Partial: {incomplete data behavior}

```
BAD:  "show a loading state"
GOOD: "Loading: skeleton pulse matching content layout (not spinner),
       shown after 200ms delay (avoid flash for fast responses).
       If loading > 5s, show 'Still working...' text below skeleton."
```

## User Actions
- {action}: {response + timing}
  - Click/tap: {immediate feedback < 100ms}
  - Submit: {loading indicator, disable button, success/error}
  - Navigate: {transition type, back behavior}
  - Scroll: {lazy loading, infinite scroll, pagination}
  - Keyboard: {shortcuts, tab order, enter/escape}

```
BAD:  "button click submits form"
GOOD: "Submit button: on click, immediately disable + show spinner inside
       button (replaces text). Form fields become readonly. On success,
       button turns green with checkmark for 1.5s, then redirect.
       On error, re-enable form, focus first invalid field, shake animation."
```

## Animation/Motion
- Page transition: {type, duration, easing}
- Component enter: {type, duration}
- Component exit: {type, duration}
- Micro-interaction: {hover, focus, active states}
- Reduced motion: {prefers-reduced-motion behavior}

```
BAD:  "smooth animations"
GOOD: "Modal enter: fade-in 200ms ease-out + scale from 0.95.
       Modal exit: fade-out 150ms ease-in.
       prefers-reduced-motion: no scale/slide, opacity-only transitions."
```

## Gestures (mobile) — include only if mobile interaction exists
- Swipe: {direction, action}
- Pull to refresh: {behavior}
- Long press: {behavior}
- Pinch/zoom: {enabled/disabled}

## Real-time — include only if live data exists
- Live updates: {polling/websocket/SSE, interval}
- Optimistic updates: {behavior on failure}
- Conflict resolution: {last-write-wins/merge/prompt}

Note: Gestures and Real-time are optional extensions. Include them under
"User Actions" in the spec output when relevant. Do not create separate
sections for them — fold into the main interaction spec.
