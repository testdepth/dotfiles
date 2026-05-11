# Pi Skills Workflow

Recommended migration and rollout sequence when adopting Pi in an existing project.

## 1) Harness import

```bash
/skill:harness-unify-import
```

Use first to inventory and migrate settings/instructions from Claude Code, Cursor, Codex, Copilot CLI, and related project harness files.

## 2) MCP migration planning

```bash
/skill:mcp-migration
```

Use when MCP configs are present. Produces a Pi-native mapping and explicit deferred items.

## 3) Deferred MCP scaffold (as needed)

```bash
/skill:mcp-extension-scaffold <server-name>
```

Use for each deferred MCP server that needs a starter Pi extension.

## 4) Promote local changes globally

```bash
/skill:pi-promote-local-to-global [all|settings|agents|skills|prompts|extensions|themes]
```

Use after local `.pi/` changes are validated to selectively promote them into global Pi config (or dotfiles-managed global sources).

## Notes

- Keep project changes in-repo under `.pi/` for reproducibility.
- Promote globally only after explicit confirmation.
- If global Pi is dotfiles-managed, update dotfiles sources and run your normal apply flow.

## Included global extensions

- `config/pi/agent/extensions/paste-clipboard-image.ts`
  - Adds `/paste-image [optional message]` in Pi.
  - Binds `Ctrl+V` to paste a clipboard image directly.
  - Pulls an image from the macOS clipboard and sends it as an attached user image.
  - Uses `pngpaste` when available, with AppleScript fallback.
