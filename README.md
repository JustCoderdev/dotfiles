# Dotfiles
These are my dotfiles, feel free to use them and
share with me any feedback or trick you may know :p

## Index

Configuration files for
- Alacritty \[v0.12.2\] ([Github](https://github.com/alacritty))
- Clang ([Docs](https://clangd.llvm.org/config.html))
- Clang-format ([Docs](https://releases.llvm.org/12.0.0/tools/clang/docs/ClangFormatStyleOptions.html))
- i3 ([Docs](https://i3wm.org/docs/userguide.html), [statDocs](https://i3wm.org/docs/i3status.html))
- Nvim \[v0.9.1\] ([Github](https://github.com/neovim))
- Zsh

## Installation

### Alacritty

Terminal emulator that supports
full RGB range

**Requirements**
- Font: `Roboto Mono` [Link](https://github.com/googlefonts/RobotoMono.git)

```bash
# Install alacritty source
sudo git clone https://github.com/alacritty/alacritty.git /bin/alacritty
sudo git checkout tags/v0.12.2 # Change to right release

# Install build dependency
sudo apt-get install curl cmake pkg-config libfreetype6-dev libfontconfig1-dev libxcb-xfixes0-dev libxkbcommon-dev python3
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
rustup override set stable
rustup update stable

# Set permission
sudo chmod -R g+w /usr/bin/alacritty  # Set permission to run cargo
sudo chown -R root:sudo /usr/bin/alacritty  # Allow group sudo to edit

# Build alacritty
cd /bin/alacritty
cargo build --release

# Check integrity
tic -xe alacritty,alacritty-direct extra/alacritty.info # Install infocmp
infocmp alacritty  # If returns without error terminfo is installed

# Add to desktop db
sudo cp target/release/alacritty /usr/local/bin
sudo cp extra/logo/alacritty-term.svg /usr/share/pixmaps/Alacritty.svg
sudo desktop-file-install extra/linux/Alacritty.desktop
sudo update-desktop-database
```

### Clang
C compiler (duh)

### Clang-format
C file formatter

### i3
A window manager

### Nvim
Textual code editor

### Zsh
Shell environment


