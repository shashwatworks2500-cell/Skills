# INSTALL — using this stack in a Claude Code project

This repository is a **Claude Code plugin distribution**. It is not a snapshot of `~/.claude`;
it is a self-contained, version-controlled stack you can install into any project.

There are two ways to use it. Pick one.

---

## Option A — Install as a plugin (recommended)

Best when you want the stack available across projects and updatable with one command. The
skills stay in this repository; nothing is copied into your project.

```bash
# 1. Register this repository as a Claude Code marketplace
claude plugin marketplace add shashwatworks2500-cell/Skills

# 2. Install the stack
claude plugin install web-design-stack@web-design-stack

# 3. Install the external plugins that are not vendored here
claude plugin marketplace add anthropics/claude-plugins-official
claude plugin install frontend-design@claude-plugins-official
claude plugin install feature-dev@claude-plugins-official
claude plugin install code-review@claude-plugins-official
claude plugin install claude-security@claude-plugins-official

claude plugin marketplace add DietrichGebert/ponytail
claude plugin install ponytail@ponytail

claude plugin marketplace add thedotmack/claude-mem
claude plugin install claude-mem@thedotmack
```

Then restart Claude Code.

**Two things Option A does not do**, because plugins cannot provide them:

1. **`CLAUDE.md` is not installed as project context.** A plugin cannot write your project's
   `CLAUDE.md`. The rules are still available — the `web-design-constitution` skill points to
   them — but for the constitution to load automatically as project context, copy it in:
   ```bash
   curl -fsSL https://raw.githubusercontent.com/shashwatworks2500-cell/Skills/main/CLAUDE.md \
     -o CLAUDE.md
   ```
2. **MCP servers need a project `.mcp.json`.** The plugin declares them, but if you want them
   project-scoped and reviewable, copy `.mcp.json` into your project root (see Option B).

To update later:
```bash
claude plugin update web-design-stack
```

---

## Option B — Clone and install into a project

Best when you want everything version-controlled inside your own project, or you want to
customise the skills.

```bash
# 1. Clone this repository somewhere outside your project
git clone https://github.com/shashwatworks2500-cell/Skills.git web-design-stack
cd web-design-stack

# 2. Install into your project
./scripts/install.sh --into /path/to/your-project
```

That copies into `/path/to/your-project`:

| What | Where it lands |
|---|---|
| 40 skills | `.claude/skills/` |
| `design-review` agent | `.claude/agents/` |
| `/design-plan`, `/design-review` | `.claude/commands/` |
| The constitution | `CLAUDE.md` *(not overwritten if one exists)* |
| MCP servers | `.mcp.json` *(not overwritten if one exists)* |
| Multi-viewport audit | `scripts/design-audit.mjs` |

It also installs the external plugins listed in Option A.

**Idempotent** — run it as many times as you like. Skill directories are replaced in place, so
you never get duplicates. Existing `CLAUDE.md` and `.mcp.json` are never overwritten; the script
tells you to merge manually instead.

---

## Option C — Activate the stack in this repository itself

To use this repo as your working project:

```bash
./scripts/install.sh
```

This registers the repo as a local marketplace, installs the plugin from it, installs the
external plugins, installs the audit dependencies, and runs verification.

---

## Verify

```bash
./scripts/verify.sh
```

Checks every skill, agent, command, MCP server, plugin, and the repository hygiene rules
(no secrets, no `node_modules`, no memory database, no duplicate UI/UX Pro Max). **Exits
non-zero if a critical component is missing**, so it works in CI:

```yaml
- run: ./scripts/verify.sh
```

Expected tail on success:

```
✓ PROFESSIONAL WEBSITE DESIGN STACK VERIFIED
```

---

## API keys

Four of the seven MCP servers need credentials. **Copy the template and fill in only what you
need** — every server degrades gracefully when its key is absent, and the rest of the stack is
unaffected.

```bash
cp .env.example .env      # .env is git-ignored — never commit it
```

| Capability | Server | Variable | Where to get it |
|---|---|---|---|
| Image search | `imagebank` | `PEXELS_API_KEY` | https://www.pexels.com/api/ — free, no attribution required |
| | | `UNSPLASH_ACCESS_KEY` | https://unsplash.com/developers — free, **on-site attribution required** |
| | | `PIXABAY_API_KEY` | https://pixabay.com/api/docs/ — free, no attribution required |
| Image generation | `nanobanana` | `GOOGLE_AI_API_KEY` | https://aistudio.google.com/apikey — free tier available |
| Component discovery | `21st` | `TWENTY_FIRST_API_KEY` | https://21st.dev/mcp |
| Pinterest references | `pinterest` | *(none)* | Browser OAuth on first use — see below |

**At least one** image-search key is required for `search_images` to return results; the server
prints which providers it found on startup. `GEMINI_API_KEY` is accepted as an alias for
`GOOGLE_AI_API_KEY`.

**21st:** keys issued by the old *Magic* console were reset upstream and no longer work — you
need a current 21st key. `npx @21st-dev/cli@latest init --client claude` is an interactive
alternative that writes the server entry for you.

**Pinterest authentication** works by OAuth, not by an API key. The default `.mcp.json` entry
points at the maintainer's hosted Cloudflare Worker; on first use Claude Code opens a browser
consent screen where you authorise access to *your own* Pinterest account. The worker holds the
token server-side (encrypted KV) and the session carries a bearer token — **no Pinterest
credential ever enters this repository**. Unauthenticated calls return `401 invalid_token`,
which is the expected state until you connect.

For client work, self-host instead so you control the token store: fork
`what-name/pinterest-mcp`, register an app at developers.pinterest.com, deploy with Wrangler, set
`PINTEREST_CLIENT_ID`, `PINTEREST_CLIENT_SECRET` and `COOKIE_ENCRYPTION_KEY` as **Wrangler
secrets** (`wrangler secret put …`, never committed), and point the `url` in `.mcp.json` at your
worker.

**Never commit a key.** `.gitignore` covers `.env` and `.env.*` (with `!.env.example`);
`.mcp.json` only ever contains `${VAR}` expansions, and `scripts/verify.sh` fails the build if a
literal value appears there or if a credential-shaped string lands in any tracked file.

---

## Approve the MCP servers

On first start in a directory containing `.mcp.json`, Claude Code prompts you to approve the
project MCP servers (**playwright**, **chrome-devtools**, **shadcn**, **imagebank**,
**nanobanana**, **21st**, **pinterest**). Approve them.
`.claude/settings.json` sets `enableAllProjectMcpServers: true` so they load on subsequent
starts. Confirm with `/mcp`.

If a server fails, run its command by hand to see the error:

```bash
npx -y @playwright/mcp@latest
npx -y imagebank-mcp@1.0.0          # prints which image providers are configured
npx -y @ycse/nanobanana-mcp@1.1.1   # errors if GOOGLE_AI_API_KEY is unset
```

Usually a Node version or a network/proxy problem. For the two HTTP servers (`21st`,
`pinterest`), a `401` is authentication, not a failure — set the key or complete the OAuth flow.

---

## Start building

```
> /design-plan portfolio site for a photographer, editorial and minimal
> /website
> Build the hero, then screenshot it at 375px and 1440px and fix anything that breaks.
> /design-review http://localhost:3000
```

Standalone audit without Claude:

```bash
npm install
npm run audit -- --url http://localhost:3000
npm run audit -- --file ./index.html
```

Writes `audit-output/report.md` plus per-viewport screenshots, and exits non-zero on
high-severity findings — useful in CI (see `.github/workflows/design-review.yml`).

---

## Update the stack

```bash
./scripts/update-skills.sh              # refresh vendored skills from upstream
./scripts/update-skills.sh --dry-run    # preview changes first
./scripts/update-skills.sh --uipro      # only UI/UX Pro Max
./scripts/update-skills.sh --taste      # only Taste
```

The updater re-applies the exclusion rules on every run, so an upstream change can never
reintroduce taste's stale `ui-ux-pro-max` duplicate or the overlapping `impeccable` skill. It
refreshes the vendored licences, records the new upstream commit in `STACK-MANIFEST.json`, and
re-runs verification. Roll back with `git checkout -- skills/`.

External plugins update through Claude Code:

```bash
claude plugin update frontend-design
claude plugin update ponytail
```

---

## Requirements

| Tool | Minimum | Why |
|---|---|---|
| Node | 18+ | MCP servers, audit script |
| npm / npx | any current | package resolution |
| Python | 3.x | `ui-ux-pro-max` search engine (stdlib only, no network) |
| git | any current | cloning, plugin marketplaces |
| Claude Code | current | plugins, skills, MCP |

---

## Troubleshooting

**Skills don't appear.** Restart Claude Code. Then `claude plugin list` — the stack should show
`web-design-stack@web-design-stack · √ enabled`. If it says *failed to load*, run
`claude plugin validate .` from the repo root.

**`claude-mem` shows "failed to load".** Its npm installer can exit 0 while leaving the
marketplace directory without a `.claude-plugin/marketplace.json`. Fix:
```bash
claude plugin marketplace update thedotmack
claude plugin install claude-mem@thedotmack --yes
```

**`ui-ux-pro-max` search says "command not found".** Run
`python3 skills/ui-ux-pro-max/scripts/search.py "test" --domain style` from the repo root and
use the path it reports.

**Do not install `uipro-cli`.** The correct npm package is `ui-ux-pro-max-cli`. Upstream
states that older `uipro-cli` releases are stale and ship outdated assets.
