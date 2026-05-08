---
name: mcp-extension-scaffold
description: Generate a minimal Pi extension scaffold for one deferred MCP server migration, including tool contract, config surface, and verification checklist.
allowed-tools: read write edit bash grep find ls
argument-hint: "<server-name>"
---

# MCP Extension Scaffold

Use this skill after `/skill:mcp-migration` when one MCP server is marked deferred and needs a Pi extension starter.

## Goal

Create a small, runnable extension skeleton for a single MCP server replacement with clear TODOs and verification steps.

## Usage

```bash
/skill:mcp-extension-scaffold <server-name>
```

## Inputs

1. `.pi/MIGRATION.md` (required)
2. Existing extension paths from `.pi/settings.json`
3. Source MCP config (`.ai/mcp.json`, `.cursor/mcp.json`, `.claude/settings*.json`) if still present

If `<server-name>` is missing, ask for one deferred server from `.pi/MIGRATION.md`.

## Process

1. Resolve target server details:
   - command
   - args
   - env/auth requirements
   - expected user workflows
2. Create extension directory:
   - `.pi/extensions/<server-name>/index.ts`
   - `.pi/extensions/<server-name>/README.md`
3. Implement minimal `index.ts`:
   - default export factory
   - one `registerTool` skeleton with strict parameter schema
   - placeholder `execute` body with explicit TODO and safe error message
   - optional command to run local self-check
4. Ensure `.pi/settings.json` includes extension path if missing.
5. Update `.pi/MIGRATION.md`:
   - move server from Deferred -> Implemented (scaffolded)
   - add unchecked verification items
6. Ask before finishing if scaffold should be promoted globally:
   - "Do you also want this extension scaffold available in your global Pi config?"
   - If yes: provide global/dotfiles mirror path and settings mapping.
   - If no: keep local only and record decision in `.pi/MIGRATION.md`.

## `index.ts` baseline

- Use `Type.Object` from `typebox` for parameters
- Return structured content with clear “not implemented yet” status
- Avoid hidden side effects
- No fake success responses

## README requirements

Include:

- Purpose and mapped MCP server
- Required environment variables
- Planned tool behavior
- Test command(s)
- Known gaps

## Verification Checklist (append to `.pi/MIGRATION.md`)

- [ ] Extension loads in Pi (`/reload` succeeds)
- [ ] Tool appears in available tool list
- [ ] Invalid inputs fail with clear errors
- [ ] Happy-path command works against target environment
- [ ] Output shape is stable and documented

## Global Promotion Output

Always report one of:

- `Promoted`: `<local path>` -> `<global path>`
- `Local only`: not promoted by user choice

## Quality Bar

- Keep scaffold minimal and compilable.
- Prefer one solid tool over many placeholders.
- Never mark migration complete when only scaffold exists.
