{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.modules.cli.cursor;
in
{
  options.modules.cli.cursor = {
    enable = lib.mkEnableOption "cursor global config";
  };

  config = lib.mkIf cfg.enable {
    home.activation.cursorConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
            cursor_dir="$HOME/.cursor"
            $DRY_RUN_CMD mkdir -p "$cursor_dir"

            managed_mcp='${../../config/cursor/mcp.json}'
            managed_cli='${../../config/cursor/cli-config.json}'
            mcp_file="$cursor_dir/mcp.json"
            cli_file="$cursor_dir/cli-config.json"

            # cli-config.json: copy if missing or is a symlink
            if [ -L "$cli_file" ] || [ ! -f "$cli_file" ]; then
              $DRY_RUN_CMD rm -f "$cli_file"
              $DRY_RUN_CMD cp "$managed_cli" "$cli_file"
              $DRY_RUN_CMD chmod 644 "$cli_file"
            fi

            # mcp.json: merge managed servers into existing file, preserving auth headers
            if [ -L "$mcp_file" ] || [ ! -f "$mcp_file" ]; then
              $DRY_RUN_CMD rm -f "$mcp_file"
              $DRY_RUN_CMD cp "$managed_mcp" "$mcp_file"
              $DRY_RUN_CMD chmod 644 "$mcp_file"
            else
              if [ -z "''${DRY_RUN:-}" ]; then
                ${pkgs.python3}/bin/python - <<'PY'
      import json
      import os
      from pathlib import Path

      mcp_path = Path(os.environ["HOME"]) / ".cursor/mcp.json"
      managed_path = Path("${../../config/cursor/mcp.json}")

      current = json.loads(mcp_path.read_text())
      managed = json.loads(managed_path.read_text())

      current_servers = current.get("mcpServers", {})
      managed_servers = managed.get("mcpServers", {})

      for name, managed_cfg in managed_servers.items():
          if name not in current_servers:
              current_servers[name] = managed_cfg
          else:
              existing = current_servers[name]
              for k, v in managed_cfg.items():
                  if k not in existing:
                      existing[k] = v

      current["mcpServers"] = current_servers
      mcp_path.write_text(json.dumps(current, indent=2) + "\n")
      PY
              fi
            fi
    '';
  };
}
