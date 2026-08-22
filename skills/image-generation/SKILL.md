---
name: image-generation
description: Generate and edit original imagery with Google Gemini via the nanobanana MCP — hero imagery, product shots, editorial photography, background artwork, illustrations, textures — with reference images, aspect-ratio control, multiple variations, and iterative editing. Use when the art-direction image plan says GENERATE, when stock photography cannot deliver the required visual identity, or when an existing image needs editing, extending or re-lighting. Covers the brief → references → prompt → generate → review → iterate → optimise → integrate loop.
---

# Image Generation

Executes the **GENERATE** branch of the `visual-art-direction` decision framework.

**Tools:** `nanobanana` MCP (Google Gemini) →
`set_model` · `set_aspect_ratio` · `gemini_generate_image` · `gemini_edit_image` ·
`gemini_chat` · `get_image_history` · `clear_conversation`.

Requires `GOOGLE_AI_API_KEY` (free tier at https://aistudio.google.com/apikey). See
`.env.example`. **Never put a key in a repository file, a prompt, a commit, or a screenshot.**

---

## When to generate rather than source

Generate when originality is the *point*, not when sourcing was inconvenient.

| Generate | Source instead |
|---|---|
| The brand needs a visual world stock cannot supply | The subject is real, generic-safe and photographable |
| A **consistent** light/palette/texture across 6+ images | You need one image and stock has it |
| The subject does not exist (fictional space, unreleased product, abstract brand world) | Documentary evidence, real work, real people |
| Backgrounds, textures, atmospheric plates | A recognisable real place |
| Editorial illustration in a specific house style | — |

**Never generate:** photographs of identifiable real people presented as real, fake testimonial
portraits, fabricated product photography of a product that doesn't look like that, or anything
presented as documentary evidence. Testimonials use real portraits or no portrait
(CLAUDE.md IMAGE & VISUAL CONTENT CONSTITUTION).

---

## The loop

```
BRIEF → VISUAL REFERENCES → PROMPT → GENERATION → REVIEW → ITERATE → OPTIMISE → INTEGRATE
```

### 1. BRIEF

Take the 14-field spec from `visual-art-direction`. If you don't have it, go get it. Generating
without a spec produces the exact "generic AI hero image" the constitution bans.

### 2. VISUAL REFERENCES

Gather 3–5 references **before** prompting — from `pinterest-art-direction`, from the client's
existing assets, from `ui-ux-pro-max --domain style`. Extract from them: light direction and
hardness, palette, texture, lens character, composition. Reference *the qualities*, never
"in the style of [living artist]".

`gemini_generate_image` and `gemini_edit_image` accept reference images. Passing a real reference
beats describing it in words.

### 3. PROMPT

Set the session up first — aspect ratio and model must be set **before** generating:

```
set_model("pro")            # "pro" for hero/final assets, "flash" for exploration
set_aspect_ratio("21:9")    # must precede generation; see aspect table below
```

Write prompts in this order — **subject → composition → light → colour → medium → detail →
negative**:

> A glassblower's kiln mouth, molten glass drawn onto a steel rod. Subject at left third,
> deep negative space to the right for a headline. Single hard practical light source from
> inside the kiln, warm amber falloff into near-black shadow. Palette limited to amber, ember
> orange and charcoal — no blue, no purple. Shot on 50mm at f/2, shallow depth of field, visible
> film grain, slight sensor bloom on the highlight. Workshop is used and worn, tools out of
> focus behind. No people's faces, no text, no logos, no lens flare.

Rules that decide whether the output is usable:

- **Name the negative space.** "Deep negative space to the right for a headline" is the single
  highest-value clause for a hero — it's what makes the image compose with type.
- **Limit the palette explicitly**, and explicitly exclude the ones you don't want. Gemini drifts
  toward blue/purple/teal unless told otherwise; that drift is the AI-slop tell.
- **Specify a light source and its direction.** Unspecified light = flat, evenly-lit, generic.
- **Specify lens and medium.** 50mm/f2/grain reads as photography; without it output reads as render.
- **Negative clauses matter:** `no text, no logos, no watermark, no extra fingers, no lens flare,
  no floating glass shapes, no gradient mesh`.
- **Never prompt for text in the image.** Type is set in CSS, where it can be styled, translated,
  selected and read by a screen reader.

### 4. GENERATION — variations and consistency

- Generate **3–4 variations** for any hero or signature asset. First output is a draft, not a choice.
- Vary one axis at a time (light, or crop, or palette) — varying everything gives you four
  unrelated images and no information.
- **Consistency across a set:** `gemini_generate_image` is session-based. Keep one conversation
  for a whole image set so light and palette carry across; use `get_image_history` and reference
  `last` or `history:N` from `gemini_edit_image` to hold continuity. Start a *new* session
  (`clear_conversation`) when you deliberately change visual world.

### Aspect ratios

| Slot | Desktop | Tablet | Mobile |
|---|---|---|---|
| Full-bleed hero | `21:9` | `16:9` | `4:5` |
| Contained hero | `16:9` | `16:9` | `1:1` |
| Editorial / about | `3:2` | `3:2` | `4:5` |
| Product | `1:1` | `1:1` | `1:1` |
| Portrait | `4:5` | `4:5` | `4:5` |
| Background plate | `16:9` (generate wide, crop in CSS) | | |

Generate the **mobile crop as its own image** when the subject cannot survive the reframe. Do not
generate one 21:9 and squash it.

### 5. REVIEW — reject on these

Look at the output properly before accepting it. Reject and re-prompt if:

- ❌ Focal point sits where the headline goes
- ❌ Palette drifted to blue/purple/teal, or fights the design tokens
- ❌ Hands, faces, tools, or text are malformed — **zoom in and check**
- ❌ Reads as "AI image": glowing edges, impossible light, hyper-clean surfaces, floating geometry
- ❌ Lighting is flat or omnidirectional
- ❌ It could belong to any brand in the category
- ❌ Any text, watermark or pseudo-logo appears in frame

### 6. ITERATE

Use `gemini_edit_image` against the session's `last` image rather than regenerating from scratch —
it preserves what already worked. Change **one variable per iteration**; two changes and you
can't tell which one helped. Three failed iterations on the same axis means the prompt's
structure is wrong, not its adjectives — rewrite the brief.

### 7. OPTIMISE

Generated output is raw PNG and far too heavy to ship. Run it through the same pipeline as
sourced imagery: `optimize_local_image` (`imagebank` MCP) → WebP, resized to 2× the largest
rendered width. See `image-sourcing` §3.

Save to `public/images/<section>/<descriptive-name>.webp`.

### 8. INTEGRATE

`next/image` with explicit `width`/`height`, correct `sizes`, `priority` on the LCP image only,
`object-position` set to the focal point. Full pattern in `image-sourcing` §4.

Then record provenance in `public/images/image-sources.json`:

```json
{
  "file": "public/images/hero/kiln-mouth.webp",
  "source": "generated",
  "generator": "gemini (nanobanana-mcp)",
  "model": "pro",
  "prompt_summary": "kiln mouth, molten glass, hard practical amber light, 21:9, right negative space",
  "aspect_ratio": "21:9",
  "license": "original generated asset — no third-party rights",
  "attribution_required": false,
  "generated": "2026-08-22",
  "used_in": ["app/(marketing)/page.tsx — hero"]
}
```

Recording generated assets matters as much as licensed ones: it is how the set gets regenerated
consistently later, and how anyone reviewing the site knows which images are photographic
evidence and which are not.

---

## Security

- The API key lives in `.env` (git-ignored) or the shell environment. Nowhere else.
- Never paste a key into a prompt, a skill file, `.mcp.json`, a commit message, or a log.
- `.mcp.json` references `${GOOGLE_AI_API_KEY:-}` — an expansion, never a literal.
- Generated images are written into the repo. Check that no reference image you passed in
  contained confidential client material before committing.
