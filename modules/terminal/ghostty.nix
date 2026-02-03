{ config, pkgs, lib, ... }:

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
    keybind = cmd+d = new_split:right
    
    # Create new split below (for shell)
    keybind = cmd+shift+t = new_split:down
    
    # Navigate between panes (vim-style)
    keybind = ctrl+h = goto_split:left
    keybind = ctrl+j = goto_split:bottom
    keybind = ctrl+k = goto_split:top
    keybind = ctrl+l = goto_split:right
    
    # Close pane
    keybind = cmd+w = close_surface
    
    # Resize panes
    keybind = cmd+ctrl+h = resize_split:left,50
    keybind = cmd+ctrl+j = resize_split:down,50
    keybind = cmd+ctrl+k = resize_split:up,50
    keybind = cmd+ctrl+l = resize_split:right,50
    
    # Equalize splits
    keybind = cmd+= = equalize_splits
    
    # =============================================================================
    # APPEARANCE
    # =============================================================================
    
    # Theme
    theme = catppuccin-mocha
    
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
    
    # Use fish shell
    command = fish
    
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
    
    # Bell
    audible-bell = false
    visual-bell = false
    
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
    |                  +------------------+
    |                  |      Shell       |
    +------------------+------------------+
    ```
    
    ## Setup
    
    1. Open Ghostty
    2. `Cmd+D` to split right (for Neovim)
    3. `Cmd+Shift+T` to split bottom (for shell)
    4. Run `claude` in left pane
    5. Open files with `nvim` in right pane
    
    ## Navigation
    
    - `Ctrl+H` - Move to left pane
    - `Ctrl+J` - Move to bottom pane
    - `Ctrl+K` - Move to top pane
    - `Ctrl+L` - Move to right pane
    
    ## Pane Management
    
    - `Cmd+D` - Split right
    - `Cmd+Shift+T` - Split down
    - `Cmd+W` - Close pane
    - `Cmd+=` - Equalize panes
    
    ## Resize
    
    - `Cmd+Ctrl+H/J/K/L` - Resize in direction
  '';
}
