{
  config,
  pkgs,
  lib,
  ...
}:

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

  # Core packages available everywhere
  home.packages = with pkgs; [
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
