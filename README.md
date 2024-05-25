> ⚠️ My dotfiles are divided in 3 branches:
>
> - `main`: Oldest "stable" version (fully "compatible" with macos)
> - `nixos-compliant`: Stable version of nixos, preferred but not updated
> - `nixos-compliant-unstable`: (CURRENT) Switched to unstable to configure hyprland

> ⚠️ My dotfiles had an incident >:(
>
> This is why all commits before a certain point report
> the date of the incident and I lost 8 commits (as far as I know)

# Dotfiles

These are my dotfiles, feel free to use them and
share with me any feedback or trick you may know :p

> Virtual machine notes
>
> - Remember to enable `settings.runningVM` in `nixos/hosts/HOST/settings.nix`
> - Nixos doesn't like default graphics driver, use `VBoxVGA`
> - Hyrpland may not work in a VM, try but it's not assured

---

[Xfce desktop]
> "Xfce", i3, i3status, nvim and zsh showcase

[Hyprland desktop]
> "Hyprland", waybar, wallpaper showcase

[Plymouth theme]
> Plymouth darnix theme (custom)

---

## Overview

These are all my dotfiles which are compatible with or
without (or at least that's the goal) nix/NixOS installed

- `Operating System`: NixOS
- `Terminal`: Alacritty
- `Editor`: Nvim (trying emacs tho...)

|                | XServer  | Wayland  |
| -------------: | -------- | -------- |
| Window manager | i3       | hyprland |
| Status bar     | i3status | waybar   |
| App launcher   | dmenu    | wofi     |

Included configuration files

- Alacritty \[v0.12.2\] ([Github](https://github.com/alacritty))
- Clang \[7.0.1-8\] ([Docs](https://clangd.llvm.org/config.html))
- Clang-format \[7.0.1-8\] ([Docs](https://releases.llvm.org/7.0.0/tools/clang/docs/ClangFormatStyleOptions.html))
- Hyprland (WIP)
- i3 \[4.16.1\] ([Docs](https://i3wm.org/docs/userguide.html), [statDocs](https://i3wm.org/docs/i3status.html))
- MangoHud (WIP)
- NixOS \[v23.11\]
- Nvim \[v0.9.1\] ([Github](https://github.com/neovim))
- Plymouth \[v24.004.60\] ([Gitlab](https://gitlab.freedesktop.org/plymouth/plymouth))
- Waybar \[v0.10.3\] ([Github](https://github.com/Alexays/Waybar))
- Zsh \[5.7.1\]

## Special Requirements

- Font: `Roboto Mono` [Link](https://github.com/googlefonts/RobotoMono.git) (For Alacritty)

## Installing Configuration

1. Cloning repo

```bash
DOT_FILES="${HOME}/.config/dotfiles" # or /.dotfiles
git clone https://github.com/JustCoderdev/dotfiles.git "${DOT_FILES}"
cd "${DOT_FILES}"
```

2. Running installer

    - Without nix

    ```bash
    ./mount-configs.sh
    ```

    - With nix stuff (home-manager)

    ```bash
    cd nixos
    nix build ".#${USER}"
    ./result/activate
    ```

    - With NixOS

    ```bash
    cd nixos
    ./install.sh
    ```

## NixOS file structure








