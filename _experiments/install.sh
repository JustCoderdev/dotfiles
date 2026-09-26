#!/nix/store/ih68ar79msmj0496pgld4r3vqfr7bbin-bash-5.2p37/bin/bash

# Quit on error
set -e


# Check if git is installed
if hash git >/dev/null 2>&1; then echo -e "- Git is installed"
else echo -e "Git not found, quitting..."; exit 1 fi

# Check if vim is installed
if hash vim >/dev/null 2>&1; then echo -e "- Vim is installed"; EDITOR='vim'
else echo -e "Vim not found, quitting..."; exit 1 fi

DOT_FILES="$(pwd)"
NIXOS_PATH="${DOT_FILES}/nixos"
HOSTS_PATH="${NIXOS_PATH}/hosts"


echo -e "\n### Nixos system installation ###\n"

HOSTNAME="nixos"
# shellcheck disable=SC2162
read -p 'Enter machine hostname: ' hostname
if [[ "${hostname}" == "" ]]; then
	echo -e "Hostname not passed, defaulting to \033[32m#${HOSTNAME}\033[0m"
else
	HOSTNAME=$hostname
fi


HOST_PATH="${HOSTS_PATH}/${HOSTNAME}"
TEMP_PATH="${HOSTS_PATH}/.template"
echo -e "Installing as \033[32m\"${HOSTNAME}\"\033[0m\n"

generate_files=1
if [ -d "${HOST_PATH}" ]; then
	# shellcheck disable=SC2162
	read -p 'Host configuration already exists, do you want to replace them? (y/N): ' continue_confirm
	if [[ "${continue_confirm}" == [yY] ]] || [[ "${continue_confirm}" == [yY][eE][sS] ]]; then
		echo "Moving old configuration to '${HOSTS_PATH}/${HOSTNAME}.old'\n"
		cp -rf "${HOSTS_PATH}/${HOSTNAME}" "${HOSTS_PATH}/${HOSTNAME}.old"
	else
		generate_files=0
	fi
fi

if [[ $generate_files == 1 ]];
then
	echo -e "\nCloning templates"
	mkdir -p "${HOST_PATH}"
	cp -f "${TEMP_PATH}/*" "${HOST_PATH}"

	echo -e "\nGenerating missing files"
	nixos-generate-config --show-hardware-config > "${HOST_PATH}/hardware-configuration.nix"
	echo -ne "{ ... }:\n\n{\n\n}\n" > "${HOST_PATH}/configuration.nix"

	BOOT_FILE_PATH="${HOST_PATH}/boot.nix"
	echo -ne "{\n\tcommon.core.bootloader =\n\t{\n\t\tgrub.enable = true;\n\t\t support-efi = " > "${BOOT_FILE_PATH}"

	# If UEFI system
	if [ -d "/sys/firmware/efi/efivars" ]; then
		echo "Efivars found, setting as UEFI";
		echo -n 'true' >> "${BOOT_FILE_PATH}"
	else
		echo "Efivars not found, setting as Legacy Boot"
		echo -n 'false' >> "${BOOT_FILE_PATH}"
	fi
	echo -ne ";\n\t};\n}\n" >> "${BOOT_FILE_PATH}"
fi

# Edit files
read -p 'Do you want to edit the configuration? (Y/n): ' editoptions_confirm
if [[ "${editoptions_confirm}" != [nN] ]] && [[ "${editoptions_confirm}" != [nN][oO] ]]; then
	exit 0;
fi

# Rebuild system
./bin/bash-scripts/rebuild-system.sh ${HOSTNAME}

# sudo mkdir -p /mnt
# echo -e "Installing system for \033[32m\"${HOSTNAME}\"\033[0m"
# sudo nixos-install --show-trace --flake "${DOT_FILES}#${HOSTNAME}" --option substituters "${substituters}"
