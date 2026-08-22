#!/usr/bin/env bash
# update-skills.sh — refresh the vendored skills from their upstream sources.
#
# Vendored skills live in skills/ and are updated from:
#   • UI/UX Pro Max (+ companions) — the official ui-ux-pro-max-cli npm package
#   • Taste                        — github.com/tyfarrago-hub/taste
#
# Exclusions are enforced on every run, so an update can never reintroduce
# taste's stale ui-ux-pro-max duplicate or the overlapping 'impeccable' skill.
#
#   ./scripts/update-skills.sh              Update everything
#   ./scripts/update-skills.sh --uipro      Only UI/UX Pro Max + companions
#   ./scripts/update-skills.sh --taste      Only Taste skills
#   ./scripts/update-skills.sh --dry-run    Show what would change, change nothing
#
set -uo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$REPO_ROOT"

DO_UIPRO=1; DO_TASTE=1; DRY=0
case "${1:-}" in
  --uipro)   DO_TASTE=0 ;;
  --taste)   DO_UIPRO=0 ;;
  --dry-run) DRY=1 ;;
  "" ) ;;
  -h|--help) sed -n '2,15p' "$0"; exit 0 ;;
  *) echo "Unknown option: $1" >&2; exit 2 ;;
esac

# Never vendor these — see NOTICE.md and STACK-MANIFEST.json.
TASTE_EXCLUDE="ui-ux-pro-max impeccable"

c() { printf '\033[36m==> %s\033[0m\n' "$1"; }
ok(){ printf '    \033[32m✓\033[0m %s\n' "$1"; }
no(){ printf '    \033[31m✗\033[0m %s\n' "$1"; }
sk(){ printf '    \033[33m–\033[0m %s\n' "$1"; }

TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

[ "$DRY" -eq 1 ] && printf '\033[33mDRY RUN — no files will be changed\033[0m\n'

# ── UI/UX Pro Max ────────────────────────────────────────────────────────────
if [ "$DO_UIPRO" -eq 1 ]; then
  c "Updating UI/UX Pro Max from ui-ux-pro-max-cli"
  # Upstream README is explicit: the package is 'ui-ux-pro-max-cli'.
  # The older 'uipro-cli' package is stale and must not be used.
  BEFORE=$(cat skills/ui-ux-pro-max/SKILL.md 2>/dev/null | wc -c | tr -d ' ')
  if (cd "$TMP" && npx --yes ui-ux-pro-max-cli@latest init --ai claude >/dev/null 2>&1); then
    if [ -d "$TMP/.claude/skills" ]; then
      for d in "$TMP"/.claude/skills/*/; do
        n=$(basename "$d")
        if [ "$DRY" -eq 1 ]; then
          sk "would update skills/$n"
        else
          rm -rf "skills/$n"; cp -R "$d" "skills/$n"; ok "skills/$n"
        fi
      done
      AFTER=$(cat skills/ui-ux-pro-max/SKILL.md 2>/dev/null | wc -c | tr -d ' ')
      [ "$DRY" -eq 0 ] && ok "ui-ux-pro-max SKILL.md: ${BEFORE}b → ${AFTER}b"
    else
      no "CLI produced no .claude/skills directory"
    fi
  else
    no "ui-ux-pro-max-cli failed (network or npm issue) — nothing changed"
  fi
fi

# ── Taste ────────────────────────────────────────────────────────────────────
if [ "$DO_TASTE" -eq 1 ]; then
  c "Updating Taste skills from github.com/tyfarrago-hub/taste"
  if git clone --depth 1 -q https://github.com/tyfarrago-hub/taste "$TMP/taste" 2>/dev/null; then
    SHA=$(git -C "$TMP/taste" rev-parse HEAD)
    ok "cloned at $SHA"
    updated=0; skipped=0
    for d in "$TMP"/taste/skills/*/; do
      n=$(basename "$d")
      if echo "$TASTE_EXCLUDE" | grep -qw "$n"; then
        sk "excluded: $n"; skipped=$((skipped+1)); continue
      fi
      if [ "$DRY" -eq 1 ]; then
        [ -d "skills/$n" ] && sk "would update skills/$n" || sk "would add skills/$n"
      else
        rm -rf "skills/$n"; cp -R "$d" "skills/$n"
      fi
      updated=$((updated+1))
    done
    ok "$updated skill(s) processed, $skipped excluded"
    # Refresh vendored licence + attribution alongside the content.
    if [ "$DRY" -eq 0 ]; then
      cp "$TMP/taste/LICENSE"    licenses/LICENSE.taste     2>/dev/null && ok "licenses/LICENSE.taste refreshed"
      cp "$TMP/taste/CREDITS.md" licenses/CREDITS.taste.md  2>/dev/null && ok "licenses/CREDITS.taste.md refreshed"
      # Record the new commit in the manifest.
      if command -v jq >/dev/null 2>&1; then
        jq --arg sha "$SHA" '(.components[] | select(.component=="taste") | .commit_sha) = $sha' \
           STACK-MANIFEST.json > "$TMP/m.json" && mv "$TMP/m.json" STACK-MANIFEST.json \
           && ok "STACK-MANIFEST.json taste commit updated"
      fi
    fi
  else
    no "could not clone taste — nothing changed"
  fi
fi

# ── Enforce exclusions and re-verify ─────────────────────────────────────────
if [ "$DRY" -eq 0 ]; then
  c "Enforcing exclusions"
  for x in $TASTE_EXCLUDE; do
    if [ "$x" = "ui-ux-pro-max" ]; then continue; fi   # ours is the authoritative one
    [ -d "skills/$x" ] && { rm -rf "skills/$x"; ok "removed re-introduced skills/$x"; } || ok "skills/$x absent"
  done

  c "Re-verifying"
  ./scripts/verify.sh --quiet
  RC=$?
  echo
  if [ "$RC" -eq 0 ]; then
    printf '\033[32m✓ Skills updated and verified. Review with: git diff --stat\033[0m\n'
  else
    printf '\033[31m✗ Verification failed after update. Inspect with: git diff\033[0m\n'
    printf '  Roll back with: git checkout -- skills/\n'
  fi
  exit $RC
fi
