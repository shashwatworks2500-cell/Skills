#!/usr/bin/env bash
# install.sh — set up the Ultimate Claude Code Web Design Stack.
#
# Idempotent: running it twice will not create duplicate skills, marketplaces, or plugins.
#
#   ./scripts/install.sh                  Activate the stack (this repo as a Claude Code plugin)
#   ./scripts/install.sh --into <dir>     Also copy skills + CLAUDE.md + .mcp.json into <dir>
#   ./scripts/install.sh --skip-plugins   Skip the external plugin installs (offline / restricted)
#   ./scripts/install.sh --refresh-skills Re-pull UI/UX Pro Max from its official CLI first
#
set -uo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
INTO=""
SKIP_PLUGINS=0
REFRESH_SKILLS=0
FAILED=()
SKIPPED=()
OK=()

while [ $# -gt 0 ]; do
  case "$1" in
    --into) INTO="${2:-}"; shift 2 ;;
    --skip-plugins) SKIP_PLUGINS=1; shift ;;
    --refresh-skills) REFRESH_SKILLS=1; shift ;;
    -h|--help) sed -n '2,12p' "$0"; exit 0 ;;
    *) echo "Unknown option: $1" >&2; exit 2 ;;
  esac
done

c_cyan()  { printf '\033[36m%s\033[0m\n' "$1"; }
c_green() { printf '\033[32m%s\033[0m\n' "$1"; }
c_red()   { printf '\033[31m%s\033[0m\n' "$1"; }
c_yellow(){ printf '\033[33m%s\033[0m\n' "$1"; }

step() { c_cyan "==> $1"; }
ok()   { OK+=("$1");      printf '    \033[32m✓\033[0m %s\n' "$1"; }
fail() { FAILED+=("$1");  printf '    \033[31m✗\033[0m %s\n' "$1"; }
skip() { SKIPPED+=("$1"); printf '    \033[33m–\033[0m %s\n' "$1"; }

# ── 1. Detect prerequisites ──────────────────────────────────────────────────
step "Checking prerequisites"
MISSING=0
for c in node npm npx git; do
  if command -v "$c" >/dev/null 2>&1; then ok "$c $("$c" --version 2>&1 | head -1)"
  else fail "$c not found"; MISSING=1; fi
done

if command -v claude >/dev/null 2>&1; then
  ok "claude $(claude --version 2>&1 | head -1)"
  HAVE_CLAUDE=1
else
  fail "claude CLI not found — plugin installation will be skipped"
  HAVE_CLAUDE=0
fi

if command -v python3 >/dev/null 2>&1; then
  ok "python3 $(python3 --version 2>&1)"
else
  fail "python3 not found — the ui-ux-pro-max search script needs it"
fi

NODE_MAJOR="$(node -p 'process.versions.node.split(".")[0]' 2>/dev/null || echo 0)"
if [ "$NODE_MAJOR" -lt 18 ] 2>/dev/null; then
  fail "Node 18+ required (found $NODE_MAJOR)"; MISSING=1
fi

if [ "$MISSING" -eq 1 ]; then
  c_red "Missing required tooling. Install Node 18+, npm and git, then re-run."
  exit 1
fi

# ── 2. Refresh UI/UX Pro Max from its official CLI (optional) ────────────────
if [ "$REFRESH_SKILLS" -eq 1 ]; then
  step "Refreshing UI/UX Pro Max from its official CLI"
  # Upstream README: the package is ui-ux-pro-max-cli. 'uipro-cli' is stale — do not use it.
  if npx --yes ui-ux-pro-max-cli@latest init --ai claude --force >/dev/null 2>&1; then
    # The CLI writes to .claude/skills/; fold those into the plugin's skills/ dir.
    if [ -d "$REPO_ROOT/.claude/skills" ]; then
      for d in "$REPO_ROOT"/.claude/skills/*/; do
        [ -d "$d" ] || continue
        rm -rf "$REPO_ROOT/skills/$(basename "$d")"
        mv "$d" "$REPO_ROOT/skills/"
      done
      rmdir "$REPO_ROOT/.claude/skills" 2>/dev/null || true
    fi
    ok "ui-ux-pro-max refreshed"
  else
    fail "ui-ux-pro-max refresh failed (network or npm issue) — existing vendored copy kept"
  fi
else
  skip "ui-ux-pro-max refresh (vendored copy in skills/ is used; pass --refresh-skills to update)"
fi

# ── 3. Activate this repo as a Claude Code plugin ────────────────────────────
if [ "$HAVE_CLAUDE" -eq 1 ]; then
  step "Activating the web-design-stack plugin from this repository"
  if claude plugin marketplace list 2>/dev/null | grep -q "web-design-stack"; then
    claude plugin marketplace update web-design-stack >/dev/null 2>&1
    ok "marketplace 'web-design-stack' already registered (refreshed)"
  elif claude plugin marketplace add "$REPO_ROOT" >/dev/null 2>&1; then
    ok "marketplace 'web-design-stack' added from $REPO_ROOT"
  else
    fail "could not register this repo as a marketplace"
  fi

  if claude plugin list 2>/dev/null | grep -q "web-design-stack@"; then
    ok "plugin 'web-design-stack' already installed"
  elif claude plugin install "web-design-stack@web-design-stack" --yes >/dev/null 2>&1; then
    ok "plugin 'web-design-stack' installed"
  else
    fail "could not install plugin 'web-design-stack'"
  fi
else
  skip "plugin activation (claude CLI unavailable)"
fi

# ── 4. External plugins from their official sources ──────────────────────────
# These are intentionally NOT vendored: they are marketplace-managed and must stay updatable.
add_marketplace() {  # $1 = marketplace name, $2 = source
  if claude plugin marketplace list 2>/dev/null | grep -q "^  > $1$"; then
    return 0
  fi
  claude plugin marketplace add "$2" >/dev/null 2>&1
}

install_plugin() {   # $1 = plugin@marketplace, $2 = label
  if claude plugin list 2>/dev/null | grep -q "^  > $1$"; then
    ok "$2 already installed"; return 0
  fi
  if claude plugin install "$1" --yes >/dev/null 2>&1; then ok "$2 installed"
  else fail "$2 failed to install"; fi
}

if [ "$HAVE_CLAUDE" -eq 1 ] && [ "$SKIP_PLUGINS" -eq 0 ]; then
  step "Installing official plugins (not vendored — installed from source)"

  add_marketplace "claude-plugins-official" "anthropics/claude-plugins-official" \
    && ok "marketplace anthropics/claude-plugins-official" \
    || fail "marketplace anthropics/claude-plugins-official"

  install_plugin "frontend-design@claude-plugins-official"  "frontend-design (taste layer)"
  install_plugin "feature-dev@claude-plugins-official"      "feature-dev"
  install_plugin "code-review@claude-plugins-official"      "code-review"
  install_plugin "claude-security@claude-plugins-official"  "claude-security"

  add_marketplace "ponytail" "DietrichGebert/ponytail" >/dev/null 2>&1
  install_plugin "ponytail@ponytail" "ponytail"

  # claude-mem: use the marketplace route. 'npx claude-mem install' can exit 0 while leaving
  # the plugin unloadable (it populates the marketplace dir via npm without marketplace.json).
  add_marketplace "thedotmack" "thedotmack/claude-mem" >/dev/null 2>&1
  install_plugin "claude-mem@thedotmack" "claude-mem"
else
  skip "external plugin installation"
fi

# ── 5. MCP servers ───────────────────────────────────────────────────────────
step "Checking MCP configuration"
if [ -f "$REPO_ROOT/.mcp.json" ]; then
  for s in playwright chrome-devtools shadcn; do
    if grep -q "\"$s\"" "$REPO_ROOT/.mcp.json"; then ok "MCP server '$s' declared"
    else fail "MCP server '$s' missing from .mcp.json"; fi
  done
  echo "    (Claude Code prompts to approve project MCP servers on first start in this directory.)"
else
  fail ".mcp.json not found"
fi

# ── 6. Audit dependencies ────────────────────────────────────────────────────
step "Installing audit dependencies (Playwright)"
if (cd "$REPO_ROOT" && npm install --silent >/dev/null 2>&1); then
  ok "npm dependencies installed"
  if npx playwright install chromium >/dev/null 2>&1; then ok "Chromium ready"
  else skip "Chromium install (already present or managed by the environment)"; fi
else
  fail "npm install failed"
fi

# ── 7. Optional: install into a separate project ─────────────────────────────
if [ -n "$INTO" ]; then
  step "Installing stack into project: $INTO"
  if [ ! -d "$INTO" ]; then
    fail "target directory does not exist: $INTO"
  else
    mkdir -p "$INTO/.claude/skills" "$INTO/.claude/agents" "$INTO/.claude/commands"
    # cp -R over an existing dir replaces it in place: idempotent, no duplicates.
    for d in "$REPO_ROOT"/skills/*/; do
      rm -rf "$INTO/.claude/skills/$(basename "$d")"
      cp -R "$d" "$INTO/.claude/skills/"
    done
    cp -R "$REPO_ROOT"/agents/.   "$INTO/.claude/agents/"   2>/dev/null || true
    cp -R "$REPO_ROOT"/commands/. "$INTO/.claude/commands/" 2>/dev/null || true
    ok "$(ls "$REPO_ROOT/skills" | wc -l | tr -d ' ') skills, agents and commands copied"

    if [ -f "$INTO/CLAUDE.md" ]; then
      skip "CLAUDE.md exists in target — not overwritten (see $REPO_ROOT/CLAUDE.md to merge)"
    else
      cp "$REPO_ROOT/CLAUDE.md" "$INTO/CLAUDE.md"; ok "CLAUDE.md installed"
    fi

    if [ -f "$INTO/.mcp.json" ]; then
      skip ".mcp.json exists in target — not overwritten (merge the seven servers manually)"
    else
      cp "$REPO_ROOT/.mcp.json" "$INTO/.mcp.json"; ok ".mcp.json installed"
    fi

    # Environment template for the four credentialed MCP servers. Never copy a real .env.
    if [ -f "$INTO/.env.example" ]; then
      skip ".env.example exists in target — not overwritten"
    else
      cp "$REPO_ROOT/.env.example" "$INTO/.env.example" && ok ".env.example installed (cp to .env and fill in)"
    fi
    if [ -f "$INTO/.gitignore" ] && ! grep -qE '^\.env$' "$INTO/.gitignore"; then
      printf '\n# Env / secrets (added by web-design-stack)\n.env\n.env.*\n!.env.example\n' >> "$INTO/.gitignore"
      ok ".env added to target .gitignore"
    fi

    mkdir -p "$INTO/scripts"
    cp "$REPO_ROOT/scripts/design-audit.mjs" "$INTO/scripts/" && ok "design-audit.mjs installed"
  fi
fi

# ── 8. Verify ────────────────────────────────────────────────────────────────
step "Running verification"
if [ -x "$REPO_ROOT/scripts/verify.sh" ]; then
  "$REPO_ROOT/scripts/verify.sh" || fail "verification reported problems"
else
  fail "scripts/verify.sh missing or not executable"
fi

# ── 9. Report ────────────────────────────────────────────────────────────────
echo
c_cyan "════════════════════ INSTALL SUMMARY ════════════════════"
printf '  %-10s %d\n' "OK:"      "${#OK[@]}"
printf '  %-10s %d\n' "Skipped:" "${#SKIPPED[@]}"
printf '  %-10s %d\n' "Failed:"  "${#FAILED[@]}"
if [ "${#FAILED[@]}" -gt 0 ]; then
  echo
  c_red "Failures:"
  for f in "${FAILED[@]}"; do echo "  ✗ $f"; done
  echo
  c_yellow "The stack is partially installed. Re-run this script after fixing the above."
  exit 1
fi
echo
c_green "PROFESSIONAL WEBSITE DESIGN STACK READY"
echo
echo "  Restart Claude Code in this directory, then try:"
echo "    /design-plan portfolio site for a photographer, editorial and minimal"
echo "    /website"
echo "    /design-review http://localhost:3000"
echo
echo "  Image sourcing, image generation and 21st need API keys to do anything:"
echo "    cp .env.example .env    then fill in only what you need"
echo "  Pinterest uses browser OAuth on first use — no key required."
echo "  Everything else works with no secrets at all."
echo
echo "  Docs: docs/INSTALL.md · docs/ARCHITECTURE.md · docs/WORKFLOW.md · docs/GAP-REPORT.md"
