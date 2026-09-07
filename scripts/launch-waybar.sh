#!/usr/bin/env bash
# ==============================================================================
# Waybar Launcher Script
# Kills existing instances and launches Waybar safely
# ==============================================================================

# Terminate already running waybar instances
pkill -x waybar &>/dev/null

# Wait until the processes have been killed
while pgrep -x waybar >/dev/null; do sleep 0.1; done

# Launch Waybar
waybar &
