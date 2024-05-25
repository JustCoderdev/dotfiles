#!/bin/sh

DOTFILES_PATH="/.dotfiles"

# Clone dotfiles
# nix-shell -p git --command "git clone https://github.com/JustCoderdev/dotfiles.git ${DOTFILES_PATH}"
# nix-shell -p git --command "git checkout nixos-compliant"

mkdir "${DOTFILES_PATH}/nixos/hosts/nixos"

# Generate harware configuration
sudo nixos-generate-config --show-hardware-config > "${DOTFILES_PATH}/nixos/hosts/nixos/hardware-configuration.nix"

# Move boot commands
BOOT_FILE_PATH="${DOTFILES_PATH}/nixos/hosts/nixos/boot.nix"
CONFIG_FILE_PATH="/etc/nixos/configuration.nix"

touch $BOOT_FILE_PATH
echo -ne "{ ... }:\n\n{\n\t#Bootloader\n"  > $BOOT_FILE_PATH
grep "boot" $CONFIG_FILE_PATH             >> $BOOT_FILE_PATH

echo -ne "\n\t#Virtualisation\n"          >> $BOOT_FILE_PATH
grep "virtualisation" $CONFIG_FILE_PATH   >> $BOOT_FILE_PATH

echo -ne "}\n"                            >> $BOOT_FILE_PATH

# Rebuild system
sudo nixos-rebuild switch --show-trace --flake "${DOTFILES_PATH}/nixos#nixos"
