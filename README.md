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

## TODO

### NixOS

- [ ] Restructure dotfiles
- [ ] Background image
- [ ] Mac-like gestures
- [ ] Custom enable config (mk.force)

- [ ] Setup Firefox
- [ ] Setup Ly
- [ ] Setup Github
	- [ ] `git config --global --add safe.directory /.dotfiles`
	- [ ] `git config --global pull.rebase true`
	- [ ] `push.autoSetupRemote`

- [ ] Check tmux
- [ ] Check emax
- [ ] Check xnomad
- [ ] Check Wayland

- [ ] Custom XKB LAYOUT (`Shift+Backspace`=`Canc`)

- [ ] Set version for each package
- [ ] Installation script (`system.userActivationScripts`)
- [ ] Auto-fetch dotfile repo


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
