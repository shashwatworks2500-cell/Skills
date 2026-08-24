---
name: interaction-patterns
description: Implement premium web interactions — magnetic buttons, image reveals, text reveals, scroll-triggered and pinned sections, parallax, horizontal scroll, cursor effects, marquees, counters, spotlight and clip-path transitions — each with a stated purpose, performance budget, touch fallback and reduced-motion path. Use when building signature interaction moments, adding GSAP or Lenis, or when motion feels decorative, janky, or broken on mobile.
version: 1.0.0
user-invocable: true
argument-hint: "[interaction or section]"
---

The catalogue of interactions that separate a premium site from a template — and the four
things every one of them must satisfy before it ships.

`animate` decides *whether and where* motion belongs. This skill is the implementation layer:
concrete recipes, costs, and fallbacks. Read `animate` first for strategy.

## The four-part contract

No interaction ships without all four. Write them down before you write the code.

1. **Purpose** — what it communicates: state change, spatial relationship, causality, or
   continuity. "It looks cool" is not a purpose. Decoration is debt.
2. **Performance** — animate `transform` and `opacity` only. No layout properties. No permanent
   `requestAnimationFrame`. Budget the cost on a mid-tier phone, not your laptop.
3. **Touch fallback** — every hover/cursor interaction needs a tap or scroll path. Gate with
   `@media (hover: hover) and (pointer: fine)`; never assume a mouse.
4. **Reduced motion** — a genuine reduced path, not a stub, and never one that hides content.

```css
@media (prefers-reduced-motion: reduce) {
  *, *::before, *::after {
    animation-duration: .01ms !important;
    animation-iteration-count: 1 !important;
    transition-duration: .01ms !important;
    scroll-behavior: auto !important;
  }
}
```

```js
const reduced = window.matchMedia('(prefers-reduced-motion: reduce)').matches;
const fine    = window.matchMedia('(hover: hover) and (pointer: fine)').matches;
```

**Content must never depend on motion.** If JS fails or motion is reduced, everything is
visible and readable. Never author `opacity: 0` in CSS and rely on a tween to reveal it — set
the start state from JS, so a JS failure leaves content on screen.

## Choosing a tool

| Need | Use |
|---|---|
| Hover, focus, state, simple entrance | **CSS transitions** — always try first |
| One-off element entrance on scroll | **IntersectionObserver** + a CSS class |
| Sequenced timelines, scrub, pin, complex orchestration | **GSAP** + ScrollTrigger |
| Normalised smooth scroll (opt-in, justified) | **Lenis** |
| 3D that the brief genuinely requires | Three.js / R3F — see constitution §11 |

CSS first, always. Reach for GSAP when CSS genuinely cannot express the sequence — not by
default.

### GSAP hygiene

Register plugins once, centrally. Import only what you use. **Always clean up** — leaked
ScrollTriggers are the top cause of scroll and memory bugs.

```js
// React
useGSAP(() => {
  const mm = gsap.matchMedia();
  mm.add(
    { desktop: '(min-width:768px) and (prefers-reduced-motion: no-preference)',
      reduced: '(prefers-reduced-motion: reduce)' },
    (ctx) => {
      const { desktop } = ctx.conditions;
      if (!desktop) return;                    // reduced → no tween, content already visible
      gsap.from('.reveal', {
        y: 24, opacity: 0, duration: .6, ease: 'power2.out', stagger: .08,
        scrollTrigger: { trigger: '.reveal', start: 'top 85%' },
      });
    },
  );
  return () => mm.revert();
}, { scope: container });
```

`gsap.matchMedia()` is the correct place to branch on breakpoint *and* reduced motion — it
reverts cleanly when the query stops matching.

### Lenis rules

Smooth scroll is **opt-in and justified**, never a default — it can feel wrong on trackpads and
harm accessibility. If used: one instance; drive it from the GSAP ticker (never two competing
RAF loops); **disable entirely** under reduced motion; destroy on route change/unmount; and
never break anchor links, find-in-page, or keyboard scrolling.

```js
if (reduced) return;                       // no Lenis at all
const lenis = new Lenis();
lenis.on('scroll', ScrollTrigger.update);
gsap.ticker.add((t) => lenis.raf(t * 1000));
gsap.ticker.lagSmoothing(0);
// cleanup: gsap.ticker.remove(raf); lenis.destroy();
```

## The catalogue

Each entry: what it is for → the cost → the fallback.

### Pointer-driven (all require a touch path)

- **Magnetic button** — pulls toward the cursor within a radius. Signals "this is the primary
  action". Translate on `transform` from `pointermove`, reset on leave; cap displacement ~8px.
  *Touch/coarse:* skip entirely — a normal `:active` press state. *Reduced:* skip.
- **Hover transformation** — card lifts, image scales, content swaps. Communicates
  affordance. Use `transform: scale()` + `translateY`, 150–250ms, ease-out. *Touch:* the whole
  card is a link; give it a visible `:active`. Never hide content behind hover.
- **Cursor interaction** — custom cursor, follower, or context label ("drag", "view"). Reserve
  for one signature moment. Cost: a RAF loop — kill it on unmount and when off-screen.
  *Touch/coarse:* never render it; keep the native cursor and real affordances.
- **Spotlight effect** — radial highlight tracking the pointer across a card or grid. A CSS
  radial-gradient driven by two custom properties (`--x`, `--y`) — **no WebGL**.
  *Touch:* static gradient or none.
- **Interactive card** — tilt/glow/border-trace on hover. Cap tilt ≤ 8°; more reads as a toy.
  *Touch:* flat card, tap navigates.

### Reveal and text

- **Text reveal** — lines or words rise behind a mask as they enter. Directs reading order and
  paces a headline. Split by **line** (not character) for anything longer than a few words —
  per-character on a paragraph is a performance and screen-reader problem. Keep the original
  text in the DOM; ensure the accessible name is unchanged. *Reduced:* render final state.
- **Image reveal** — a mask or clip wipes the image in. Frames the subject and paces the
  section. Animate `clip-path` (composited) with `transform`; never animate `width`/`height`.
  *Reduced:* image simply present.
- **Clip-path transition** — shape morph between states or sections. Use sparingly; it is a
  signature move, not a default. Keep point counts equal between shapes.
- **Staggered entrance** — grid/list items appear in sequence. Shows grouping and order.
  Stagger 40–80ms, total ≤ 600ms; cap the number of staggered items (~12) then reveal the rest
  as a block. **Never stagger a whole page** — that is the AI-slop signature.
- **Image mask** — text or shape masking imagery. Verify legibility and contrast over every
  underlying region; provide a solid-background fallback.

### Scroll-driven

- **Scroll-triggered animation** — element animates as it enters. Rewards scrolling and paces
  density. `start: 'top 85%'`, play once (`once: true`) unless repetition carries meaning.
  *Reduced:* content visible, no tween.
- **Parallax** — layers move at different rates for depth. Use `scrub` and keep the delta small
  (≤ 15% of viewport height); large offsets cause overlap bugs and motion sickness. Transform
  only. *Reduced:* static layers. *Mobile:* usually disable — it costs more than it gives.
- **Pinned section** — a section holds while content advances through it. For genuinely
  sequential content (a process, a comparison). **Avoid pinning long sections on mobile** — it
  traps the user and fights native scrolling. Always give an escape and a real scrollbar.
- **Horizontal scroll section** — vertical scroll drives horizontal travel. Only for content
  that is genuinely a sequence (a gallery, a timeline). Must be keyboard-navigable and must not
  trap focus. *Mobile:* native horizontal swipe with snap points instead of pinning.
- **Progress indicator** — reading or section progress. Genuinely useful on long-form. Drive
  from `scrollYProgress`; a `transform: scaleX()` bar, `aria-hidden` if purely decorative.
- **Counter** — numbers count up when in view. Only for figures where the *change* is the
  point. Trigger once. *Reduced:* render the final number immediately — never leave it at zero.

### Navigation and continuity

- **Animated navigation** — sticky header condensing, menu open/close, active-item transitions.
  Communicates position. Fixed headers must not cover focused inputs or eat scroll anchors.
  Menus need focus trapping, `Esc` to close, and focus restoration.
- **Page transition** — continuity between routes. Must never delay content or block
  interaction; keep under ~300ms. Announce route changes to screen readers (a live region or
  focus move to `<h1>`). *Reduced:* instant swap.
- **Accordion / tabs** — progressive disclosure. Use the shadcn/Radix primitives; do not
  hand-roll. Animate height via `grid-template-rows: 0fr → 1fr` or Radix's CSS variables.
  Keyboard and ARIA come free — do not strip them.
- **Carousel** — sequential browsing where all items are peers. Needs keyboard arrows, visible
  focus, pause-on-hover/focus for autoplay, and swipe on touch. Prefer a real scroll container
  with CSS scroll-snap over a JS transform carousel — it is lighter and accessible by default.
- **Marquee** — continuous ticker for logos or short phrases. The one legitimate use of a
  linear ease and an infinite loop. Duplicate content and translate; pause on hover **and**
  focus. Mark the duplicate `aria-hidden="true"` so screen readers hear it once.
  *Reduced:* stop it — a static row, or a normal scroll container.

## Performance rules for motion

- `transform` and `opacity` only. Animating `width`, `height`, `top`, `left`, `margin`, or
  `box-shadow` causes layout/paint every frame.
- `will-change` sparingly and temporarily — permanently on many elements exhausts GPU memory.
- No permanent RAF loop. Tie loops to visibility (IntersectionObserver) and to
  `document.visibilityState`; stop when off-screen or hidden.
- Kill scroll listeners, observers, tweens, ScrollTriggers, and Lenis on unmount.
- Dynamic-import GSAP, Lenis, and any 3D so they never block first paint.
- Throttle pointer handlers to one RAF tick; never do layout reads inside them (`getBoundingClientRect`
  in `pointermove` is a forced reflow — cache it on resize).
- Verify with a Performance trace via the chrome-devtools MCP. Dropped frames are a finding.

## Before you ship any interaction

- [ ] Purpose stated in one sentence
- [ ] `transform`/`opacity` only; no layout animation
- [ ] Works and looks right on touch — no hover-only affordance
- [ ] Touch targets ≥ 44px; no accidental scroll trapping
- [ ] Genuine `prefers-reduced-motion` path; content never hidden by it
- [ ] Keyboard operable; focus visible; focus order sane; no trap
- [ ] Screen-reader sane — duplicated marquee content hidden, live regions where needed
- [ ] All tweens/observers/loops cleaned up on unmount
- [ ] Content visible if JS never runs
- [ ] Traced in the browser at 375 / 768 / 1024 / 1440 with no dropped frames
