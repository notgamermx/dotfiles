#!/usr/bin/env bash
# ==============================================================================
# Hyprland Custom Dotfiles Uninstaller
# Restores backed-up configurations and removes dotfile symlinks
# ==============================================================================

set -e

CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}"

echo "=== Hyprland Dotfiles Uninstaller ==="

restore_backup() {
    local target="$1"
    local target_path="$CONFIG_DIR/$target"

    if [ -L "$target_path" ]; then
        echo "[+] Removing symlink at $target_path"
        rm -f "$target_path"
    fi

    # Find the most recent backup file/folder
    LATEST_BACKUP=$(ls -td "$CONFIG_DIR/$target".backup-* 2>/dev/null | head -n 1 || true)

    if [ -n "$LATEST_BACKUP" ] && [ -e "$LATEST_BACKUP" ]; then
        echo "[+] Restoring backup: $LATEST_BACKUP -> $target_path"
        mv "$LATEST_BACKUP" "$target_path"
    else
        echo "[*] No prior backup found for $target."
    fi
}

read -p "Are you sure you want to uninstall dotfile symlinks and restore backups? [y/N] " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    restore_backup "hypr"
    restore_backup "waybar"
    echo ""
    echo "=== Uninstallation Complete! ==="
else
    echo "Uninstallation cancelled."
fi
