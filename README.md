# Mark's Dotfiles

Reproducible dotfiles using **Nix**, **devenv**, and **home-manager**.

## New Machine Setup (Complete Guide)

### Step 1: Install Xcode Command Line Tools

```bash
xcode-select --install
```
Click "Install" in the dialog. Wait ~5-10 minutes.

### Step 2: Generate SSH Key & Add to GitHub

```bash
# Generate SSH key
ssh-keygen -t ed25519 -C "testdepth@users.noreply.github.com"

# Start ssh-agent and add key
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519

# Copy public key to clipboard
pbcopy < ~/.ssh/id_ed25519.pub
```

Add key at https://github.com/settings/keys, then verify:
```bash
ssh -T git@github.com
```

### Step 3: Install Nix

Install Nix via the recommended multi-user installation. Open a Terminal (by pressing [Cmd] + [Space] and typing terminal) and run the following command:

```bash
sh <(curl --proto '=https' --tlsv1.2 -L https://nixos.org/nix/install)
```

**Restart terminal** after installation.

### Step 4: Enable Flakes

```bash
mkdir -p ~/.config/nix
echo "experimental-features = nix-command flakes" > ~/.config/nix/nix.conf
```

### Step 5: Install direnv

```bash
nix profile install nixpkgs#direnv
```

### Step 6: Clone & Setup Dotfiles

```bash
git clone git@github.com:testdepth/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
direnv allow
```
Wait for devenv to build (~2-5 min first time).

### Step 7: Apply Configuration

```bash
apply
```
Or: `nix run home-manager -- switch --flake .#macbook`

### Step 8: Set Fish as Default Shell

```bash
echo $(which fish) | sudo tee -a /etc/shells
chsh -s $(which fish)
```
**Restart terminal** to use fish.

### Step 9: Install Ghostty

Download from https://ghostty.org/download or:
```bash
brew install --cask ghostty
```

### Step 10: Install LazyVim (Neovim)

```bash
git clone https://github.com/LazyVim/starter ~/.config/nvim
rm -rf ~/.config/nvim/.git
nvim  # Wait for plugins to install, then :q
```

### Step 11: Install Claude Code (Optional)

```bash
npm install -g @anthropic-ai/claude-code
```

### Quick Reference

| Step | Command | Time |
|------|---------|------|
| Xcode tools | `xcode-select --install` | 5-10 min |
| SSH key | `ssh-keygen -t ed25519` | 1 min |
| Nix | `curl ... \| sh` | 2-3 min |
| Enable flakes | `echo ... > ~/.config/nix/nix.conf` | 10 sec |
| direnv | `nix profile install nixpkgs#direnv` | 30 sec |
| Clone & setup | `git clone ... && direnv allow` | 2-5 min |
| Apply config | `apply` | 2-5 min |
| Fish shell | `chsh -s $(which fish)` | 10 sec |
| Ghostty | Download/brew | 1 min |
| LazyVim | `git clone ...` | 1 min |

**Total: ~20-30 minutes**

---

## Existing Machine Update

```bash
cd ~/.dotfiles
nix flake update  # Update dependencies
apply             # Apply configuration
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
| `shark` | macOS Apple Silicon (shark) |
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
