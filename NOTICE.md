# NOTICE — Third-Party Attribution

This repository vendors design skills authored by third parties. **None of the vendored skill
content is original work of this repository's maintainer.** Upstream licenses are preserved in
`licenses/`. Full machine-readable provenance is in `STACK-MANIFEST.json`.

---

## Vendored content

### UI/UX Pro Max and companion skills — MIT

- **Upstream:** https://github.com/nextlevelbuilder/ui-ux-pro-max-skill
- **Copyright:** © 2024 Next Level Builder
- **License:** MIT — `licenses/LICENSE.ui-ux-pro-max`
- **Installed via:** `ui-ux-pro-max-cli` v2.15.0 (npm), `uipro init --ai claude`
- **Upstream commit:** `bc826e2267a36d98a2dcf5231e16c30ff546770f`
- **Paths:** `skills/{ui-ux-pro-max,brand,design,design-system,ui-styling,banner-design,slides}/`

`skills/ui-styling/LICENSE.txt` (Apache-2.0) is an upstream-shipped per-skill license and is
preserved unmodified in place.

### Taste design skills — MIT

- **Upstream:** https://github.com/tyfarrago-hub/taste
- **Copyright:** © 2026 Ty Farrago
- **License:** MIT — `licenses/LICENSE.taste`
- **Upstream commit:** `acbb3e9c9051e096cb9e5e5cc1af88d56bc05459`
- **Paths:** 32 skill directories under `skills/` (see `STACK-MANIFEST.json`)

Upstream's own attribution file is preserved at `licenses/CREDITS.taste.md`.

---

## ⚠️ Known licensing caveat — please read

Taste's `CREDITS.md` states that **six** of its skills are vendored from the `taste-skill`
project by **lexnlin / learn2vibecode.dev** (GitHub: Leonxlnx), and that:

> "The upstream project ships no license file, so no formal license terms apply. These are
> included with attribution; contact for removal."

The six skills are:

| Skill | Originally |
|---|---|
| `design-taste-frontend` | `taste-skill` |
| `minimalist-ui` | `minimalist-skill` |
| `full-output-enforcement` | `output-skill` |
| `redesign-existing-projects` | `redesign-skill` |
| `industrial-brutalist-ui` | `brutalist-skill` |
| `high-end-visual-design` | `soft-skill` |

**What this means:** a work published without a license grants no redistribution permission by
default. Taste redistributes them with attribution and an offer of removal; this repository
inherits that same posture and the same unresolved status. This is flagged rather than hidden.

**If you intend to publish or commercially rely on this repository**, either obtain permission
from the original author (contacts per upstream: [x.com/lexnlin](https://x.com/lexnlin),
hello@learn2vibecode.dev) or remove those six directories:

```bash
rm -rf skills/{design-taste-frontend,minimalist-ui,full-output-enforcement,\
redesign-existing-projects,industrial-brutalist-ui,high-end-visual-design}
```

Removing them does not break the stack — no other skill depends on them.

`skills/impeccable` was **deliberately not vendored**: upstream declares it a derivative of
Anthropic's `frontend-design` skill, which this stack installs directly from source instead.

---

## Not vendored — installed from official sources

These are installed by `scripts/install.sh` from their official distribution channels. They are
**not** copied into this repository, so their licenses are not redistributed here; each is
governed by its own upstream license at its source.

| Component | Upstream | License |
|---|---|---|
| `frontend-design` | anthropics/claude-plugins-official | Apache-2.0 |
| `feature-dev` | anthropics/claude-plugins-official | Apache-2.0 |
| `code-review` | anthropics/claude-plugins-official | Apache-2.0 |
| `claude-security` | anthropics/claude-plugins-official | Apache-2.0 |
| `ponytail` | DietrichGebert/ponytail | MIT © 2026 DietrichGebert |
| `claude-mem` | thedotmack/claude-mem | Apache-2.0 |

---

## Original work in this repository

The following are original to this repository and are MIT-licensed (see `LICENSE`):

- `CLAUDE.md` — the web design constitution
- `skills/web-design-constitution/`
- `scripts/install.sh`, `scripts/verify.sh`, `scripts/update-skills.sh`
- `docs/INSTALL.md`, `docs/ARCHITECTURE.md`
- `README.md`, `STACK-MANIFEST.json`, this file

`scripts/design-audit.mjs`, `agents/design-review.md`, `commands/design-plan.md`,
`commands/design-review.md`, `docs/SETUP.md`, `docs/STACK.md`, `docs/WORKFLOW.md`, and
`.mcp.json` originate from the `stack/` directory of the UI/UX Pro Max repository (MIT, © 2024
Next Level Builder) and are covered by `licenses/LICENSE.ui-ux-pro-max`.
