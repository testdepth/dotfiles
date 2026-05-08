{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.modules.cli.pi;
  piVersion = "0.74.0";
  piCodingAgent = pkgs.writeShellApplication {
    name = "pi";
    runtimeInputs = [
      pkgs.nodejs_20
    ];
    text = ''
      exec ${pkgs.nodejs_20}/bin/npx --yes @earendil-works/pi-coding-agent@${piVersion} "$@"
    '';
  };
in
{
  options.modules.cli.pi = {
    enable = lib.mkEnableOption "pi coding agent";

    package = lib.mkOption {
      type = lib.types.package;
      default = piCodingAgent;
      description = "Package used for the pi binary.";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ cfg.package ];

    home.file = {
      ".pi/agent/AGENTS.md".source = ../../config/pi/agent/AGENTS.md;
      ".pi/agent/skills" = {
        source = ../../config/pi/agent/skills;
        recursive = true;
      };
    };

    home.activation.piSettings = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      settings_file="$HOME/.pi/agent/settings.json"
      if [ -L "$settings_file" ] || [ ! -f "$settings_file" ]; then
        $DRY_RUN_CMD rm -f "$settings_file"
        $DRY_RUN_CMD cp ${../../config/pi/agent/settings.json} "$settings_file"
        $DRY_RUN_CMD chmod 644 "$settings_file"
      fi
    '';
  };
}
