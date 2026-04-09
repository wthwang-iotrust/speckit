# Constraint Attributes

Guide: Constraints are non-negotiable. Every spec includes this section.
Use specific, measurable targets, not aspirational language.

## Performance
- LCP target: {value, e.g., < 2.5s}
- FID target: {value, e.g., < 100ms}
- CLS target: {value, e.g., < 0.1}
- Bundle size budget: {value if applicable}
- API response time: {target}
- Database query limit: {max queries per request}

```
BAD:  "should be fast"
GOOD: "LCP < 2.5s on 4G (Lighthouse mobile). API responses < 200ms p95.
       No endpoint exceeds 3 DB queries. JS bundle < 150KB gzipped."
```

## Security
- Authentication: {method, token type, expiry}
- Authorization: {role-based/attribute-based, rules}
- Input validation: {sanitization, length limits, allowed characters}
- CSRF protection: {method}
- Rate limiting: {threshold, window}
- Data encryption: {at rest, in transit}
- Secrets management: {env vars, vault, key rotation}

```
BAD:  "secure the endpoint"
GOOD: "JWT Bearer auth (RS256, 15min access / 7d refresh). Rate limit:
       100 req/min per IP on public endpoints, 1000/min on authenticated.
       All user input sanitized with DOMPurify before render.
       Passwords: bcrypt cost 12, min 8 chars."
```

## Accessibility
- WCAG level: {A/AA/AAA}
- Keyboard navigation: {tab order, focus management}
- Screen reader: {ARIA labels, landmarks, live regions}
- Color contrast: {minimum ratio}
- Touch targets: {minimum size, e.g., 44x44px}
- Focus indicators: {visible focus ring style}
- Alt text: {image/icon alt text strategy}

```
BAD:  "make it accessible"
GOOD: "WCAG 2.1 AA. All interactive elements keyboard-reachable.
       Color contrast 4.5:1 minimum (text), 3:1 (large text/UI).
       Focus ring: 2px solid #2563eb, 2px offset. All images have
       descriptive alt text. Form errors announced via aria-live."
```

## Browser/Device Support
- Browsers: {list with minimum versions}
- Devices: {desktop/tablet/mobile, specific breakpoints}
- OS: {if applicable}
- Offline: {behavior when disconnected}

```
BAD:  "works on all browsers"
GOOD: "Chrome 90+, Firefox 90+, Safari 15+, Edge 90+.
       Mobile: iOS Safari 15+, Chrome Android 90+.
       Breakpoints: 375px (mobile), 768px (tablet), 1024px (desktop).
       Offline: show cached content with 'You are offline' banner."
```

## i18n/l10n
- Languages: {supported languages}
- RTL support: {yes/no}
- Date/number formatting: {locale strategy}
- Translation strategy: {i18n library, key naming}

## Legal/Compliance
- GDPR: {consent, data retention, right to delete}
- Cookie policy: {required cookies, optional cookies}
- Terms/Privacy: {links required}
