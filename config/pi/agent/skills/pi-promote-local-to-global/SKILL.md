---
name: pi-promote-local-to-global
description: Promote selected project-local `.pi/` resources into global Pi config (or dotfiles-managed global sources) with explicit confirmation and mapping.
allowed-tools: read write edit bash grep find ls
argument-hint: "[all|settings|agents|skills|prompts|extensions|themes]"
---

# Pi Promote Local To Global

Use this skill after making project-local Pi changes when you want to reuse some or all of them globally.

## Goal

Copy or map local `.pi/` improvements into global Pi configuration safely, with clear user confirmation and no hidden overwrites.

## Scope

Project-local source candidates:

- `.pi/settings.json`
- `.pi/AGENTS.md`
- `.pi/SYSTEM.md`
- `.pi/skills/`
- `.pi/prompts/`
- `.pi/extensions/`
- `.pi/themes/`

Global targets:

- `~/.pi/agent/settings.json`
- `~/.pi/agent/AGENTS.md`
- `~/.pi/agent/SYSTEM.md`
- `~/.pi/agent/skills/`
- `~/.pi/agent/prompts/`
- `~/.pi/agent/extensions/`
- `~/.pi/agent/themes/`

If the user manages global config via dotfiles, prefer updating dotfiles source paths and letting Home Manager apply.

## Required Confirmation Flow

1. Detect changed/added local `.pi/` files.
2. Show a promotion table (`local -> proposed global target`).
3. Ask:
   - "Promote these local Pi changes globally?"
4. If yes, ask conflict policy:
   - `merge` (default for json/lists)
   - `replace` (explicit overwrite)
   - `skip` (leave global untouched)
5. Apply only approved items.

Never overwrite global files without explicit confirmation.

## Merge Rules

### settings.json

- Merge object keys conservatively.
- For arrays (`skills`, `prompts`, `extensions`, `themes`, `packages`, `enabledModels`), append unique entries.
- Preserve existing global defaults unless user requested replacement.

### AGENTS.md / SYSTEM.md

- Prefer append with section marker:
  - `## Imported from <project-name> (<date>)`
- If replacement requested, require second confirmation.

### skills/prompts/extensions/themes

- If same name exists globally:
  - default: keep both with project suffix for imported version
  - optional: replace existing if explicitly requested

## Dotfiles Mode

When dotfiles manage global Pi config:

1. Write/update files under repo-managed global source (e.g. `config/pi/agent/...`).
2. Update home-manager references only if needed.
3. Report final `apply` command.

## Outputs

Return:

1. Promotion decision (`yes/no`)
2. Conflict policy used
3. Files promoted with exact mapping
4. Files skipped and reason
5. Follow-up command (`apply` or equivalent)

## Safety

- No destructive global changes without explicit opt-in.
- Keep all edits reviewable and minimal.
- If uncertain about ownership (direct global vs dotfiles-managed), ask before writing.
