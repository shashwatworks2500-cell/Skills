# ARCHITECTURE

How this repository is put together, and why each decision was made. Read this before changing
the structure.

---

## Repository layout

```
.
├── .claude-plugin/
│   ├── plugin.json          Plugin manifest (name, version, MCP path)
│   └── marketplace.json     Makes this repo installable as a marketplace
│
├── skills/                  40 skills — the plugin's auto-discovered skill root
├── agents/                  design-review subagent
├── commands/                /design-plan, /design-review
│
├── .claude/
│   └── settings.json        Project permissions + enableAllProjectMcpServers
│
├── .mcp.json                playwright · chrome-devtools · shadcn
├── CLAUDE.md                The design constitution (25 sections, 15-stage workflow)
│
├── scripts/
│   ├── install.sh           Idempotent installer
│   ├── verify.sh            Verification, non-zero exit on critical failure
│   ├── update-skills.sh     Refresh vendored skills from upstream
│   └── design-audit.mjs     Standalone multi-viewport audit
│
├── docs/                    INSTALL · ARCHITECTURE · STACK · SETUP · WORKFLOW
├── licenses/                Upstream licences and attribution
├── STACK-MANIFEST.json      Machine-readable provenance for every component
├── NOTICE.md                Third-party attribution and the licensing caveat
└── .github/workflows/       CI design review
```

### Why `skills/` is at the repository root, not in `.claude/`

Claude Code's plugin spec allows custom paths for `commands`, `agents`, `hooks` and
`mcpServers`, **but not for `skills`** — skills are auto-discovered only from
`<plugin-root>/skills/`.

A symlink (`skills → .claude/skills`) was tested and rejected: `claude plugin validate` reports
that *component directories are read without following symlinks*, so the packaged plugin would
ship an empty skill set.

So the canonical plugin layout is the real layout, and there is exactly **one** copy of every
skill. `scripts/install.sh --into <dir>` copies them into a consumer project's `.claude/skills/`
when you want the project-scoped arrangement instead.

---

## The three-layer model

The stack separates *what to build* from *how it should feel* from *whether it actually works*.
Keeping these apart is what stops the output looking machine-generated.

| Layer | Component | Responsibility |
|---|---|---|
| **Knowledge** | `ui-ux-pro-max` | Tokens. 79 styles, 192 palettes, 74 font pairings, 119 UX guidelines, 17 GSAP presets, 22 stacks. Searchable offline via Python (stdlib only, no network). |
| **Taste** | `frontend-design` (Anthropic) | Attitude. Commits to one tone, rejects the safe centre of the training distribution. |
| **Feedback** | `playwright` + `chrome-devtools` MCP | Reality. Screenshots, interaction states, console, Lighthouse. |

The rule, from `CLAUDE.md`: **let `ui-ux-pro-max` set tokens, let `frontend-design` set
attitude.** Data for correctness, taste for distinctiveness. A stack with only the knowledge
layer produces correct but bland work; only the taste layer produces striking but inconsistent
work; without the feedback layer neither is verified.

---

## Vendored vs. external

This is the central architectural decision.

### Vendored (lives in this repository)

Pure content — markdown, CSV, Python — with permissive licences and no runtime.

| Component | Why vendored |
|---|---|
| `ui-ux-pro-max` + 6 companions | MIT. Static data + a stdlib Python search script. Pinning it makes the stack reproducible. |
| 32 Taste skills | MIT. Pure markdown instructions. |
| Stack foundation (`.mcp.json`, agent, commands, audit script, docs) | MIT. Configuration and a single Node script. |
| The constitution | Original work. |

### External (installed by `scripts/install.sh`)

| Component | Why not vendored |
|---|---|
| `frontend-design`, `feature-dev`, `code-review`, `claude-security` | Marketplace-managed plugins. Copying them forks them and breaks `claude plugin update`. Apache-2.0 would permit vendoring; the reason is technical, not legal. |
| `ponytail` | Ships Node lifecycle hooks and a statusline script. Only functions when installed as a plugin. |
| `claude-mem` | npm-distributed, with native dependencies, a Bun-managed worker daemon, SQLite, and a Chroma vector DB. Not meaningfully expressible as vendored files. |
| Playwright / Chrome DevTools / shadcn MCP | Resolved by `npx` at runtime from `.mcp.json`. Vendoring would pin stale server binaries. |

The repository never pretends to be self-contained. `install.sh` reinstalls every external
component from its official source, and `STACK-MANIFEST.json` records each one's upstream,
version, commit and install method.

---

## Deliberate exclusions

| Excluded | Reason |
|---|---|
| Taste's `ui-ux-pro-max` | Stale duplicate — 67 styles / 564K vs the official 79 styles / 3.6M. Only one authoritative copy is allowed; `verify.sh` enforces this. |
| Taste's `impeccable` | Its description claims every verb (`critique, polish, harden, optimize, adapt, animate…`), competing for triggering with all nine focused skills. Upstream also declares it a derivative of `frontend-design`, which the stack installs directly. |
| `playwright` / `chrome-devtools-mcp` plugins | The official Playwright plugin is a four-line wrapper registering `npx @playwright/mcp@latest` — identical to `.mcp.json`. Installing both would create duplicate MCP servers. |
| `security-guidance` plugin | Hooks-based passive scanner. `claude-security` provides the explicit review step the workflow needs. Can be added alongside if you want edit-time warnings. |
| Obsidian Second Brain | The project does not use Obsidian. |

`scripts/update-skills.sh` re-applies these exclusions on every run, so an upstream update
cannot silently reintroduce them.

---

## Known conflicts

**`skills/design` shadows the built-in Claude Design canvas skill.** Both are named `design`.
The vendored one (from the UI/UX Pro Max CLI) is a dispatcher with unique capabilities — logo
generation, corporate identity programs, banners, icons — and delegates to `design-system` and
`ui-styling` as external skills, so it is not a duplicate of its own companions.

It was kept rather than deleted because removing it would break the upstream package. If the
name collision is a problem for you:

```bash
rm -rf skills/design
```

Nothing else in the stack depends on it.

---

## The workflow as an architecture

`CLAUDE.md` defines a 15-stage pipeline. Stages map onto components:

```
RESEARCH ─────────────── /shape
INFORMATION ARCH ─────── /shape · ui-ux-pro-max --domain landing
DESIGN SYSTEM ────────── /design-plan · ui-ux-pro-max --design-system
VISUAL DIRECTION ─────── frontend-design · /high-end-visual-design
IMPLEMENTATION ───────── shadcn MCP
RESPONSIVE ───────────── /adapt
ANIMATION ────────────── /animate
ACCESSIBILITY ────────── /audit
PERFORMANCE ──────────── /optimize · chrome-devtools MCP (Lighthouse)
BROWSER QA ───────────── playwright MCP            ← hard gate
VISUAL CRITIQUE ──────── /design-review · /critique ← hard gate
POLISH ───────────────── /polish
CODE REVIEW ──────────── /code-review · /ponytail-review
SECURITY REVIEW ──────── claude-security
FINAL BUILD ──────────── typecheck · lint · build
```

The two hard gates exist because skipping them is precisely what makes AI-built interfaces look
AI-built. A change nobody looked at in a browser is not finished.

---

## Update model

| What | How | Cadence |
|---|---|---|
| Vendored skills | `./scripts/update-skills.sh` | When upstream ships something you want |
| External plugins | `claude plugin update <name>` | Independently, via the marketplace |
| MCP servers | Automatic — `@latest` in `.mcp.json` | Every session |
| The constitution | Edit `CLAUDE.md` | It is yours; tune it |

`STACK-MANIFEST.json` pins the upstream commit for every vendored component, so you can always
diff against what you have and see exactly what changed.
