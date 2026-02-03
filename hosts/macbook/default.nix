{
  config,
  pkgs,
  lib,
  ...
}:

{
  # macOS-specific configuration

  # User info - these override the mkDefault values in home.nix
  home.username = lib.mkForce "matkins1";
  home.homeDirectory = lib.mkForce "/Users/matkins1";

  # macOS-specific packages
  home.packages = with pkgs; [
    # macOS utilities
    coreutils # GNU core utilities

    # Development
    watchman # File watcher for React Native, etc.
  ];

  # macOS-specific shell config
  programs.fish.interactiveShellInit = lib.mkAfter ''
    # Homebrew (Apple Silicon)
    if test -d /opt/homebrew
      eval (/opt/homebrew/bin/brew shellenv)
    end

    # Google Cloud SDK
    if test -f "$HOME/google-cloud-sdk/path.fish.inc"
      source "$HOME/google-cloud-sdk/path.fish.inc"
    end
  '';

  # Environment variables
  home.sessionVariables = {
    # Homebrew
    HOMEBREW_NO_ANALYTICS = "1";
    HOMEBREW_NO_AUTO_UPDATE = "1";
  };
}
