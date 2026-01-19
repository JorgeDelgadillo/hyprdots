# Hyprdots

A comprehensive Hyprland configuration with custom Waybar setup, productivity scripts, and shell customizations built on top of [Omarchy](https://omarchy.org).

## Overview

This repository contains a well-organized collection of dotfiles for a modern Wayland-based desktop environment using Hyprland as the window manager. It includes:

- Custom Hyprland configuration with keybindings and visual settings
- Waybar status bar with system monitoring and custom modules
- Productivity utilities including session management and pomodoro timer
- Shell customization with Starship prompt
- Multi-monitor support

## Features

- **Hyprland Window Manager**: Tiling window manager with smooth animations and custom keybindings
- **Custom Waybar**: Transparent, rounded modules with system monitoring (CPU, battery, network, Bluetooth)
- **Session Management**: Save and restore workspace sessions
- **Music Source Detection**: Waybar module to display current music source (Spotify, YouTube, etc.)
- **Pomodoro Timer**: CLI-based productivity timer with visual progress bars
- **Multi-Monitor Setup**: Pre-configured support for multiple displays
- **Starship Prompt**: Minimalist, fast shell prompt with git integration

## Directory Structure

```
.
├── config/
│   ├── hyprland/          # Hyprland configuration files
│   │   ├── bindings.conf  # Application and window manager keybindings
│   │   ├── looknfeel.conf # Visual settings (gaps, borders, animations)
│   │   └── monitors.conf  # Display and workspace configuration
│   └── waybar/            # Waybar configuration
│       ├── config.json    # Waybar module configuration
│       ├── scripts/       # Waybar custom module scripts
│       │   └── system-monitor.sh  # System resource monitoring
│       └── styles/        # Waybar styling
│           └── style.css  # Custom transparent theme
├── scripts/
│   ├── session/           # Session management utilities
│   │   ├── save_session.sh     # Save current workspace state
│   │   └── restore_session.sh  # Restore saved session
│   ├── utils/             # General utility scripts
│   │   └── pomo_timer.sh  # Pomodoro timer implementation
│   └── waybar/            # Waybar-specific scripts
│       └── music-source.sh     # Detect and display music source
├── shell/
│   └── starship.toml      # Starship prompt configuration
└── docs/                  # Additional documentation
```

## Key Components

### Hyprland Configuration

- **bindings.conf**: Custom keybindings for applications and window management
  - `SUPER + RETURN`: Open terminal in current directory
  - `SUPER + Q`: Close window
  - `SUPER + SHIFT + [B/M/N/etc]`: Launch applications (browser, music, editor, etc.)
  - Web app launchers for ChatGPT, email, calendar, and more

- **looknfeel.conf**: Visual customization
  - Workspace slide animations
  - Configurable gaps and borders
  - Layout preferences

- **monitors.conf**: Multi-monitor setup
  - Display configuration for eDP-1 (laptop) and HDMI-A-1 (external)
  - Persistent workspaces across monitors
  - HiDPI scaling support

### Waybar

A transparent, modular status bar with:
- **System Information**: CPU usage, battery status, network, Bluetooth
- **Workspace Indicator**: Visual workspace switcher
- **Clock**: Time and date display
- **Custom Modules**: System monitor, music source detector
- **Tray**: Expandable system tray

The styling features rounded, semi-transparent modules with color-coded states.

### Scripts

#### Session Management
- **save_session.sh**: Captures current window layout and applications
- **restore_session.sh**: Restores saved workspace state

#### Productivity
- **pomo_timer.sh**: Terminal-based pomodoro timer
  - Customizable work/break intervals
  - Visual progress bar
  - Desktop notifications
  - Usage: `pomo [work_minutes] [break_minutes] ["task description"]`

#### Waybar Modules
- **music-source.sh**: Detects playing music source (Spotify, YouTube, Twitch, etc.)
- **system-monitor.sh**: Monitors CPU and memory usage with color-coded warnings

### Shell Configuration

- **starship.toml**: Minimal, fast shell prompt
  - Git integration with branch and status
  - Directory truncation for clean display
  - Custom styling

## Installation

See [INSTALL.md](docs/INSTALL.md) for detailed installation instructions.

## Quick Start

1. **Prerequisites**: Ensure you have [Omarchy](https://omarchy.org) installed
2. **Clone**: `git clone <repo-url> ~/.config/hyprdots`
3. **Link configs**: Symlink configuration files to appropriate locations
4. **Reload**: Restart Hyprland or reload configurations

## Customization

### Hyprland Keybindings

Edit `config/hyprland/bindings.conf` to customize keybindings. All bindings use the `bindd` directive for better organization.

### Waybar Appearance

Modify `config/waybar/styles/style.css` to change colors, transparency, and module styling.

### Monitor Setup

Edit `config/hyprland/monitors.conf` to configure your display layout and workspace assignments.

## Dependencies

- [Hyprland](https://hyprland.org) - Wayland compositor
- [Omarchy](https://omarchy.org) - Desktop environment framework
- [Waybar](https://github.com/Alexays/Waybar) - Status bar
- [Starship](https://starship.rs) - Shell prompt
- Standard utilities: `notify-send`, `jq`, `hyprctl`

## Documentation

Additional documentation can be found in the `docs/` directory:
- [INSTALL.md](docs/INSTALL.md) - Installation guide
- [HYPRLAND.md](docs/HYPRLAND.md) - Hyprland configuration details
- [WAYBAR.md](docs/WAYBAR.md) - Waybar customization guide
- [SCRIPTS.md](docs/SCRIPTS.md) - Script usage and customization

## Contributing

Contributions are welcome! Feel free to open issues or submit pull requests.

## License

This configuration is provided as-is for personal use and modification.

## Acknowledgments

- Built on top of [Omarchy](https://omarchy.org)
- Inspired by the Hyprland and r/unixporn communities
