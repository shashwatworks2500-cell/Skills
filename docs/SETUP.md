> **Note — adapted for this repository.** This document is vendored from the upstream
> UI/UX Pro Max `stack/` directory and kept close to the original. Its
> `/plugin install ...@anthropics/claude-code` commands use an obsolete marketplace path,
> and the `/plugin` slash command is unavailable in some environments. Use
> [INSTALL.md](INSTALL.md) or `scripts/install.sh`, which use the current
> `anthropics/claude-plugins-official` marketplace via the `claude plugin` CLI.

# Setup

## Prerequisites

- **Node 18+** and **Python 3.x**
- **Claude Code** with plugins enabled (run `/plugin` once to enable)

## 1. One-shot setup

```bash
./scripts/setup.sh
```

This installs the audit dependencies (Playwright + Chromium) and the `ui-ux-pro-max` skill,
then prints the two steps that must happen inside Claude Code.

## 2. Install the taste plugin (inside Claude Code)

```
/plugin install frontend-design@anthropics/claude-code
```

## 3. Approve the MCP servers

Open Claude Code in this directory. It reads `.mcp.json` and prompts you to approve the project
MCP servers (**playwright**, **chrome-devtools**, **shadcn**). Approve them. `.claude/settings.json`
already sets `enableAllProjectMcpServers: true`, so they load on start. Verify with `/mcp`.

That's it — `CLAUDE.md` defines the design loop and loads automatically.

## Verify it works

```
> /design-plan portfolio site for a photographer, editorial and minimal
> Build the hero, then screenshot it at 375px and 1440px and fix anything that breaks.
> /design-review http://localhost:3000
```

You should see Claude pull tokens from `ui-ux-pro-max`, open a browser, screenshot, and return
ranked findings.

## Standalone audit (no Claude needed)

```bash
npm run audit -- --url http://localhost:3000
npm run audit -- --file ./index.html
```

Outputs `audit-output/report.md` + per-viewport screenshots. Exit code is non-zero when there
are high-severity findings (useful for CI — see `.github/workflows/design-review.yml`).

---

## Optional add-ons

### Figma Dev Mode MCP
Requires the Figma desktop app. Enable Dev Mode → toggle the MCP server on. Then add to
`.mcp.json`:

```json
"figma": { "url": "http://127.0.0.1:3845/mcp" }
```

Guide: <https://help.figma.com/hc/en-us/articles/39888612464151-Claude-Code-and-Figma-Set-up-the-MCP-server>

> **21st.dev is no longer an optional add-on** — it ships in the default `.mcp.json` as the
> current unified 21st MCP (`https://21st.dev/api/mcp`). The old `@21st-dev/magic` package is a
> deprecated compatibility proxy upstream and old Magic API keys were reset; do not use it.
> See [API keys](INSTALL.md#api-keys).

---

## API keys

Four of the seven MCP servers take credentials. Copy the template and fill in only what you need
— every server degrades gracefully when its key is absent:

```bash
cp .env.example .env      # .env is git-ignored
```

| Server | Variable | Get it at |
|---|---|---|
| `imagebank` | `PEXELS_API_KEY` / `UNSPLASH_ACCESS_KEY` / `PIXABAY_API_KEY` (≥1) | pexels.com/api · unsplash.com/developers · pixabay.com/api/docs |
| `nanobanana` | `GOOGLE_AI_API_KEY` | aistudio.google.com/apikey |
| `21st` | `TWENTY_FIRST_API_KEY` | 21st.dev/mcp |
| `pinterest` | *(none — browser OAuth)* | — |

**Never put a key in a tracked file.** `.mcp.json` carries `${VAR}` expansions only, and
`scripts/verify.sh` fails if a literal value appears there or if a credential-shaped string lands
in any tracked file. For per-machine overrides use your shell env or
`.claude/settings.local.json` — both gitignored.

Full detail, including the Pinterest OAuth and self-hosting flow:
[`docs/INSTALL.md`](INSTALL.md#api-keys).

## Troubleshooting

- **`/mcp` shows a server failed** — run its command manually to see the error, e.g.
  `npx -y @playwright/mcp@latest`. Usually a Node version or network/proxy issue.
- **Audit can't find Chromium** — run `npx playwright install chromium`, or set
  `PW_EXECUTABLE_PATH` to your Chromium binary.
- **ui-ux-pro-max command not found** — re-run `npx ui-ux-pro-max-cli init --ai claude` and
  check the printed skill path; use that path in the `python3 …/search.py` commands.
