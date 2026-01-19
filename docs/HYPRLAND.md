# Hyprland Configuration Guide

This document details the Hyprland configuration included in this dotfiles repository.

## Configuration Files

The Hyprland configuration is split into three main files for better organization:

- **bindings.conf** - Keybindings and application launchers
- **looknfeel.conf** - Visual settings and animations
- **monitors.conf** - Display and workspace configuration

## Keybindings (bindings.conf)

### Application Launchers

#### Core Applications
| Keybinding | Action | Description |
|------------|--------|-------------|
| `SUPER + RETURN` | Terminal | Opens terminal in current working directory |
| `SUPER + SHIFT + F` | File Manager | Opens Nautilus file manager |
| `SUPER + SHIFT + B` | Browser | Opens default browser |
| `SUPER + SHIFT + ALT + B` | Browser (Private) | Opens browser in private mode |
| `SUPER + SHIFT + M` | Music | Launches or focuses Spotify |
| `SUPER + SHIFT + N` | Editor | Opens default code editor |
| `SUPER + SHIFT + T` | Activity Monitor | Opens btop system monitor |
| `SUPER + SHIFT + D` | Docker | Opens lazydocker TUI |
| `SUPER + SHIFT + G` | Signal | Launches or focuses Signal messenger |
| `SUPER + SHIFT + O` | Obsidian | Opens Obsidian note-taking app |
| `SUPER + SHIFT + W` | Typora | Opens Typora markdown editor |
| `SUPER + SHIFT + /` | Passwords | Opens 1Password |

#### Web Applications
These launchers open web apps in dedicated windows:

| Keybinding | Application |
|------------|-------------|
| `SUPER + SHIFT + A` | ChatGPT |
| `SUPER + SHIFT + ALT + A` | Grok |
| `SUPER + SHIFT + C` | Calendar (HEY) |
| `SUPER + SHIFT + E` | Email (HEY) |
| `SUPER + SHIFT + Y` | YouTube |
| `SUPER + SHIFT + ALT + G` | WhatsApp Web |
| `SUPER + SHIFT + CTRL + G` | Google Messages |
| `SUPER + SHIFT + P` | Google Photos |
| `SUPER + SHIFT + X` | X (Twitter) |
| `SUPER + SHIFT + ALT + X` | X Compose |

### Window Management

| Keybinding | Action |
|------------|--------|
| `SUPER + Q` | Close active window |
| `SUPER + W` | (Unbound - was default close, now Q is used) |

### Workspace Navigation

| Keybinding | Action |
|------------|--------|
| `SUPER + BTN_SIDE` | Previous workspace |
| `SUPER + BTN_EXTRA` | Next workspace |

Note: Mouse side buttons can be used with SUPER to navigate workspaces.

## Custom Bindings

You can add your own keybindings using the format:

```conf
bindd = MODIFIERS, KEY, Description, action, parameters
```

### Examples

```conf
# Launch a custom application
bindd = SUPER SHIFT, C, Calculator, exec, uwsm-app -- gnome-calculator

# Run a custom script
bindd = SUPER, P, Screenshot, exec, ~/scripts/screenshot.sh

# Hyprland actions
bindd = SUPER, F, Fullscreen, fullscreen, 0
```

### Unbinding Keys

To remove default Omarchy bindings:

```conf
unbind = SUPER, SPACE
```

## Visual Settings (looknfeel.conf)

### General Settings

```conf
general {
    gaps_in = 0      # Gap size between windows
    gaps_out = 0     # Gap size from screen edge
    border_size = 0  # Window border thickness
    layout = dwindle # Layout algorithm
}
```

### Decoration

```conf
decoration {
    rounding = 8     # Corner radius for windows
}
```

### Dwindle Layout

```conf
dwindle {
    # Controls aspect ratio for single windows on wide screens
    single_window_aspect_ratio = 1 1
}
```

### Animations

```conf
animation = workspaces, 1, 5, default, slide
```

Format: `animation = NAME, ENABLED, SPEED, BEZIER, STYLE`

Available animation names:
- `windows` - Window open/close
- `windowsIn` - Window appearing
- `windowsOut` - Window disappearing
- `windowsMove` - Window movement
- `fade` - Fade effects
- `border` - Border color changes
- `workspaces` - Workspace switching
- `layers` - Layer surface animations

Animation styles:
- `slide` - Slide transition
- `slidevert` - Vertical slide
- `fade` - Fade in/out
- `popin` - Pop-in effect

## Monitor Configuration (monitors.conf)

### Display Setup

```conf
# Environment variables
env = GDK_SCALE,2

# Monitor definitions
monitor = eDP-1, preferred, auto, 1
monitor = HDMI-A-1, 3440x1440@120, auto, 1
```

Format: `monitor = NAME, RESOLUTION@REFRESH, POSITION, SCALE`

### Finding Monitor Names

Use this command to list your monitors:

```bash
hyprctl monitors
```

### Monitor Configuration Examples

```conf
# Auto-detect resolution, auto position, no scaling
monitor = DP-1, preferred, auto, 1

# Specific resolution at 144Hz, positioned at coordinates
monitor = DP-1, 2560x1440@144, 1920x0, 1

# HiDPI scaling (2x)
monitor = eDP-1, 1920x1080, 0x0, 2

# Disable a monitor
monitor = HDMI-A-2, disable
```

### Workspace Assignment

Assign specific workspaces to monitors:

```conf
# Workspaces for laptop screen (eDP-1)
workspace = 1, monitor:eDP-1, persistent:true, default:true
workspace = 2, monitor:eDP-1, persistent:true
workspace = 3, monitor:eDP-1, persistent:true
workspace = 4, monitor:eDP-1, persistent:true

# Workspaces for external monitor (HDMI-A-1)
workspace = 5, monitor:HDMI-A-1, persistent:true
workspace = 6, monitor:HDMI-A-1, persistent:true
workspace = 7, monitor:HDMI-A-1, persistent:true
workspace = 8, monitor:HDMI-A-1, persistent:true
```

Options:
- `persistent:true` - Workspace always exists even when empty
- `default:true` - Default workspace for that monitor

## Advanced Configuration

### Environment Variables

Set environment variables for applications:

```conf
env = GDK_SCALE, 2
env = QT_SCALE_FACTOR, 2
env = XCURSOR_SIZE, 24
```

### Window Rules

Create rules for specific windows (add to bindings.conf or looknfeel.conf):

```conf
# Float specific applications
windowrule = float, ^(pavucontrol)$
windowrule = float, ^(blueman-manager)$

# Workspace assignment
windowrule = workspace 2, ^(firefox)$

# Opacity
windowrule = opacity 0.9, ^(kitty)$

# Size and position
windowrule = size 800 600, ^(calculator)$
windowrule = center, ^(calculator)$
```

### Layer Rules

Control layer surfaces (bars, notifications, etc.):

```conf
layerrule = blur, waybar
layerrule = ignorezero, waybar
```

## Omarchy Integration

This configuration leverages Omarchy's built-in commands:

- `omarchy-launch-browser` - Smart browser launcher
- `omarchy-launch-or-focus` - Launch or focus application
- `omarchy-launch-webapp` - Open web app in dedicated window
- `omarchy-launch-tui` - Launch terminal UI application
- `omarchy-menu` - Application launcher menu
- `omarchy-cmd-terminal-cwd` - Get terminal's current directory

Refer to [Omarchy documentation](https://omarchy.org) for more commands.

## Useful Hyprland Commands

### hyprctl Commands

```bash
# Reload configuration
hyprctl reload

# Get monitor info
hyprctl monitors

# List all windows
hyprctl clients

# Get active window info
hyprctl activewindow

# List all workspaces
hyprctl workspaces

# Switch workspace
hyprctl dispatch workspace 2

# Move window to workspace
hyprctl dispatch movetoworkspace 3
```

## Tips and Tricks

1. **Quick Window Movement**: Use `SUPER + [1-9]` to switch workspaces (default Omarchy binding)
2. **Multi-Monitor**: Assign different workspace ranges to different monitors
3. **Persistent Workspaces**: Keep important workspaces always visible even when empty
4. **Web Apps**: Use `omarchy-launch-webapp` for any web service you use frequently
5. **Terminal CWD**: The terminal launcher opens in the current directory of the focused terminal

## Troubleshooting

### Keybindings Not Working

1. Check for syntax errors: `hyprctl reload` will show them
2. Ensure no conflicting bindings exist
3. Verify Omarchy commands are in PATH

### Monitor Not Detected

1. Check connection and power
2. Run `hyprctl monitors` to see available monitors
3. Update monitor name in monitors.conf
4. Try `monitor = NAME, preferred, auto, 1` for auto-detection

### Windows Not Following Rules

1. Get window class: `hyprctl activewindow | grep class`
2. Use `^(class)$` for exact match or `class` for partial match
3. Reload config after changes

## Further Reading

- [Hyprland Wiki](https://wiki.hyprland.org)
- [Omarchy Documentation](https://omarchy.org)
- [Hyprland Variables](https://wiki.hyprland.org/Configuring/Variables/)
- [Hyprland Dispatchers](https://wiki.hyprland.org/Configuring/Dispatchers/)
