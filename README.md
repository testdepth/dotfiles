# Mark's Dotfiles

Reproducible dotfiles using **Nix**, **devenv**, and **home-manager**.

## Quick Start

### New Machine Setup

```bash
# Install Nix (Determinate Systems installer)
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh

# Clone this repo
git clone git@github.com:testdepth/dotfiles.git ~/.dotfiles
cd ~/.dotfiles

# Allow direnv
direnv allow

# Apply configuration
home-manager switch --flake .#macbook
```

Or run the bootstrap script:

```bash
curl -fsSL https://raw.githubusercontent.com/testdepth/dotfiles/main/scripts/bootstrap.sh | bash
```

### Existing Machine Update

```bash
cd ~/.dotfiles
nix flake update  # Update dependencies
home-manager switch --flake .#macbook
```

## Structure

```
~/.dotfiles/
├── flake.nix              # Nix flake entry point
├── flake.lock             # Locked dependencies
├── devenv.nix             # Development shell
├── home.nix               # Base home-manager config
├── .envrc                 # direnv configuration
│
├── modules/               # Modular configurations
│   ├── shell/fish.nix     # Fish shell + starship prompt
│   ├── terminal/ghostty.nix  # Ghostty terminal
│   ├── git/default.nix    # Git configuration
│   └── editor/nvim/       # Neovim (LazyVim starter)
│
├── hosts/                 # Machine-specific configs
│   └── macbook/           # macOS configuration
│
├── scripts/               # Helper scripts
│   └── bootstrap.sh       # New machine setup
│
├── .claude/               # Claude Code settings
│   └── CLAUDE.md          # AI assistant instructions
│
└── AGENTS.md              # AI coding guidelines
```

## Workflow: Claude Code + Neovim + Ghostty

This setup is optimized for the [Claude Code + Neovim workflow](https://danielmiessler.com/blog/replacing-cursor-with-neovim-claude-code).

### 3-Pane Layout

```
+------------------+------------------+
|                  |                  |
|   Claude Code    |     Neovim       |
|                  |                  |
|                  +------------------+
|                  |      Shell       |
+------------------+------------------+
```

### Ghostty Keybindings

- `Cmd+D` - Split right (for Neovim)
- `Cmd+Shift+T` - Split down (for shell)
- `Ctrl+H/J/K/L` - Navigate between panes (vim-style)
- `Cmd+W` - Close pane

### Setup

1. Open Ghostty
2. `Cmd+D` to create right pane
3. `Cmd+Shift+T` to create bottom pane
4. Run `claude` in left pane
5. Open files with `nvim` in right pane

## Neovim

Uses [LazyVim starter](https://github.com/LazyVim/starter). See [modules/editor/nvim/README.md](modules/editor/nvim/README.md) for setup.

## Configurations

| Configuration | Description |
|---------------|-------------|
| `macbook` | macOS Apple Silicon |
| `macbook-intel` | macOS Intel |
| `linux` | Linux x86_64 |

## Commands

Available in the devenv shell:

```bash
apply   # Apply home-manager configuration
update  # Update flake inputs
fmt     # Format Nix files
```

## Requirements

- [Nix](https://nixos.org/) (with flakes enabled)
- [direnv](https://direnv.net/)
- [Ghostty](https://ghostty.org/) (terminal)
- [Claude Code](https://docs.anthropic.com/en/docs/claude-code/overview) (optional)

## Credits

- [LazyVim](https://www.lazyvim.org/)
- [Daniel Miessler's workflow](https://danielmiessler.com/blog/replacing-cursor-with-neovim-claude-code)
- [dejanr/dotfiles](https://github.com/dejanr/dotfiles) - Structure inspiration
