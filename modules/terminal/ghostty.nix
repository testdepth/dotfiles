{
  config,
  pkgs,
  lib,
  ...
}:

{
  # Ghostty configuration
  # Note: Ghostty config is a plain text file, not managed by home-manager directly
  # This creates the config file in ~/.config/ghostty/config

  xdg.configFile."ghostty/config".text = ''
    # Ghostty Configuration
    # 3-pane layout for Claude Code + Neovim workflow
    # Based on: https://danielmiessler.com/blog/replacing-cursor-with-neovim-claude-code

    # =============================================================================
    # KEYBINDINGS - Pane Management
    # =============================================================================

    # Create new split to the right (for Neovim)
    keybind = cmd+d=new_split:right

    # Create new split below (for shell)
    keybind = cmd+shift+d=new_split:down

    # Navigate between panes (Cmd+Option+Arrows)
    keybind = cmd+alt+left=goto_split:left
    keybind = cmd+alt+down=goto_split:bottom
    keybind = cmd+alt+up=goto_split:top
    keybind = cmd+alt+right=goto_split:right

    # Close pane
    keybind = cmd+w=close_surface

    # Resize panes
    keybind = cmd+ctrl+h=resize_split:left,50
    keybind = cmd+ctrl+j=resize_split:down,50
    keybind = cmd+ctrl+k=resize_split:up,50
    keybind = cmd+ctrl+l=resize_split:right,50

    # Equalize splits
    keybind = cmd+equal=equalize_splits

    # =============================================================================
    # APPEARANCE
    # =============================================================================

    # Theme
    theme = nordfox

    # Font
    font-family = JetBrains Mono
    font-size = 14
    font-thicken = true

    # Cursor
    cursor-style = block
    cursor-style-blink = false

    # Window
    window-padding-x = 8
    window-padding-y = 8
    window-decoration = true
    macos-titlebar-style = hidden

    # =============================================================================
    # SHELL
    # =============================================================================
    # TODO: parametrize hostname
    # Use fish shell (full path needed for macOS GUI apps)
    command = /Users/gerald/.nix-profile/bin/fish 

    # Shell integration
    shell-integration = fish
    shell-integration-features = cursor,sudo,title

    # =============================================================================
    # BEHAVIOR
    # =============================================================================

    # Copy/paste
    copy-on-select = true
    clipboard-read = allow
    clipboard-write = allow

    # Mouse
    mouse-hide-while-typing = true

    # Scrollback
    scrollback-limit = 10000

    # Links
    link-url = true


    # =============================================================================
    # PERFORMANCE
    # =============================================================================

    # GPU acceleration
    gtk-single-instance = true
  '';

  # Also create a simple README for the workflow
  xdg.configFile."ghostty/README.md".text = ''
    # Ghostty + Claude Code + Neovim Workflow

    ## Layout

    ```
    +------------------+------------------+
    |                  |                  |
    |   Claude Code    |     Neovim       |
    |                  |                  |
    +------------------+------------------+
    |              Shell                  |
    +-------------------------------------+
    ```

    ## Setup

    1. Open Ghostty
    2. `Cmd+Shift+D` to split bottom (full-width shell)
    3. `Cmd+Option+↑` to move to top pane
    4. `Cmd+D` to split right (for Neovim)
    5. Run `claude` in left pane, `nvim` in right pane

    ## Navigation (Ghostty panes)

    - `Cmd+Option+←` - Move to left pane
    - `Cmd+Option+↓` - Move to bottom pane
    - `Cmd+Option+↑` - Move to top pane
    - `Cmd+Option+→` - Move to right pane

    ## Navigation (Neovim splits)

    - `Ctrl+H` - Move to left split
    - `Ctrl+J` - Move to lower split
    - `Ctrl+K` - Move to upper split
    - `Ctrl+L` - Move to right split

    ## Pane Management

    - `Cmd+D` - Split right
    - `Cmd+Shift+D` - Split down
    - `Cmd+W` - Close pane
    - `Cmd+=` - Equalize panes

    ## Resize

    - `Cmd+Ctrl+H/J/K/L` - Resize in direction
  '';
}
