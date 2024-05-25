#!/bin/sh

# Clone dotfiles
echo -e "Cloning dotfiles"
DOTFILES_PATH="/.dotfiles"

nix-shell -p git --command "git clone https://github.com/JustCoderdev/dotfiles.git ${DOTFILES_PATH}"
nix-shell -p git --command "git checkout nixos-compliant"


# Generate harware configuration
echo -e "Generating hardware configuration"

rm "${DOTFILES_PATH}/nixos/hosts/nixos/*"
sudo mkdir -p "${DOTFILES_PATH}/nixos/hosts/nixos"
sudo nixos-generate-config --show-hardware-config > "${DOTFILES_PATH}/nixos/hosts/nixos/hardware-configuration.nix"


# Move boot commands
echo -e "Updating boot.nix file..."

BOOT_FILE_PATH="${DOTFILES_PATH}/nixos/hosts/nixos/boot.nix"
CONFIG_FILE_PATH="/etc/nixos/configuration.nix"

sudo touch $BOOT_FILE_PATH
echo -ne "{ ... }:\n\n{\n\t#Bootloader\n"  > $BOOT_FILE_PATH
grep "boot" $CONFIG_FILE_PATH             >> $BOOT_FILE_PATH

echo -ne "\n\tboot.loader.systemd-boot.configurationLimit = 5;\n"  >> $BOOT_FILE_PATH
echo -ne "\tboot.loader.grub.configurationLimit = 5;\n"            >> $BOOT_FILE_PATH

echo -ne "\n\t#Virtualisation\n"          >> $BOOT_FILE_PATH
grep "virtualisation" $CONFIG_FILE_PATH   >> $BOOT_FILE_PATH
echo -ne "}\n"                            >> $BOOT_FILE_PATH
git add .


# Rebuild system
echo -e "Rebuilding system for \033[32m\"nixos\"\033[0m"
sudo nixos-rebuild switch --show-trace --flake "${DOTFILES_PATH}#nixos"
