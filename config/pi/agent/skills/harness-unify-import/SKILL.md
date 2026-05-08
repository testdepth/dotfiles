---
name: harness-unify-import
description: Migrate an existing project's AI harness setup (Claude Code, Cursor, Codex, Copilot CLI, MCP config) into Pi `.pi/` settings, skills, prompts, and agent instructions.
allowed-tools: read write edit bash grep find ls
---

# Harness Unify Import

Use this skill when a project already has one or more AI harness configurations and you want a clean Pi-first setup.

## Goal

Produce a reproducible `.pi/` configuration that preserves useful behavior from existing harness files.

## Inputs to Detect

Scan the project root and parent workspace for:

- `.claude/` (`CLAUDE.md`, `settings*.json`, `skills/`, `commands/`, `rules/`)
- `.cursor/` (rules, prompts, config)
- `.codex/` (skills, prompts, settings)
- `.github/copilot-instructions.md`
- `.ai/mcp.json`, `.cursor/mcp.json`, or other MCP server definitions
- Existing `.pi/` files

## Migration Workflow

1. Build an inventory table of discovered files by harness.
2. Read all instruction/context files and normalize into:
   - `.pi/AGENTS.md` for durable agent guidance
   - `.pi/SYSTEM.md` only when strict system-level behavior is required
3. Merge configuration into `.pi/settings.json`:
   - Preserve existing Pi settings
   - Add discovered reusable resource paths to `skills`, `prompts`, and `extensions`
   - Keep paths project-relative when possible
4. Import reusable skills:
   - Prefer referencing existing harness skill directories first
   - Copy skill content into `.pi/skills/` only when format or naming changes are required
5. Handle MCP configuration explicitly:
   - Pi has no built-in MCP runtime
   - Convert each MCP server entry into one of:
     - A native CLI workflow documented in `.pi/AGENTS.md`
     - A Pi extension plan in `.pi/extensions/`
     - A deferred migration item in `.pi/MIGRATION.md`
6. Create `.pi/MIGRATION.md` summarizing:
   - What was imported
   - What was mapped manually
   - What remains unmigrated
7. If project-local `.pi/` files were created or changed, ask before finishing:
   - "Do you want to promote these project Pi changes into your global Pi config as well?"
   - If yes: produce equivalent global targets (`~/.pi/agent/...`) or dotfiles-managed sources.
   - If no: keep changes project-local and note the decision in `.pi/MIGRATION.md`.

## Quality Bar

- Do not silently drop existing behavior.
- Keep changes minimal and reviewable.
- Ensure all generated files are committed in-repo.
- If a decision is ambiguous, prefer documenting the option in `.pi/MIGRATION.md`.

## Output

Return:

1. Final file list created/updated
2. Key mapping decisions (old harness -> Pi)
3. Outstanding follow-ups
4. Global promotion decision (yes/no) and resulting file mapping
