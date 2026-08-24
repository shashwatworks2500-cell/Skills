---
name: image-sourcing
description: Source real photography for websites — decide photo vs generated, search Pexels/Unsplash/Pixabay with graceful provider fallback, judge whether an image fits the art direction, handle licensing and attribution, and ship responsive optimized markup. Use when a page needs a hero image, editorial imagery, product shots, avatars, textures, or backgrounds, or when imagery looks generic, mismatched, or slow.
version: 1.0.0
user-invocable: true
argument-hint: "[what the image is for]"
---

Source real imagery that serves the design direction. Imagery is the fastest way to make a
site look expensive — and the fastest way to make it look like a template.

## Two hard rules

1. **Never invent an image URL.** Every URL must come back from a provider API response, an
   asset you generated, or a file already in the repo. A plausible-looking
   `images.unsplash.com/photo-1234…` you wrote from memory is a broken image in production.
   If you cannot reach a provider, say so and leave a documented placeholder — do not guess.
2. **Never ship placeholder services in a final build.** `picsum.photos`, `placehold.co`,
   `via.placeholder.com`, and grey boxes are scaffolding. They are fine mid-build; they are a
   defect at delivery. Track every one and replace it before you call the work done.

## 1. Decide: real photo or generated?

Ask what the image has to be *true* about.

| Use a **real photograph** when | Use a **generated image** when |
|---|---|
| It depicts a real product, place, person, or event | The subject is abstract, conceptual, or decorative |
| Credibility depends on it (team, office, customers, food, hardware) | No real referent exists yet (pre-launch product, metaphor) |
| Human faces carry trust (testimonials, about, careers) | You need an exact composition no stock library has |
| Texture/material realism matters (fabric, stone, skin) | You need a texture, gradient field, or backdrop |
| Legal/editorial accuracy matters | You need consistent art direction across many images |

**Do not generate when a good real photograph exists.** A generated "team photo" or "our
office" is a lie, an uncanny one, and reads instantly as AI. When the choice is close, real
photography wins — it carries grain, imperfection, and specificity that generation smooths away.

For the generation path, hand off to `imagegen-frontend-web` (web art direction),
`imagegen-frontend-mobile` (app screens), or `image-to-code` (design-first implementation).
This skill owns the *real photography* path.

## 2. Search with provider fallback

Three providers, all free-tier, all requiring a key in the environment. **Never hardcode a
key — never commit one.** Read from env only:

| Provider | Env var | Endpoint | Licence |
|---|---|---|---|
| Pexels | `PEXELS_API_KEY` | `https://api.pexels.com/v1/search` (header `Authorization: <key>`) | Pexels Licence — free commercial, no attribution required |
| Unsplash | `UNSPLASH_ACCESS_KEY` | `https://api.unsplash.com/search/photos` (`client_id=<key>`) | Unsplash Licence — free commercial, **attribution required by API terms** |
| Pixabay | `PIXABAY_API_KEY` | `https://pixabay.com/api/` (`key=<key>`) | Pixabay Content Licence — free commercial, no attribution required |

**Fallback order and behaviour.** Try in order: Pexels → Unsplash → Pixabay. Fall through on
*any* of: missing env var, non-2xx status, connection failure, or zero results. Treat all four
identically — a network-policy block and a missing key both mean "this provider is unavailable,
try the next one."

```bash
# Probe availability before relying on a provider. HTTP 000 = blocked/unreachable.
curl -sS -o /dev/null -w '%{http_code}\n' --max-time 20 \
  -H "Authorization: $PEXELS_API_KEY" \
  "https://api.pexels.com/v1/search?query=test&per_page=1"
```

If **all three** are unavailable, stop and report it. Do not silently substitute a placeholder
service and do not invent URLs. Offer the user two real options: supply images manually, or
generate them (§1).

**Query craft.** Stock search rewards concrete nouns and photographic language, not marketing
abstractions. Search `concrete stairwell shadow`, not `innovative solutions`. Add lighting and
lens terms (`golden hour`, `overcast`, `macro`, `wide angle`, `shallow depth of field`) to steer
away from the over-saturated top-of-results look. Pull `per_page=15` and *choose*; never take
the first result reflexively.

## 3. Judge the candidate against the direction

Reject an image that fails any of these, even if it is technically beautiful:

- **Direction match** — does it share the palette, contrast level, and mood already committed
  to in VISUAL DIRECTION? A warm editorial site cannot take a cold blue-grey corporate shot.
- **Colour compatibility** — will your accent colour survive on top of it? Sample the region
  where text or CTA will sit.
- **Negative space** — is there a quiet area for the headline, or will you be fighting the
  subject? For heroes this is usually the deciding factor.
- **Subject specificity** — a real, particular moment beats a generic one. Two people laughing
  at a laptop is the visual equivalent of "Empower your workflow."
- **Crop survivability** — will it still read at 21:9 desktop *and* 4:5 mobile? Check the
  subject's position before committing (§5).

**The generic-stock smell test.** Reject on sight: handshakes over conference tables, isolated
smiling headsets, hands stacked in a team huddle, glowing blue circuit-board abstractions,
"diverse team pointing at a whiteboard", lens-flare skyscrapers shot from below, anything with a
visible stock watermark. If it could sit on any competitor's site unchanged, it fails the same
test the art direction does.

**Consistency across a set.** Images on one page must look like one shoot. Lock and hold:
colour temperature, contrast/grain level, depth of field, human-vs-object ratio, and whether
subjects look at camera. One mismatched image degrades the whole set — it is better to run four
consistent images than six good unrelated ones.

## 4. Licence and attribution

Record for every sourced image, in the repo (a `credits.md` or a data file — not only in chat):
photographer name, provider, source page URL, and licence name.

- **Unsplash requires attribution** under its API terms, and requires triggering the
  download endpoint (`links.download_location`) when an image is actually used. Honour both.
- Pexels and Pixabay do not require attribution — credit anyway; it costs a line.
- **Never** hotlink a provider's CDN as your production asset path. Download, optimize, and
  serve from your own origin or image CDN. Hotlinking breaks when they rotate URLs and can
  violate terms.
- Model/property releases: none of these providers guarantee releases for commercial
  *endorsement* use. A face on a landing page implying endorsement needs a released image —
  flag it rather than assume.

## 5. Role, aspect ratio, and crop

| Role | Typical ratio | Notes |
|---|---|---|
| Hero (full-bleed) | 21:9 desktop → 4:5 or 3:4 mobile | Needs negative space for headline + CTA |
| Editorial inline | 3:2 or 16:9 | Aligns to the text column or breaks the grid deliberately |
| Product | 1:1 or 4:5 | Consistent padding and background across the set |
| Card thumbnail | 16:9 or 4:3 | One ratio for the whole set, no exceptions |
| Avatar | 1:1 | Round mask, face centred |
| Texture/background | any | Must survive heavy overlay; never compete with text |

Mobile crops to a *taller* box than desktop, so a subject at the horizontal edge gets cut.
Use `object-position` to protect the subject rather than accepting the centre crop:

```html
<img src="/img/hero-1600.avif" alt="" class="h-full w-full object-cover object-[70%_center]" />
```

For genuinely different compositions per breakpoint, use `<picture>` with art-directed sources
(different crops), not just different resolutions of one crop.

## 6. Optimize and implement

Non-negotiables, matching the constitution's performance budgets:

- **Format**: AVIF with WebP fallback. Never ship a hero as PNG; never ship an unoptimized JPEG.
- **Dimensions**: always set `width`/`height` (or an aspect-ratio box) — this is CLS prevention.
- **Loading**: the LCP image gets `loading="eager"` + `fetchpriority="high"` (and `priority` on
  `next/image`). Everything below the fold gets `loading="lazy"` + `decoding="async"`.
- **Responsive**: ship a `srcset` ladder — roughly 640 / 960 / 1280 / 1920 / 2560 — with a
  `sizes` attribute that matches the actual layout. A 2560px file served into a 400px slot is
  the most common Core Web Vitals failure on image-rich sites.
- **Weight budget**: hero ≤ 200KB, inline ≤ 120KB, thumbnail ≤ 40KB after compression. If you
  cannot hit it, the image is too detailed for the slot — crop tighter or pick another.
- **Alt text**: describe *function*, not pixels. Decorative images take `alt=""`. Never write
  "image of".
- **Overlay contrast**: text over an image needs a scrim (gradient or tint), not hope. Verify
  4.5:1 against the *lightest* pixel the text actually covers.

```html
<picture>
  <source type="image/avif" srcset="/img/hero-960.avif 960w, /img/hero-1920.avif 1920w"
          sizes="100vw">
  <source type="image/webp" srcset="/img/hero-960.webp 960w, /img/hero-1920.webp 1920w"
          sizes="100vw">
  <img src="/img/hero-1920.jpg" width="1920" height="820" alt=""
       fetchpriority="high" class="w-full object-cover">
</picture>
```

With Next.js use `next/image` and let it build the ladder; set `priority` on the LCP image and
`sizes` on every fill image.

## 7. Pinterest and reference research

Pinterest is a **research** input, never a source of production assets.

**Workflow:** collect references → extract patterns → synthesize an original direction → build.

Drive it with the Playwright MCP (`browser_navigate` to a search or board URL,
`browser_take_screenshot`, `browser_snapshot`) and read the results as *evidence*, not as a
template. Extract only the transferable layer:

- composition and grid rhythm; where the eye lands first
- type pairing, weight contrast, and scale relationships
- palette relationships (dominant / supporting / accent proportions)
- imagery treatment — grain, temperature, crop tightness, subject distance
- interaction affordances implied by the layout

Then write a direction in your own words and build from *that*. Never reproduce a specific
layout, illustration, photograph, or artwork; never download and ship pinned images; never
imitate a named living artist's style. Boards are full of copyrighted work whose licence you do
not have.

**Authentication status.** Pinterest needs no credentials for browser-based research on public
search and board pages — that path works wherever the browser can reach `pinterest.com`. The
Pinterest *API* (v5) additionally requires an OAuth app: register at
`developers.pinterest.com`, create an app, complete the OAuth 2.0 authorization-code flow, and
export the resulting token as `PINTEREST_ACCESS_TOKEN`. **This stack does not ship Pinterest
API credentials and does not require them** — if the token is absent, use the browser path. Any
alternative reference source (Behance, Dribbble, Awwwards, Savee, Cosmos, or the client's own
competitors) substitutes cleanly; nothing here depends on Pinterest specifically.

## Checklist before you call imagery done

- [ ] Every URL traced to a real API response, generated asset, or repo file
- [ ] Zero placeholder-service URLs remain
- [ ] Images on a page read as one coherent set
- [ ] Hero has negative space where the headline sits; text passes 4.5:1 over it
- [ ] Subject survives the mobile crop (`object-position` set where needed)
- [ ] AVIF/WebP, `srcset` + `sizes`, explicit dimensions, correct eager/lazy split
- [ ] Weight budgets met
- [ ] Alt text meaningful; decorative images `alt=""`
- [ ] Attribution recorded; Unsplash download endpoint triggered if used
- [ ] Verified in the browser at 375 / 768 / 1024 / 1440
