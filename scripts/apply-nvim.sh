#!/usr/bin/env bash
set -euo pipefail

REPO="${DOTFILES:-$HOME/.dotfiles}"
if [[ ! -f "$REPO/flake.nix" ]]; then
  echo "error: no flake at $REPO — set DOTFILES to your dotfiles clone" >&2
  exit 1
fi
cd "$REPO"

HOST="${1:-$(hostname -s)}"
echo "Applying home-manager for $HOST (full profile; nvim comes from config/nvim/)..."
exec nix run home-manager -- switch --flake ".#$HOST"
