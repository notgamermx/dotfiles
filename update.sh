#!/usr/bin/env bash
# ==============================================================================
# Hyprland Custom Dotfiles Updater
# Pulls git updates, updates packages/plugins, and reloads environment
# ==============================================================================

set -e

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CAELESTIA_SHELL_DIR="$HOME/.local/share/caelestia/shell"

echo "=== Hyprland Dotfiles Updater ==="

# 1. Git Pull Dotfiles
echo "[+] Pulling latest changes from dotfiles repository..."
git -C "$REPO_DIR" pull || echo "[!] Failed to pull git updates, proceeding..."

# 2. Update Caelestia Shell if present
if [ -d "$CAELESTIA_SHELL_DIR" ]; then
    echo "[+] Updating Caelestia Shell repository..."
    git -C "$CAELESTIA_SHELL_DIR" pull || echo "[!] Failed to update Caelestia Shell repo."
fi

# 3. Detect AUR helper and system update
if command -v paru &>/dev/null; then
    AUR_HELPER="paru"
elif command -v yay &>/dev/null; then
    AUR_HELPER="yay"
else
    AUR_HELPER=""
fi

if [ -n "$AUR_HELPER" ]; then
    echo "[+] Updating system packages via $AUR_HELPER..."
    $AUR_HELPER -Syu --noconfirm || echo "[!] Package update skipped or encountered errors."
fi

# 4. Update hyprpm plugins
if command -v hyprpm &>/dev/null; then
    echo "[+] Updating Hyprland plugins (hyprpm)..."
    hyprpm update || echo "[!] hyprpm update skipped."
fi

# 5. Reload Environment
echo "[+] Reloading Hyprland and Shell..."
"$REPO_DIR/scripts/reload.sh"

echo ""
echo "=== Update Complete! ==="
