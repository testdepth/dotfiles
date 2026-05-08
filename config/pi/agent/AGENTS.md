# Pi Global Instructions

- Prefer project-local `.pi/settings.json` for project-specific overrides.
- When adopting Pi in an existing project that already uses Claude Code, Cursor, Codex, or Copilot CLI settings, run `/skill:harness-unify-import` first.
- If MCP config is present, run `/skill:mcp-migration` after import to produce a Pi-native migration plan.
- For deferred MCP servers, run `/skill:mcp-extension-scaffold <server-name>` to generate a minimal extension starter.
- Keep migrations reproducible: write generated Pi config files into the repo (`.pi/`) and avoid machine-only manual edits.
- After project-local Pi changes, prompt whether to promote them into global Pi config (`~/.pi/agent` or dotfiles-managed equivalents).
- Use `/skill:pi-promote-local-to-global` to perform controlled promotion with merge/replace/skip confirmation.
