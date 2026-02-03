{
  config,
  pkgs,
  lib,
  ...
}:

{
  programs.git = {
    enable = true;

    # Settings (new unified config structure)
    settings = {
      user = {
        name = "Mark Atkins";
        email = "testdepth@users.noreply.github.com";
      };

      init.defaultBranch = "main";

      core = {
        editor = "nvim";
        autocrlf = "input";
        whitespace = "trailing-space,space-before-tab";
      };

      push = {
        default = "current";
        autoSetupRemote = true;
      };

      pull = {
        rebase = true;
      };

      fetch = {
        prune = true;
      };

      merge = {
        conflictStyle = "diff3";
      };

      diff = {
        colorMoved = "default";
      };

      rebase = {
        autoStash = true;
      };

      # Aliases
      alias = {
        # Status
        s = "status";
        st = "status --short --branch";

        # Commits
        c = "commit";
        cm = "commit -m";
        ca = "commit --amend";
        can = "commit --amend --no-edit";

        # Branches
        b = "branch";
        co = "checkout";
        cob = "checkout -b";

        # Logging
        l = "log --oneline -20";
        lg = "log --graph --oneline --decorate";
        ll = "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit";

        # Diffs
        d = "diff";
        ds = "diff --staged";

        # Reset
        unstage = "reset HEAD --";
        uncommit = "reset --soft HEAD~1";

        # Stash
        ss = "stash save";
        sp = "stash pop";
        sl = "stash list";

        # Cleanup
        cleanup = "!git branch --merged | grep -v '\\*\\|main\\|master' | xargs -n 1 git branch -d";
      };
    };

    # Global gitignore
    ignores = [
      # macOS
      ".DS_Store"
      ".AppleDouble"
      ".LSOverride"
      "._*"

      # Editors
      "*.swp"
      "*.swo"
      "*~"
      ".idea/"
      ".vscode/"
      "*.sublime-*"

      # Environment
      ".env"
      ".env.local"
      ".envrc"
      ".direnv/"

      # Dependencies
      "node_modules/"
      "__pycache__/"
      "*.pyc"
      ".venv/"
      "venv/"

      # Build outputs
      "dist/"
      "build/"
      "*.egg-info/"

      # Nix
      "result"
      "result-*"
      ".devenv/"
    ];
  };

  # Delta for better diffs
  programs.delta = {
    enable = true;
    enableGitIntegration = true;
    options = {
      navigate = true;
      light = false;
      side-by-side = false;
      line-numbers = true;
    };
  };

  # GitHub CLI
  programs.gh = {
    enable = true;
    settings = {
      git_protocol = "ssh";
      prompt = "enabled";
    };
  };

  # Lazygit
  programs.lazygit = {
    enable = true;
    settings = {
      gui = {
        showIcons = true;
      };
      git = {
        paging = {
          colorArg = "always";
          pager = "delta --dark --paging=never";
        };
      };
    };
  };
}
