# YOU'RE ON THE `main` BRANCH, SWITCH TO `nixos-integration` FOR THE LATEST CHANGES

> `/!\` My dotfiles had an incident
>
> This is why all commits before a certain point report
> the date of the incident and at least 8 commits got lost (as far as I know)

> `(i)` My dotfiles are divided in 4 branches:
>
> - `main`: Oldest "stable" version (fully "compatible" with macos)
> - `nixos-integration`: (CURRENT) Restructuring of nixos w better flakes
> - `nixos-compliant`: [DEPRECATED] Messy stable version of nixos
> - `nixos-compliant-unstable`: [DEPRECATED] Switched to unstable to configure hyprland

```plaintext
* 16d55fd main
|\
| * 88e48b9 nixos-compliant (nixpkgs-23.05)
| |\
| | * cfb1ed0 nixos-compliant-unstable (nixpkgs/unstable)
| | |
| |/
| * 2c6a8c9 nixos-compliant (nixpkgs-24.05)
| |
| * 0be0f74 nixos-compliant (nixpkgs-24.11)
' |
  * 91c5ef1 nixos-integration (nixpkgs-24.11)
  v
```

# Dotfiles
These are my dotfiles, feel free to use them and
share with me any feedback or trick you may know :p

## Index

Configuration files for
- Alacritty \[v0.12.2\] ([Github](https://github.com/alacritty))
- Clang \[7.0.1-8\] ([Docs](https://clangd.llvm.org/config.html))
- Clang-format \[7.0.1-8\] ([Docs](https://releases.llvm.org/7.0.0/tools/clang/docs/ClangFormatStyleOptions.html))
- i3 \[4.16.1\] ([Docs](https://i3wm.org/docs/userguide.html), [statDocs](https://i3wm.org/docs/i3status.html))
- NixOS \[v23.11\]
- Nvim \[v0.9.1\] ([Github](https://github.com/neovim))
- Zsh \[5.7.1\]

## Special Requirements
- Font: `Roboto Mono` [Link](https://github.com/googlefonts/RobotoMono.git) (For Alacritty)

## Special Installing

#TODO

## Installing Configuration

```shell
git clone https://github.com/JustCoderdev/dotfiles.git ~/.config/dotfiles

# Create filepaths
mkdir ~/Developer
mkdir ~/Developer/Github
mkdir ~/Developer/Projects

# Setting soft links <3
cd ~/-config/dotfiles
ln -s ~/.config/dotfiles/alacritty  ..  # Alacritty
ln -s ~/.config/dotfiles/clangd/    ..  # Clang
ln -s ~/.config/dotfiles/standalone/.clang-format ~       # Clang format
ln -s ~/.config/dotfiles/i3/        ..  # i3
ln -s ~/.config/dotfiles/i3/scripts/bin/* /usr/local/bin  # i3
ln -s ~/.config/dotfiles/nvim       ..      # Nvim
ln -s ~/.config/dotfiles/zsh        ~/.zsh  # Zsh
ln -s ~/.config/dotfiles/zsh/.zshrc ~       # Zsh
```
