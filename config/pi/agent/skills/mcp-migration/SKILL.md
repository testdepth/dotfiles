---
name: mcp-migration
description: Migrate MCP server configurations from Claude/Cursor/Codex/Copilot projects into a Pi-native plan using CLI workflows, extensions, or deferred migration tasks.
allowed-tools: read write edit bash grep find ls
---

# MCP Migration

Use this skill when a project has MCP configuration and you want a practical Pi-native replacement plan.

## Goal

Create a reproducible migration from MCP configs to Pi conventions without losing capability coverage.

## Inputs to Discover

Search for MCP and adjacent harness config in project and workspace roots:

- `.ai/mcp.json`
- `.cursor/mcp.json`
- `.claude/settings.json`, `.claude/settings.local.json`
- `.vscode/settings.json`
- `.pi/settings.json`
- `README.md`, `AGENTS.md`, `CLAUDE.md` references to MCP tools

If multiple MCP files exist, merge them into one inventory and mark duplicates.

## Process

1. Build an inventory table for each MCP server:
   - Server key
   - Command
   - Args
   - Environment variables
   - Where defined
   - Apparent purpose
2. Classify each server into one target strategy:
   - **Native CLI workflow**: replace with shell commands/tools Pi can already run
   - **Pi extension**: requires persistent process, custom UI, or structured API bridge
   - **Deferred**: no safe replacement yet; document explicit gap
3. For each server, create migration output:
   - Exact replacement command/workflow in `.pi/AGENTS.md`, or
   - Extension scaffold plan in `.pi/extensions/<name>/index.ts`, or
   - Deferred item in `.pi/MIGRATION.md`
4. Update `.pi/settings.json` only with resources that exist now:
   - `extensions` entries for created extension paths
   - `skills` entries for reusable imported skills
5. Add verification steps in `.pi/MIGRATION.md`:
   - How to validate each migrated capability end-to-end
   - What remains intentionally unmigrated
6. If local `.pi/` files changed, ask before finishing:
   - "Do you want to promote these MCP migration changes to your global Pi config too?"
   - If yes: map to global locations (`~/.pi/agent/...`) or dotfiles sources.
   - If no: keep project-local and document that choice in `.pi/MIGRATION.md`.

## Mapping Heuristics

- Browser/debug MCP servers often map to:
  - `bash` + project scripts for smoke tests
  - or a Pi extension if interactive session state is required
- Local file/query MCP servers often map to built-in tools directly:
  - `read`, `grep`, `find`, `ls`, `edit`, `write`
- External API MCP servers usually map to:
  - existing CLI clients if available
  - otherwise extension-backed tools with explicit auth/env handling

## Required Outputs

Create or update:

1. `.pi/MIGRATION.md`
2. `.pi/AGENTS.md` (MCP replacement notes)
3. `.pi/settings.json` (only valid current resources)
4. `.pi/extensions/...` scaffold only when needed

## `.pi/MIGRATION.md` Template

```markdown
# MCP Migration

## Inventory

| Server | Source | Command | Args | Purpose | Strategy |
|---|---|---|---|---|---|

## Decisions

- `<server>` -> `<strategy>` because `<reason>`

## Implemented

- [x] `<server>` mapped to `<replacement>`

## Deferred

- [ ] `<server>` not migrated yet: `<gap>`

## Verification

- [ ] Validate `<server>` replacement via `<steps>`

## Global Promotion

- Decision: `<yes|no>`
- If yes: `<local file>` -> `<global target>`
- If no: `Keep project-local only`
```

## Quality Bar

- Do not claim MCP parity unless behavior is verifiably replaced.
- Keep migration artifacts in-repo and reviewable.
- Prefer explicit deferred notes over risky partial replacements.
