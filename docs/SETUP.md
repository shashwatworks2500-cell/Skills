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

### 21st.dev MCP
Generates React components from a prompt. Configured in `.mcp.json` as the `21st` server —
an HTTP server authenticated by header, not a local `npx` process:

```json
"21st": {
  "type": "http",
  "url": "https://21st.dev/api/mcp",
  "headers": { "x-api-key": "${TWENTY_FIRST_API_KEY}" }
}
```

Get an API key at <https://21st.dev/settings/api-keys> and export it as `TWENTY_FIRST_API_KEY`.

The older `@21st-dev/magic` package is deprecated — it is now only a compatibility proxy for
old configs. Do not use it in new setups.

Requires egress to `21st.dev`. In a sandboxed environment with an allowlist proxy, that host
must be permitted or the server fails to connect.

Keep keys out of git — prefer `.claude/settings.local.json` or your shell env, both gitignored.

## Troubleshooting

- **`/mcp` shows a server failed** — run its command manually to see the error, e.g.
  `npx -y @playwright/mcp@latest`. Usually a Node version or network/proxy issue.
- **Audit can't find Chromium** — run `npx playwright install chromium`, or set
  `PW_EXECUTABLE_PATH` to your Chromium binary.
- **ui-ux-pro-max command not found** — re-run `npx ui-ux-pro-max-cli init --ai claude` and
  check the printed skill path; use that path in the `python3 …/search.py` commands.
