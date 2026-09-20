# Custom Hyprland Dotfiles 

A modular, fluid, and robust dotfile configuration for Hyprland on Arch Linux, featuring smooth bezier animations, video wallpaper support via `mpvpaper`, and a clean Waybar setup.

## Features
- **Modular Config**: Cleanly separated Hyprland configs (`animations.conf`, `keybinds.conf`, `windowrules.conf`, `monitors.conf`).
- **Fluid Animations**: Custom bezier curves tailored for a sleek, modern desktop feel.
- **Video Wallpaper Default**: Automatic video wallpaper playback using `mpvpaper` with fallback support.
- **Waybar Integration**: Modern status bar with dynamic blur enabled natively by Hyprland window rules.
- **Smart Installer**: Interactive `install.sh` supporting `--dry-run`, automatic backup creation (`~/.config/hypr.backup-*`), AUR helper detection (`paru`/`yay`), and required/optional dependency management.

## Directory Structure
```text
dotfiles/
├── install.sh
├── README.md
├── config/
│   ├── hypr/
│   │   ├── hyprland.conf
│   │   ├── animations.conf
│   │   ├── keybinds.conf
│   │   ├── windowrules.conf
│   │   └── monitors.conf
│   └── waybar/
│       ├── config.jsonc
│       └── style.css
├── scripts/
│   ├── set-bg.sh
│   ├── launch-waybar.sh
│   └── reload.sh
└── assets/
    └── wallpapers/
```

## Quick Start

```bash
git clone https://github.com/notgamermx/dotfiles.git
cd dotfiles
chmod +x install.sh
./install.sh
```

### Options
- `--dry-run`: View what changes and packages would be installed without modifying your system.
otfiles
chmod +x install.sh update.sh uninstall.sh

# Run installation:
./install.sh
```

### Installation Options
- `./install.sh --dry-run`: Preview actions and packages without modifying your system.

---

## 🔄 Updating

To pull git updates, update system packages/plugins, and refresh your running desktop environment:

```bash
./update.sh
# OR
./install.sh --update
```

---

## 🗑️ Uninstallation

To safely remove dotfile symlinks and restore your previous configuration backups (`~/.config/hypr.backup-*`):

```bash
./uninstall.sh
# OR
./install.sh --uninstall
```
