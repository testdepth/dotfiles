{ pkgs, ... }:
{
  name = "dotfiles";

  # Development packages
  packages = with pkgs; [
    # Core tools
    git
    gh
    ripgrep
    fd
    fzf
    jq
    yq

    # Shell
    fish
    starship

    # Editors
    neovim

    # Python (via uv)
    python311
    uv

    # Node (for LSP servers)
    nodejs_20

    # Nix tools
    nil # Nix LSP
    nixfmt
  ];

  # Environment variables
  env = {
    EDITOR = "nvim";
  };

  # Scripts
  scripts = {
    # Apply home-manager config
    apply.exec = ''
      HOST=''${1:-$(hostname -s)}
      echo "Applying home-manager configuration for $HOST..."
      nix run home-manager -- switch --flake ".#$HOST"
    '';

    # Update flake inputs
    update.exec = ''
      echo "Updating flake inputs..."
      nix flake update
    '';

    # Format all Nix files
    fmt.exec = ''
      echo "Formatting Nix files..."
      nix fmt
    '';
  };

  # Shell greeting
  enterShell = ''
    echo ""
    echo "  Dotfiles Development Environment"
    echo "  ================================="
    echo ""
    echo "  Commands:"
    echo "    apply   - Apply home-manager configuration"
    echo "    update  - Update flake inputs"
    echo "    fmt     - Format Nix files"
    echo ""
  '';

  # Git hooks (pre-commit)
  git-hooks.hooks = {
    nixfmt.enable = true;
  };
}
