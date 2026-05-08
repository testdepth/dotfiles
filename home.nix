{
  config,
  pkgs,
  lib,
  ...
}:

let
  apply-nvim = pkgs.writeShellScriptBin "apply-nvim" (
    lib.removePrefix "#!/usr/bin/env bash\n" (builtins.readFile ./scripts/apply-nvim.sh)
  );
in
{
  # User info - set defaults, override in host-specific config
  # Using mkDefault so host configs can override without conflict
  home.username = lib.mkDefault "matkins1";
  home.homeDirectory = lib.mkDefault "/Users/matkins1";

  # State version - don't change after initial setup
  home.stateVersion = "24.05";

  # Import modules
  imports = [
    ./modules/shell/fish.nix
    ./modules/git
    ./modules/terminal/ghostty.nix
  ];

  # Symlink dotfiles - link static dirs individually so settings.json stays mutable
  home.file = {
    ".claude/CLAUDE.md".source = ./.claude/CLAUDE.md;
    ".claude/.gitignore".source = ./.claude/.gitignore;
    ".claude/skills" = {
      source = ./.claude/skills;
      recursive = true;
    };
    ".claude/commands" = {
      source = ./.claude/commands;
      recursive = true;
    };
    ".claude/rules" = {
      source = ./.claude/rules;
      recursive = true;
    };
    ".claude/agents" = {
      source = ./.claude/agents;
      recursive = true;
    };
    ".claude/output-styles" = {
      source = ./.claude/output-styles;
      recursive = true;
    };
  };

  # Bootstrap settings.json as a mutable file (not a symlink) so Claude Code can modify it
  home.activation.claudeSettings = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    settings_file="$HOME/.claude/settings.json"
    if [ -L "$settings_file" ] || [ ! -f "$settings_file" ]; then
      $DRY_RUN_CMD rm -f "$settings_file"
      $DRY_RUN_CMD cp ${./.claude/settings.json} "$settings_file"
      $DRY_RUN_CMD chmod 644 "$settings_file"
    fi
  '';

  # Neovim config (LazyVim)
  xdg.configFile."nvim" = {
    source = ./config/nvim;
    recursive = true;
    force = true;
  };

  # Core packages available everywhere
  home.packages = with pkgs; [
    apply-nvim

    # CLI essentials
    ripgrep
    fd
    fzf
    jq
    yq
    bat
    eza # modern ls
    zoxide # smart cd

    # Git tools
    gh
    lazygit
    delta # git diff pager

    # Development
    neovim

    # Python (uv for package management)
    python311
    uv

    # Node (for various tools)
    nodejs_20
  ];

  # Let home-manager manage itself
  programs.home-manager.enable = true;

  # Enable XDG base directories
  xdg.enable = true;
}
