---
name: component-discovery
description: Search component catalogues before building UI by hand — the 21st MCP for components, themes and templates, and the shadcn MCP for shadcn/ui plus registered namespaces. Covers searching, comparing candidates, choosing one, and adapting it to the project's design tokens rather than letting it import its own. Use when a design requirement calls for a non-trivial UI component, before hand-rolling any dialog, combobox, nav, pricing table, form pattern or layout block, and whenever picking between registry candidates.
---

# Component Discovery

The rule this skill exists to enforce: **search before you build.** A hand-rolled combobox is a
week of accessibility bugs that someone else already fixed.

The rule it exists to prevent: **shipping someone else's design.** A registry component arrives
with its own colours, radii, shadows and type scale. Those are *placeholders*. Re-theme to the
project's tokens or don't use it.

**Tools:**
- `21st` MCP — catalogue search across components, themes and templates; UI generation with
  variants; bookmarks and team libraries. HTTP endpoint, needs `TWENTY_FIRST_API_KEY`.
- `shadcn` MCP — `search_items_in_registries`, `list_items_in_registries`,
  `view_items_in_registries`, `get_item_examples_from_registries`,
  `get_add_command_for_items`, `get_project_registries`, `get_audit_checklist`.

---

## The workflow

```
DESIGN REQUIREMENT → SEARCH 21ST (and shadcn registries) → COMPARE CANDIDATES
                   → SELECT → ADAPT TO DESIGN SYSTEM → IMPLEMENT → AUDIT
```

### 1. DESIGN REQUIREMENT

Write the requirement **before** searching, in behavioural terms:

> "Pricing comparison, 3 tiers, monthly/annual toggle, one tier highlighted, must collapse to a
> stacked accordion at 375px, keyboard-operable toggle, values come from CMS."

Searching without this gets you whatever is pretty. Searching with it gets you whatever fits.

### 2. SEARCH

- **21st** — the broad catalogue. Search components, then themes, then templates. Templates are
  worth looking at even if you only take the *structure*.
- **shadcn** — `get_project_registries` first to see what namespaces the project has registered,
  then `search_items_in_registries` across them. Primitives live here.
- Search **2–3 phrasings**: the component name (`combobox`), the behaviour (`searchable select`),
  and the use case (`country picker`).

### 3. COMPARE CANDIDATES — do not install to evaluate

Use `view_items_in_registries` and `get_item_examples_from_registries` to read the source
**before** adding anything. Installing to look is how a project ends up with eleven unused
components and four conflicting animation libraries.

Score each candidate:

| Check | Reject if |
|---|---|
| **Behaviour fit** | It needs more editing than building it would take |
| **Accessibility** | No focus management, no ARIA wiring, div-soup instead of `<button>`/`<a>` |
| **Dependencies** | It pulls a second animation library, an icon set you don't use, or a state manager |
| **Token surface** | Colours/radii/shadows are hardcoded and scattered, not themeable |
| **Responsive** | Desktop-only; no real story at 375px |
| **Weight** | It ships a 3D or shader runtime for a hover effect |
| **Maintenance** | Unmaintained, or a fork of something better maintained |

**Do not blindly install every component.** Pick one. If two are close, pick the one with fewer
dependencies — you will be editing it anyway.

### 4. ADAPT TO THE DESIGN SYSTEM — mandatory

**External components must never override the project's design tokens.** This is the step that
gets skipped and it is the single biggest source of the generic-AI look (CLAUDE.md §19, §25).

On every component you add:

1. **Strip hardcoded values.** Replace hex colours, `rounded-2xl`, `shadow-lg`, arbitrary
   `text-[15px]` with semantic tokens: `bg-surface`, `text-muted`, `rounded-card`, `shadow-raised`.
2. **Re-scale.** The component's spacing came from someone else's scale. Map it onto the project's
   4px/8px scale — no leftover `p-[13px]`.
3. **Re-type.** Font sizes come from the project's modular scale, not the component's.
4. **Adopt the radius system.** Radius varies by element role in this stack; a registry component
   that is `rounded-2xl` everywhere must be re-mapped.
5. **Keep the accessibility wiring.** Restyle Radix/ARIA components; never strip their ARIA
   attributes, focus traps, or keyboard handlers to make styling easier.
6. **Delete what you don't use.** Unused variants, props and dead branches go now, not later.
7. **Keep customisations in the component file**, themed via tokens — not overridden at every
   call site.

The acceptance test: **a reviewer looking at the page cannot tell which components came from a
registry.** If shadcn's or 21st's default look is still visible, the adaptation isn't done.

### 5. IMPLEMENT

- Use `get_add_command_for_items` for the correct install command — don't hand-write paths.
- Shared primitives land in `components/ui`. Feature components live with their feature.
- Composition over configuration: if adapting means adding four boolean props, wrap it instead.

### 6. AUDIT

- `get_audit_checklist` (shadcn MCP) after adding components.
- Then the normal gates: keyboard operability, focus-visible, contrast at both themes, and a real
  browser screenshot at 375 / 768 / 1024 / 1440 (CLAUDE.md §22, §23).

---

## 21st authentication

The `.mcp.json` entry is an HTTP server with a header expansion — no literal key in the repo:

```json
"21st": {
  "type": "http",
  "url": "https://21st.dev/api/mcp",
  "headers": { "x-api-key": "${TWENTY_FIRST_API_KEY:-}" }
}
```

- Generate a key at **https://21st.dev/mcp**, put it in `.env` as `TWENTY_FIRST_API_KEY`.
- **Old "Magic" keys were reset upstream and no longer work anywhere.** The
  `@21st-dev/magic` npm package is now only a deprecated compatibility proxy — this stack does
  not use it.
- `npx @21st-dev/cli@latest init --client claude` is the alternative interactive setup; it writes
  the same server entry into your Claude config. Use it if you'd rather not manage the env var.
- Unauthenticated calls return
  `-32001 Not authenticated - your API key is missing or was reset`. That is the expected state
  until a key is set — the rest of the stack is unaffected.

---

## Where this sits

This skill covers **structural and functional** components — dialogs, selects, navs, tables,
pricing blocks, forms, layout patterns.

For **animated and interaction-led** components — cursor effects, scroll effects, text animation,
galleries, backgrounds, transitions — use `interactive-components`, which owns the full selection
hierarchy across shadcn, 21st, React Bits and Aceternity.
