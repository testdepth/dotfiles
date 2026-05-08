# MCP Migration

## Inventory

| Server | Source | Command / URL | Args / Auth | Purpose | Strategy |
|---|---|---|---|---|---|
| `nvim` | `~/.cursor/mcp.json` | `npx` | `nvim-mcp-server` | Editor context and code navigation bridge from Cursor | Native CLI workflow |
| `chrome-devtools` | `~/.cursor/mcp.json` | `npx` | `-y chrome-devtools-mcp@latest` | Browser debugging/inspection from MCP clients | Deferred |
| `itdoc-redbull-com` | `~/.cursor/mcp.json` | `https://devmcp-linux-web-app-p.azurewebsites.net/mcp/` | HTTP + Authorization header | Remote MCP integration for internal docs/tooling | Deferred |
| `todoist` (referenced only) | `.claude/skills/daily/SKILL.md` | _(not configured)_ | _(not configured)_ | Daily-note task sync assumes MCP Todoist tools | Deferred |

## Decisions

- Imported MCP inventory from global Cursor config (`~/.cursor/mcp.json`) into this repo migration plan.
- `nvim` is treated as **native workflow replacement** in this repo via `pi-mono.nvim` context prompts (`@this`, `@diagnostics`) and Pi built-in tools.
- `chrome-devtools` is **deferred** pending an explicit replacement path (project scripts / Playwright flow or extension scaffold).
- `itdoc-redbull-com` is **deferred** because it requires authenticated remote MCP semantics; likely best handled through a dedicated Pi extension.
- `todoist` remains deferred because it is only referenced in a Claude skill and has no corresponding server config in this repo.

## Implemented

- [x] Added project-local `.pi/AGENTS.md` with MCP replacement guidance.
- [x] Added project-local `.pi/settings.json` baseline for Pi project overrides.
- [x] Folded global Cursor MCP inventory into project `.pi/MIGRATION.md`.

## Deferred

- [ ] `chrome-devtools` not migrated yet:
  - Option A: standardize on browser automation via project scripts/tests.
  - Option B: scaffold extension via `/skill:mcp-extension-scaffold chrome-devtools`.
- [ ] `itdoc-redbull-com` not migrated yet:
  - Option A: CLI wrapper with token/env auth and documented workflow.
  - Option B: scaffold extension via `/skill:mcp-extension-scaffold itdoc-redbull-com`.
- [ ] `todoist` not migrated yet:
  - Option A: Todoist CLI workflow documented in `.pi/AGENTS.md`.
  - Option B: scaffold extension via `/skill:mcp-extension-scaffold todoist`.

## Verification

- [ ] Run `pi` in this repo and confirm no MCP-dependent startup assumptions.
- [ ] Validate routine code tasks work with built-in tools (`read`, `grep`, `find`, `ls`, `edit`, `write`, `bash`).
- [ ] Validate `nvim` replacement flow: from Neovim prompt contexts to Pi actions without MCP.
- [ ] Choose and verify one replacement for `chrome-devtools`.
- [ ] Choose and verify one replacement for `itdoc-redbull-com`.
- [ ] If Todoist automation is required, choose and verify one replacement path.

## Global Promotion

- Decision: `yes` (merge)
- Promoted:
  - `.pi/AGENTS.md` MCP discovery note -> `config/pi/agent/AGENTS.md`
  - `.pi/settings.json` skill-path intent -> `config/pi/agent/settings.json` (added `~/.cursor/skills-cursor`)
- Kept project-local only:
  - `.pi/MIGRATION.md` (project migration log)
  - `.pi/AGENTS.md` project-specific MCP decisions
