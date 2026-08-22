---
name: interactive-components
description: Search component libraries before reinventing complex interaction patterns — animated text, cursor effects, scroll effects, galleries, interactive cards, animated backgrounds, navigation interactions and visual transitions. Owns the component selection hierarchy (project → shadcn → 21st → React Bits → Aceternity → custom) and the React Bits / Aceternity shadcn-registry setup. Use before hand-building any non-trivial animation or interaction, when a design calls for scroll choreography, hover effects, magnetic buttons, text reveals or animated backgrounds, and when deciding whether to reuse, adapt, compose or custom-build.
---

# Interactive Components

Complex interaction patterns are **solved problems with hard edge cases** — pointer capture,
reduced-motion, cleanup on unmount, touch fallbacks, SSR hydration, `will-change` thrash. Building
one from scratch means re-discovering all of them.

**Search the libraries first. Every time.**

Then apply the constitution: the pattern must earn its place (CLAUDE.md INTERACTION & MOTION
CONSTITUTION), and it must wear the project's tokens, not the library's.

---

## THE COMPONENT SELECTION HIERARCHY

Walk it **in order**. Stop at the first level that genuinely fits. Document which level you
stopped at and why — "I checked 1–3, none fit" is the justification for level 6.

| # | Level | Use for | Stop here when |
|---|---|---|---|
| **1** | **Existing project component** | Anything already built in this repo | It exists. Extend it. A second implementation of the same pattern is a bug |
| **2** | **shadcn** | Primitives, accessible behaviour: dialog, select, combobox, popover, form, table, tabs, tooltip | The need is structural/functional. Radix accessibility is worth more than any effect |
| **3** | **21st** | Broader catalogue: composed blocks, themes, templates, marketing sections | You need a composed block, not a primitive |
| **4** | **React Bits** | Animated & interaction-led: text animation, cursor effects, scroll effects, galleries, interactive cards, animated backgrounds, nav interactions, transitions | The requirement is *motion or interaction*, not structure |
| **5** | **Aceternity** *(secondary, only if justified)* | Premium cards, spotlight effects, hover effects, background effects, animated navigation, interactive hero elements | Levels 1–4 genuinely have no equivalent. **Write down which one you looked for and didn't find** |
| **6** | **Custom implementation** | Everything else | Nothing above fits, or every candidate needs more editing than writing it |

**Level 5 is a last resort before custom, not a parallel option.** Aceternity overlaps React Bits
heavily (spotlight cards, hover glow, animated backgrounds). Pulling the same effect from two
libraries is how a project ends up with two animation runtimes and inconsistent easing.
**Avoid duplicate components:** before adding from level 5, search level 4 for the same effect.

### The decision after selection

Having found a candidate, decide explicitly:

- **Reuse** — fits as-is after re-theming. Most common outcome.
- **Adapt** — take the source, strip what you don't need, rewrite the styling layer.
- **Compose** — combine two simple components rather than importing one complex one.
- **Custom build** — only with the hierarchy walk documented.

---

## Setup — React Bits and Aceternity need no MCP server

Both publish **shadcn-compatible registries**, so the `shadcn` MCP already installed reaches them.
This is deliberate: it avoids adding unmaintained MCP servers, keeps one search path, and lands
components as **owned source** that the design system re-themes.

Register the namespaces in the **consuming project's** `components.json`:

```json
{
  "registries": {
    "@react-bits": "https://reactbits.dev/r/{name}.json",
    "@aceternity": "https://ui.aceternity.com/registry/{name}.json"
  }
}
```

Then search and add through the shadcn MCP as usual:

```
search_items_in_registries(registries: ["@react-bits"], query: "text reveal")
view_items_in_registries(items: ["@react-bits/SplitText-TS-TW"])
get_add_command_for_items(items: ["@react-bits/SplitText-TS-TW"])
```

**React Bits naming:** every component ships four variants —
`{Component}-{TS|JS}-{TW|CSS}`. Pick the pair matching the project
(`SplitText-TS-TW` for a TypeScript + Tailwind project). ~166 components, ~664 registry items.

**Aceternity naming:** plain lowercase names — `@aceternity/spotlight`.

---

## What React Bits is for

| Category | Examples |
|---|---|
| **Text animation** | `SplitText`, `BlurText`, `DecryptedText`, `GlitchText`, `FallingText`, `CountUp`, `CircularText`, `GradientText` |
| **Cursor effects** | `BlobCursor`, `GhostCursor`, `Crosshair`, `ClickSpark`, `ImageTrail`, `CursorGrid` |
| **Scroll effects** | `AnimatedContent`, `FadeContent`, `GradualBlur`, `FlyingPosters`, `ScrollReveal`-type wrappers |
| **Galleries** | `CircularGallery`, `DomeGallery`, `AccordionGallery`, `DepthCarousel`, `ChromaGrid`, `Carousel` |
| **Interactive cards** | `CardSwap`, `DecayCard`, `BounceCards`, `GlareHover`, `ElectricBorder`, `BorderGlow` |
| **Backgrounds** | `Aurora`, `Beams`, `LightRays`, `DarkVeil`, `Dither`, `Galaxy`, `Iridescence`, `Grainient`, `LiquidChrome` |
| **Navigation** | `Dock`, `GooeyNav`, `FlowingMenu`, `BubbleMenu`, `CardNav`, `InfiniteMenu`, `LineSidebar` |
| **Transitions / motion** | `AnimatedList`, `ElasticSlider`, `Folder`, `Magnet`, `LogoLoop` |

---

## Guardrails — apply to every level 3–5 component

These are not optional. A registry effect dropped in unedited is exactly the "generic AI" failure
mode the constitution bans.

### Design tokens win

**Never let an external component override the project's design tokens.** Strip hardcoded hex,
`rounded-2xl`, `shadow-lg`, arbitrary sizes; map onto the project's colour, spacing, radius and
type scales. Full adaptation checklist in `component-discovery` §4.

### Budget the motion

Per the INTERACTION & MOTION CONSTITUTION: **never more than a few major motion systems on one
viewport simultaneously.** One shader background + a cursor effect + text scramble + magnetic
buttons + scroll parallax is not five features, it is one unusable page. Pick the one that
carries the idea; make the rest quiet.

### Reduced motion is not optional

Many of these components animate continuously. Every one you add must:

- honour `prefers-reduced-motion: reduce` with a **genuine** reduced path — the final state
  rendered immediately, not a stub and not a blank div;
- never hide content that fails to animate. If JS or WebGL fails, the content is still there.

### Weight and cleanup

- Shader/3D/canvas backgrounds (`Aurora`, `Galaxy`, `Ballpit`, `LiquidChrome`, `Balatro`) pull real
  runtime weight. **Dynamic-import them**, never in the main bundle, never blocking first paint.
  Cap DPR at 2, pause the loop when off-screen or the tab is hidden (CLAUDE.md §11, §14).
- Anything using GSAP/ScrollTrigger must clean up: `gsap.context()` / `useGSAP`, revert on
  unmount. Leaked ScrollTriggers are the top cause of scroll bugs (CLAUDE.md §9).
- Animate `transform` and `opacity` only. If a component animates `width`/`height`/`top`, fix it
  or drop it.

### Mobile is simpler by default

Cursor effects, magnetic hovers and heavy shader backgrounds have **no touch equivalent**. Disable
them below the pointer-fine breakpoint rather than shipping a dead interaction:

```css
@media (hover: none), (pointer: coarse) { /* static fallback */ }
```

Every hover affordance needs a tap path (CLAUDE.md §24).

### Accessibility survives the effect

Nav components (`Dock`, `GooeyNav`, `FlowingMenu`) must stay real `<nav>` + `<a>`, keyboard
operable, with visible `:focus-visible`. An effect that breaks tab order is a defect, not a
feature.

---

## After adding

Screenshot at 375 / 768 / 1024 / 1440, in light and dark, with reduced-motion on and off. Read
the console. An interaction you have not driven in a real browser is not finished (CLAUDE.md §23).
