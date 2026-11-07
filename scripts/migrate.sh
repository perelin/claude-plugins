#!/usr/bin/env bash
# Moves plugins installed from their single-plugin marketplaces (<name>@<name>)
# to this catalog (<name>@perelin). Safe to run repeatedly.
set -euo pipefail

CATALOG=perelin
REPO=perelin/claude-plugins
PLUGINS=(boxed-ui reladraw-view voice-brief end-session visual-companion)

installed="$(claude plugin list --json | python3 -I -c 'import json,sys; print("\n".join(p["id"] for p in json.load(sys.stdin)))')"
markets="$(claude plugin marketplace list --json | python3 -I -c 'import json,sys; print("\n".join(m["name"] for m in json.load(sys.stdin)))')"

has() { grep -qxF "$1" <<<"$2"; }

if has "$CATALOG" "$markets"; then
  claude plugin marketplace update "$CATALOG"
else
  claude plugin marketplace add "$REPO"
fi

for p in "${PLUGINS[@]}"; do
  if has "${p}@${p}" "$installed"; then
    claude plugin uninstall "${p}@${p}" --scope user
  fi
  if has "$p" "$markets"; then
    claude plugin marketplace remove "$p"
  fi
  if has "${p}@${CATALOG}" "$installed"; then
    echo "${p}@${CATALOG} already installed"
  else
    claude plugin install "${p}@${CATALOG}" --scope user
  fi
done

claude plugin list --json | python3 -I -c '
import json, sys
for p in json.load(sys.stdin):
    if p["id"].endswith("@" + sys.argv[1]):
        print("%-32s %-8s enabled=%s" % (p["id"], p["version"], p["enabled"]))' "$CATALOG"
