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
      gs = "git status";
      gd = "git diff";
      gl = "git log --oneline -20";
      gp = "git push";
      gpl = "git pull";

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
      # Initialize zoxide (smart cd)
      zoxide init fish | source

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
    '';

    # Plugins via fisher
    plugins = [
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

  # Starship prompt
  programs.starship = {
    enable = true;
    enableFishIntegration = true;
    settings = {
      add_newline = true;
      character = {
        success_symbol = "[➜](bold green)";
        error_symbol = "[✗](bold red)";
      };
      directory = {
        truncation_length = 3;
        truncate_to_repo = true;
      };
      git_branch = {
        symbol = " ";
      };
      git_status = {
        ahead = "⇡\${count}";
        behind = "⇣\${count}";
        diverged = "⇕⇡\${ahead_count}⇣\${behind_count}";
      };
      python = {
        symbol = " ";
      };
      nodejs = {
        symbol = " ";
      };
      rust = {
        symbol = " ";
      };
      nix_shell = {
        symbol = " ";
        format = "via [$symbol$state]($style) ";
      };
    };
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
