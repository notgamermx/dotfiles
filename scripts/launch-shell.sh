#!/usr/bin/env bash
# ==============================================================================
# Desktop Shell Launcher
# Prefers Caelestia Shell (caelestia-dots/shell / quickshell)
# Falls back seamlessly to Waybar if Caelestia Shell is not installed
# ==============================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# 1. Kill any active Waybar or Quickshell instances
pkill -x waybar &>/dev/null || true
pkill -x quickshell &>/dev/null || true
pkill -x caelestia-shell &>/dev/null || true

while pgrep -x waybar >/dev/null || pgrep -x quickshell >/dev/null; do sleep 0.1; done

# 2. Check for Caelestia Shell / Quickshell
if command -v caelestia-shell &>/dev/null; then
    echo "[+] Launching Caelestia Shell..."
    caelestia-shell &
elif command -v quickshell &>/dev/null && [ -d "$HOME/.local/share/caelestia/shell" ]; then
    echo "[+] Launching Caelestia Shell via quickshell..."
    quickshell -path "$HOME/.local/share/caelestia/shell" &
elif command -v waybar &>/dev/null; then
    echo "[*] Caelestia Shell not detected. Falling back to Waybar..."
    "$SCRIPT_DIR/launch-waybar.sh" &
else
    echo "[!] Neither Caelestia Shell nor Waybar could be found!"
fi
