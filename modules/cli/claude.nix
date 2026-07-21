{
  config,
  lib,
  ...
}:

let
  cfg = config.modules.cli.claude;
in
{
  options.modules.cli.claude = {
    enable = lib.mkEnableOption "claude code config";
  };

  config = lib.mkIf cfg.enable {
    home.file = {
      ".claude/CLAUDE.md".source = ../../.claude/CLAUDE.md;
      ".claude/.gitignore".source = ../../.claude/.gitignore;
    };

    home.activation.claudeSettings = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      settings_file="$HOME/.claude/settings.json"
      if [ -L "$settings_file" ] || [ ! -f "$settings_file" ]; then
        $DRY_RUN_CMD rm -f "$settings_file"
        $DRY_RUN_CMD cp ${../../.claude/settings.json} "$settings_file"
        $DRY_RUN_CMD chmod 644 "$settings_file"
      fi
    '';
  };
}
