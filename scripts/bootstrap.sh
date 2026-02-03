#!/usr/bin/env bash
set -euo pipefail

# =============================================================================
# Dotfiles Bootstrap Script
# =============================================================================
# This script sets up a new machine with Nix, home-manager, and dotfiles.
#
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/testdepth/dotfiles/main/scripts/bootstrap.sh | bash
#
# Or after cloning:
#   ./scripts/bootstrap.sh
# =============================================================================

echo ""
echo "======================================"
echo "  Dotfiles Bootstrap"
echo "======================================"
echo ""

# Detect OS
OS="$(uname -s)"
ARCH="$(uname -m)"

echo "Detected: $OS ($ARCH)"
echo ""

# =============================================================================
# Install Nix
# =============================================================================

if ! command -v nix &> /dev/null; then
    echo "Installing Nix..."
    
    # Use Determinate Systems installer (recommended)
    curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
    
    # Source Nix
    if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
        . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
    fi
    
    echo "Nix installed successfully!"
else
    echo "Nix is already installed."
fi

echo ""

# =============================================================================
# Install direnv
# =============================================================================

if ! command -v direnv &> /dev/null; then
    echo "Installing direnv..."
    nix profile install nixpkgs#direnv
    echo "direnv installed successfully!"
else
    echo "direnv is already installed."
fi

echo ""

# =============================================================================
# Clone dotfiles (if not already in repo)
# =============================================================================

DOTFILES_DIR="$HOME/.dotfiles"

if [ ! -d "$DOTFILES_DIR" ]; then
    echo "Cloning dotfiles..."
    git clone https://github.com/testdepth/dotfiles.git "$DOTFILES_DIR"
    echo "Dotfiles cloned to $DOTFILES_DIR"
else
    echo "Dotfiles already exist at $DOTFILES_DIR"
fi

cd "$DOTFILES_DIR"

echo ""

# =============================================================================
# Setup direnv
# =============================================================================

echo "Setting up direnv..."
direnv allow

echo ""

# =============================================================================
# Determine home-manager configuration
# =============================================================================

if [ "$OS" = "Darwin" ]; then
    if [ "$ARCH" = "arm64" ]; then
        HM_CONFIG="macbook"
    else
        HM_CONFIG="macbook-intel"
    fi
else
    HM_CONFIG="linux"
fi

echo "Using home-manager configuration: $HM_CONFIG"
echo ""

# =============================================================================
# Apply home-manager configuration
# =============================================================================

echo "Applying home-manager configuration..."
echo "This may take a few minutes on first run..."
echo ""

nix run home-manager -- switch --flake ".#$HM_CONFIG"

echo ""
echo "======================================"
echo "  Bootstrap Complete!"
echo "======================================"
echo ""
echo "Next steps:"
echo "  1. Restart your terminal (or run: exec fish)"
echo "  2. Install Ghostty from: https://ghostty.org/download"
echo "  3. Install Claude Code: npm install -g @anthropic-ai/claude-code"
echo ""
echo "Your dotfiles are at: $DOTFILES_DIR"
echo ""
