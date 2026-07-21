{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.modules.cli.apm;
  agentConfigPath = "${config.home.homeDirectory}/code/dotfiles/agent-config";
in
{
  options.modules.cli.apm = {
    enable = lib.mkEnableOption "APM global agent primitives";
  };

  config = lib.mkIf cfg.enable {
    home.activation.apmGlobalInstall = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      apm_bin="/usr/local/bin/apm"

      if [ ! -x "$apm_bin" ]; then
        echo "[apm] apm not found at $apm_bin, skipping agent primitives install" >&2
      else
        # Remove Nix-managed symlinks that APM will now own.
        # These were previously managed by claude.nix via home.file.
        for dir in "$HOME/.claude/skills" "$HOME/.claude/agents" "$HOME/.claude/rules" "$HOME/.claude/output-styles"; do
          if [ -L "$dir" ]; then
            $DRY_RUN_CMD rm "$dir"
          fi
        done

        # Deploy skills and agents from the dotfiles APM package to global tool locations.
        # apm install -g writes to ~/.claude/, ~/.cursor/, ~/.copilot/, ~/.agents/
        if [ -z "''${DRY_RUN:-}" ]; then
          GIT_PYTHON_GIT_EXECUTABLE="${pkgs.git}/bin/git" \
            "$apm_bin" install -g "${agentConfigPath}" --target claude,cursor,copilot --no-policy
        else
          echo "[apm] DRY_RUN: would run: apm install -g ${agentConfigPath} --target claude,cursor,copilot"
        fi
      fi
    '';
  };
}
