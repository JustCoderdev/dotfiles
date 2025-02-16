#!/usr/bin/env bash

# Quit on error
set -e


# Create and enter a git subshell
if hash git >/dev/null 2>&1; then
	echo -e "\nGit found"
else
	echo -e "Git not found, entering git shell..."
	nix-shell -p git --command "bash ${0}"
fi


DOTFILES_PATH="$(pwd)/.."
NIXOS_PATH="${DOTFILES_PATH}/nixos"
HOSTS_PATH="${NIXOS_PATH}/hosts"



echo -e "\n### Nixos system installation ###"


HOSTNAME="nixos"
# shellcheck disable=SC2162
read -p 'Enter machine hostname: ' hostname
if [[ "${hostname}" == "" ]]; then
	echo -e "Hostname not passed, defaulting to \033[32m#${HOSTNAME}\033[0m"
else
	HOSTNAME=$hostname
fi


HOST_PATH="${HOSTS_PATH}/${HOSTNAME}"
TEMP_PATH="${HOSTS_PATH}/.example"
echo -e "Installing as \033[32m\"${HOSTNAME}\"\033[0m"

echo -e "Updating flake"
sed -i "s/\(_hostname = \).*/\1\"${HOSTNAME}\";/" "${NIXOS_PATH}/flake.nix"

grep -q "${HOSTNAME} = systemBuilder;" "${NIXOS_PATH}/flake.nix" || grep_exit=$?
if [[ $grep_exit == 1 ]]; then
	echo "Adding new nixosConfiguration"
	sed -i "s/\(nixosConfigurations = {\).*/\1\n\t\t\t${HOSTNAME} = systemBuilder;/" "${NIXOS_PATH}/flake.nix"
else
	echo "nixosConfiguration already in place, skipping"
fi


if [ -d "${HOSTS_PATH}/${HOSTNAME}" ]; then
	# shellcheck disable=SC2162
	read -p 'Host configuration already exists, do you want to continue? (y/N): ' continue_confirm
	if [[ "${continue_confirm}" == [yY] ]] || [[ "${continue_confirm}" == [yY][eE][sS] ]]; then
		echo "Moving old configuration from '${HOSTS_PATH}/${HOSTNAME}' to '${HOSTS_PATH}/${HOSTNAME}.old'"
		rm -rf "${HOSTS_PATH}/${HOSTNAME}.old"
		cp -r "${HOSTS_PATH}/${HOSTNAME}" "${HOSTS_PATH}/${HOSTNAME}.old"
	else
		echo -e "\033[31mExiting...\033[0m"
		exit 1
	fi
else
	echo -e "Cloning templates..."
	mkdir -p "${HOST_PATH}"
	cp "${TEMP_PATH}/settings.nix" "${HOST_PATH}/settings.nix"
	cp "${TEMP_PATH}/configuration.nix" "${HOST_PATH}/configuration.nix"
	cp "${TEMP_PATH}/options.nix" "${HOST_PATH}/options.nix"
fi


echo -e "Setting configuration"
sed -i "s/\(hostname = \).*/\1\"${HOSTNAME}\";/" "${HOST_PATH}/settings.nix"


read -p 'Do you want to edit options.nix? (Y/n): ' editoptions_confirm
if [[ "${editoptions_confirm}" == [nN] ]] || [[ "${editoptions_confirm}" == [nN][oO] ]]; then
	echo "Skipping" > /dev/null
else
	$EDITOR "${HOST_PATH}/options.nix"
fi

read -p 'Do you want to edit settings.nix? (Y/n): ' editsett_confirm
if [[ "${editsett_confirm}" == [nN] ]] || [[ "${editsett_confirm}" == [nN][oO] ]]; then
	echo "Skipping" > /dev/null
else
	$EDITOR "${HOST_PATH}/settings.nix"
fi

echo -e "Generating missing files"
nixos-generate-config --show-hardware-config | tee "${HOST_PATH}/hardware-configuration.nix"

BOOTF_PATH="${HOST_PATH}/boot.nix"
DEF_CONF_PATH="/etc/nixos/configuration.nix"

touch "${BOOTF_PATH}"
echo -ne "{ ... }:\n\n{\n\t#Bootloader\n" | tee "${BOOTF_PATH}"

# If UEFI system
if [ -d "/sys/firmware/efi/efivars" ]; then
	echo "Efivars found, setting systemd..."
	echo -ne "\tboot.loader.systemd-boot.enable = true;\n"           | tee -a "${BOOTF_PATH}"
	echo -ne "\tboot.loader.systemd-boot.configurationLimit = 5;\n"  | tee -a "${BOOTF_PATH}"
	echo -ne "\tboot.loader.efi.canTouchEfiVariables = true;\n"      | tee -a "${BOOTF_PATH}"
else
	echo "Not found efivars, setting grub..."
	echo -ne "\tboot.loader.grub.enable = true;\n"                   | tee -a "${BOOTF_PATH}"
	echo -ne "\tboot.loader.grub.device = \"/dev/sda\";\n"           | tee -a "${BOOTF_PATH}"
	echo -ne "\t#boot.loader.grub.configurationLimit = 5;\n"         | tee -a "${BOOTF_PATH}"
	echo -ne "\tboot.loader.grub.useOSProber = false;\n"             | tee -a "${BOOTF_PATH}"
fi

# If using pre-existing configuration.nix file
if [ -f "/etc/nixos/configuration.nix" ]; then
	#echo -ne "\n\t#Boot\n"                | tee -a $BOOT_FILE_PATH
	#grep "boot" $CONFIG_FILE_PATH         | tee -a $BOOT_FILE_PATH

	echo "Checking virtualization options..."
	echo -ne "\n\t#Virtualisation\n"      | tee -a "${BOOTF_PATH}"
	grep "virtualisation" $DEF_CONF_PATH  | tee -a "${BOOTF_PATH}"
fi

echo -ne "}\n" | tee -a "${BOOTF_PATH}"
pushd "${DOTFILES_PATH}" && git add "${DOTFILES_PATH}/nixos"


## Check for online substituters
substituters="https://cache.nixos.org/?priority=40"
if [ -z "${DOT_NIX_SUB_URL:-}" ]; then
	echo -e "No nix substituter set, ignoring..."
else
	echo -ne "Found nix substituter '${DOT_NIX_SUB_URL}', pinging... "

	ping -c 4 "${DOT_NIX_SUB_URL:-}" > /dev/null 2>&1
	# shellcheck disable=SC2181 #ah the irony
	if [[ "${?}" -eq 0 ]]; then
		echo -e "\033[32mONLINE\033[0m"
		substituters+=" http://${DOT_NIX_SUB_URL}"

		if [ -z "${DOT_NIX_SUB_PORT:-}" ]; then
			#echo -e "No nix substituter port set, leaving default"
			substituters+=":56552"
		else
			#echo -e "Using found port '${DOT_NIX_SUB_PORT}'"
			substituters+=":${DOT_NIX_SUB_PORT}"
		fi

		substituters+="?priority=30"
	else
		echo -e "\033[31mOFFLINE\033[0m"
	fi
fi

# Rebuild system
echo -e "Installing system for \033[32m\"${HOSTNAME}\"\033[0m"
sudo nixos-install --show-trace --flake "${DOTFILES_PATH}/nixos#${HOSTNAME}" --option substituters "${substituters}"
