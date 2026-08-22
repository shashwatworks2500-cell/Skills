---
name: pinterest-art-direction
description: Use Pinterest boards and pins as visual reference and art-direction input — never as an image source. Inspect the user's own boards and pins, search where API permissions allow, then analyse the visual patterns: typography, composition, colour palette, photography direction, lighting, texture and interaction inspiration. Use during the reference-research stage of a website build, when establishing visual direction, when the user mentions a moodboard or their Pinterest boards, or when a design brief needs grounding in real references before tokens are chosen.
---

# Pinterest Art Direction

Pinterest is a **reference library**, not an asset library. Everything on it belongs to someone
else. Its value here is that it shows you what the client actually responds to — which is worth
more than any adjective they can give you.

**Tools:** `pinterest` MCP (Pinterest API v5, OAuth). Reference-relevant tools:
`list_boards` · `list_board_pins` · `list_pins` · `get_pin` · `search_pins` ·
`get_suggested_keywords` · `get_related_keywords` · `get_trending_keywords`.

The server also exposes write tools (`create_pin`, `update_board`, `delete_pin`, analytics…).
**Do not call write or delete tools** as part of a design workflow. They modify the user's real
Pinterest account. Only use them if the user explicitly asks you to post something.

**Auth:** OAuth in the browser, on first use. No key goes in a repo file. See "Authentication"
below. If Pinterest is not connected, this skill degrades gracefully — see "Working without
Pinterest".

---

## The workflow

```
PINTEREST REFERENCE → ANALYSE → EXTRACT DESIGN LANGUAGE → CREATE ORIGINAL DIRECTION
                    → SOURCE LICENSED EQUIVALENT ── or ── GENERATE ORIGINAL IMAGE
```

The middle arrow is the whole point. You go **reference → language → original work**. You never
go reference → download → ship.

### 1. GATHER

- `list_boards` to see what the client keeps. **Board names and how they've grouped things are
  data** — a board called "restraint" tells you more than a brief does.
- `list_board_pins` on the 1–3 boards relevant to this project.
- `search_pins` / `get_related_keywords` to widen only when the client's own boards are thin.
- 15–40 pins is enough. A hundred pins is not more signal, it's less.

Ask which boards matter rather than guessing — a client's "kitchen ideas" board is not art
direction for their B2B site.

### 2. ANALYSE — what to actually extract

Look for what **repeats**. One striking pin is a coincidence; a pattern across twelve is a brief.

| Dimension | What to look for | What you write down |
|---|---|---|
| **Typography** | Serif vs sans vs mixed; weight contrast; all-caps usage; tracking; how large the largest type gets relative to the page | "Consistently one high-contrast serif display + one neutral grotesque body; display set very large with tight negative tracking" |
| **Composition** | Centred vs asymmetric; grid vs broken grid; how much negative space; where subjects sit in frame | "Asymmetric, subject on the left third, 40%+ of frame empty" |
| **Colour palette** | Dominant neutral; temperature; accent frequency; saturation ceiling | "Warm off-white ground, one deep ink neutral, single rust accent used at ~5%" |
| **Photography direction** | Lighting hardness and direction; lens; grain; staged vs documentary; colour grade | "Hard single-source light, deep shadow, visible grain, documentary not staged" |
| **Texture / materiality** | Paper, film, print artefacts, flat digital, matte vs gloss | "Matte print, subtle paper tooth, no gloss, no glass" |
| **Density & rhythm** | Sparse vs packed; how often the eye rests | "Very sparse; one idea per view" |
| **Interaction inspiration** | For UI pins: hover states, transitions, nav patterns, scroll behaviour implied | "Nav collapses to a single mark; content enters on scroll, no bounce" |

Then state the **through-line in one sentence**. If you cannot, you have a pile of pins, not a
direction. Example: *"Quiet, warm, print-derived; type does all the work; one rust accent; hard
light and real texture; nothing glossy."*

Note the **negative space of the board** too — what is conspicuously absent. If forty pins
contain no gradients, no glass, and no rounded cards, that is an explicit instruction.

### 3. EXTRACT DESIGN LANGUAGE → ORIGINAL DIRECTION

Convert observations into **your own system**, not a copy:

- Typography → a pairing from `ui-ux-pro-max --domain typography` that has the *observed
  qualities* (contrast, weight, tracking behaviour). Not necessarily the same fonts.
- Colour → tokens from `ui-ux-pro-max --domain color` matching the observed temperature,
  neutral ramp and accent ratio. Run the contrast floors (CLAUDE.md §4).
- Photography → becomes the light/lens/grade clauses in the `image-generation` prompt, or the
  rejection criteria in `image-sourcing` §2.
- Composition → becomes grid and section-rhythm decisions.
- Interaction → becomes named patterns from the INTERACTION & MOTION CONSTITUTION.

**The test:** the finished site should share a *sensibility* with the board and share no
*artefacts* with it. If someone can point at a pin and at your page and say "that's the same
image / that's the same layout", you copied instead of directed.

### 4. HAND OFF

Every visual the references imply goes through the normal routes:

- **SOURCE** → `image-sourcing` (licensed, downloaded, attributed)
- **GENERATE** → `image-generation` (original, prompted with the extracted qualities)
- **ASSET** → build it in-repo as SVG/component

---

## Copyright — the hard rule

**Never download a Pinterest image into a client website.**

Pins are overwhelmingly third-party copyrighted work, frequently re-pinned without the
photographer's or designer's involvement. The pin's "source" link is often wrong, dead, or points
to another aggregator. There is usually **no licence at all**, and no way to obtain one from
Pinterest.

- ❌ Do not save pin images into `public/`.
- ❌ Do not hotlink Pinterest CDN URLs.
- ❌ Do not feed a pin image to the generator as a reference and treat the output as clean — a
  close derivative of a copyrighted work is still a derivative. Reference *qualities*
  (light, palette, composition), not a specific image.
- ✅ The one exception: an image the user **owns or has demonstrable rights to** — their own
  photography, their own brand assets, a pin of their own past work. Record the rights in
  `public/images/image-sources.json` with `"source": "client"` and who granted them.

If a pin is genuinely perfect and the underlying work is licensable, follow the pin to the
*original creator* and license it from them properly. That is a real path — it just isn't a
Pinterest download.

---

## Authentication

The default `.mcp.json` entry points at the maintainer's hosted Cloudflare Worker:

```json
"pinterest": {
  "type": "http",
  "url": "https://pinterest-mcp.orange-tooth-1f40.workers.dev/mcp"
}
```

- On first use, Claude Code opens a **browser OAuth consent** flow. You approve Pinterest access
  for your own account; the worker stores the token server-side (encrypted KV), and the session
  carries a bearer token. **No Pinterest key ever enters this repository.**
- Unauthenticated calls return `401 invalid_token` — that is the expected state until you connect.
- `search_pins` scope availability depends on what Pinterest grants your app. Personal boards and
  pins (`list_boards`, `list_board_pins`, `list_pins`) work with standard access; broad public
  search may not. **Treat your own boards as the primary source and search as a bonus.**
- **Self-hosting** (recommended for client work — you control the token store): fork
  `what-name/pinterest-mcp`, register an app at developers.pinterest.com, deploy with Wrangler,
  set `PINTEREST_CLIENT_ID`, `PINTEREST_CLIENT_SECRET`, `COOKIE_ENCRYPTION_KEY` as **Wrangler
  secrets** (`wrangler secret put …`), not as committed vars, and point the `url` at your worker.

---

## Working without Pinterest

Pinterest is optional. If it isn't connected, do not stall the build — run the same
ANALYSE → EXTRACT → DIRECT loop against other reference input:

- reference URLs the client supplies (fetch and analyse the live sites),
- the client's existing brand assets, print collateral, or photography,
- `ui-ux-pro-max --domain style` for style profiles, and `--domain color` for palettes,
- competitor sites, analysed for what to deliberately *not* do.

The skill's value is the analysis discipline, not the API.
