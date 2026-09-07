#!/usr/bin/env bash
# ==============================================================================
# Hyprland Custom Dotfiles Installer
# Inspired by Caelestia Shell (caelestia-dots/shell) & Built for Arch Linux
# ==============================================================================

set -e

DRY_RUN=false
if [[ "$1" == "--dry-run" ]]; then
    DRY_RUN=true
    echo "[DRY-RUN MODE ENABLED] No files or packages will be modified."
elif [[ "$1" == "--uninstall" ]]; then
    exec "$(dirname "${BASH_SOURCE[0]}")/uninstall.sh"
elif [[ "$1" == "--update" ]]; then
    exec "$(dirname "${BASH_SOURCE[0]}")/update.sh"
fi

# Detect repository directory
REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}"
TIMESTAMP="$(date +%Y-%m-%d-%H%M%S)"

echo "=== Hyprland + Caelestia Shell Dotfiles Setup ==="
echo "Source Repo: $REPO_DIR"
echo "Target Config: $CONFIG_DIR"
echo ""

# Helper function for executing or dry-running commands
run_cmd() {
    if [ "$DRY_RUN" = true ]; then
        echo "[DRY-RUN] $*"
    else
        "$@"
    fi
}

# 1. Detect or Install AUR Helper
detect_aur_helper() {
    if command -v paru &>/dev/null; then
        AUR_HELPER="paru"
    elif command -v yay &>/dev/null; then
        AUR_HELPER="yay"
    else
        AUR_HELPER=""
    fi

    if [ -z "$AUR_HELPER" ]; then
        echo "[!] Neither 'paru' nor 'yay' was detected."
        if [ "$DRY_RUN" = false ]; then
            read -p "Would you like to build and install 'yay-bin' automatically? [Y/n] " -n 1 -r
            echo
            if [[ $REPLY =~ ^[Yy]$ ]] || [[ -z $REPLY ]]; then
                echo "Installing dependencies to build yay..."
                sudo pacman -S --needed --noconfirm base-devel git
                git clone https://aur.archlinux.org/yay-bin.git /tmp/yay-bin
                cd /tmp/yay-bin
                makepkg -si --noconfirm
                cd "$REPO_DIR"
                rm -rf /tmp/yay-bin
                AUR_HELPER="yay"
            else
                echo "[*] Proceeding with official pacman packages only."
            fi
        else
            echo "[DRY-RUN] Would prompt to install yay-bin."
            AUR_HELPER="yay (dry-run placeholder)"
        fi
    else
        echo "[+] Using AUR Helper: $AUR_HELPER"
    fi
}

# 2. Package Lists
REQUIRED_PKGS=(
    hyprland
    kitty
    mpv
    mpvpaper
    qt5-wayland
    qt6-wayland
    polkit-kde-agent
)

CAELESTIA_SHELL_PKGS=(
    quickshell-git
    caelestia-shell-git
    caelestia-cli-git
)

FALLBACK_SHELL_PKGS=(
    waybar
    rofi-wayland
)

OPTIONAL_PKGS=(
    hyprlock
    hypridle
    mako
    swww
    ttf-font-awesome
    otf-font-awesome
    ttf-jetbrains-mono-nerd
)

install_packages() {
    echo ""
    echo "--- Installing Core Required Packages ---"
    if [ -n "$AUR_HELPER" ]; then
        run_cmd $AUR_HELPER -S --needed --noconfirm "${REQUIRED_PKGS[@]}"
    else
        run_cmd sudo pacman -S --needed --noconfirm "${REQUIRED_PKGS[@]}"
    fi

    echo ""
    echo "--- Attempting to Install Caelestia Shell (caelestia-dots/shell via AUR) ---"
    if [ -n "$AUR_HELPER" ]; then
        run_cmd $AUR_HELPER -S --needed --noconfirm "${CAELESTIA_SHELL_PKGS[@]}" || {
            echo "[!] Could not build/install Caelestia Shell from AUR. Installing Waybar + Rofi fallbacks..."
            run_cmd $AUR_HELPER -S --needed --noconfirm "${FALLBACK_SHELL_PKGS[@]}"
        }
    else
        echo "[!] No AUR helper active. Installing Waybar + Rofi fallback shell via pacman..."
        run_cmd sudo pacman -S --needed --noconfirm "${FALLBACK_SHELL_PKGS[@]}"
    fi

    echo ""
    echo "--- Installing Optional Desktop Packages & Fonts ---"
    if [ -n "$AUR_HELPER" ]; then
        run_cmd $AUR_HELPER -S --needed --noconfirm "${OPTIONAL_PKGS[@]}" || echo "[!] Some optional packages skipped..."
    else
        run_cmd sudo pacman -S --needed --noconfirm "${OPTIONAL_PKGS[@]}" || echo "[!] Some optional packages skipped..."
    fi
}

# 3. Clone / Link Caelestia Shell Repo if requested
setup_caelestia_shell_repo() {
    echo ""
    echo "--- Checking Caelestia Shell Source Repository ---"
    CAELESTIA_SHARE_DIR="$HOME/.local/share/caelestia"

    if [ ! -d "$CAELESTIA_SHARE_DIR/shell" ]; then
        echo "[+] Cloning caelestia-dots/shell to $CAELESTIA_SHARE_DIR/shell..."
        run_cmd mkdir -p "$CAELESTIA_SHARE_DIR"
        run_cmd git clone https://github.com/caelestia-dots/shell.git "$CAELESTIA_SHARE_DIR/shell" || echo "[!] Could not clone caelestia-dots/shell."
    else
        echo "[+] Caelestia Shell already exists at $CAELESTIA_SHARE_DIR/shell"
    fi
}

# 4. Safe Backups & Symlinking
setup_configs() {
    echo ""
    echo "--- Deploying Configuration Files ---"
    mkdir -p "$CONFIG_DIR"

    for target in hypr waybar; do
        TARGET_PATH="$CONFIG_DIR/$target"
        SOURCE_PATH="$REPO_DIR/config/$target"

        if [ -e "$TARGET_PATH" ] || [ -L "$TARGET_PATH" ]; then
            BACKUP_PATH="${TARGET_PATH}.backup-${TIMESTAMP}"
            echo "[+] Backing up existing $target config to $BACKUP_PATH"
            run_cmd mv "$TARGET_PATH" "$BACKUP_PATH"
        fi

        echo "[+] Symlinking $target -> $TARGET_PATH"
        run_cmd ln -s "$SOURCE_PATH" "$TARGET_PATH"
    done
}

# 5. Make Scripts Executable
make_scripts_executable() {
    echo ""
    echo "--- Making Helper Scripts Executable ---"
    run_cmd chmod +x "$REPO_DIR/scripts/"*.sh
}

# Main Execution Flow
detect_aur_helper
install_packages
setup_caelestia_shell_repo
setup_configs
make_scripts_executable

echo ""
echo "=== Installation Complete! ==="
echo "Caelestia Shell & Hyprland environment setup is ready."
