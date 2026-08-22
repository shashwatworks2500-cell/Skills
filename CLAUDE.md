# CLAUDE.md — Professional Web Design Constitution

This project is an **agency-grade website design and development environment**. These rules are
permanent and apply to every UI, page, component, and visual-polish task. They are not
suggestions. When a rule here conflicts with a habit, the rule wins.

The stack has three layers, and each has one job:

| Layer | Tool | Job |
|---|---|---|
| **Knowledge** | `ui-ux-pro-max` skill (`skills/ui-ux-pro-max`, or `.claude/skills/ui-ux-pro-max` in a project install) | What to build. Tokens, palettes, type pairings, UX rules, Core Web Vitals budgets. |
| **Taste** | `frontend-design` plugin skill | Make it distinctive. Attitude, art direction, anti-default. |
| **Feedback** | `playwright` + `chrome-devtools` MCP | Actually see the rendered result and fix it. |
| **Components** | `shadcn` MCP (+ `@react-bits`, `@aceternity` registries), `21st` MCP | Add primitives and interactions instead of hand-rolling them. |
| **Art direction** | `visual-art-direction`, `pinterest-art-direction` skills, `pinterest` MCP | Decide what the page should *show*, before deciding how it looks. |
| **Imagery** | `image-sourcing` + `imagebank` MCP, `image-generation` + `nanobanana` MCP | Source licensed photography, or generate original assets. |
| **Review** | `design-review` agent, `code-review`, `claude-security` | Gate before done. |

---

## THE WORKFLOW

Every website task runs this sequence. Do not skip stages. Do not reorder them.

```
DISCOVERY → DESIGN BRIEF → ART DIRECTION → REFERENCE RESEARCH → IMAGE STRATEGY →
DESIGN SYSTEM → COMPONENT DISCOVERY → INFORMATION ARCHITECTURE → VISUAL DESIGN →
IMPLEMENTATION → INTERACTION DESIGN → ANIMATION → RESPONSIVE → ACCESSIBILITY →
PERFORMANCE → BROWSER QA → VISUAL CRITIQUE → POLISH → CODE REVIEW → SECURITY →
FINAL AUDIT
```

| # | Stage | Do this | Primary tool |
|---|---|---|---|
| 1 | **DISCOVERY** | Audience, competitors, constraints, what success means. Never design blind. | `/shape` |
| 2 | **DESIGN BRIEF** | Write it down: positioning, the one thing to remember, tone, constraints. Everything downstream cites this. | `/shape` |
| 3 | **ART DIRECTION** | Decide what the page should *show*. Run the image decision framework per section. Commit to ONE tone and the signature element. | `visual-art-direction`, `frontend-design`, `/high-end-visual-design` |
| 4 | **REFERENCE RESEARCH** | Gather and analyse references. Extract typography, composition, palette, photography direction — then design originally from them. | `pinterest-art-direction`, `pinterest` MCP, `ui-ux-pro-max --domain style` |
| 5 | **IMAGE STRATEGY** | Produce the image plan: per section, NEED? → SOURCE / GENERATE / ASSET, with subject, aspect, focal point, motion, alt. | `visual-art-direction` |
| 6 | **DESIGN SYSTEM** | Generate concrete tokens: color, type, spacing, radius, elevation. This is the source of truth. | `/design-plan`, `ui-ux-pro-max --design-system` |
| 7 | **COMPONENT DISCOVERY** | Search before building. Walk the selection hierarchy; choose and plan adaptation. | `component-discovery`, `interactive-components`, `shadcn` + `21st` MCP |
| 8 | **INFORMATION ARCHITECTURE** | Page inventory, nav model, content hierarchy, conversion path. Structure before pixels. | `/shape`, `ui-ux-pro-max --domain landing` |
| 9 | **VISUAL DESIGN** | Compose the page: grid, rhythm, density variation, where the boldness is spent. | `frontend-design`, `/layout`, `/typeset` |
| 10 | **IMPLEMENTATION** | Build with the tokens. Components adapted, never dropped in raw. Images produced and integrated. | `shadcn` MCP, `image-sourcing`, `image-generation` |
| 11 | **INTERACTION DESIGN** | Choose the interaction patterns and their purpose. Budget them. Define reduced-motion and touch paths. | `interactive-components` |
| 12 | **ANIMATION** | Implement the motion. Only motion that carries meaning. Respect reduced-motion. | `/animate`, `ui-ux-pro-max --domain gsap` |
| 13 | **RESPONSIVE** | Verify 375 / 768 / 1024 / 1440. Content reflows, never shrinks. Focal points survive every crop. | `/adapt` |
| 14 | **ACCESSIBILITY** | WCAG 2.1 AA floor. Keyboard, contrast, semantics, focus, alt text. | `/audit` |
| 15 | **PERFORMANCE** | Core Web Vitals budgets. Images, fonts, bundle, deferred effect runtimes. | `/optimize`, Lighthouse via chrome-devtools MCP |
| 16 | **BROWSER QA** | Open the real page. Screenshot. Exercise states. Read the console. | `playwright` MCP |
| 17 | **VISUAL CRITIQUE** | Ranked findings across viewports. | `/design-review`, `/critique` |
| 18 | **POLISH** | Alignment, optical spacing, micro-detail. | `/polish` |
| 19 | **CODE REVIEW** | Correctness, conventions, over-engineering. | `/code-review`, `/ponytail-review` |
| 20 | **SECURITY** | Injection, XSS, secrets, SSRF, dependency risk. No API key in any tracked file. | `claude-security` |
| 21 | **FINAL AUDIT** | Typecheck, lint, build, `npm run verify`, `npm run audit`, re-verify. Green or not done. | build scripts, `scripts/verify.sh` |

**Hard gate:** stages 16 and 17 are mandatory. *A UI change you have not looked at in a browser
is not finished.* Blocker/High findings must be fixed before you report done.

**Second hard gate:** stages 3 and 5 are mandatory for any page with a visual surface. *A page
whose imagery nobody decided is a page with stock photos on it.*

---

## 1. DESIGN PHILOSOPHY

- Design serves the content and the user's goal. Decoration that carries no meaning is debt.
- Every visual choice must be defensible in one sentence. "It looked nice" is not a reason.
- Restraint reads as premium. Excess reads as amateur.
- Spend boldness in **one** place per view. Everything else stays quiet and supports it.
- Consistency beats novelty within a project; distinctiveness beats convention across projects.

## 2. PREMIUM WEBSITE PRINCIPLES

- Generous whitespace. Cramped layouts read as cheap; space is the cheapest luxury signal.
- Strong typographic contrast — size, weight, and case do the hierarchy work, not color alone.
- One signature element per page (a type treatment, a grid break, a material, a motion moment).
- Deliberate asymmetry over centered-everything.
- Real content and real imagery. Lorem ipsum and stock-photo placeholders hide layout failures.
- A "second-read moment": something a returning visitor notices that rewards attention.

## 3. TYPOGRAPHY RULES

- Maximum **2 typefaces** (3 only if one is monospace for code/data). Pull pairings from
  `ui-ux-pro-max --domain typography`.
- Use a modular scale (1.200–1.333 typical). No arbitrary font sizes.
- Body copy **16px minimum**; line-height 1.5–1.7; measure **60–75 characters**.
- Headings: tighter line-height (1.0–1.25) and negative letter-spacing at large sizes.
- `font-display: swap`, subset and preload the primary face. Self-host or use a licensed CDN.
- Never justify body text on the web. Never use font-size below 12px for anything meaningful.
- Set `text-wrap: balance` on headings, `pretty` on paragraphs where supported.

## 4. COLOR-SYSTEM RULES

- Token architecture: **primitive → semantic → component**. Components never reference raw hex.
- One dominant neutral ramp, one accent, at most one secondary accent. Pull from
  `ui-ux-pro-max --domain color`.
- Roughly 60/30/10 distribution (neutral / supporting / accent).
- Color is never the sole carrier of meaning — pair with icon, text, or shape.
- Contrast floor: **4.5:1** body text, **3:1** large text and UI boundaries.
- Dark mode is a designed variant, not an inverted filter. Verify contrast independently.

## 5. SPACING RULES

- One spacing scale based on a **4px or 8px** base. Every gap comes from the scale.
- No magic numbers. `margin: 13px` is a bug.
- Space belongs to **layout containers**, not to component internals leaking margins outward.
- Section rhythm scales with viewport: tighter on mobile, expansive on desktop.
- Related elements sit closer than unrelated ones — proximity is the cheapest grouping tool.

## 6. GRID / LAYOUT RULES

- Establish an explicit grid (commonly 12-column) and a max content width (typically
  1200–1440px), with a wider bleed allowed for feature sections.
- Use CSS Grid for two-dimensional layout, Flexbox for one-dimensional flow.
- Break the grid intentionally and rarely — a deliberate break is art direction, a random one
  is a mistake.
- Optical alignment beats mathematical alignment when they disagree.
- No horizontal overflow at any supported width, ever.

## 7. RESPONSIVE BREAKPOINTS

Mobile-first. Verify at these four widths at minimum:

| Width | Target |
|---|---|
| **375px** | Small phone |
| **768px** | Tablet |
| **1024px** | Laptop |
| **1440px** | Desktop |

- Layout reflows structurally; it does not merely scale down.
- Touch targets **≥ 44×44px** with adequate spacing.
- Test both orientations where it matters, and verify with real screenshots — not assumptions.

## 8. ANIMATION PRINCIPLES

- Motion must communicate: state change, spatial relationship, causality, or continuity.
  Motion for its own sake is banned.
- Duration **150–350ms** for UI feedback; longer only for deliberate narrative moments.
- Ease-out for entrances, ease-in for exits. Never linear for UI (except continuous loops).
- Animate **transform** and **opacity**. Animating layout properties causes jank.
- Respect `prefers-reduced-motion: reduce` — provide a genuine reduced path, not a stub.
- Nothing may block interaction or delay content while animating in.

## 9. GSAP RULES

- Use GSAP only when CSS transitions genuinely cannot express it (timelines, scroll-linked
  sequences, complex orchestration). CSS first.
- Register plugins once, centrally. Import only what is used.
- **Always clean up**: kill tweens, timelines, and ScrollTriggers on unmount. In React use
  `gsap.context()` / `useGSAP` and revert on cleanup. Leaked ScrollTriggers are a top cause of
  memory and scroll bugs.
- Prefer `scrub` for scroll-linked motion; avoid pinning long sections on mobile.
- Gate all GSAP entrance animation behind reduced-motion, and never hide content that fails to
  animate — content must be visible if JS fails.
- Presets available via `ui-ux-pro-max --domain gsap`.

## 10. LENIS RULES

- Smooth scroll is opt-in and justified — it is not a default. It can harm accessibility and
  feel wrong on trackpads.
- If used: single instance, integrated with GSAP ScrollTrigger via the ticker (do not run two
  competing RAF loops).
- **Disable entirely** under `prefers-reduced-motion`.
- Never break native anchor links, browser find-in-page, or keyboard scrolling.
- Destroy the instance on route change / unmount.

## 11. THREE.JS / R3F RULES

- 3D requires justification. It must serve the story, not prove technical skill.
- Budget-bound: keep draw calls and poly count low; compress textures (KTX2/Basis); use
  `dispose()` on unmount for geometries, materials, and textures.
- Lazy-load the 3D bundle; never let it block first paint or inflate the main bundle.
- Always ship a **static fallback** — reduced-motion, low-power devices, WebGL unavailable, and
  no-JS all need a real visual.
- Cap DPR (`Math.min(devicePixelRatio, 2)`) and pause the render loop when off-screen or the
  tab is hidden.
- 3D is decorative: it must never be the only carrier of essential content.

## 12. ACCESSIBILITY

- **WCAG 2.1 AA is the floor**, not the goal.
- Semantic HTML first: real `<button>`, `<a>`, `<nav>`, `<main>`, `<h1>`–`<h6>` in order.
  ARIA only when semantics genuinely cannot express it.
- Visible `:focus-visible` on every interactive element. Never `outline: none` without a
  replacement.
- Full keyboard operability; logical tab order; no keyboard traps; skip-to-content link.
- All images need meaningful `alt` (empty `alt=""` for decorative).
- Forms: real `<label>` for every field; errors announced and tied via `aria-describedby`.
- Respect reduced motion, forced colors, and 200% zoom without loss of content.

## 13. SEO

- One `<h1>` per page; logical heading hierarchy.
- Unique `<title>` and meta description per route; canonical URLs.
- Open Graph + Twitter card metadata; use Next.js Metadata API.
- Structured data (JSON-LD) where it applies (Organization, Product, Article, BreadcrumbList).
- Semantic markup, descriptive link text (never "click here"), sitemap and robots.
- Server-render content that matters for indexing. Core Web Vitals are a ranking factor.

## 14. PERFORMANCE

Budgets (mobile, mid-tier device):

| Metric | Budget |
|---|---|
| **LCP** | < 2.5s |
| **INP** | < 200ms |
| **CLS** | < 0.1 |

- Images: modern formats (AVIF/WebP), explicit `width`/`height` to reserve space,
  `next/image`, lazy-load below the fold, eager + `priority` for the LCP element.
- Fonts: preload primary, `font-display: swap`, subset aggressively.
- Ship less JS. Server Components by default; `"use client"` only at real interaction leaves.
- Dynamic-import heavy client libraries (GSAP, Three.js, charts).
- Verify with Lighthouse through the chrome-devtools MCP — measure, don't guess.

## 15. COMPONENT ARCHITECTURE

- One responsibility per component. If the name needs "and", split it.
- Composition over configuration — prefer children/slots over a boolean prop explosion.
- Props are a public API: explicit, typed, minimal. No prop drilling past two levels
  (use composition or context).
- Colocate component, styles, and tests. Shared primitives live in `components/ui`.
- Presentational and data-fetching concerns stay separate.
- No premature abstraction: **build it twice before you generalize it.**

## 16. NEXT.JS ARCHITECTURE

- **App Router only.** No Pages Router in new work.
- Server Components by default. Add `"use client"` at the smallest possible leaf.
- Data fetching in Server Components; Server Actions for mutations.
- `loading.tsx` and `error.tsx` per meaningful route segment; stream with Suspense.
- Metadata API for SEO. `next/image` and `next/font` are mandatory, not optional.
- Route handlers validate input at the boundary. Never leak secrets to client components —
  only `NEXT_PUBLIC_*` reaches the browser.

## 17. TYPESCRIPT STRICTNESS

- `"strict": true`. Plus `noUncheckedIndexedAccess`, `noImplicitOverride`,
  `exactOptionalPropertyTypes` where the codebase tolerates them.
- **`any` is banned.** Use `unknown` and narrow. No `@ts-ignore` without an adjacent comment
  justifying it (`@ts-expect-error` preferred, since it fails when obsolete).
- Type external data at the boundary — parse and validate (e.g. Zod), don't cast.
- Prefer inference internally; be explicit at exported/public API boundaries.
- Discriminated unions over optional-field soup.

## 18. TAILWIND CONVENTIONS

- Tokens live in the Tailwind theme config. Arbitrary values (`w-[347px]`) are a smell — allowed
  only for genuinely one-off values, never for spacing/color that belongs in the scale.
- Use semantic theme tokens (`bg-surface`, `text-muted`), not raw palette values in components.
- Extract a component when a class list repeats — not a `@apply` soup file.
- Use `cn()` (clsx + tailwind-merge) for conditional classes so conflicts resolve correctly.
- Mobile-first modifiers; keep class order conventional (layout → box → type → visual → state).
- Dark mode via the `dark:` variant driven by a class strategy.

## 19. SHADCN USAGE

- Add components through the **shadcn MCP** (`search_items_in_registries`,
  `get_add_command_for_items`) — do not hand-roll dialogs, selects, or comboboxes.
- shadcn components are **owned source**, not a locked dependency: restyle them to the design
  system. Do not ship default shadcn styling as the final look — that is a primary source of
  generic-AI appearance.
- Keep customizations in the component file; re-theme via tokens rather than overriding at every
  call site.
- Preserve the underlying Radix accessibility behavior. Never strip ARIA wiring while restyling.

## 20. CODE-QUALITY RULES

- Match the surrounding code's conventions; the codebase's style beats personal preference.
- Smallest diff that fully solves the problem. Fix root causes, not symptoms.
- No dead code, no commented-out blocks, no speculative abstractions or unused config.
- Names say what things are; comments explain *why*, never *what*.
- Handle errors at trust boundaries; never swallow exceptions silently.
- Non-trivial logic ships with one runnable check.

## 21. SECURITY RULES

- **Never** commit secrets. Server-only env vars stay server-only.
- Validate and sanitize all external input at the boundary — body, params, headers, webhooks.
- Escape output by default. `dangerouslySetInnerHTML` requires sanitization (DOMPurify) and a
  written justification.
- Parameterized queries only. No string-built SQL.
- AuthZ checked server-side on every request. Client-side checks are UX, never enforcement.
- CSP, HSTS, `X-Content-Type-Options`, `Referrer-Policy` configured. CSRF protection on
  state-changing routes. Rate-limit public endpoints.
- Keep dependencies current; treat advisories as work, not noise.
- Run `claude-security` before shipping anything that handles user data or auth.

## 22. VISUAL QA

- Screenshot every changed surface at all four breakpoints before declaring done.
- Check interactive states explicitly: default, hover, focus, active, disabled, loading, error,
  **empty**, and overflow with long content.
- Verify both light and dark themes.
- Look for: layout shift, z-index collisions, text clipping, inconsistent spacing, orphaned
  headings, misaligned optical edges.
- Re-screenshot after every fix. The loop is cheap; regressions are not.

## 23. BROWSER TESTING

- Drive a real browser via **Playwright MCP** — never assume rendered output from source.
- Read the console; warnings and errors are findings, not background noise.
- Exercise real user flows: keyboard-only navigation, form submission with invalid input,
  focus order through modals and menus.
- Use **chrome-devtools MCP** for Lighthouse audits, performance traces, and network analysis.
- `scripts/design-audit.mjs` (`npm run audit`) gives a fast multi-viewport heuristic pass and
  runs in CI via `.github/workflows/design-review.yml`.

## 24. MOBILE-FIRST CHECKS

- Author base styles for the smallest viewport, then add complexity upward.
- Verify at 375px **first**, not last.
- Touch targets ≥ 44px; no hover-only affordances — every hover interaction needs a tap path.
- Respect safe-area insets on notched devices.
- Test with a throttled network and CPU: the mobile experience is the real experience.
- Fixed headers must not eat scroll anchors or cover focused inputs when the keyboard opens.

## 25. ANTI-GENERIC-AI DESIGN RULES

These are **prohibitions**. Violating them makes work look machine-generated.

**Banned by default** (allowed only if the brief explicitly asks):

- ❌ Purple/blue hero gradients, and gradient text as a headline default.
- ❌ Glassmorphism as a general surface treatment (`backdrop-blur` on everything).
- ❌ Uniform grids of identically-sized rounded cards with an icon, a bold line, and two lines
  of gray filler.
- ❌ Everything at `rounded-2xl`. Radius should vary by element role and be part of the system.
- ❌ Soft drop shadows on every surface to fake depth.
- ❌ Animation on every element, staggered fade-up on entire pages.
- ❌ Centered-everything hero → 3-column features → testimonials → CTA. That's a wireframe, not
  a design.
- ❌ The three AI-slop palettes: cream + serif + terracotta; near-black + acid green/lime;
  hairline broadsheet minimalism.
- ❌ Emoji as iconography in production UI.
- ❌ Generic stock imagery and meaningless abstract 3D blobs.
- ❌ Filler copy ("Lorem ipsum", "Your tagline here", "Empower your workflow").

**Required instead:**

- ✅ Commit to one specific tone and execute it precisely.
- ✅ Vary section rhythm, density, and composition down the page.
- ✅ Let typography and spacing carry hierarchy before color and shadow do.
- ✅ One deliberate signature element per page.
- ✅ Real copy, real data, real images.
- ✅ Asymmetry and intentional grid breaks where they serve the content.

**The test:** if this page could be swapped onto a competitor's site by changing only the logo
and the copy, the art direction has failed. Start again at VISUAL DIRECTION.

---

## INTERACTION & MOTION CONSTITUTION

Sections 8–11 cover *how* to animate. This section covers *whether* to, *what* to reach for, and
*which named patterns* this stack uses. It sits above them: when they conflict, this wins.

### The twelve rules

1. **Every animation must have a purpose.** State it in one sentence before you write it: what
   state change, spatial relationship, causality or continuity does it communicate? No sentence,
   no animation.
2. **Never add animation just to demonstrate animation.** A page that animates to prove it can is
   a demo, not a product.
3. **Prefer subtle, premium motion.** The best motion is noticed as *feel*, not as *effect*.
   2–8px of displacement and 200ms usually beats 40px and 800ms.
4. **Respect `prefers-reduced-motion`.** A genuine reduced path — final state rendered
   immediately — never a stub, never hidden content.
5. **Use GSAP/ScrollTrigger for complex scroll choreography.** Timelines, pinning, scrubbing,
   orchestration across elements. Register plugins once, centrally.
6. **Use CSS transitions for simple hover states.** If a CSS transition expresses it, GSAP is
   over-engineering. CSS first.
7. **Use Lenis for smooth scrolling only where appropriate** — opt-in and justified, single
   instance, driven from the GSAP ticker, disabled under reduced motion, destroyed on unmount.
8. **Use magnetic / cursor effects only when they improve interaction.** A magnetic CTA that
   makes the primary action feel responsive: yes. A cursor blob on a content site: no.
9. **Avoid animation overload.** If a reviewer's first comment is about the motion rather than the
   content, there is too much motion.
10. **Never more than a few major motion systems on one viewport simultaneously.** Hard budget:
    **at most two** of { shader/canvas background, scroll-scrubbed choreography, cursor effect,
    page-wide text animation, parallax } visible at once. Everything else is micro-interaction.
11. **Keep mobile interactions simpler.** Cursor and magnetic effects have no touch equivalent —
    disable them at `(pointer: coarse)`, don't ship a dead interaction. Avoid pinned sections on
    mobile. Fewer, shorter, cheaper.
12. **Never sacrifice accessibility or performance for effects.** Tab order, focus-visible,
    contrast and the CWV budgets in §14 are floors. An effect that breaks one of them is a defect.

### Standard patterns

The vocabulary for this stack. Use these names in plans and reviews. Before implementing any of
them, search `interactive-components` (React Bits and 21st cover most) — reach for a custom
implementation only after walking the hierarchy.

| Pattern | Purpose it must serve | Implementation | Reduced-motion path |
|---|---|---|---|
| **Hero reveal** | Establish hierarchy on entry; headline lands before support copy | GSAP timeline, opacity + `y` ≤ 24px, stagger 60–80ms | Render final state; no delay |
| **Image reveal** | Draw the eye to the visual as it enters the viewport | Clip-path or mask wipe + slight scale (1.04 → 1) | Image visible immediately |
| **Staggered content reveal** | Show reading order in a list or grid | `stagger` 40–80ms, cap total under ~600ms | All items visible |
| **Scroll-triggered section reveal** | Signal a new idea has begun | ScrollTrigger `once: true`, trigger at ~85% viewport | Content visible |
| **Image parallax** | Depth; separates background from foreground content | ScrollTrigger `scrub`, `yPercent` ≤ 15 | No transform |
| **Magnetic CTA** | Make the single primary action feel responsive | `gsap.quickTo` on pointer delta, ≤ 8px pull, spring back | Static button |
| **Hover card** | Preview or affordance on a content card | CSS transition, `translateY(-4px)` + shadow token, 200ms | Instant state change |
| **Spotlight card** | Guide attention across a grid of equals | Pointer-position CSS custom property + radial gradient | Static surface |
| **Cursor-follow interaction** | Reinforce a brand's tactility on a signature surface | `quickTo` lerp; **desktop only** | Native cursor |
| **Text split animation** | Emphasise one headline — the signature line, not every heading | Split by word or char; **never split body copy** | Full text rendered |
| **Horizontal scroll section** | Content that is genuinely sequential (process, timeline, gallery) | ScrollTrigger pin + `x` scrub; **vertical stack on mobile** | Native horizontal scroll |
| **Gallery reveal** | Present a body of work as a set | Staggered mask reveal, or a React Bits gallery component | All items visible |
| **Page transition** | Preserve continuity between routes | Short (≤ 300ms) fade/slide; never block content or delay LCP | Instant navigation |
| **Nav scroll-state transformation** | Reclaim space and signal depth once scrolling starts | Class toggle at a scroll threshold, CSS transition on height/background | Instant state change |

**Accessibility floor for all of them:** content is present in the DOM and visible if JS fails;
tab order is unchanged; focus is never trapped; `:focus-visible` survives the effect.

**Cleanup is not optional:** every GSAP timeline and ScrollTrigger is killed on unmount
(`gsap.context()` / `useGSAP` + revert). Leaked ScrollTriggers are the top cause of scroll bugs.

### COMPONENT USAGE RULE

**Claude must NOT build every UI element from scratch.**

Before creating any complex interactive component, **search** — in this order:

1. **Existing project components** — it may already be built. A second implementation is a bug.
2. **shadcn** — primitives and accessible behaviour (dialog, select, combobox, form, table).
3. **21st** — composed blocks, themes, templates.
4. **React Bits** — animated and interaction-led components.
5. **Aceternity** — secondary; only if 1–4 genuinely lack an equivalent, and say which you looked for.
6. **Custom implementation** — only with the hierarchy walk documented.

Then decide explicitly: **reuse / adapt / compose / custom build.**

**All components must conform to the existing design system.** External components arrive with
placeholder styling: strip hardcoded colours, radii, shadows and sizes, and re-theme to the
project's tokens. Preserve the underlying accessibility wiring while restyling. A reviewer should
not be able to tell which components came from a registry.

See `component-discovery` and `interactive-components` for the full workflow.

---

## IMAGE & VISUAL CONTENT CONSTITUTION

**Every major landing page must consciously decide whether visual content is required** — section
by section, written down, before implementation. The decision may be "no". The decision may not
be "we didn't think about it".

**Do not leave websites visually empty by default.** A wall of well-set type with no visual
anchor is as much a failure of art direction as a page of stock photos. Both are the result of
not deciding.

**Equally: do not force images into sections where they do not improve communication.** An image
that exists to break up text is filler; whitespace breaks up text.

### Per-section defaults

These are starting positions, not obligations. Each is overridden by the brief.

| Section | Default |
|---|---|
| **Hero** | A high-quality visual or generated artwork, unless the brand is deliberately type-led. This is where the best asset goes. |
| **About** | Contextual photography or editorial imagery **where appropriate** — real place, real people, real process. Generic office photography is worse than nothing. |
| **Services** | Visual storytelling **where beneficial**. Often better served by a diagram or an SVG system than by photography. |
| **Portfolio / Work** | **Real work imagery.** Never stock, never generated. This section is evidence; fabricating it is dishonest. |
| **Testimonials** | **Real portraits only** when available and the person has agreed. Otherwise no portrait — a name and role is fine. **Never generate a face for a testimonial.** |
| **CTA** | A supporting visual **only when it strengthens conversion**. Usually it doesn't; usually it competes with the button. |
| **Pricing / comparison / FAQ / spec** | Default NO. These are decision surfaces; imagery slows them. |

### IMAGE USAGE RULE

When building a website, ask internally for every section:

> **"Would this section communicate better with a visual?"**

If **no** — say why in the plan, and let typography, space and layout do the work.

If **yes**, run this sequence:

1. **Search Pinterest for references** if connected — `pinterest-art-direction`. Analyse the
   visual direction: typography, composition, palette, photography direction. If Pinterest isn't
   connected, use client assets, supplied reference URLs, or `ui-ux-pro-max --domain style`.
2. **Analyse the visual direction** and state the through-line in one sentence. Convert it into
   *your own* direction — never copy a reference.
3. **Search licensed image sources** — `image-sourcing` via the `imagebank` MCP. Compare at least
   five candidates against the spec; pick on composition and focal point, not prettiness.
4. **If no suitable image exists, generate with Gemini** — `image-generation` via the
   `nanobanana` MCP. Prefer an original generated asset over a licensed photo that is about
   nothing.
5. **Optimise** — WebP, sized to 2× the largest rendered width, via `download_image` or
   `optimize_local_image`.
6. **Integrate using `next/image`** — explicit `width`/`height`, accurate `sizes`, `priority` on
   the LCP image only, meaningful `alt`.
7. **Add the responsive crop** — `object-position` at the focal point, or art-directed
   `<picture>` sources. Verify at 375 / 768 / 1024 / 1440 with a real screenshot.
8. **Add subtle motion if appropriate** — image reveal or parallax from the pattern table, within
   the motion budget, with a reduced-motion path.

### Non-negotiables

- **Licensing is tracked.** Every sourced or generated image is recorded in
  `public/images/image-sources.json` with source, licence, attribution requirement and where it's
  used. Unsplash attribution appears **on the site**, not only in the file.
- **Self-host. Do not hotlink** unless a licence requires serving from the provider's CDN — and
  then write down why.
- **Never download Pinterest images into a site.** Pinterest is reference only.
- **Never generate imagery presented as documentary evidence** — real people, real testimonials,
  real product photography, real completed work.
- **No placeholders.** A "swap this later" image never gets swapped. Ship the real asset or ship
  no image.
- **Alt text describes meaning**, or is `alt=""` for genuinely decorative imagery.
- The banned aesthetics in §25 apply to imagery in full: no gradient-mesh heroes, no floating
  glass shapes, no laughing-team-at-laptop, no abstract 3D blobs.

---

## Operating notes

- `ui-ux-pro-max` search:
  ```bash
  python3 <skills-root>/ui-ux-pro-max/scripts/search.py "<query>" --domain style|color|typography|ux|landing|gsap|web-vitals
  python3 <skills-root>/ui-ux-pro-max/scripts/search.py "<product> <industry>" --design-system -p "Project"
  ```
  `<skills-root>` is `skills/` when this stack is installed as a plugin, or
  `.claude/skills/` when installed into a project by `scripts/install.sh --into`.
- Standalone multi-viewport audit: `npm run audit -- --url http://localhost:3000`
- Let `ui-ux-pro-max` set **tokens**; let `frontend-design` set **attitude**. Data for
  correctness, taste for distinctiveness.
- Blocker/High findings gate completion. Medium/Nit do not — keep momentum.
- **Visual intelligence layer:** `visual-art-direction` decides, `image-sourcing` and
  `image-generation` execute, `pinterest-art-direction` supplies references. Decide before you
  execute — searching or generating first and rationalising after is how stock pages happen.
- **Component layer:** `component-discovery` for structural/functional components,
  `interactive-components` for motion and interaction (and it owns the selection hierarchy).
  React Bits and Aceternity need **no extra MCP** — register them as shadcn registry namespaces
  in the consuming project's `components.json`.
- **API keys** live in `.env` (git-ignored) — never in `.mcp.json`, a skill, or a commit. Copy
  `.env.example` and fill in only what you need; every server degrades gracefully when its key is
  absent. See `docs/INSTALL.md`.
- See `docs/STACK.md` (why each tool), `docs/SETUP.md` and `docs/INSTALL.md` (install),
  `docs/WORKFLOW.md` (worked example), `docs/GAP-REPORT.md` (what this upgrade added and why).
