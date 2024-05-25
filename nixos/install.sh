#!/bin/bash

# Quit on error
set -e

echo -n "Entering git shell...  "
nix-shell -p git
echo "Done!"

DOTFILES_PATH="/.dotfiles"
NIXOS_PATH="${DOTFILES_PATH}/nixos"
HOSTS_PATH="${NIXOS_PATH}/hosts"

# Clone dotfiles
# echo -e "Cloning dotfiles in ${DOTFILES_PATH}"
# sudo git clone https://github.com/JustCoderdev/dotfiles.git --branch nixos-compliant ${DOTFILES_PATH}


echo -e "\n### Nixos system installation ###"


HOSTNAME="nixos"
# shellcheck disable=SC2162
read -p 'Enter machine hostname: ' hostname
if [[ "${hostname}" == "" ]]; then
	echo -e "Hostname not passed, defaulting to \033[32m#${HOSTNAME}\033[0m"
else
	if [ -d "${HOSTS_PATH}/${HOSTNAME}" ]; then
		# shellcheck disable=SC2162
		read -p 'Host configuration already existing, do you want to continue? (y/N): ' continue_confirm
		if [[ "${continue_confirm}" == [yY] ]] || [[ "${continue_confirm}" == [yY][eE][sS] ]]; then
			echo "Moved old configuration from ${HOSTS_PATH}/${HOSTNAME} to ${HOSTS_PATH}/${HOSTNAME}.old"
			mv -f "${HOSTS_PATH}/${HOSTNAME}" "${HOSTS_PATH}/${HOSTNAME}.old"
			mkdir -p "${HOSTS_PATH}/${HOSTNAME}"
		else
			echo -e "\033[31mExiting...\033[0m"
			exit 1
		fi
	fi
fi

HOST_PATH="${HOSTS_PATH}/${HOSTNAME}"
TEMP_PATH="${HOSTS_PATH}/.example"
echo -e "Installing as \033[32m\"${HOSTNAME}\"\033[0m"

echo -e "Updating flake..."
sed -i "s/\(_hostname = \).*/\1\"${HOSTNAME}\";/" "${NIXOS_PATH}/flake.nix"
sed -i "s/\(nixosConfigurations = {\).*/\1\n\t\t\t${HOSTNAME} = systemBuilder;/" "${NIXOS_PATH}/flake.nix"

echo -e "Cloning templates..."
cp "${TEMP_PATH}/settings.nix" "${HOST_PATH}/settings.nix"
cp "${TEMP_PATH}/configuration.nix" "${HOST_PATH}/configuration.nix"

echo -e "Setting configuration"
sed -i "s/\(hostname = \).*/\1\"${HOSTNAME}\";/" "${HOST_PATH}/settings.nix"
$EDITOR "${HOST_PATH}/configuration.nix"
$EDITOR "${HOST_PATH}/settings.nix"

echo -e "Generating missing files"
nixos-generate-config --show-hardware-config | tee "${DOTFILES_PATH}/nixos/hosts/nixos/hardware-configuration.nix"

BOOTF_PATH="${HOST_PATH}/boot.nix"
DEF_CONF_PATH="/etc/nixos/configuration.nix"

touch $BOOTF_PATH
echo -ne "{ ... }:\n\n{\n\t#Bootloader\n" | tee $BOOTF_PATH

# If UEFI system
if [ -d "/sys/firmware/efi/efivars" ]; then
	echo "Efivars found, setting systemd..."
	echo -ne "\tboot.loader.systemd-boot.enable = true;\n"           | tee -a $BOOTF_PATH
	echo -ne "\tboot.loader.systemd-boot.configurationLimit = 5;\n"  | tee -a $BOOTF_PATH
	echo -ne "\tboot.loader.efi.canTouchEfiVariables = true;\n"      | tee -a $BOOTF_PATH
else
	echo "Not found efivars, setting grub..."
	echo -ne "\tboot.loader.grub.enable = true;\n"                   | tee -a $BOOTF_PATH
	echo -ne "\tboot.loader.grub.device = \"/dev/sda\";\n"           | tee -a $BOOTF_PATH
	echo -ne "\t#boot.loader.grub.configurationLimit = 5;\n"         | tee -a $BOOTF_PATH
	echo -ne "\tboot.loader.grub.useOSProber = false;\n"             | tee -a $BOOTF_PATH
fi

# If using pre-existing configuration.nix file
if [ -f "/etc/nixos/configuration.nix" ]; then
	#echo -ne "\n\t#Boot\n"                | tee -a $BOOT_FILE_PATH
	#grep "boot" $CONFIG_FILE_PATH         | tee -a $BOOT_FILE_PATH

	echo "Checking virtualization options..."
	echo -ne "\n\t#Virtualisation\n"      | tee -a $BOOTF_PATH
	grep "virtualisation" $DEF_CONF_PATH  | tee -a $BOOTF_PATH
fi

echo -ne "}\n"                               | tee -a $BOOTF_PATH
pushd "${DOTFILES_PATH}" && git add "${DOTFILES_PATH}/nixos"


# Rebuild system
echo -e "Rebuilding system for \033[32m\"${HOSTNAME}\"\033[0m"
sudo nixos-rebuild switch --show-trace --flake "${DOTFILES_PATH}/nixos#${HOSTNAME}"
