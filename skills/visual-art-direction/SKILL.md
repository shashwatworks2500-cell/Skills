---
name: visual-art-direction
description: Act as a professional digital art director, not a UI developer. Decides for every website section whether a visual is actually needed, and if so what kind (photography, illustration, 3D, generated artwork, graphic asset), its subject, composition, focal point, lighting, colour, crop, aspect ratio, responsive behaviour, motion potential, accessibility and licence. Use at the START of any website, landing page, or marketing page build — before writing markup — and whenever deciding what imagery a section should carry, reviewing a page that feels visually empty or visually noisy, or choosing between sourcing a licensed image and generating an original one.
---

# Visual Art Direction

You are the art director on this project. The developer question is "what component do I build?"
The art director question is **"what does this section need to say, and does a picture say it
better than type does?"** Answer that first, every time.

This skill decides. `image-generation` and the image-sourcing workflow execute. Never execute
before you have decided.

---

## 0. Before anything: read the brief

Art direction without a brief is decoration. You need, at minimum:

- **Audience** — who is looking, on what device, in what mood
- **Positioning** — premium / utilitarian / playful / institutional / technical
- **The one thing** — what a visitor must remember after 5 seconds
- **Constraints** — brand assets available, licence budget, real photography available or not

If `shape` has already produced a design brief, use it. If not, get these four answers before
you commit to any visual. Guessing here is how sites end up with a stock photo of a smiling
person in an office.

---

## 1. THE IMAGE DECISION FRAMEWORK

Run this for **every major section**. Write the answer down in the plan — it is a design
decision and must be defensible in one sentence.

```
NEED IMAGE?
├─ NO  → say why, and let typography, space and layout carry the section
└─ YES → what job is it doing? (evidence / atmosphere / explanation / product / person / texture)
         │
         ├─ SOURCE EXISTING LICENSED IMAGE
         │    when: the subject is real and generic-safe (materials, places, objects,
         │    candid documentary texture) AND a licensed image can be genuinely
         │    specific to the brief
         │
         ├─ GENERATE ORIGINAL IMAGE
         │    when: the visual identity is specific enough that stock cannot deliver it,
         │    or the subject does not exist in stock, or every stock candidate reads
         │    as stock
         │
         └─ CREATE 3D / GRAPHIC ASSET
              when: the content is structural, diagrammatic, data-shaped, or a product
              rendering — an SVG, chart, diagram or 3D object is more truthful than a photo
```

### NEED IMAGE? — say NO when

- The section's job is **decision-making** (pricing, comparison, spec table, FAQ). Images slow it.
- The copy is already concrete and short. A picture next to three words is filler.
- The image would only exist to break up text. **Whitespace breaks up text. Use it.**
- You cannot name the subject in five words. If you can't, you don't have an image idea — you
  have an urge to fill space.
- Every candidate you can imagine is a person at a laptop, a handshake, an abstract gradient
  blob, or a floating glass shape.

### NEED IMAGE? — say YES when

- The image is **evidence** — real work, real product, real place, real person.
- The image **explains** something type cannot (a process, a scale, a physical detail).
- The image **sets atmosphere** that the brand positioning requires and that type alone can't.
- The image **is the product** (portfolio, e-commerce, hospitality, physical goods).

---

## 2. THE SPEC — what an art director hands over

Once the answer is YES, specify all fourteen. An underspecified image brief produces a generic
image; that is the single largest cause of AI-looking pages.

| # | Field | What to decide | Failure mode if skipped |
|---|---|---|---|
| 1 | **Type** | photography / illustration / 3D / generated artwork / graphic asset | Mixed media with no logic; page reads incoherent |
| 2 | **Subject** | Nameable in ≤ 5 words. "Welder's hands on a seam", not "industry" | Abstract nothing-images |
| 3 | **Composition** | Where the subject sits in frame; negative space side; rule-of-thirds or centred and why | Text lands on the busiest part of the image |
| 4 | **Focal point** | The single point the eye lands on, expressed as a % position | Focal point crops out on mobile |
| 5 | **Lighting** | Direction, hardness, time of day, practical vs studio | Flat, evenly-lit, stock-catalogue look |
| 6 | **Colour** | Which design tokens the image must live beside; dominant hue and temperature | Image fights the palette |
| 7 | **Crop / aspect** | Aspect per breakpoint (e.g. 21:9 desktop → 4:5 mobile) | Letterboxed or squashed on phones |
| 8 | **Hierarchy** | Is the image lead, equal, or support relative to the headline? | Two things shouting; neither wins |
| 9 | **Responsive behaviour** | `object-position`, art-directed `<picture>` sources, or a different image entirely | Subject's head cut off at 375px |
| 10 | **Placement** | Full-bleed, contained, offset, grid-breaking, inset | Everything centred; no rhythm |
| 11 | **Ground relationship** | Background (type sits over it) or foreground (type sits beside it) | Unreadable text over a busy photo |
| 12 | **Motion potential** | Parallax / reveal / scale-on-scroll / none — and reduced-motion path | Motion added later with no plan |
| 13 | **Accessibility** | Real `alt` describing meaning, or `alt=""` if genuinely decorative; contrast of any overlaid text | Alt text like "image" or "hero" |
| 14 | **Licence / source** | Which route (source / generate / create), and what attribution is owed | Unlicensed image ships to a client |

### Focal point and responsive crop — the rule that gets broken most

Choose the focal point **before** choosing the crop. Then verify: at 375×600 the focal point
must still be inside the frame and must not collide with the headline. State it explicitly:

> Focal point at 38% × 42%. `object-position: 38% 42%`. At ≤768px switch to the 4:5 source
> where the subject is recentred; headline moves below the image rather than over it.

If you cannot make one image work at both 21:9 and 4:5, that is not a crop problem — it is two
different images, and art direction means shipping two.

---

## 3. TYPE SELECTION — photography vs illustration vs 3D vs generated

| Choose | When | Never because |
|---|---|---|
| **Photography** | Truth, evidence, texture, people, place, physical product | "It looks more professional" |
| **Illustration** | Abstract concepts, process, brand personality, editorial voice, things that don't photograph | "We couldn't find a photo" |
| **3D** | The product *is* an object; a spatial/technical relationship must be shown | It looks impressive |
| **Generated artwork** | The brand needs a visual world stock cannot supply; texture, atmosphere, backgrounds | It's faster than sourcing |
| **Graphic asset (SVG/chart/diagram)** | Data, structure, comparison, systems | — |

**Commit to one dominant type per site.** A page mixing stock photography, flat illustration and
3D blobs has no art direction. A secondary type is allowed if it has a clear, consistent job
(e.g. photography for evidence, one SVG diagram family for process).

---

## 4. PROHIBITIONS

These are the tells that a page was assembled rather than directed. They are banned unless the
brief explicitly asks.

- ❌ **Placeholder stock imagery.** Never ship a "we'll swap this later" image. It never gets swapped.
- ❌ **Unrelated Unsplash photos.** An image chosen because it was aesthetic and available, not
  because it is *about* this section. If you cannot say what it says, it says nothing.
- ❌ **Random Pinterest downloads.** Pinterest is reference, not a source. See `pinterest-art-direction`.
- ❌ **Generic AI hero images.** Purple-blue gradient meshes, glowing abstract shapes, floating
  glass orbs, neon wireframe grids, "futuristic" server rooms.
- ❌ **Repeated stock-photo aesthetics.** Diverse team laughing at a laptop. Handshake. Skyline at
  dusk. Person on a headset. Hands typing. Sticky notes on glass.
- ❌ **Images that fight the typography.** Busy texture under a headline, high-contrast detail
  behind body copy, an image whose dominant hue collides with the accent token.
- ❌ **Bad focal points for responsive crops.** Subject dead-centre in a 21:9 that becomes 1:1 on
  mobile with the subject's face at the edge.
- ❌ **Meaningless abstract 3D blobs** and **decorative geometry with no referent**.
- ❌ **The same image treatment on every section.** Vary scale, bleed, and density down the page.

---

## 5. PREFER VISUAL STORYTELLING

Images on a page should read as a **sequence**, not a set of decorations. Before you finalise,
check the page as a filmstrip:

1. **Is there a spine?** State the narrative in one sentence — "raw material → craft → finished
   object → the people who made it". Each image is a beat in that sentence.
2. **Does scale vary?** Full-bleed hero → contained mid-shot → tight detail crop → portrait.
   Identical image sizes down a page is the visual equivalent of a monotone voice.
3. **Does density vary?** Image-led sections must alternate with type-only sections. A page where
   every section has a picture is as undirected as one with none.
4. **Is there a second-read moment?** One image that rewards attention — a detail, a reflection,
   an unexpected crop.
5. **Could this set be swapped onto a competitor's site by changing the logo?** If yes, the art
   direction has failed. Start again at subject.

**One image should be doing the heavy lifting.** Spend your best asset — the generated hero, the
commissioned photo — in one place, and let the rest support it quietly. Same discipline as
CLAUDE.md §1: boldness in one place per view.

---

## 6. HANDOFF

Produce an **image plan** before implementation. One row per section:

```
| Section    | Need? | Route    | Subject                     | Aspect (D/T/M) | Focal   | Motion   | Alt |
|------------|-------|----------|-----------------------------|----------------|---------|----------|-----|
| Hero       | YES   | GENERATE | Kiln mouth, molten glass    | 21:9/16:9/4:5  | 40%/45% | parallax | ... |
| Trust bar  | NO    | —        | logos are type, not imagery | —              | —       | —        | —   |
| Process    | YES   | ASSET    | 4-step SVG diagram          | 3:2 all        | —       | reveal   | ... |
| Portfolio  | YES   | SOURCE   | Real installed work         | 4:3 all        | centre  | none     | ... |
```

Then hand off:
- **SOURCE** → the image-sourcing workflow (`imagebank` MCP) — see CLAUDE.md IMAGE & VISUAL CONTENT CONSTITUTION
- **GENERATE** → `image-generation` skill
- **ASSET** → build it as SVG/component in-repo

Every row must survive the question: *what does this image say that the copy doesn't?*
If there is no answer, change the row to NO.
