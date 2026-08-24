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
| **Components** | `shadcn` MCP (shadcn + React Bits + Aceternity + 21st.dev registries) | Add primitives instead of hand-rolling them. |
| **Imagery** | `image-sourcing` skill, `imagegen-frontend-web` / `image-to-code` | Real photography vs generated. Licence, crop, weight. |
| **Motion** | `interaction-patterns` skill + GSAP / Lenis | Signature interactions with a fallback for every one. |
| **Review** | `design-review` agent, `code-review`, `claude-security` | Gate before done. |

---

## THE WORKFLOW

Every website task runs this sequence. Do not skip stages. Do not reorder them.

```
RESEARCH → INFORMATION ARCHITECTURE → DESIGN SYSTEM → VISUAL DIRECTION →
IMAGE STRATEGY → COMPONENT STRATEGY → IMPLEMENTATION → RESPONSIVE → ANIMATION →
ACCESSIBILITY → PERFORMANCE → BROWSER QA → VISUAL CRITIQUE → POLISH →
CODE REVIEW → SECURITY REVIEW → FINAL BUILD
```

| # | Stage | Do this | Primary tool |
|---|---|---|---|
| 1 | **RESEARCH** | Understand audience, competitors, references, constraints. Never design blind. | `/shape` |
| 2 | **INFORMATION ARCHITECTURE** | Page inventory, nav model, content hierarchy, conversion path. Structure before pixels. | `/shape`, `ui-ux-pro-max --domain landing` |
| 3 | **DESIGN SYSTEM** | Generate concrete tokens: color, type, spacing, radius, elevation. This is the source of truth. | `/design-plan`, `ui-ux-pro-max --design-system` |
| 4 | **VISUAL DIRECTION** | Commit to ONE tone. Pick the signature element. Reject defaults explicitly. | `frontend-design`, `/high-end-visual-design` |
| 5 | **IMAGE STRATEGY** | Decide photo vs generated per slot. Source, licence, crop, budget. Never invent URLs. | `/image-sourcing`, `imagegen-frontend-web` |
| 6 | **COMPONENT STRATEGY** | Choose sources before building. Evaluate a11y, mobile, weight. Don't hand-roll primitives. | `/component-discovery`, `shadcn` MCP |
| 7 | **IMPLEMENTATION** | Build with the tokens. Components via shadcn MCP. | `shadcn` MCP |
| 8 | **RESPONSIVE** | Verify 375 / 768 / 1024 / 1440. Content reflows, never shrinks. | `/adapt` |
| 9 | **ANIMATION** | Only motion that carries meaning. Respect reduced-motion. | `/animate`, `/interaction-patterns` |
| 10 | **ACCESSIBILITY** | WCAG 2.1 AA floor. Keyboard, contrast, semantics, focus. | `/audit` |
| 11 | **PERFORMANCE** | Core Web Vitals budgets. Images, fonts, bundle. | `/optimize`, Lighthouse via chrome-devtools MCP |
| 12 | **BROWSER QA** | Open the real page. Screenshot. Exercise states. Read the console. | `playwright` MCP |
| 13 | **VISUAL CRITIQUE** | Ranked findings across viewports. | `/design-review`, `/critique` |
| 14 | **POLISH** | Alignment, optical spacing, micro-detail. | `/polish` |
| 15 | **CODE REVIEW** | Correctness, conventions, over-engineering. | `/code-review`, `/ponytail-review` |
| 16 | **SECURITY REVIEW** | Injection, XSS, secrets, SSRF, dependency risk. | `claude-security` |
| 17 | **FINAL BUILD** | Typecheck, lint, build, re-verify. Green or not done. | build scripts |

**Hard gate:** stages 12 and 13 are mandatory. *A UI change you have not looked at in a browser
is not finished.* Blocker/High findings must be fixed before you report done.

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
- Image weight budgets: hero ≤ 200KB, inline ≤ 120KB, thumbnail ≤ 40KB after compression.
  Ship a `srcset` ladder with a `sizes` that matches the real layout — a 2560px file in a
  400px slot is the most common failure on image-rich pages. See `image-sourcing`.
- No autoplaying background video above ~2MB, and never as the LCP element. Poster frame
  always; `preload="none"` below the fold; drop it entirely on save-data or reduced motion.
- Minimise animation work: `transform`/`opacity` only, `will-change` sparingly and
  temporarily. No permanent `requestAnimationFrame` — tie loops to IntersectionObserver and
  `document.visibilityState`, and kill them on unmount. See `interaction-patterns`.
- No Three.js/R3F for effects CSS or 2D canvas can carry (gradients, parallax, particles).
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
- The same MCP fronts **React Bits**, **Aceternity UI** and **21st.dev** via the `registries`
  block in the project's `components.json` (template: `templates/components.json`). Prefer
  one client over a redundant MCP server per vendor. Semantics from shadcn/Radix, visual
  character from the others. Evaluate before installing — see `component-discovery`.
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
- ❌ Generic stock imagery and meaningless abstract 3D blobs — handshakes, headset smiles,
  team huddles, glowing circuit boards. See `image-sourcing` for the full smell test.
- ❌ Placeholder image services (`picsum.photos`, `placehold.co`) in a delivered build, and
  invented image URLs anywhere. Every URL traces to a real API response or repo asset.
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
- See `docs/STACK.md` (why each tool), `docs/SETUP.md` (install), `docs/WORKFLOW.md` (worked
  example).
