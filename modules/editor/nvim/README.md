# Neovim Configuration

This dotfiles repository uses **LazyVim starter** for Neovim configuration.

## Setup

The Neovim configuration is installed separately from home-manager because it requires `lazy.nvim` to manage plugins.

### Fresh Install

```bash
# Backup existing config (if any)
mv ~/.config/nvim ~/.config/nvim.backup 2>/dev/null || true
mv ~/.local/share/nvim ~/.local/share/nvim.backup 2>/dev/null || true
mv ~/.local/state/nvim ~/.local/state/nvim.backup 2>/dev/null || true
mv ~/.cache/nvim ~/.cache/nvim.backup 2>/dev/null || true

# Clone LazyVim starter
git clone https://github.com/LazyVim/starter ~/.config/nvim

# Remove the .git folder so you can add it to your own repo
rm -rf ~/.config/nvim/.git

# Start Neovim (will install plugins on first run)
nvim
```

## Customization

After installation, customize by editing files in `~/.config/nvim/lua/`:

### Disable Auto-formatting (for Claude Code workflow)

Edit `~/.config/nvim/lua/config/options.lua`:

```lua
-- Disable auto-format (let Claude Code handle it)
vim.g.autoformat = false
```

### Add Language Support

Edit `~/.config/nvim/lua/config/lazy.lua` to enable extras:

```lua
{ import = "lazyvim.plugins.extras.lang.python" },
{ import = "lazyvim.plugins.extras.lang.typescript" },
{ import = "lazyvim.plugins.extras.lang.go" },
{ import = "lazyvim.plugins.extras.lang.rust" },
{ import = "lazyvim.plugins.extras.lang.json" },
{ import = "lazyvim.plugins.extras.lang.yaml" },
```

## Claude Code + Neovim Workflow

When using Neovim with Claude Code (in Ghostty 3-pane layout):

1. **Claude Code** handles: AI assistance, code generation, refactoring
2. **Neovim** handles: Navigation, syntax highlighting, git integration
3. **Disable LSP conflicts**: Consider disabling Neovim's LSP for languages Claude handles

## Resources

- [LazyVim Documentation](https://www.lazyvim.org/)
- [LazyVim Starter](https://github.com/LazyVim/starter)
- [Claude Code + Neovim Workflow](https://danielmiessler.com/blog/replacing-cursor-with-neovim-claude-code)
