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

    home.sessionVariables = {
      NPM_CONFIG_PREFIX = "${config.home.homeDirectory}/.npm-global";
    };

    home.sessionPath = [
      "${config.home.homeDirectory}/.npm-global/bin"
    ];

    home.file = {
      ".pi/agent/AGENTS.md".source = ../../config/pi/agent/AGENTS.md;
      ".pi/agent/skills" = {
        source = ../../config/pi/agent/skills;
        recursive = true;
      };
      ".pi/agent/extensions" = {
        source = ../../config/pi/agent/extensions;
        recursive = true;
      };
    };

    home.activation.piSettings = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
            settings_file="$HOME/.pi/agent/settings.json"
            managed_settings='${../../config/pi/agent/settings.json}'

            $DRY_RUN_CMD mkdir -p "$HOME/.pi/agent" "$HOME/.npm-global"

            if [ ! -f "$settings_file" ] || [ -L "$settings_file" ]; then
              $DRY_RUN_CMD rm -f "$settings_file"
              $DRY_RUN_CMD cp "$managed_settings" "$settings_file"
              $DRY_RUN_CMD chmod 644 "$settings_file"
            else
              if [ -z "$DRY_RUN" ]; then
                ${pkgs.python3}/bin/python - <<'PY'
      import json
      import os
      from pathlib import Path

      settings_path = Path(os.environ["HOME"]) / ".pi/agent/settings.json"
      managed_path = Path("${../../config/pi/agent/settings.json}")

      current = json.loads(settings_path.read_text())
      managed = json.loads(managed_path.read_text())

      def merge(dst, src):
          for k, v in src.items():
              if k not in dst:
                  dst[k] = v
              elif isinstance(dst[k], dict) and isinstance(v, dict):
                  merge(dst[k], v)
              elif isinstance(dst[k], list) and isinstance(v, list):
                  for item in v:
                      if item not in dst[k]:
                          dst[k].append(item)

      merge(current, managed)
      settings_path.write_text(json.dumps(current, indent=2) + "\n")
      PY
              fi
            fi
    '';
  };
}
