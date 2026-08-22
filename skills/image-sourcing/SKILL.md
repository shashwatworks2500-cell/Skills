---
name: image-sourcing
description: Search, compare, download, optimise and attribute real licensed photography from Pexels, Unsplash and Pixabay via the imagebank MCP. Use when the art-direction image plan says SOURCE — the subject is real and a licensed photograph can be genuinely specific to the brief. Covers candidate comparison, WebP conversion, saving under public/images, next/image integration, responsive art-directed crops, and recording licence and attribution metadata in public/images/image-sources.json.
---

# Image Sourcing

Executes the **SOURCE** branch of the `visual-art-direction` decision framework. Do not start
here — start with an image plan that says what this image is *for*. Searching first and
rationalising after is exactly how sites end up with unrelated stock.

**Tools:** `imagebank` MCP → `search_images`, `download_image`, `optimize_local_image`.
Requires at least one of `PEXELS_API_KEY`, `UNSPLASH_ACCESS_KEY`, `PIXABAY_API_KEY` (see
`.env.example`). The server prints which providers are configured on startup.

---

## The workflow

```
SEARCH → COMPARE CANDIDATES → SELECT STRONGEST COMPOSITION → DOWNLOAD
       → OPTIMISE → SAVE UNDER public/images → USE next/image
       → RECORD ATTRIBUTION / LICENCE
```

Never skip COMPARE. One search, first result, ship it — that is the stock-photo aesthetic.

### 1. SEARCH

Query the **subject**, not the concept. `search_images` responds to nouns and physical detail.

| Bad query (concept) | Good query (subject) |
|---|---|
| `innovation` | `machinist hands adjusting a lathe` |
| `teamwork` | `two people over a paper plan on a workbench` |
| `technology` | `fibre optic patch panel close up` |
| `luxury hotel` | `linen bed, morning light through shutters` |

Run **2–3 query variants** per slot. If every result across all variants reads as stock, that is
your answer: stop, and switch the row to GENERATE.

### 2. COMPARE CANDIDATES

Pull at least **5 candidates** and score each against the spec the art director wrote:

| Check | Reject if |
|---|---|
| **Subject match** | It illustrates a *category*, not this section's specific claim |
| **Composition** | No negative space where the headline must sit |
| **Focal point** | Focal point dies in the mobile crop (test the aspect mentally at 4:5) |
| **Lighting** | Flat, evenly-lit catalogue light when the brief wants directional |
| **Colour** | Dominant hue collides with the accent token, or drags the neutral ramp warm/cool |
| **Stock tells** | Staged smiles, pristine unused tools, laptop-and-coffee, model release energy |
| **Resolution** | Smaller than 2× the largest rendered width |

State the winner **and why it beat the runner-up** in one sentence. That sentence is the
defensibility test from CLAUDE.md §1.

### 3. DOWNLOAD + OPTIMISE

`download_image` converts to WebP and optionally resizes in one step — use it rather than
downloading raw and converting separately. For client-supplied photography, use
`optimize_local_image`, which runs the same pipeline.

- Save under `public/images/<section>/<descriptive-name>.webp`. Never `image1.webp`, never `hero.webp`
  when there are three heroes.
- Request the **largest width you actually render at 2×**, not the source maximum. A 6000px
  original behind a 1440px container is wasted bytes and a CLS risk.
- Keep an original-resolution copy out of `public/` if you may need to re-crop later.

### 4. INTEGRATE with next/image

```tsx
import Image from "next/image";

<Image
  src="/images/hero/kiln-mouth.webp"
  alt="Molten glass drawn from the kiln mouth on a steel rod"
  width={2560}
  height={1097}
  priority                       // LCP element only — never on below-fold images
  sizes="100vw"
  className="object-cover"
  style={{ objectPosition: "38% 42%" }}   // the focal point from the spec
/>
```

Non-negotiables (they enforce CLAUDE.md §14):
- Explicit `width`/`height` — reserves space, protects CLS.
- `priority` on the LCP image **only**; everything else lazy-loads by default.
- Accurate `sizes` — a wrong `sizes` silently downloads the desktop asset on phones.
- `alt` describes **meaning**, not the file. Decorative-only → `alt=""`.

### 5. RESPONSIVE ART-DIRECTED CROPS

When one crop genuinely cannot serve all breakpoints, ship two sources rather than squashing one:

```tsx
<picture>
  <source media="(max-width: 768px)" srcSet="/images/hero/kiln-mouth-4x5.webp" />
  <img src="/images/hero/kiln-mouth-21x9.webp" alt="…" width={2560} height={1097} />
</picture>
```

Verify the focal point survives at **375 / 768 / 1024 / 1440** with a real screenshot
(CLAUDE.md §22). A focal point you did not look at is a guess.

### 6. RECORD ATTRIBUTION

Maintain `public/images/image-sources.json` whenever any sourced image ships. It is the record
that the site is licensed — without it, nobody can prove it later.

```json
{
  "$schema": "https://json-schema.org/draft/2020-12/schema",
  "images": [
    {
      "file": "public/images/hero/kiln-mouth.webp",
      "source": "unsplash",
      "source_id": "abc123XYZ",
      "source_url": "https://unsplash.com/photos/abc123XYZ",
      "photographer": "Jane Doe",
      "photographer_url": "https://unsplash.com/@janedoe?utm_source=web-design-stack&utm_medium=referral",
      "license": "Unsplash License",
      "attribution_required": true,
      "attribution_text": "Photo by Jane Doe on Unsplash",
      "downloaded": "2026-08-22",
      "used_in": ["app/(marketing)/page.tsx — hero"]
    }
  ]
}
```

- **Unsplash requires attribution** to photographer and to Unsplash, with UTM-tagged links.
  When `attribution_required` is true, the credit must appear **on the site** (image caption,
  or a credits line in the footer / colophon) — not only in this file.
- Pexels and Pixabay do not require attribution, but still record the source: it is how you
  re-license, re-download, or defend the choice a year from now.
- Client-supplied photography: record `"source": "client"` and who granted the rights.

---

## Do not hotlink

Always download and self-host. Hotlinking a provider CDN:

- puts a third-party origin in your LCP critical path,
- breaks silently when the provider rotates or removes the asset,
- leaks visitor IPs to that provider,
- defeats `next/image` optimisation and your own caching headers,
- usually violates the provider's API terms.

**The only acceptable exception** is a provider whose terms *require* serving from their CDN
(some editorial and rights-managed licences do). If you hotlink, write the reason next to the
`<Image>` call and set `"hotlinked": true` with the reason in `image-sources.json`.

---

## When to stop sourcing and generate instead

Switch the row to GENERATE and hand off to `image-generation` when:

- three query variants all return recognisable stock aesthetics,
- the subject does not exist in stock (your specific product, a fictional space, a brand world),
- the brief needs a visual identity — a consistent light, palette and texture across 6 images —
  that assembled stock cannot hold together,
- every usable candidate has the wrong aspect and cannot be cropped without losing the subject.

Sourcing harder is not a virtue. A generated original that is *about* the brand beats a licensed
photo that is about nothing.
