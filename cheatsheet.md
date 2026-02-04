# Ghostty + LazyVim Navigation Cheatsheet

## Pane/Window Navigation

| Action | Ghostty Panes | Neovim Splits |
|--------|---------------|---------------|
| Move left | `Cmd+Option+H` | `Ctrl+H` |
| Move down | `Cmd+Option+J` | `Ctrl+J` |
| Move up | `Cmd+Option+K` | `Ctrl+K` |
| Move right | `Cmd+Option+L` | `Ctrl+L` |

---

## Ghostty Terminal

| Action | Keybinding |
|--------|------------|
| Split right | `Cmd+D` |
| Split below | `Cmd+Shift+T` |
| Close pane | `Cmd+W` |
| Equalize splits | `Cmd+=` |
| Resize left/down/up/right | `Cmd+Ctrl+H/J/K/L` |

---

## LazyVim Essentials

### Files & Buffers

| Action | Keybinding |
|--------|------------|
| Find files | `<leader>ff` |
| Recent files | `<leader>fr` |
| Live grep | `<leader>sg` |
| File explorer | `<leader>e` |
| Switch buffer | `<leader>bb` |
| Close buffer | `<leader>bd` |

### Code Navigation (LSP)

| Action | Keybinding |
|--------|------------|
| Go to definition | `gd` |
| Go to references | `gr` |
| Go to implementation | `gI` |
| Hover docs | `K` |
| Rename symbol | `<leader>cr` |
| Code actions | `<leader>ca` |

### Diagnostics

| Action | Keybinding |
|--------|------------|
| Next diagnostic | `]d` |
| Prev diagnostic | `[d` |
| Next error | `]e` |
| Prev error | `[e` |
| Trouble panel | `<leader>xx` |

### Git

| Action | Keybinding |
|--------|------------|
| LazyGit | `<leader>gg` |
| Git log | `<leader>gl` |

### Misc

| Action | Keybinding |
|--------|------------|
| Toggle comment | `<leader>/` |
| Which-key help | `<leader>` (wait) |

---

## Fish Shell (FZF)

| Action | Keybinding |
|--------|------------|
| Directory search | `Ctrl+F` |
| Git log | `Ctrl+L` |
| Git status | `Ctrl+S` |
| Process search | `Ctrl+P` |

---

## 3-Pane Workflow

```
┌──────────────┬──────────────┐
│              │    Neovim    │
│  Claude Code ├──────────────┤
│              │    Shell     │
└──────────────┴──────────────┘
```

Setup: Open Ghostty → `Cmd+D` → `Cmd+Shift+T` → Navigate with `Ctrl+H/J/K/L`
