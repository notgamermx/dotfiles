#!/usr/bin/env bash
# ==============================================================================
# Dynamic Video Wallpaper Script (mpvpaper with Fallback)
# Handles multi-monitor setups, graceful error checking, and toggles
# ==============================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WALLPAPER_DIR="$SCRIPT_DIR/../assets/wallpapers"
DEFAULT_VIDEO="$WALLPAPER_DIR/default.mp4"

# 1. Toggle Option (kill running mpvpaper)
if [[ "$1" == "--toggle" ]]; then
    if pgrep -x mpvpaper &>/dev/null; then
        echo "[+] Stopping mpvpaper..."
        pkill -x mpvpaper
        exit 0
    fi
fi

# 2. Check mpvpaper installation
if ! command -v mpvpaper &>/dev/null; then
    echo "[!] mpvpaper is not installed."
    if command -v swww &>/dev/null; then
        echo "[*] Falling back to swww..."
        swww init &>/dev/null || true
        exit 0
    else
        echo "[!] No supported wallpaper daemon found. Skipping background..."
        exit 1
    fi
fi

# 3. Check for Video File
if [ ! -f "$DEFAULT_VIDEO" ]; then
    echo "[!] Video wallpaper not found at: $DEFAULT_VIDEO"
    echo "[*] Please place an .mp4 video file at assets/wallpapers/default.mp4"
    exit 1
fi

# 4. Stop any existing mpvpaper instances
pkill -x mpvpaper &>/dev/null || true

# 5. Multi-monitor auto-detection
if command -v hyprctl &>/dev/null; then
    MONITORS=$(hyprctl monitors -j | grep -oP '"name":\s*"\K[^"]+')
else
    MONITORS="*"
fi

# 6. Launch mpvpaper on each active monitor
echo "[+] Starting mpvpaper video wallpaper..."
for mon in $MONITORS; do
    mpvpaper -o "no-audio --loop-playlist=inf --hwdec=auto" "$mon" "$DEFAULT_VIDEO" &
done

echo "[+] Video wallpaper playing on monitor(s): $MONITORS"
