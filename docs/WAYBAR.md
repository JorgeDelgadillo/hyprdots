# Waybar Configuration Guide

This document details the Waybar configuration and customization options.

## Overview

The Waybar setup features a transparent, modular status bar with rounded modules and custom scripts for system monitoring and media tracking.

## Files

- **config.json** - Module configuration and layout
- **styles/style.css** - Visual styling (colors, transparency, borders)
- **scripts/system-monitor.sh** - System resource monitoring script
- **scripts/music-source.sh** - Music source detection (linked from scripts/waybar/)

## Layout

The bar is divided into three sections:

**Left**: `[Arch Icon] [Clock] [System Monitor]`

**Center**: `[Workspaces] [Update Indicator] [Screen Recording]`

**Right**: `[Tray] [Bluetooth] [Network] [Audio] [CPU] [Battery]`

## Modules

### Built-in Modules

#### Hyprland Workspaces
Shows active workspaces with visual indicators.

```json
"hyprland/workspaces": {
  "on-click": "activate",
  "format": "{icon}",
  "persistent-workspaces": {
    "1": [], "2": [], "3": [], "4": [], "5": []
  }
}
```

- Click to switch workspaces
- Persistent workspaces (1-5) always visible
- Active workspace highlighted

#### Clock
Displays time and date with alternating views.

```json
"clock": {
  "format": "{:L%A %H:%M}",
  "format-alt": "{:L%d %B W%V %Y}",
  "on-click-right": "omarchy-launch-floating-terminal-with-presentation omarchy-tz-select"
}
```

- Click to toggle between time and date
- Right-click for timezone selector

#### Network
Shows network status and bandwidth.

```json
"network": {
  "format-wifi": "{icon} {essid}",
  "format-ethernet": "󰀂",
  "format-disconnected": "󰤮",
  "tooltip-format-wifi": "{essid} ({frequency} GHz)\n⇣{bandwidthDownBytes}  ⇡{bandwidthUpBytes}",
  "on-click": "omarchy-launch-wifi"
}
```

Icons indicate signal strength and connection type.

#### Battery
Battery level with charging indication.

```json
"battery": {
  "format": "{capacity}% {icon}",
  "states": {
    "warning": 20,
    "critical": 10
  },
  "on-click": "omarchy-menu power"
}
```

Different icons for charging/discharging states.

#### Bluetooth
Bluetooth status indicator.

```json
"bluetooth": {
  "format": "",
  "format-connected": "󰂱",
  "tooltip-format": "Devices connected: {num_connections}",
  "on-click": "omarchy-launch-bluetooth"
}
```

#### Audio (PulseAudio)
Volume control and audio device management.

```json
"pulseaudio": {
  "format": "{icon}",
  "on-click": "omarchy-launch-or-focus-tui wiremix",
  "on-click-right": "pamixer -t",
  "scroll-step": 5
}
```

- Click: Open audio mixer
- Right-click: Mute/unmute
- Scroll: Adjust volume

#### CPU
CPU usage indicator.

```json
"cpu": {
  "interval": 5,
  "format": "󰍛",
  "on-click": "omarchy-launch-or-focus-tui btop"
}
```

Click to open system monitor (btop).

#### System Tray
Expandable tray for system icons.

```json
"group/tray-expander": {
  "orientation": "inherit",
  "drawer": {
    "transition-duration": 600
  },
  "modules": ["custom/expand-icon", "tray"]
}
```

Click the arrow to expand/collapse tray icons.

### Custom Modules

#### Arch/Omarchy Icon
Application launcher icon.

```json
"custom/arch": {
  "format": " ",
  "on-click": "omarchy-menu",
  "on-click-right": "omarchy-launch-terminal"
}
```

- Click: Open application menu
- Right-click: Open terminal

#### System Monitor
Custom module showing CPU and memory usage.

Location: `config/waybar/scripts/system-monitor.sh`

```json
"custom/system-monitor": {
  "format": "{}",
  "exec": "~/.config/waybar/scripts/system-monitor.sh",
  "return-type": "json",
  "interval": 3,
  "on-click": "omarchy-launch-or-focus-tui btop"
}
```

The script returns JSON with:
- CPU usage percentage
- Memory usage percentage
- Color-coded warnings (yellow > 75%, red > 90%)

#### Update Indicator
Shows when Omarchy updates are available.

```json
"custom/update": {
  "format": "",
  "exec": "omarchy-update-available",
  "on-click": "omarchy-launch-floating-terminal-with-presentation omarchy-update",
  "signal": 7,
  "interval": 21600
}
```

Hidden when no updates available.

#### Screen Recording Indicator
Shows when screen recording is active.

```json
"custom/screenrecording-indicator": {
  "on-click": "omarchy-cmd-screenrecord",
  "exec": "$OMARCHY_PATH/default/waybar/indicators/screen-recording.sh",
  "signal": 8,
  "return-type": "json"
}
```

#### Music Source Detector
Displays current music source with color coding.

Location: `scripts/waybar/music-source.sh`

Detects and displays:
- **Spotify** - Green background
- **YouTube** - Red background
- **Twitch** - Purple background
- **Browser** - Orange background

## Styling

### Color Scheme

The default theme uses:
- **Background**: `rgba(0, 0, 0, 0.7)` - Transparent black
- **Border**: `rgba(255, 255, 255, 0.2)` - Semi-transparent white
- **Text**: `#ffffff` - White
- **Border Radius**: `15px` - Rounded corners

### Module Styling

All modules share this base style:

```css
#clock,
#battery,
#network,
/* ... other modules ... */ {
    background: rgba(0, 0, 0, 0.7);
    border: 1px solid rgba(255, 255, 255, 0.2);
    border-radius: 15px;
    padding: 2px 8px;
    margin: 2px 4px;
    color: #ffffff;
}
```

### Custom Module Colors

#### Music Source
Dynamic colors based on detected source:

```css
#custom-music-source.spotify {
    background: rgba(29, 185, 84, 0.8);
    border: 1px solid rgba(30, 215, 96, 0.6);
}

#custom-music-source.youtube {
    background: rgba(255, 0, 0, 0.586);
    border: 1px solid rgba(255, 0, 0, 0.6);
}
```

#### System Monitor
Warning states:

```css
#custom-system-monitor.warning {
    background: rgba(255, 165, 0, 0.7);  /* Orange for 75%+ */
}

#custom-system-monitor.high {
    background: rgba(255, 0, 0, 0.7);    /* Red for 90%+ */
}
```

### Workspace Styling

```css
#workspaces button {
    background: rgba(255, 255, 255, 0.1);
    border-radius: 12px;
    padding: 2px 6px;
}

#workspaces button.active {
    background: rgba(255, 255, 255, 0.3);
    font-weight: bold;
}
```

### Tooltip Styling

```css
tooltip {
    background: rgba(0, 0, 0, 0.95);
    border: 1px solid rgba(255, 255, 255, 0.4);
    border-radius: 8px;
    padding: 8px 12px;
    box-shadow: 0 2px 10px rgba(0, 0, 0, 0.5);
}
```

## Customization

### Changing Colors

Edit `config/waybar/styles/style.css`:

```css
/* Change background transparency */
background: rgba(0, 0, 0, 0.9);  /* Less transparent */

/* Change text color */
color: #00ff00;  /* Green text */

/* Change border color */
border: 1px solid rgba(0, 255, 0, 0.4);  /* Green border */
```

### Adjusting Module Layout

Edit `config/waybar/config.json`:

```json
{
  "modules-left": ["custom/arch", "clock"],
  "modules-center": ["hyprland/workspaces"],
  "modules-right": ["cpu", "battery", "clock"]
}
```

### Adding New Modules

1. Add to module list in config:

```json
"modules-right": ["network", "battery", "custom/my-module"]
```

2. Configure the module:

```json
"custom/my-module": {
  "format": "{}",
  "exec": "~/scripts/my-script.sh",
  "interval": 10
}
```

3. Add styling in CSS:

```css
#custom-my-module {
    background: rgba(0, 0, 255, 0.7);
    border-radius: 15px;
    padding: 2px 8px;
}
```

### Changing Font

Edit the CSS:

```css
* {
    font-family: 'Your Font Name', sans-serif;
    font-size: 12px;
}
```

Make sure the font is installed and is a Nerd Font for icons.

### Module-Specific Customization

#### CPU Interval
```json
"cpu": {
  "interval": 10,  /* Update every 10 seconds */
}
```

#### Battery Warning Levels
```json
"battery": {
  "states": {
    "warning": 30,   /* Warning at 30% */
    "critical": 15   /* Critical at 15% */
  }
}
```

#### Network Update Frequency
```json
"network": {
  "interval": 5  /* Update every 5 seconds */
}
```

## Custom Scripts

### System Monitor Script

The system monitor script (`config/waybar/scripts/system-monitor.sh`) outputs JSON:

```json
{
  "text": "CPU: 45% MEM: 60%",
  "tooltip": "Detailed system info",
  "class": "normal|warning|high"
}
```

Modify thresholds in the script:
```bash
if [ $cpu_usage -gt 90 ] || [ $mem_usage -gt 90 ]; then
    class="high"
elif [ $cpu_usage -gt 75 ] || [ $mem_usage -gt 75 ]; then
    class="warning"
fi
```

### Creating Custom Scripts

Custom module scripts should:
1. Be executable (`chmod +x script.sh`)
2. Output plain text or JSON
3. Handle signals for instant updates

Example JSON output script:
```bash
#!/bin/bash
echo "{\"text\":\"Value\", \"tooltip\":\"Info\", \"class\":\"normal\"}"
```

## Signals

Update modules instantly with signals:

```bash
# Update module with signal 7 (update indicator)
pkill -RTMIN+7 waybar

# Update screen recording indicator (signal 8)
pkill -RTMIN+8 waybar
```

## Troubleshooting

### Waybar Not Starting

```bash
# Check for errors
waybar 2>&1 | tee waybar.log

# Validate JSON config
jq . ~/.config/waybar/config
```

### Custom Scripts Not Working

1. Check permissions: `ls -l ~/.config/waybar/scripts/`
2. Run manually: `~/.config/waybar/scripts/system-monitor.sh`
3. Check script output format (JSON vs plain text)

### Styling Not Applied

1. Ensure CSS file path is correct
2. Check for CSS syntax errors
3. Reload Waybar: `killall waybar && waybar &`

### Icons Not Showing

1. Install a Nerd Font (e.g., JetBrainsMono Nerd Font)
2. Set font in CSS: `font-family: 'JetBrainsMonoNL Nerd Font'`
3. Verify font is installed: `fc-list | grep JetBrains`

### Modules Not Updating

1. Check interval settings
2. Verify scripts are executable
3. Check script exit codes
4. Review Waybar logs

## Reload Waybar

After making changes:

```bash
killall waybar && waybar &
```

Or use the Omarchy command:
```bash
omarchy-reload-waybar
```

## Advanced Features

### Click Actions

Modules support multiple click types:
- `on-click` - Left click
- `on-click-right` - Right click
- `on-click-middle` - Middle click
- `on-scroll-up` - Scroll up
- `on-scroll-down` - Scroll down

Example:
```json
"pulseaudio": {
  "on-click": "pavucontrol",
  "on-click-right": "pamixer -t",
  "on-scroll-up": "pamixer -i 5",
  "on-scroll-down": "pamixer -d 5"
}
```

### Dynamic Classes

Scripts can return CSS classes for conditional styling:

```json
{
  "text": "Status",
  "class": "warning"
}
```

Then in CSS:
```css
#custom-module.warning {
    background: orange;
}
```

## Resources

- [Waybar Wiki](https://github.com/Alexays/Waybar/wiki)
- [Waybar Module Reference](https://github.com/Alexays/Waybar/wiki/Module:-Custom)
- [Nerd Fonts](https://www.nerdfonts.com/)

## Example Configurations

### Minimal Bar

```json
{
  "modules-left": ["hyprland/workspaces"],
  "modules-center": ["clock"],
  "modules-right": ["battery"]
}
```

### Information-Dense Bar

```json
{
  "modules-left": ["custom/arch", "clock", "cpu", "memory", "temperature"],
  "modules-center": ["hyprland/workspaces"],
  "modules-right": ["tray", "bluetooth", "network", "pulseaudio", "battery"]
}
```

### Vertical Bar

Change position in config:
```json
{
  "position": "left",
  "height": null,
  "width": 30
}
```
