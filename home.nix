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
    ./modules/cli
  ];

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

  modules.cli.claude.enable = true;
  modules.cli.pi.enable = true;

  # Let home-manager manage itself
  programs.home-manager.enable = true;

  # Enable XDG base directories
  xdg.enable = true;
}
