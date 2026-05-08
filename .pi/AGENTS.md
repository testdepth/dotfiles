# Project Pi Instructions (MCP Migration)

- MCP inventory for migration is sourced from global Cursor config at `~/.cursor/mcp.json`.
- Treat `nvim` MCP usage as replaced by native Pi + Neovim integration:
  - `pi-mono.nvim` prompt contexts (`@this`, `@diagnostics`)
  - Pi built-in tools (`read`, `grep`, `find`, `ls`, `edit`, `write`, `bash`)
- `chrome-devtools` and `itdoc-redbull-com` remain deferred until a concrete replacement is selected.
- If Todoist automation is needed, choose one explicit path:
  - CLI-first workflow, or
  - Extension scaffold via `/skill:mcp-extension-scaffold <server-name>`
- Keep all Pi migration artifacts in `.pi/` and update `.pi/MIGRATION.md` when decisions change.
