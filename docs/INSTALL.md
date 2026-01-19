# Installation Guide

This guide will help you install and configure the Hyprdots setup on your system.

## Prerequisites

Before installing, ensure you have the following:

1. **Omarchy Desktop Environment**
   - This configuration is built on top of [Omarchy](https://omarchy.org)
   - Follow the official Omarchy installation guide first

2. **Required Software**
   - Hyprland (usually included with Omarchy)
   - Waybar
   - Git
   - A Nerd Font (recommended: JetBrainsMono Nerd Font)

3. **Optional but Recommended**
   - Starship (for shell prompt)
   - notify-send / libnotify (for notifications)
   - jq (for JSON parsing in scripts)

## Installation Steps

### 1. Clone the Repository

```bash
cd ~/Projects
git clone <your-repo-url> hyprdots
cd hyprdots
```

### 2. Backup Existing Configurations

Always backup your existing configurations before installing:

```bash
# Backup Hyprland config
cp -r ~/.config/hypr ~/.config/hypr.backup

# Backup Waybar config
cp -r ~/.config/waybar ~/.config/waybar.backup

# Backup Starship config
cp ~/.config/starship.toml ~/.config/starship.toml.backup 2>/dev/null || true
```

### 3. Install Hyprland Configuration

Since this configuration uses Omarchy, you'll need to place the configs in the Omarchy user config directory:

```bash
# Create Omarchy user config directory if it doesn't exist
mkdir -p ~/.config/omarchy

# Link or copy Hyprland configs
cp config/hyprland/bindings.conf ~/.config/omarchy/
cp config/hyprland/looknfeel.conf ~/.config/omarchy/
cp config/hyprland/monitors.conf ~/.config/omarchy/
```

### 4. Install Waybar Configuration

```bash
# Create Waybar config directory
mkdir -p ~/.config/waybar

# Copy Waybar configuration
cp config/waybar/config.json ~/.config/waybar/config
cp -r config/waybar/styles ~/.config/waybar/
cp -r config/waybar/scripts ~/.config/waybar/

# Make scripts executable
chmod +x ~/.config/waybar/scripts/*.sh
```

### 5. Install Scripts

```bash
# Create a local bin directory if it doesn't exist
mkdir -p ~/.local/bin

# Copy scripts to local bin or keep in place
cp -r scripts ~/hyprdots-scripts

# Make scripts executable
chmod +x ~/hyprdots-scripts/session/*.sh
chmod +x ~/hyprdots-scripts/utils/*.sh
chmod +x ~/hyprdots-scripts/waybar/*.sh

# Optionally, add scripts to PATH by adding to ~/.bashrc or ~/.zshrc:
# export PATH="$HOME/hyprdots-scripts/session:$HOME/hyprdots-scripts/utils:$PATH"
```

### 6. Install Shell Configuration

```bash
# Install Starship if not already installed
# Arch Linux: sudo pacman -S starship
# Ubuntu/Debian: Install from https://starship.rs

# Copy Starship config
cp shell/starship.toml ~/.config/starship.toml
```

### 7. Configure Monitor Setup

Edit the monitor configuration for your specific setup:

```bash
nano ~/.config/omarchy/monitors.conf
```

Update the monitor names and resolutions according to your hardware. You can find your monitor names with:

```bash
hyprctl monitors
```

### 8. Update Waybar Script Paths

Check the Waybar configuration and update the script path if needed:

```bash
nano ~/.config/waybar/config
```

Look for the `custom/system-monitor` module and ensure the path points to:
```json
"exec": "~/.config/waybar/scripts/system-monitor.sh",
```

## Post-Installation

### 1. Reload Hyprland

After installation, reload Hyprland to apply changes:

```bash
hyprctl reload
```

Or restart Hyprland completely (logout and login again).

### 2. Reload Waybar

```bash
killall waybar
waybar &
```

Or use the Omarchy command if available:
```bash
omarchy-reload-waybar
```

### 3. Test Scripts

Test that scripts are working:

```bash
# Test system monitor
~/.config/waybar/scripts/system-monitor.sh

# Test music source detector
~/hyprdots-scripts/waybar/music-source.sh

# Test pomodoro timer
~/hyprdots-scripts/utils/pomo_timer.sh 1 1 "Test"
```

## Customization

### Adjusting Keybindings

Edit `~/.config/omarchy/bindings.conf` to customize keybindings. The format is:

```
bindd = MODIFIERS, KEY, Description, action, [parameters]
```

Common modifiers:
- `SUPER` - Windows/Super key
- `SHIFT` - Shift key
- `ALT` - Alt key
- `CTRL` - Control key

### Customizing Waybar

1. **Change appearance**: Edit `~/.config/waybar/styles/style.css`
2. **Modify modules**: Edit `~/.config/waybar/config`
3. **After changes**: Reload Waybar with `killall waybar && waybar &`

### Adjusting Visual Settings

Edit `~/.config/omarchy/looknfeel.conf` to customize:
- Gaps between windows
- Border sizes
- Animation speeds
- Layout preferences

## Troubleshooting

### Waybar Not Showing Custom Modules

- Check script permissions: `ls -l ~/.config/waybar/scripts/`
- Verify script paths in config: `~/.config/waybar/config`
- Check Waybar logs: `killall waybar && waybar 2>&1 | tee waybar.log`

### Keybindings Not Working

- Ensure configs are in the right location for Omarchy
- Check for syntax errors: `hyprctl reload` will show errors
- Verify no conflicting bindings

### Monitor Configuration Issues

- Get monitor info: `hyprctl monitors`
- Check workspace assignments in monitors.conf
- Ensure monitor names match your hardware

### Script Errors

- Check script has execute permissions
- Verify dependencies are installed (`jq`, `notify-send`, etc.)
- Run scripts manually to see error messages

## Uninstallation

To revert to your previous configuration:

```bash
# Restore backups
rm -rf ~/.config/omarchy/bindings.conf ~/.config/omarchy/looknfeel.conf ~/.config/omarchy/monitors.conf
rm -rf ~/.config/waybar
mv ~/.config/waybar.backup ~/.config/waybar

# Remove scripts
rm -rf ~/hyprdots-scripts

# Restore Starship config
mv ~/.config/starship.toml.backup ~/.config/starship.toml

# Reload
hyprctl reload
killall waybar && waybar &
```

## Getting Help

- Check the main [README.md](../README.md) for feature overview
- Review component-specific documentation in the `docs/` folder
- Check [Omarchy documentation](https://omarchy.org)
- Visit [Hyprland wiki](https://wiki.hyprland.org)

## Next Steps

After installation:
1. Review [HYPRLAND.md](HYPRLAND.md) for Hyprland-specific configuration
2. Check [WAYBAR.md](WAYBAR.md) for Waybar customization options
3. Read [SCRIPTS.md](SCRIPTS.md) to learn about available scripts
