# Ultimate Claude Code Web Design Stack

An agency-grade Claude Code environment for designing and building premium websites.

Most AI-generated interfaces look AI-generated: purple gradients, uniform rounded cards, a
centered hero above three feature columns, and nobody ever looked at the result in a browser.
This stack exists to prevent that. It combines a **knowledge** layer that supplies real design
tokens, a **taste** layer that commits to a specific art direction, and a **feedback** layer
that drives an actual browser and fixes what it finds — bound together by a 15-stage workflow
and a written constitution.

```bash
claude plugin marketplace add shashwatworks2500-cell/Skills
claude plugin install web-design-stack@web-design-stack
```

Full instructions, including installing into an existing project: **[docs/INSTALL.md](docs/INSTALL.md)**

---

## What it covers

**Design** — UI/UX design · design systems and tokens · premium typography · colour systems ·
spacing scales · visual hierarchy · art direction · design critique · brand and identity

**Frontend** — Next.js App Router · React · TypeScript (strict) · Tailwind CSS · shadcn/ui ·
component architecture · semantic HTML

**Motion** — GSAP · Lenis · Three.js / React Three Fiber when justified · micro-interactions ·
`prefers-reduced-motion` compliance

**Quality** — responsive design (375 / 768 / 1024 / 1440) · WCAG 2.1 AA accessibility · SEO ·
Core Web Vitals · browser QA · visual QA · code review · security review

---

## How it works

Three layers, kept deliberately separate:

| Layer | Component | Job |
|---|---|---|
| **Knowledge** | `ui-ux-pro-max` | Tokens. 79 styles, 192 palettes, 74 font pairings, 119 UX guidelines, 17 GSAP presets, 22 stacks — searchable offline. |
| **Taste** | `frontend-design` | Attitude. One committed tone; rejects templated defaults. |
| **Feedback** | Playwright + Chrome DevTools MCP | Reality. Screenshots, interaction states, console, Lighthouse. |

The governing rule: *let `ui-ux-pro-max` set tokens, let `frontend-design` set attitude.*
Data for correctness, taste for distinctiveness.

### The workflow

```
RESEARCH → INFORMATION ARCHITECTURE → DESIGN SYSTEM → VISUAL DIRECTION →
IMPLEMENTATION → RESPONSIVE → ANIMATION → ACCESSIBILITY → PERFORMANCE →
BROWSER QA → VISUAL CRITIQUE → POLISH → CODE REVIEW → SECURITY REVIEW → FINAL BUILD
```

**BROWSER QA** and **VISUAL CRITIQUE** are hard gates. A UI change nobody has looked at in a
real browser is not finished.

### The constitution

[`CLAUDE.md`](CLAUDE.md) is a 25-section ruleset covering typography, colour, spacing, grids,
breakpoints, animation, GSAP, Lenis, Three.js, accessibility, SEO, performance, component
architecture, Next.js, TypeScript strictness, Tailwind, shadcn, code quality, security, visual
QA, browser testing, mobile-first checks — and a list of banned generic-AI patterns.

Its final test:

> If the page could be swapped onto a competitor's site by changing only the logo and the copy,
> the art direction has failed.

---

## Commands

| Command | Does |
|---|---|
| `/design-plan` | Generate a concrete design system before building |
| `/website` | Premium narrative landing pages |
| `/shape` | Structured discovery interview → design brief |
| `/design-review` | 7-phase review: WCAG AA, responsive, interaction |
| `/critique` | UX evaluation with scoring and anti-pattern detection |
| `/audit` | Accessibility, performance, theming, responsive |
| `/polish` | Final alignment and micro-detail pass |
| `/animate` | Purposeful motion and micro-interactions |
| `/adapt` | Responsive breakpoints, fluid layouts, touch targets |
| `/optimize` | Loading, rendering, bundle size |
| `/harden` | Error states, empty states, i18n, edge cases |
| `/high-end-visual-design` | Agency-grade visual standards |
| `/image-to-code` | Screenshot or reference → working frontend |
| `/layout` `/typeset` `/colorize` `/distill` `/bolder` `/quieter` | Targeted refinements |
| `/code-review` `/ponytail-review` | Correctness and over-engineering review |

43 skills total — run `./scripts/verify.sh` for the full inventory.

---

## Components and upstream sources

### Vendored in this repository

| Component | Upstream | Version | Licence |
|---|---|---|---|
| UI/UX Pro Max + 6 companions | [nextlevelbuilder/ui-ux-pro-max-skill](https://github.com/nextlevelbuilder/ui-ux-pro-max-skill) | 2.15.0 | MIT © Next Level Builder |
| Taste (32 skills) | [tyfarrago-hub/taste](https://github.com/tyfarrago-hub/taste) | `acbb3e9` | MIT © Ty Farrago |
| Design stack foundation | [ui-ux-pro-max-skill `/stack`](https://github.com/nextlevelbuilder/ui-ux-pro-max-skill/tree/main/stack) | `bc826e2` | MIT © Next Level Builder |

### Installed from source by `scripts/install.sh`

| Component | Upstream | Version | Licence |
|---|---|---|---|
| Frontend Design | [anthropics/claude-plugins-official](https://github.com/anthropics/claude-plugins-official) | `340e33a` | Apache-2.0 |
| Feature Dev | anthropics/claude-plugins-official | `340e33a` | Apache-2.0 |
| Code Review | anthropics/claude-plugins-official | `340e33a` | Apache-2.0 |
| Claude Security | anthropics/claude-plugins-official | 0.10.2 | Apache-2.0 |
| Ponytail | [DietrichGebert/ponytail](https://github.com/DietrichGebert/ponytail) | 4.9.0 | MIT © DietrichGebert |
| Claude-Mem | [thedotmack/claude-mem](https://github.com/thedotmack/claude-mem) | 13.15.3 | Apache-2.0 |
| Playwright MCP | [microsoft/playwright-mcp](https://github.com/microsoft/playwright-mcp) | latest | Apache-2.0 |
| Chrome DevTools MCP | [ChromeDevTools/chrome-devtools-mcp](https://github.com/ChromeDevTools/chrome-devtools-mcp) | latest | Apache-2.0 |
| shadcn MCP | [shadcn-ui/ui](https://github.com/shadcn-ui/ui) | latest | MIT |

These six plugins are **not** copied here. They are marketplace-managed, and vendoring them
would fork them and break `claude plugin update`. `scripts/install.sh` installs each from its
official source. Full provenance — including commit SHAs and install methods — is in
[`STACK-MANIFEST.json`](STACK-MANIFEST.json).

---

## Scripts

```bash
./scripts/install.sh                 # activate the stack here
./scripts/install.sh --into ../app   # install into another project
./scripts/verify.sh                  # verify everything (non-zero exit on failure)
./scripts/update-skills.sh           # refresh vendored skills from upstream
npm run audit -- --url http://localhost:3000
```

`install.sh` is idempotent — running it twice never creates duplicate skills.

---

## Requirements

Node 18+ · npm · Python 3.x · git · Claude Code

---

## Attribution and licence

The scripts, documentation, constitution and packaging in this repository are MIT licensed
(see [`LICENSE`](LICENSE)). **The vendored skills are the work of their original authors, not of
this repository's maintainer.** Upstream licences are preserved in [`licenses/`](licenses/) and
attribution is documented in [`NOTICE.md`](NOTICE.md).

> ⚠️ **Please read [`NOTICE.md`](NOTICE.md) before publishing or commercially relying on this
> repository.** Six of the vendored Taste skills originate from a project that ships no licence
> file, which means no redistribution permission is formally granted. The issue is documented,
> and `NOTICE.md` explains how to remove them if that matters for your use.
