---
name: web-design-constitution
description: The permanent design rules and 15-stage workflow for this web design stack. Use at the START of any website, landing page, UI, component, or visual-polish task, and whenever deciding typography, color, spacing, layout, animation, accessibility, SEO, or performance. Also use when reviewing UI for generic-AI aesthetics.
---

# Web Design Constitution

The full constitution lives at **`CLAUDE.md` in this plugin's root**
(`${CLAUDE_PLUGIN_ROOT}/CLAUDE.md`). Read it before any design work — it is the
authoritative source. Read it now if you have not already this session.

If this stack was installed into a project by `scripts/install.sh`, the constitution is
also at the project root as `CLAUDE.md` and loads automatically as project context.

## The workflow (never skip a stage)

```
RESEARCH → INFORMATION ARCHITECTURE → DESIGN SYSTEM → VISUAL DIRECTION →
IMPLEMENTATION → RESPONSIVE → ANIMATION → ACCESSIBILITY → PERFORMANCE →
BROWSER QA → VISUAL CRITIQUE → POLISH → CODE REVIEW → SECURITY REVIEW → FINAL BUILD
```

**Hard gate:** BROWSER QA and VISUAL CRITIQUE are mandatory. A UI change you have not
looked at in a real browser is not finished. Fix Blocker/High findings before reporting done.

## The three layers

- **Knowledge** — `ui-ux-pro-max` sets tokens (color, type, spacing). Data for correctness.
- **Taste** — `frontend-design` sets attitude. Taste for distinctiveness.
- **Feedback** — `playwright` / `chrome-devtools` MCP. See the rendered result and fix it.

## Non-negotiable floor

- Responsive at **375 / 768 / 1024 / 1440** — no horizontal scroll, content reflows.
- WCAG 2.1 AA — visible focus, 4.5:1 text contrast, keyboard operable, semantic HTML.
- Core Web Vitals — LCP < 2.5s, INP < 200ms, CLS < 0.1.
- `prefers-reduced-motion` respected with a genuine reduced path.

## Banned by default (generic-AI tells)

Purple/blue hero gradients · gradient headline text · blanket glassmorphism · uniform grids of
identical rounded cards · everything `rounded-2xl` · soft shadows on every surface · staggered
fade-up on entire pages · centered-hero → 3-column → testimonials → CTA · emoji as production
iconography · filler copy.

**The test:** if the page could be swapped onto a competitor's site by changing only the logo
and copy, the art direction failed. Return to VISUAL DIRECTION.
