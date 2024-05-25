#!/bin/sh

# Quit on error
set -e

# Clone dotfiles
DOTFILES_PATH="/.dotfiles"
# echo -e "Cloning dotfiles in ${DOTFILES_PATH}"

# Move to dotfiles
# nix-shell -p git --command "sudo git clone https://github.com/JustCoderdev/dotfiles.git --branch nixos-compliant ${DOTFILES_PATH}"


# Generate harware configuration
echo -e "Generating hardware configuration"

sudo rm -df "${DOTFILES_PATH}/nixos/hosts/nixos"
sudo mkdir -p "${DOTFILES_PATH}/nixos/hosts/nixos"
sudo nixos-generate-config --show-hardware-config | sudo tee "${DOTFILES_PATH}/nixos/hosts/nixos/hardware-configuration.nix"


# Move boot commands
echo -e "Updating boot.nix file..."

BOOT_FILE_PATH="${DOTFILES_PATH}/nixos/hosts/nixos/boot.nix"
CONFIG_FILE_PATH="/etc/nixos/configuration.nix"

sudo touch $BOOT_FILE_PATH
echo -ne "{ ... }:\n\n{\n\t#Bootloader\n" | sudo tee $BOOT_FILE_PATH

# If UEFI system
if [ -d "/sys/firmware/efi/efivars" ]; then
	echo -ne "\tboot.loader.systemd-boot.enable = true;\n"           | sudo tee -a $BOOT_FILE_PATH
	echo -ne "\t#boot.loader.systemd-boot.configurationLimit = 5;\n"  | sudo tee -a $BOOT_FILE_PATH
	echo -ne "\tboot.loader.efi.canTouchEfiVariables = true;\n"      | sudo tee -a $BOOT_FILE_PATH
else
	echo -ne "\tboot.loader.grub.enable = true;\n"                   | sudo tee -a $BOOT_FILE_PATH
	echo -ne "\tboot.loader.grub.device = \"/dev/sda\";\n"           | sudo tee -a $BOOT_FILE_PATH
	echo -ne "\t#boot.loader.grub.configurationLimit = 5;\n"          | sudo tee -a $BOOT_FILE_PATH
	echo -ne "\tboot.loader.grub.useOSProber = false;\n"             | sudo tee -a $BOOT_FILE_PATH
fi

# If using pre-existing configuration.nix file
if [ -f "/etc/nixos/configuration.nix" ]; then
	#echo -ne "\n\t#Boot\n"                   | sudo tee -a $BOOT_FILE_PATH
	#grep "boot" $CONFIG_FILE_PATH            | sudo tee -a $BOOT_FILE_PATH

	echo -ne "\n\t#Virtualisation\n"         | sudo tee -a $BOOT_FILE_PATH
	grep "virtualisation" $CONFIG_FILE_PATH  | sudo tee -a $BOOT_FILE_PATH
fi

echo -ne "}\n"                               | sudo tee -a $BOOT_FILE_PATH
pushd "${DOTFILES_PATH}" && sudo git add "${DOTFILES_PATH}/nixos"


# Rebuild system
echo -e "Rebuilding system for \033[32m\"nixos\"\033[0m"
sudo nixos-rebuild switch --show-trace --flake "${DOTFILES_PATH}/nixos#nixos"
