#!/usr/bin/env bash
# verify.sh — verify the Ultimate Claude Code Web Design Stack is correctly installed.
#
# Exits non-zero if any CRITICAL component is missing.
# Warnings (non-critical) do not affect the exit status.
#
#   ./scripts/verify.sh            Full verification
#   ./scripts/verify.sh --quiet    Only print failures and the summary
#
set -uo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$REPO_ROOT"

QUIET=0
[ "${1:-}" = "--quiet" ] && QUIET=1

PASS=0; FAILN=0; WARN=0

pass() { PASS=$((PASS+1)); [ "$QUIET" -eq 1 ] || printf '  \033[32m✓\033[0m %s\n' "$1"; }
fail() { FAILN=$((FAILN+1));           printf '  \033[31m✗\033[0m %s\n' "$1"; }
warn() { WARN=$((WARN+1));  [ "$QUIET" -eq 1 ] || printf '  \033[33m!\033[0m %s\n' "$1"; }
head_() { [ "$QUIET" -eq 1 ] || printf '\n\033[36m%s\033[0m\n' "$1"; }

have_claude=0
command -v claude >/dev/null 2>&1 && have_claude=1

# ── Core files ───────────────────────────────────────────────────────────────
head_ "Core files"
for f in CLAUDE.md .mcp.json STACK-MANIFEST.json NOTICE.md README.md .gitignore \
         .claude-plugin/plugin.json .claude-plugin/marketplace.json; do
  [ -f "$f" ] && pass "$f" || fail "$f missing"
done
jq -e . .claude-plugin/plugin.json      >/dev/null 2>&1 && pass "plugin.json is valid JSON"      || fail "plugin.json invalid JSON"
jq -e . .claude-plugin/marketplace.json >/dev/null 2>&1 && pass "marketplace.json is valid JSON" || fail "marketplace.json invalid JSON"
jq -e . STACK-MANIFEST.json             >/dev/null 2>&1 && pass "STACK-MANIFEST.json is valid JSON" || fail "STACK-MANIFEST.json invalid JSON"

# ── UI/UX Pro Max ────────────────────────────────────────────────────────────
head_ "UI/UX Pro Max (knowledge layer)"
if [ -f skills/ui-ux-pro-max/SKILL.md ]; then
  pass "skills/ui-ux-pro-max/SKILL.md"
  [ -f skills/ui-ux-pro-max/scripts/search.py ] && pass "search.py present" || fail "search.py missing"
  [ -d skills/ui-ux-pro-max/data ] && pass "data/ present ($(ls skills/ui-ux-pro-max/data | wc -l | tr -d ' ') files)" \
    || fail "data/ missing"
  if command -v python3 >/dev/null 2>&1; then
    if python3 skills/ui-ux-pro-max/scripts/search.py "editorial" --domain style --max-results 1 >/dev/null 2>&1; then
      pass "search engine runs and returns results"
    else
      fail "search engine failed to execute"
    fi
  else
    warn "python3 unavailable — cannot exercise the search engine"
  fi
else
  fail "skills/ui-ux-pro-max/SKILL.md missing (CRITICAL)"
fi

# ── No duplicate UI/UX Pro Max ───────────────────────────────────────────────
head_ "Duplicate checks"
UIPRO_COUNT=$(find . -type d -name "ui-ux-pro-max" -not -path "./node_modules/*" -not -path "./.git/*" | wc -l | tr -d ' ')
if [ "$UIPRO_COUNT" -eq 1 ]; then pass "exactly one ui-ux-pro-max installation"
else fail "$UIPRO_COUNT ui-ux-pro-max directories found (must be exactly 1)"; fi

[ -d skills/impeccable ] && fail "skills/impeccable present — conflicts with frontend-design" \
                         || pass "taste's 'impeccable' correctly excluded"

DUPES=$(for d in skills/*/; do basename "$d"; done | sort | uniq -d)
[ -z "$DUPES" ] && pass "no duplicate skill names" || fail "duplicate skill names: $DUPES"

for s in playwright chrome-devtools shadcn; do
  n=$(jq -r --arg s "$s" '.mcpServers | keys[] | select(.==$s)' .mcp.json 2>/dev/null | wc -l | tr -d ' ')
  [ "$n" -eq 1 ] && pass "MCP '$s' declared exactly once" || fail "MCP '$s' declared $n times"
done

# ── Skills ───────────────────────────────────────────────────────────────────
head_ "Skills"
SKILL_COUNT=$(ls -d skills/*/ 2>/dev/null | wc -l | tr -d ' ')
[ "$SKILL_COUNT" -ge 45 ] && pass "$SKILL_COUNT skills present" || fail "only $SKILL_COUNT skills (expected 45+)"

BAD=0
for d in skills/*/; do
  n=$(basename "$d")
  [ -f "$d/SKILL.md" ] || { fail "$n: SKILL.md missing"; BAD=1; continue; }
  head -1 "$d/SKILL.md" | grep -q '^---$' || { fail "$n: SKILL.md has no YAML frontmatter"; BAD=1; continue; }
  fn=$(sed -n '2,15p' "$d/SKILL.md" | sed -n 's/^name: *//p' | head -1 | tr -d '"'"'"'')
  [ -n "$fn" ] || { fail "$n: no 'name' in frontmatter"; BAD=1; continue; }
  [ "$fn" = "$n" ] || { fail "$n: frontmatter name is '$fn'"; BAD=1; }
done
[ "$BAD" -eq 0 ] && pass "every SKILL.md is well-formed and name-matched"

# UI/UX Pro Max companions
head_ "UI/UX Pro Max companion skills"
for s in brand design design-system ui-styling banner-design slides; do
  [ -f "skills/$s/SKILL.md" ] && pass "$s" || fail "$s missing"
done

# Representative Taste skills (the nine workflow verbs)
head_ "Taste workflow skills"
for s in website critique polish animate adapt optimize harden high-end-visual-design image-to-code; do
  [ -f "skills/$s/SKILL.md" ] && pass "/$s" || fail "/$s missing"
done

# ── Agents, commands, scripts, docs ──────────────────────────────────────────
head_ "Agents, commands and stack tooling"
[ -f agents/design-review.md ]        && pass "agents/design-review.md"        || fail "agents/design-review.md missing"
[ -f commands/design-plan.md ]        && pass "commands/design-plan.md"        || fail "commands/design-plan.md missing"
[ -f commands/design-review.md ]      && pass "commands/design-review.md"      || fail "commands/design-review.md missing"
[ -f scripts/design-audit.mjs ]       && pass "scripts/design-audit.mjs"       || fail "scripts/design-audit.mjs missing"
[ -f scripts/install.sh ]             && pass "scripts/install.sh"             || fail "scripts/install.sh missing"
[ -f scripts/update-skills.sh ]       && pass "scripts/update-skills.sh"       || fail "scripts/update-skills.sh missing"
for f in scripts/install.sh scripts/verify.sh scripts/update-skills.sh; do
  [ -x "$f" ] && pass "$f is executable" || warn "$f is not executable (chmod +x)"
done
for d in docs/INSTALL.md docs/STACK.md docs/ARCHITECTURE.md docs/WORKFLOW.md; do
  [ -f "$d" ] && pass "$d" || fail "$d missing"
done

# ── MCP configuration ────────────────────────────────────────────────────────
head_ "MCP configuration"
for s in playwright chrome-devtools shadcn imagebank nanobanana; do
  cmd=$(jq -r --arg s "$s" '.mcpServers[$s] | (.command // "") + " " + ((.args // []) | join(" "))' .mcp.json 2>/dev/null)
  [ -n "${cmd// /}" ] && pass "$s → $cmd" || fail "$s not configured"
done
for s in 21st pinterest; do
  url=$(jq -r --arg s "$s" '.mcpServers[$s].url // ""' .mcp.json 2>/dev/null)
  [ -n "$url" ] && pass "$s → $url (http)" || fail "$s not configured"
done

# Every server name must be unique (jq would silently keep the last duplicate).
DECLARED=$(jq -r '.mcpServers | keys | length' .mcp.json 2>/dev/null)
RAW=$(grep -cE '^\s{4}"[a-z0-9-]+": \{' .mcp.json 2>/dev/null)
[ "$DECLARED" = "$RAW" ] && pass "$DECLARED MCP servers, no duplicate keys" \
                         || fail "duplicate MCP server keys ($RAW raw vs $DECLARED parsed)"

# No literal credential may appear in .mcp.json — only ${VAR} expansions.
if jq -r '.mcpServers[] | ((.env // {}) | to_entries[] | .value), ((.headers // {}) | to_entries[] | .value)' .mcp.json 2>/dev/null \
   | grep -qvE '^\$\{[A-Z_][A-Z0-9_]*(:-)?\}$'; then
  fail ".mcp.json contains a literal env/header value (must be a \${VAR} expansion)"
else
  pass ".mcp.json passes all secrets through \${VAR} expansions only"
fi

# ── No duplicate skills ──────────────────────────────────────────────────────
head_ "Duplicate skill check"
# Two skills claiming the same frontmatter name would shadow each other at load time.
DUPNAMES=$(for d in skills/*/; do
  sed -n '2,15p' "$d/SKILL.md" 2>/dev/null | sed -n 's/^name: *//p' | head -1 | tr -d '"'"'"''
done | sort | uniq -d)
[ -z "$DUPNAMES" ] && pass "no duplicate skill names" \
                   || fail "duplicate skill names: $(echo "$DUPNAMES" | tr '\n' ' ')"
# A skill directory nested inside another skill would be installed twice.
NESTED=$(find skills -mindepth 3 -name SKILL.md 2>/dev/null)
[ -z "$NESTED" ] && pass "no nested skill directories" \
                 || fail "nested SKILL.md: $(echo "$NESTED" | tr '\n' ' ')"

# ── Constitution consistency ─────────────────────────────────────────────────
head_ "Constitution consistency"
# The workflow is stated in three places; they must not drift apart.
STAGES=$(grep -cE '^\| [0-9]+ \| \*\*' CLAUDE.md)
[ "$STAGES" -eq 21 ] && pass "CLAUDE.md declares $STAGES workflow stages" \
                     || fail "CLAUDE.md declares $STAGES workflow stages (expected 21)"
for f in CLAUDE.md README.md skills/web-design-constitution/SKILL.md; do
  if grep -qE '15-stage|FINAL BUILD|RESEARCH → INFORMATION ARCHITECTURE' "$f" 2>/dev/null; then
    fail "$f still references the superseded 15-stage workflow"
  else
    pass "$f is on the 21-stage workflow"
  fi
done
for sect in "INTERACTION & MOTION CONSTITUTION" "IMAGE & VISUAL CONTENT CONSTITUTION"; do
  grep -qF "## $sect" CLAUDE.md && pass "CLAUDE.md has $sect" || fail "CLAUDE.md missing $sect"
done

# ── Visual intelligence + component skills ───────────────────────────────────
head_ "Visual intelligence & component skills"
for s in visual-art-direction image-sourcing image-generation pinterest-art-direction \
         component-discovery interactive-components; do
  [ -f "skills/$s/SKILL.md" ] && pass "$s" || fail "$s missing"
done

# ── .env.example ─────────────────────────────────────────────────────────────
head_ "Environment template"
if [ -f .env.example ]; then
  pass ".env.example present"
  for k in PEXELS_API_KEY UNSPLASH_ACCESS_KEY PIXABAY_API_KEY GOOGLE_AI_API_KEY TWENTY_FIRST_API_KEY; do
    grep -q "^$k=" .env.example && pass "documents $k" || fail ".env.example missing $k"
  done
  if grep -qE '^[A-Z_]+=.+$' .env.example; then
    fail ".env.example has a filled-in value (it must ship empty)"
  else
    pass ".env.example ships with no values"
  fi
else
  fail ".env.example missing"
fi

# ── External plugins ─────────────────────────────────────────────────────────
head_ "External plugins (installed from source, not vendored)"
if [ "$have_claude" -eq 1 ]; then
  PLUGINS=$(claude plugin list 2>/dev/null || echo "")
  for p in frontend-design feature-dev code-review claude-security ponytail claude-mem; do
    if echo "$PLUGINS" | grep -q "^  > $p@"; then
      if echo "$PLUGINS" | grep -A3 "^  > $p@" | grep -q "failed to load"; then
        fail "$p installed but FAILED TO LOAD"
      else
        pass "$p enabled"
      fi
    else
      warn "$p not installed — run scripts/install.sh"
    fi
  done
else
  warn "claude CLI unavailable — cannot verify plugins"
fi

# ── Hygiene: nothing sensitive or bulky tracked ──────────────────────────────
head_ "Repository hygiene"
if git rev-parse --git-dir >/dev/null 2>&1; then
  TRACKED=$(git ls-files)

  echo "$TRACKED" | grep -q "^node_modules/" \
    && fail "node_modules is tracked" || pass "no node_modules tracked"

  echo "$TRACKED" | grep -qE "(^|/)\.claude-mem/|claude-mem-data/|\.db$|\.sqlite3?$" \
    && fail "claude-mem database or SQLite file tracked" || pass "no claude-mem database tracked"

  # .env.example is tracked on purpose; any other .env variant is a leak.
  echo "$TRACKED" | grep -E "(^|/)\.env(\..*)?$" | grep -qv "\.env\.example$" \
    && fail ".env file tracked" || pass "no .env tracked (.env.example excepted)"

  echo "$TRACKED" | grep -qE "\.(pem|key|p12|pfx)$|id_rsa|id_ed25519" \
    && fail "private key material tracked" || pass "no key material tracked"

  # Content scan for credential-shaped strings in text files.
  SECRETS=$(echo "$TRACKED" \
    | grep -viE '\.(png|jpg|jpeg|gif|webp|svg|ico|woff2?|ttf|pdf|csv|lock)$' \
    | while read -r f; do [ -f "$f" ] && echo "$f"; done \
    | xargs -r grep -lnIE \
        "(api[_-]?key|secret|passwd|password|token)[\"' ]*[:=][\"' ]*[A-Za-z0-9/+_-]{20,}|BEGIN (RSA|EC|OPENSSH|PRIVATE) |gh[pousr]_[A-Za-z0-9]{16,}|sk-[A-Za-z0-9]{20,}|AKIA[0-9A-Z]{16}" \
        2>/dev/null || true)
  if [ -n "$SECRETS" ]; then
    fail "possible secrets in: $(echo "$SECRETS" | tr '\n' ' ')"
  else
    pass "no credential-shaped strings in tracked files"
  fi

  REPO_MB=$(du -sm . --exclude=.git --exclude=node_modules 2>/dev/null | cut -f1)
  [ "${REPO_MB:-0}" -lt 100 ] && pass "working tree ${REPO_MB}MB (under 100MB)" \
                              || warn "working tree ${REPO_MB}MB is large"
else
  warn "not a git repository — hygiene checks skipped"
fi

# ── .gitignore ───────────────────────────────────────────────────────────────
head_ ".gitignore coverage"
for p in "node_modules/" ".env" ".claude-mem/" "audit-output/"; do
  grep -qF -- "$p" .gitignore 2>/dev/null && pass "ignores $p" || fail ".gitignore missing $p"
done
# The stack's own content must NOT be ignored.
for p in skills agents commands CLAUDE.md .mcp.json scripts docs; do
  if git check-ignore -q "$p" 2>/dev/null; then fail "$p is gitignored (it must be tracked)"
  else pass "$p is tracked (not ignored)"; fi
done

# ── Summary ──────────────────────────────────────────────────────────────────
printf '\n\033[36m══════════════════ VERIFICATION SUMMARY ══════════════════\033[0m\n'
printf '  passed: %d   failed: %d   warnings: %d\n\n' "$PASS" "$FAILN" "$WARN"
if [ "$FAILN" -gt 0 ]; then
  printf '\033[31m✗ VERIFICATION FAILED — %d critical problem(s)\033[0m\n' "$FAILN"
  exit 1
fi
printf '\033[32m✓ PROFESSIONAL WEBSITE DESIGN STACK VERIFIED\033[0m\n'
[ "$WARN" -gt 0 ] && printf '\033[33m  (%d warning(s) — non-critical)\033[0m\n' "$WARN"
exit 0
