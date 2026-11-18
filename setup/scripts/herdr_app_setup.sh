#!/bin/bash
# Apply the Herdr desktop app look that lives in dotfiles.
#
# Herdr saves the selected layout/theme in its own local state
# (~/.config/herdr-app/shared.json), not in the linked files, so a fresh
# machine or an app update can fall back to the bundled "main" layout.
# This re-applies the choices from dotfiles:
#
#   - layouts/square-panes.json   (custom layout)
#   - themes/material-darker.json (terminal theme)
#
# Safe to run any time: it skips itself when herdr-app is not installed.

set -euo pipefail

if ! command -v herdr-app >/dev/null 2>&1; then
  echo "==> ℹ️  herdr-app not installed; skipping Herdr app setup"
  exit 0
fi

echo "==> 🖥️  Applying Herdr app layout and theme..."

herdr-app do layout.switch --name square-panes
herdr-app do app.theme --name material-darker

if command -v jq >/dev/null 2>&1; then
  ACTIVE_LAYOUT=$(herdr-app status | jq -r '.layout')
  if [[ "$ACTIVE_LAYOUT" == "square-panes" ]]; then
    echo "==> ✅ Herdr app layout is square-panes"
  else
    echo "==> ⚠️  Herdr app layout is '$ACTIVE_LAYOUT', expected 'square-panes'"
  fi
else
  echo "==> ✅ Herdr app layout and theme applied"
fi
