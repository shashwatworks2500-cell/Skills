---
name: component-discovery
description: Find, evaluate and choose UI components across the existing codebase, shadcn/ui, React Bits, Aceternity UI and 21st.dev instead of hand-rolling or blindly installing them. Use when a feature needs a dialog, carousel, table, combobox, animated hero, marquee, card effect, or any non-trivial interactive primitive.
version: 1.0.0
user-invocable: true
argument-hint: "[component or interaction needed]"
---

Pick the right component from the right source. Hand-rolling a combobox is a bug factory;
installing an 80KB animated hero for a static banner is debt.

## Preference order

Walk it top-down and stop at the first source that genuinely satisfies the requirement.

1. **What the codebase already has.** Grep before anything else. A near-match you extend beats a
   new dependency every time, and it stays consistent by construction.
2. **shadcn/ui** — accessible Radix-backed primitives you own as source. Default for anything
   with real interaction semantics: dialog, select, combobox, popover, tabs, accordion,
   dropdown, form, table, toast, carousel.
3. **React Bits** — animated/visual React components (text effects, backgrounds, cursor
   effects). Reach here for *motion character*, not for interaction semantics.
4. **Aceternity UI** — high-production marketing/landing effects (spotlight cards, beams,
   3D-ish hovers, scroll reveals). Strong visual payoff, heavier and more opinionated.
5. **21st.dev** — generated/community React components. Last resort: widest variance in
   quality and accessibility, so it carries the highest review burden.

**Semantics from shadcn, character from the rest.** The reliable pattern for a premium build is
a shadcn primitive (correct focus management, ARIA, keyboard) restyled to the design system and
wrapped in motion borrowed from React Bits or Aceternity. Do not take an inaccessible animated
dropdown from a visual library when a Radix one exists.

## Evaluate before you install

Score every candidate on all eight. A failure on **accessibility** or **mobile** is
disqualifying regardless of how good it looks.

| # | Criterion | Reject when |
|---|---|---|
| 1 | **Visual quality** | Generic defaults; can't be re-themed to your tokens |
| 2 | **Interaction quality** | Janky, no hover/focus/active states, wrong easing |
| 3 | **Accessibility** | No keyboard path, missing ARIA, focus trap broken, `outline:none` with no replacement |
| 4 | **Mobile behaviour** | Hover-only affordance, touch targets < 44px, no `pointer: coarse` path |
| 5 | **Performance** | Permanent `requestAnimationFrame`, layout-property animation, heavy blur on scroll |
| 6 | **Dependency weight** | Pulls Three.js/R3F, a physics engine, or a second animation runtime for a small effect |
| 7 | **Stack compatibility** | Client-only where you need RSC; wrong Tailwind major; conflicting React version |
| 8 | **Design-system consistency** | Hardcoded hex/radii/shadows that ignore your tokens |

**Read the source before installing.** These registries deliver code you own — that is the
point, and it means you inherit every defect. Check the actual component for: `outline: none`,
`div` used as a button, `useEffect` scroll listeners without cleanup, `window` accessed during
render, and animation on `width`/`top`/`left`.

**The dependency-weight test.** Ask what the effect costs at runtime. A spotlight hover is a
CSS radial gradient following two CSS custom properties — it does not need WebGL. Per the
constitution, reach for Three.js/R3F only when the brief genuinely calls for 3D, and never for
a gradient, a parallax layer, or a particle field that CSS or a 2D canvas can carry.

## Registry configuration

Use the **shadcn MCP** as the single client for all four registries rather than adding a
redundant MCP server per vendor. Registries are declared in the consuming project's
`components.json`:

```jsonc
{
  "$schema": "https://ui.shadcn.com/schema.json",
  "style": "new-york",
  "tailwind": { "css": "app/globals.css", "baseColor": "neutral", "cssVariables": true },
  "aliases": { "components": "@/components", "ui": "@/components/ui", "utils": "@/lib/utils" },
  "registries": {
    "@react-bits":  "https://reactbits.dev/r/{name}.json",
    "@aceternity":  "https://ui.aceternity.com/registry/{name}.json",
    "@21st": {
      "url": "https://21st.dev/r/{name}.json",
      "headers": { "Authorization": "Bearer ${TWENTY_FIRST_API_KEY}" }
    }
  }
}
```

`@shadcn` is built in and needs no entry. A copy of this lives at
`templates/components.json` in this repo — copy it into the project you are building, not into
the stack repo itself.

**Credentials come from the environment.** 21st.dev needs `TWENTY_FIRST_API_KEY` exported in
the shell; `${VAR}` in `components.json` is expanded by the shadcn CLI. Never paste a key into
the file, and never commit one.

**Verify each registry on first use in a new environment** — vendors move these paths, and a
restricted network blocks them outright:

```bash
npx shadcn@latest view @react-bits    # lists items if the registry resolves
curl -sS -o /dev/null -w '%{http_code}\n' --max-time 20 https://ui.shadcn.com/r/registry.json
```

`HTTP 000` means the host is unreachable (network policy or DNS), not that the URL is wrong.
If a registry is unreachable, fall back down the preference order — build on shadcn primitives
you already have and write the motion by hand — rather than blocking the work.

## Once installed

- **Re-theme immediately.** Default shadcn styling shipped as the final look is a primary
  source of generic-AI appearance. Map every colour, radius, and shadow onto your tokens in the
  component file, not at each call site.
- **Preserve the accessibility wiring.** Restyle freely; never strip ARIA attributes, focus
  management, or Radix behaviour while doing it.
- **Delete what you did not use.** Registries often install siblings and helpers.
- **Add the reduced-motion path.** Most animated registry components ship without one. See
  `interaction-patterns`.
- **Re-verify in a browser** at 375 / 768 / 1024 / 1440, keyboard-only, in both themes.

## Do not

- Install a component before grepping the codebase for one that already exists.
- Take a component you have not read.
- Add a second animation runtime because one component wanted it.
- Ship default registry styling as the finished design.
- Use a visual-library dropdown/dialog/tooltip when a Radix-backed one exists.
