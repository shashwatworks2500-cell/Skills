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

### 21st.dev Magic MCP
Generates React components from a prompt. Get an API key at <https://21st.dev>, then add:

```json
"magic": { "command": "npx", "args": ["-y", "@21st-dev/magic@latest"], "env": { "API_KEY": "<your-key>" } }
```

Keep keys out of git — prefer `.claude/settings.local.json` or your shell env, both gitignored.

### Image-sourcing providers (Pexels / Unsplash / Pixabay)

The `image-sourcing` skill searches all three and falls through to the next on a missing key,
a non-2xx response, a connection failure, or zero results. Export whichever you have — none is
individually required, but with none of them the real-photography path is unavailable:

```bash
export PEXELS_API_KEY=...        # https://www.pexels.com/api/
export UNSPLASH_ACCESS_KEY=...   # https://unsplash.com/developers
export PIXABAY_API_KEY=...       # https://pixabay.com/api/docs/
```

Unsplash additionally requires attribution and a trigger of the `download_location` endpoint
when an image is used. Never commit a key; never hotlink a provider CDN in production.

### AI image generation (Gemini / Nano Banana)

```bash
export GOOGLE_AI_API_KEY=...     # https://aistudio.google.com/apikey
```

Image models: `gemini-2.5-flash-image` (fast), `gemini-3-pro-image` (quality). Image generation
is **not** on the free tier — a key with no billing returns HTTP 429
(`generate_content_free_tier_requests, limit: 0`) even though model listing succeeds. Enable
billing on the Google Cloud project behind the key before relying on generation.

### Component registries (React Bits / Aceternity / 21st.dev)

Fronted by the **shadcn MCP** — no extra MCP server needed. Copy `templates/components.json`
into your project and export the 21st.dev key if you use that registry:

```bash
export TWENTY_FIRST_API_KEY=...  # https://21st.dev
```

Verify a registry resolves before relying on it: `npx shadcn@latest view @react-bits`.

### Pinterest (visual research)

Public board and search research needs **no credentials** — drive it with the Playwright MCP.
The Pinterest v5 API additionally needs an OAuth app (register at `developers.pinterest.com`,
run the authorization-code flow, export `PINTEREST_ACCESS_TOKEN`). This stack ships no
Pinterest credentials and does not require them; Behance, Dribbble, Awwwards, Savee or Cosmos
substitute cleanly.

## Troubleshooting

- **`/mcp` shows a server failed** — run its command manually to see the error, e.g.
  `npx -y @playwright/mcp@latest`. Usually a Node version or network/proxy issue.
- **Audit can't find Chromium** — run `npx playwright install chromium`, or set
  `PW_EXECUTABLE_PATH` to your Chromium binary.
- **ui-ux-pro-max command not found** — re-run `npx ui-ux-pro-max-cli init --ai claude` and
  check the printed skill path; use that path in the `python3 …/search.py` commands.
