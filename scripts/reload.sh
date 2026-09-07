#!/usr/bin/env bash
# ==============================================================================
# Reload Desktop Environment Components
# ==============================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "[+] Reloading Hyprland config..."
hyprctl reload

echo "[+] Relaunching Desktop Shell (Caelestia Shell / Waybar)..."
"$SCRIPT_DIR/launch-shell.sh"

echo "[+] Relaunching Video Wallpaper..."
"$SCRIPT_DIR/set-bg.sh"

echo "[+] Reload complete!"
