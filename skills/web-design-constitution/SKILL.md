---
name: web-design-constitution
description: The permanent design rules and 21-stage workflow for this web design stack. Use at the START of any website, landing page, UI, component, or visual-polish task, and whenever deciding art direction, imagery, typography, color, spacing, layout, components, interaction, animation, accessibility, SEO, or performance. Also use when reviewing UI for generic-AI aesthetics.
---

# Web Design Constitution

The full constitution lives at **`CLAUDE.md` in this plugin's root**
(`${CLAUDE_PLUGIN_ROOT}/CLAUDE.md`). Read it before any design work — it is the
authoritative source. Read it now if you have not already this session.

If this stack was installed into a project by `scripts/install.sh`, the constitution is
also at the project root as `CLAUDE.md` and loads automatically as project context.

## The workflow (never skip a stage)

```
DISCOVERY → DESIGN BRIEF → ART DIRECTION → REFERENCE RESEARCH → IMAGE STRATEGY →
DESIGN SYSTEM → COMPONENT DISCOVERY → INFORMATION ARCHITECTURE → VISUAL DESIGN →
IMPLEMENTATION → INTERACTION DESIGN → ANIMATION → RESPONSIVE → ACCESSIBILITY →
PERFORMANCE → BROWSER QA → VISUAL CRITIQUE → POLISH → CODE REVIEW → SECURITY →
FINAL AUDIT
```

**Hard gate 1:** BROWSER QA and VISUAL CRITIQUE are mandatory. A UI change you have not
looked at in a real browser is not finished. Fix Blocker/High findings before reporting done.

**Hard gate 2:** ART DIRECTION and IMAGE STRATEGY are mandatory for any page with a visual
surface. A page whose imagery nobody decided is a page with stock photos on it.

## The layers

- **Knowledge** — `ui-ux-pro-max` sets tokens (color, type, spacing). Data for correctness.
- **Taste** — `frontend-design` sets attitude. Taste for distinctiveness.
- **Art direction** — `visual-art-direction` decides what the page should *show*;
  `pinterest-art-direction` supplies references, analysed into original direction.
- **Imagery** — `image-sourcing` (licensed stock) and `image-generation` (Gemini) execute
  the art director's plan. Decide first, execute second.
- **Components** — `component-discovery` (structural) and `interactive-components` (motion).
  Search before building; re-theme to the project's tokens.
- **Feedback** — `playwright` / `chrome-devtools` MCP. See the rendered result and fix it.

## Non-negotiable floor

- Responsive at **375 / 768 / 1024 / 1440** — no horizontal scroll, content reflows, image
  focal points survive every crop.
- WCAG 2.1 AA — visible focus, 4.5:1 text contrast, keyboard operable, semantic HTML,
  meaningful `alt` on every image.
- Core Web Vitals — LCP < 2.5s, INP < 200ms, CLS < 0.1.
- `prefers-reduced-motion` respected with a genuine reduced path.
- At most **two** major motion systems visible on one viewport at a time.
- Every sourced or generated image recorded in `public/images/image-sources.json` with its
  licence and attribution. No placeholders, ever.
- No API key in any tracked file.

## The two decision rules

**Image usage** — for every section ask *"would this communicate better with a visual?"*
If no, say why and let type and space work. If yes: references → analyse → search licensed →
generate if nothing fits → optimise → `next/image` → responsive crop → subtle motion.
Never leave a site visually empty by default; never force images where they don't help.

**Component usage** — never build a complex interactive component from scratch before
searching. Hierarchy: **project → shadcn → 21st → React Bits → Aceternity → custom**.
Then decide: reuse / adapt / compose / custom build. External components always conform to
the project's design tokens.

## Banned by default (generic-AI tells)

Purple/blue hero gradients · gradient headline text · blanket glassmorphism · uniform grids of
identical rounded cards · everything `rounded-2xl` · soft shadows on every surface · staggered
fade-up on entire pages · centered-hero → 3-column → testimonials → CTA · emoji as production
iconography · filler copy · placeholder stock imagery · unrelated Unsplash photos · generic AI
hero images (gradient mesh, floating glass, abstract 3D blobs) · laughing-team-at-laptop.

**The test:** if the page could be swapped onto a competitor's site by changing only the logo
and copy, the art direction failed. Return to ART DIRECTION.
