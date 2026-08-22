# Gap Report — Visual Intelligence & Interactive Web Upgrade

**Date:** 2026-08-22
**Branch:** `claude/repo-skills-analysis-ebw9cm`
**Method:** Full filesystem audit of the repository, plus live probes of every candidate
package/registry/repository. Nothing was installed before this audit completed.

---

## 1. What already exists (verified present — do NOT reinstall)

### Skills — 39, all under `skills/`

| Cluster | Skills |
|---|---|
| Knowledge engine | `ui-ux-pro-max` (88 styles, 192 palettes/reasoning profiles, 74 font pairings, 1934 Google Fonts, 105 curated + 1512 Phosphor icons, 119 UX guidelines, **17 GSAP motion presets**, 25 chart types, 22 stacks / 1260 stack guidelines) |
| Process | `web-design-constitution`, `shape`, `design-system`, `adapt`, `animate`, `audit`, `optimize`, `critique`, `polish`, `harden` |
| Taste / art direction | `high-end-visual-design`, `emil-design-eng`, `gpt-taste`, `design-taste-frontend`, `stitch-design-taste`, `website`, `redesign-existing-projects` |
| Tone dials | `bolder`, `quieter`, `colorize`, `distill`, `delight`, `overdrive`, `layout`, `typeset`, `clarify` |
| Locked visual languages | `cosmic-glass-dashboard`, `industrial-brutalist-ui`, `minimalist-ui` |
| Brand & asset direction | `design`, `brand`, `brandkit`, `banner-design`, `slides`, `imagegen-frontend-web`, `imagegen-frontend-mobile`, `image-to-code` |
| Implementation | `ui-styling`, `full-output-enforcement` |

### MCP servers — 3, in `.mcp.json`
`playwright`, `chrome-devtools`, `shadcn` — all npx-resolved, all confirmed live in-session.

### Commands — 2
`/design-plan`, `/design-review`

### Agents — 1
`design-review` (Playwright + chrome-devtools, WCAG 2.1 AA, ranked Blocker→Nit findings)

### Workflows
`CLAUDE.md` — 25 numbered rule sections + a mandatory **15-stage workflow**.

### Animation coverage — STRONG, already present
- `CLAUDE.md` §8 Animation, **§9 GSAP rules** (cleanup, `gsap.context()`, ScrollTrigger leaks), **§10 Lenis rules** (single instance, ticker integration, reduced-motion disable, destroy on unmount), §11 Three.js/R3F.
- `skills/animate`, `skills/overdrive`, `skills/delight`, `skills/gpt-taste` (GSAP ScrollTrigger choreography).
- `ui-ux-pro-max/data/motion.csv` — 17 presets with real GSAP snippets, easings, durations, reduced-motion notes, performance notes.
**→ No animation *rules* gap. The gap is named, reusable interaction *patterns* and a component source.**

### Image coverage — DIRECTION ONLY, no execution
`imagegen-frontend-web`, `imagegen-frontend-mobile`, `brandkit`, `banner-design`, `image-to-code` all
write **prompts and art direction**. None of them can search, download, generate, optimize, or
attribute a real image file. `skills/design` and `skills/banner-design` *mention* Gemini but no
generation tool is wired.
**→ Real gap.**

### Component libraries
`shadcn` MCP only. No animated/interaction component source.
**→ Real gap.**

---

## 2. Gaps confirmed

| # | Gap | Evidence |
|---|---|---|
| G1 | **No art-direction decision layer.** Nothing decides *whether* a section needs a visual, what type, focal point, crop, or responsive behaviour. Image skills assume the answer is already "yes, generate a comp." | No skill contains a need-image decision framework |
| G2 | **No real image sourcing.** Cannot search or download licensed stock; no attribution/licence tracking. | No image-search MCP; no `image-sources.json` convention |
| G3 | **No image generation execution.** | No Gemini/OpenAI image MCP in `.mcp.json` |
| G4 | **No visual-reference research.** No Pinterest or moodboard input to art direction. | No Pinterest MCP |
| G5 | **No interactive component source.** shadcn covers primitives (dialog, select, form) but has no animated text, cursor, scroll, gallery, or background effects. | `.mcp.json` lists shadcn only |
| G6 | **No component-selection hierarchy.** Nothing tells Claude to search before hand-rolling a complex interaction. | Absent from `CLAUDE.md` §15/§19 |
| G7 | **Motion patterns are presets, not named page-level choreography.** No "hero reveal", "magnetic CTA", "horizontal scroll section" vocabulary. | `motion.csv` is component-level |

---

## 3. Candidate evaluation — live probe results

| Candidate | Probe result | Decision |
|---|---|---|
| `imagebank-mcp` (romuloquintanilha/imagebank-mcp) | **npm `imagebank-mcp@1.0.0`, MIT.** Launched via npx: `[imagebank-mcp] running. Providers configured: NONE (set API keys)` | ✅ **INSTALL** — npx-resolvable, portable |
| `guinacio/claude-image-gen` | Repo exists (MIT). **Not published to npm** (`claude-image-gen` and `@guinacio/claude-image-gen` both 404). Requires `/plugin install` or a git clone + `npm build`, then an absolute path to `mcp-server/build/bundle.js` | ❌ **NOT INSTALLED** — cannot be expressed as a portable project `.mcp.json` entry. Documented as an optional user-scope alternative |
| `tygwan/nanobanana-mcp` | Repo exists. npm **`@ycse/nanobanana-mcp@1.1.1`, MIT.** Launched via npx: exits with `Error: GOOGLE_AI_API_KEY environment variable is required` — proves resolution + execution | ✅ **INSTALL** — the compatible Gemini route for this environment |
| `what-name/pinterest-mcp` | Repo exists (MIT). Remote **HTTP** MCP on Cloudflare Workers, Pinterest API v5, OAuth. 20 tools. Needs `PINTEREST_CLIENT_ID` / `PINTEREST_CLIENT_SECRET` for self-host | ⚠️ **CONFIGURED, NOT VERIFIABLE HEADLESSLY** — OAuth requires an interactive browser consent this session cannot perform |
| `21st-dev/magic-mcp` | `@21st-dev/magic@0.2.2` is now explicitly a **deprecated compatibility proxy**. Current path is `@21st-dev/cli@1.16.0` (published 2026-08-21) or the HTTP endpoint `https://21st.dev/api/mcp` with an `x-api-key` header | ⚠️ **CONFIGURED (HTTP + env key), NOT VERIFIABLE** — requires a 21st.dev API key |
| `duolabstech/react-bits-mcp-server` | Repo exists, README claims npm `react-bits-mcp-server` — but the registry returns **404, not published**. Only installable by git clone + build | ❌ **NOT INSTALLED** — see below |
| `devinoldenburg/aceternity-mcp` | **HTTP 404 — repository does not exist** | ❌ **NOT INSTALLED** — see below |

### The React Bits / Aceternity finding

Both libraries publish **shadcn-compatible registries**, verified live:

- `https://reactbits.dev/r/registry.json` → **664 items / 166 unique components** (`SplitText`, `Magnet`, `ClickSpark`, `Aurora`, `CircularGallery`, `BlobCursor`, `CardSwap`…), each variant as `{Name}-{TS|JS}-{TW|CSS}`.
- `https://ui.aceternity.com/registry.json` and `https://ui.aceternity.com/registry/{name}.json` → valid shadcn registry items (`spotlight` confirmed).

Both are therefore reachable through the **shadcn MCP already installed**, by registering them as
namespaces in the consuming project's `components.json`. This is strictly better than the MCP route:

- no unpublished/unmaintained server in the dependency chain,
- no duplicate component surface,
- components land as **owned source** that the design system re-themes (CLAUDE.md §19),
- one search path (`shadcn` MCP) instead of three.

**Net new MCP servers: 4 (image search, image generation, Pinterest, 21st). React Bits and
Aceternity add 0 servers and 0 duplicated capability.**

---

## 4. Deliberate exclusions

| Excluded | Reason |
|---|---|
| `@21st-dev/magic` | Upstream declares it a deprecated compat proxy; old Magic keys were reset |
| `react-bits-mcp-server` | Not on npm; superseded by the verified shadcn registry route |
| `aceternity-mcp` | Repository does not exist (404); superseded by the verified shadcn registry route |
| `guinacio/claude-image-gen` | Not npm-distributed; overlaps 100% with the installed Gemini server. Phase 4 forbids installing both |
| Any re-install of ui-ux-pro-max, Taste, Playwright, chrome-devtools, shadcn, frontend-design, feature-dev, code-review, claude-security, ponytail, claude-mem | All verified present |
