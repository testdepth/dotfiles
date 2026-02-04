{
  config,
  pkgs,
  lib,
  ...
}:

{
  # Force overwrite existing fish config
  xdg.configFile."fish/config.fish".force = true;

  programs.fish = {
    enable = true;

    # Shell aliases
    shellAliases = {
      # Navigation
      ".." = "cd ..";
      "..." = "cd ../..";
      "...." = "cd ../../..";

      # Modern replacements
      ls = "eza";
      ll = "eza -la";
      la = "eza -a";
      lt = "eza --tree";
      cat = "bat";

      # Git shortcuts
      g = "git";
      ga = "git add";
      gau = "git add -u";
      gb = "git branch";
      gco = "git checkout";
      gcm = "git commit -m";
      gs = "git status";
      gd = "git diff";
      gl = "git log --oneline -20";
      gp = "git pull";
      pew = "git push";
      pub = "git push --set-upstream origin";

      # Editor
      v = "nvim";
      vim = "nvim";

      # Safety
      rm = "rm -i";
      cp = "cp -i";
      mv = "mv -i";
    };

    # Environment variables
    shellInit = ''
      # Ensure nix profile is in PATH early (needed for GUI-launched terminals)
      if test -d ~/.nix-profile/bin
        fish_add_path --prepend ~/.nix-profile/bin
      end

      # Editor
      set -gx EDITOR nvim
      set -gx VISUAL nvim

      # Colors
      set -gx TERM xterm-256color
      set -gx LS_COLORS "di=38;5;27:fi=38;5;7:ln=38;5;51:ex=38;5;9:"

      # Disable fish greeting
      set -g fish_greeting
    '';

    # Interactive shell config
    interactiveShellInit = ''
      # Bobthefish theme settings
      set -g theme_display_git yes
      set -g theme_display_git_dirty yes
      set -g theme_display_git_untracked yes
      set -g theme_display_git_ahead_verbose yes
      set -g theme_display_git_dirty_verbose yes
      set -g theme_display_git_stashed_verbose yes
      set -g theme_display_git_default_branch yes
      set -g theme_git_default_branches master main
      set -g theme_show_exit_status yes
      set -g theme_color_scheme dark
      set -g theme_nerd_fonts yes

      # FZF key bindings (if fzf.fish is available)
      if type -q fzf_configure_bindings
        fzf_configure_bindings --directory=\cf --git_log=\cl --git_status=\cs --processes=\cp
      end

      # Cargo/Rust
      if test -d $HOME/.cargo/bin
        fish_add_path $HOME/.cargo/bin
      end

      # Homebrew (macOS)
      if test -d /opt/homebrew/bin
        fish_add_path /opt/homebrew/bin
      end
      # Cursor CLU
      if test -d $HOME/.local/bin
        fish_add_path $HOME/.local/bin
      end

    '';

    # Plugins
    plugins = [
      {
        name = "bobthefish";
        src = pkgs.fishPlugins.bobthefish.src;
      }
      {
        name = "fzf.fish";
        src = pkgs.fishPlugins.fzf-fish.src;
      }
      {
        name = "done";
        src = pkgs.fishPlugins.done.src;
      }
    ];
  };

  # FZF
  programs.fzf = {
    enable = true;
    enableFishIntegration = true;
  };

  # Zoxide (smart cd)
  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
  };
}
