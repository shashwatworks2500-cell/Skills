# Workflow — the design loop, end to end

The stack is built around one loop: **decide → plan → commit → build → see → review**.
Skipping "see" and "review" is what makes AI design look like AI design. Skipping "decide" —
the art-direction question of what a section should actually *show* — is what makes it look
like a template with stock photos on it. Here's the loop on two real tasks: one where the
answer is "no image", and one where it isn't.

## Example: "Build a pricing section for a developer tool"

### 1. Plan with data (`/design-plan` → `ui-ux-pro-max`)

```
> /design-plan developer tool pricing section, technical audience, trustworthy, high-contrast
```

Claude runs the design-system generator and pulls the palette, a font pairing, and the relevant
UX anti-patterns (e.g. "don't hide the total", "make the recommended plan obvious"). Output is a
compact token set — 4–6 colors, 2 type roles, spacing scale.

### 2. Commit to a look (`frontend-design`)

Claude answers *purpose / tone / constraints / differentiation*, picks ONE tone (say
"precise, engineered, monospace-accented"), and chooses a single signature element (a subtle
grid-paper background behind the recommended plan). It explicitly rejects the cream+serif and
acid-on-black defaults.

### 3. Build

Implements with the chosen tokens. On a React project it uses the **shadcn MCP** to add a
`card`, `toggle`, and `badge` rather than hand-rolling them.

### 4. See it (Playwright MCP) — the step that matters

```
> Open it at http://localhost:3000/pricing. Screenshot mobile (375) and desktop (1440).
> Toggle monthly/annual and check the focus states.
```

Claude opens the real page and catches what code review can't: the annual/monthly toggle has no
visible focus ring, the "Most popular" badge overlaps the card border at 375px, and a price
number animates in before the card scrolls into view. It fixes each and re-screenshots.

### 5. Review (`/design-review`)

```
> /design-review http://localhost:3000/pricing
```

The subagent drives all six viewport tiers, tabs through the whole section, checks contrast on
the muted "per month" text, and returns:

```
Verdict: Ship with fixes
Blockers: none
High: "per user / month" text is 3.9:1 on the card background (fails AA for body text)
Medium: CTA tap target is 40px tall on mobile (<44)
What's working: type scale is consistent; recommended-plan emphasis is clear
```

Claude fixes the High + Medium and the section is done — distinctive, responsive, accessible,
and actually verified.

## Example 2: "Build the hero and about sections for a glassblowing studio"

The pricing section above needed no imagery — pricing is a decision surface, and the framework
correctly answers **NO**. This one is the opposite case.

### 1. Brief, then art direction (`visual-art-direction`)

```
> /shape glassblowing studio site — commissions and workshops, premium but not precious
> Then run the image decision framework for hero, about, work, workshops, contact.
```

Claude produces the design brief, then the **image plan** — one row per section, each with a
defensible answer:

```
| Section   | Need? | Route    | Subject                    | Aspect (D/T/M) | Focal   | Motion   |
|-----------|-------|----------|----------------------------|----------------|---------|----------|
| Hero      | YES   | GENERATE | Kiln mouth, molten glass   | 21:9/16:9/4:5  | 38%/42% | parallax |
| About     | YES   | SOURCE   | Hands shaping at the bench | 3:2/3:2/4:5    | centre  | reveal   |
| Work      | YES   | CLIENT   | Real finished pieces       | 4:3 all        | centre  | none     |
| Workshops | NO    | —        | dates and prices are type  | —              | —       | —        |
| Contact   | NO    | —        | a map is not an image      | —              | —       | —        |
```

Two of five sections get no image. That is the framework working, not failing.

### 2. References (`pinterest-art-direction`)

```
> Look at my "material" and "workshop light" boards. What's the through-line?
```

Claude reads the boards and states it in one sentence — *"hard single-source light, deep
shadow, real grain, warm neutrals with one ember accent, nothing glossy"* — then converts that
into tokens and into the light/lens clauses the generator will need. **No pin is downloaded.**

### 3. Imagery (`image-generation`, `image-sourcing`)

Hero: `set_aspect_ratio("21:9")`, then a prompt that names the negative space
(*"deep negative space right of frame for a headline"*), the light source, and the palette
exclusions (*"no blue, no purple"*). Three variations, one chosen, one edit pass.

About: `search_images` with two query variants, five candidates compared on composition and
focal point, winner downloaded as WebP. Both land in `public/images/`, both recorded in
`image-sources.json` with licence and attribution.

### 4. Components (`interactive-components`)

The hero wants a text reveal and the work grid wants a gallery. Claude walks the hierarchy —
nothing in the project, nothing suitable in shadcn (these are motion, not primitives) — and
lands on React Bits via the shadcn registry, then strips the defaults and re-themes to the
studio's tokens. Motion budget: parallax + one text reveal. The cursor effect it found is
**not** added; that would be three systems on one viewport.

### 5. See it, then review

Same as steps 4–5 below — but now also: does the hero focal point survive the 4:5 mobile crop,
does the headline stay readable over the image, and does the page still work with
reduced-motion on and JavaScript off?

---

## The same loop for an existing site

Point the tools at what's already deployed:

```
> npm run audit -- --url https://your-site.com        # fast heuristic pass + screenshots
> /design-review https://your-site.com/pricing         # full review with taste + flows
```

## A worked audit on a production site

`examples/juniper-audit/` contains a real run of `scripts/design-audit.mjs` against a live
marketing site — the generated `report.md`, the per-viewport screenshots, and notes on how to
read the output. It's the fastest way to see what the heuristic layer catches before you wire
the stack into your own project.

## Rules of thumb

- **Never report UI work "done" without step 4.** If you didn't look at it, it isn't finished.
- **Let `ui-ux-pro-max` set tokens, `frontend-design` set attitude.** Data for correctness,
  taste for distinctiveness.
- **Art direction decides, imagery executes.** Never search or generate before you have written
  down what the image is *for*. Searching first and rationalising after is how stock pages happen.
- **"No image" is a real answer.** Two of five sections in the example above get none. A page
  where every section has a picture is as undirected as one with none.
- **Search before you build.** Project → shadcn → 21st → React Bits → Aceternity → custom. Then
  strip the registry's styling and re-theme to your tokens — that step is the whole point.
- **Budget the motion.** At most two major motion systems on one viewport. The third one you
  found is not a bonus.
- **Blockers/High gate merging; Medium/Nit don't.** Keep momentum; don't bikeshed nitpicks.
- **Re-screenshot after every fix.** The loop is cheap; regressions are not.
