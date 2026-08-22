> **Note — adapted for this repository.** This document is vendored from the upstream
> UI/UX Pro Max `stack/` directory and kept close to the original. Its
> `/plugin install ...@anthropics/claude-code` commands use an obsolete marketplace path,
> and the `/plugin` slash command is unavailable in some environments. Use
> [INSTALL.md](INSTALL.md) or `scripts/install.sh`, which use the current
> `anthropics/claude-plugins-official` marketplace via the `claude plugin` CLI.

# The Stack — why each tool is here

AI design fails in three predictable ways. Each layer of this stack fixes one.

| Failure mode | Fix | Tool |
|--------------|-----|------|
| Generic, templated look ("AI slop") | Force an aesthetic commitment | `frontend-design` |
| Vague, inconsistent tokens & patterns | Ground decisions in a real database | `ui-ux-pro-max` |
| Never sees the result → ships broken UI | Give the agent eyes | Playwright / Chrome DevTools MCP |
| Reinventing primitives | Pull proven components | shadcn MCP |
| "Looks fine to me" self-assessment | Independent, rigorous review | `design-review` subagent |

## 🧠 Knowledge — `ui-ux-pro-max`

A searchable design-intelligence toolkit: **84 UI styles, 192 color palettes, 73 font
pairings, 99 UX guidelines, 25 chart types, a Core Web Vitals dataset, and 22 tech stacks**,
plus a design-system generator that turns a product brief into concrete tokens. It's the
answer to "what should this actually look like, and what are the anti-patterns?"

- Repo: <https://github.com/nextlevelbuilder/ui-ux-pro-max-skill> · License: MIT
- Install: `npx ui-ux-pro-max-cli init --ai claude`
- Use: `python3 <skill>/scripts/search.py "<brief>" --design-system` and `--domain <domain>`

## 🎨 Taste — `frontend-design` (official Anthropic)

~50 lines of markdown that stop Claude from sampling the safe center of its training data. It
forces four decisions — *purpose, tone, constraints, differentiation* — before any CSS, names
three "AI-slop" defaults to avoid, and pushes boldness into a single signature element.

- Repo: <https://github.com/anthropics/claude-code/tree/main/plugins/frontend-design>
- Install: `/plugin install frontend-design@anthropics/claude-code`

`ui-ux-pro-max` decides *what's correct*; `frontend-design` decides *what's distinctive*. Use both.

## 🧩 Components — shadcn MCP + 21st MCP + React Bits / Aceternity registries

Search catalogues before hand-rolling accessible primitives or complex interactions. The
`interactive-components` skill owns the selection hierarchy — **project → shadcn → 21st →
React Bits → Aceternity → custom** — and the rule that external components are re-themed to the
project's tokens rather than shipped with registry defaults.

- **shadcn MCP** — primitives and accessible behaviour (dialog, select, combobox, form, table).
  <https://ui.shadcn.com/docs/mcp> · `npx shadcn@latest mcp`
- **21st MCP** — the broad catalogue: composed blocks, themes, templates, UI generation.
  Remote HTTP at `https://21st.dev/api/mcp`, needs `TWENTY_FIRST_API_KEY`.
  <https://github.com/21st-dev/magic-mcp>
- **React Bits** — ~166 animated components: text animation, cursor effects, scroll effects,
  galleries, interactive cards, backgrounds, navigation. <https://github.com/DavidHDev/react-bits>
- **Aceternity** — secondary source for premium cards, spotlight and hover effects, animated
  backgrounds and navigation. <https://ui.aceternity.com>

**React Bits and Aceternity add no MCP server.** Both publish shadcn-compatible registries
(`https://reactbits.dev/r/{name}.json`, `https://ui.aceternity.com/registry/{name}.json`), so the
shadcn MCP already installed reaches them once the namespaces are registered in the consuming
project's `components.json`. That keeps one search path, avoids an unmaintained server in the
dependency chain, and lands components as owned source the design system re-themes.

## 🖼️ Art direction — `visual-art-direction` + Pinterest MCP

Decides what a page should **show** before anything decides how it looks. Runs an explicit image
decision framework per section (NEED IMAGE? → SOURCE / GENERATE / CREATE ASSET) and specifies
subject, composition, focal point, lighting, colour, crop, responsive behaviour, motion and
licence. `pinterest-art-direction` supplies references — boards and pins are analysed for
typography, composition, palette and photography direction, then converted into original
direction. **Pinterest is reference, never an image source.**

- Pinterest MCP: <https://github.com/what-name/pinterest-mcp> — remote HTTP, browser OAuth

## 📸 Imagery — imagebank MCP + nanobanana MCP (Gemini)

Executes the art director's plan. `image-sourcing` searches, compares and downloads licensed
photography from Pexels, Unsplash and Pixabay, converts to WebP, and records licence and
attribution in `public/images/image-sources.json`. `image-generation` produces original assets
with Gemini when stock cannot deliver the required visual identity — hero, product, editorial,
backgrounds, illustration — with reference images, aspect-ratio control, variations and editing.

- imagebank MCP: <https://github.com/romuloquintanilha/imagebank-mcp> — `npx imagebank-mcp@1.0.0`
- nanobanana MCP: <https://github.com/tygwan/nanobanana-mcp> — `npx @ycse/nanobanana-mcp@1.1.1`

Both need API keys; see [`docs/INSTALL.md`](INSTALL.md#api-keys). Neither key ever enters a
tracked file — `.mcp.json` carries `${VAR}` expansions only.

## 👁️ Visual feedback — Playwright MCP + Chrome DevTools MCP

The single biggest lever. Claude connects to a **real Chromium**, navigates, clicks, resizes,
screenshots, reads the console, and takes an accessibility snapshot — so it can catch and fix
its own z-index bugs, animation-timing errors, overflow, and layout shift. Chrome DevTools MCP
adds deep performance/network/CLS profiling.

- Playwright MCP: <https://github.com/microsoft/playwright-mcp> — `npx @playwright/mcp@latest`
- Chrome DevTools MCP: <https://github.com/ChromeDevTools/chrome-devtools-mcp> — `npx chrome-devtools-mcp@latest`

## ✅ Automated review — `design-review` subagent

A senior-reviewer subagent (`.claude/agents/design-review.md`) that runs a 7-phase audit over a
live page: interaction states, responsiveness across 6 viewport tiers, visual polish, WCAG 2.1
AA, edge cases, and console health. Invoke with `/design-review <url>`. The heuristic subset
also runs headless in CI via `scripts/design-audit.mjs`.

## Optional add-ons (not in default `.mcp.json`)

- **Figma Dev Mode MCP** — read a frame's tokens/layout to generate matching code, and push
  Claude-built UI back to the canvas as editable layers. Needs the Figma desktop app + Dev Mode.
  <https://help.figma.com/hc/en-us/articles/39888612464151-Claude-Code-and-Figma-Set-up-the-MCP-server>

Opt-in (see `docs/SETUP.md`).

## Deliberately not installed

Evaluated during the visual-intelligence upgrade and rejected — see
[`docs/GAP-REPORT.md`](GAP-REPORT.md) for the evidence.

| Candidate | Why not |
|---|---|
| `guinacio/claude-image-gen` | Not published to npm; needs a plugin install or a git build with an absolute path, so it cannot be a portable project `.mcp.json` entry. Overlaps the installed Gemini server completely. Still available as an optional user-scope plugin. |
| `duolabstech/react-bits-mcp-server` | Its README claims npm `react-bits-mcp-server`, but that package is not published (404). Superseded by the React Bits shadcn registry. |
| `devinoldenburg/aceternity-mcp` | Repository does not exist (HTTP 404). Superseded by the Aceternity shadcn registry. |
| `@21st-dev/magic` | Upstream declares it a deprecated compatibility proxy; old Magic API keys were reset. The current unified 21st MCP is used instead. |

Zero secrets are required for the base stack — the four credentialed servers are additive and
each degrades gracefully when its key is absent.
