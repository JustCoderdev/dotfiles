#!/usr/bin/env bash

# Quit on error
set -e


# Check if git is installed
if hash git >/dev/null 2>&1; then
	echo -e "- Git is installed"
else
	echo -e "Git not found, quitting..."
	exit 1
fi

if hash vim >/dev/null 2>&1; then
	echo -e "- Vim is installed"
	EDITOR='vim'
else
	echo -e "Vim not found, quitting..."
	exit 1
fi


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
TEMP_PATH="${HOSTS_PATH}/.example"
echo -e "Installing as \033[32m\"${HOSTNAME}\"\033[0m\n"

grep -qE "${HOSTNAME}.*= system-builder" "${DOT_FILES}/flake.nix" || grep_exit=$?
if [[ $grep_exit == 1 ]]; then
	echo -e "\033[31mTODO: FIX SED THINGY\033[0m"
	echo -e "\033[33mManually add v to flake.nix"
	echo -e "${HOSTNAME} = system-builder \"${HOSTNAME}\" \"x86_64-linux\" \"ryuji\";\033[0m\n"
	exit 1

	# echo -e "Adding ${HOSTNAME} nixosConfiguration"
	#sed -i "s/\(nixosConfigurations = {\).*/\1\n\t\t\t${HOSTNAME} = system-builder \"${HOSTNAME}\" \"x86_64-linux\" \"ryuji\";/" "${DOT_FILES}/flake.nix"
else
	echo -e "NixosConfiguration already in place, skipping..."
fi


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
	cp -f "${TEMP_PATH}/options.nix"       "${HOST_PATH}/options.nix"

	echo -e "\nGenerating missing files"
	nixos-generate-config --show-hardware-config > "${HOST_PATH}/hardware-configuration.nix"

	DEF_CONF_PATH="/etc/nixos/configuration.nix"
	BOOT_FILE_PATH="${HOST_PATH}/boot.nix"
	CONF_FILE_PATH="${HOST_PATH}/configuration.nix"

	touch "${CONF_FILE_PATH}"
	echo -ne "{ ... }:\n\n{\n\n}\n" > "${CONF_FILE_PATH}"

	touch "${BOOT_FILE_PATH}"
	echo -ne "{ ... }:\n\n{\n\t#Bootloader\n" > "${BOOT_FILE_PATH}"

	# If UEFI system
	if [ -d "/sys/firmware/efi/efivars" ]; then
		echo "Efivars found, setting systemd"
		echo -ne "\tboot.loader.systemd-boot.enable = true;\n"           >> "${BOOT_FILE_PATH}"
		echo -ne "\tboot.loader.systemd-boot.configurationLimit = 5;\n"  >> "${BOOT_FILE_PATH}"
		echo -ne "\tboot.loader.efi.canTouchEfiVariables = true;\n"      >> "${BOOT_FILE_PATH}"
	else
		echo "Efivars not found, setting grub"
		echo -ne "\tboot.loader.grub.enable = true;\n"                   >> "${BOOT_FILE_PATH}"
		echo -ne "\tboot.loader.grub.device = \"/dev/sda\";\n"           >> "${BOOT_FILE_PATH}"
		echo -ne "\t#boot.loader.grub.configurationLimit = 5;\n"         >> "${BOOT_FILE_PATH}"
		echo -ne "\tboot.loader.grub.useOSProber = false;\n"             >> "${BOOT_FILE_PATH}"
	fi

	# If using pre-existing configuration.nix file
	if [ -f "/etc/nixos/configuration.nix" ]; then
		#echo "Copying existing boot options..."
		#echo -ne "\n\t#Boot\n"                 >> "$BOOT_FILE_PATH"
		#set +e
		#grep "boot" "${DEF_CONF_PATH}"         >> "$BOOT_FILE_PATH"
		#set -e

		echo "Copying existing virtualization options"
		echo -ne "\n\t#Virtualisation\n"             >> "${BOOT_FILE_PATH}"

		set +e
		grep -q "virtualisation" "${DEF_CONF_PATH}"  >> "${BOOT_FILE_PATH}"
		set -e
	fi

	echo -ne "}\n" >> "${BOOT_FILE_PATH}"
	echo -ne "\n"
fi



# Edit files
read -p 'Do you want to edit options.nix? (Y/n): ' editoptions_confirm
if [[ "${editoptions_confirm}" != [nN] ]] && [[ "${editoptions_confirm}" != [nN][oO] ]]; then
	$EDITOR "${HOST_PATH}/options.nix"
fi

read -p 'Do you want to edit configuration.nix? (Y/n): ' editconf_confirm
if [[ "${editconf_confirm}" != [nN] ]] && [[ "${editconf_confirm}" != [nN][oO] ]]; then
	$EDITOR "${HOST_PATH}/configuration.nix"
fi



#  ## Check for online substituters
#  substituters="https://cache.nixos.org/?priority=40"
#  if [ -z "${DOT_NIX_SUB_URL:-}" ]; then
#  	echo -e "No nix substituter set, ignoring..."
#  else
#  	echo -ne "Found nix substituter '${DOT_NIX_SUB_URL}', pinging... "
#
#  	ping -c 4 "${DOT_NIX_SUB_URL:-}" > /dev/null 2>&1
#  	# shellcheck disable=SC2181 #ah the irony
#  	if [[ "${?}" -eq 0 ]]; then
#  		echo -e "\033[32mONLINE\033[0m"
#  		substituters+=" http://${DOT_NIX_SUB_URL}"
#
#  		if [ -z "${DOT_NIX_SUB_PORT:-}" ]; then
#  			#echo -e "No nix substituter port set, leaving default"
#  			substituters+=":56552"
#  		else
#  			#echo -e "Using found port '${DOT_NIX_SUB_PORT}'"
#  			substituters+=":${DOT_NIX_SUB_PORT}"
#  		fi
#
#  		substituters+="?priority=30"
#  	else
#  		echo -e "\033[31mOFFLINE\033[0m"
#  	fi
#  fi



#  ## Update flake
#  echo -e "Creating jcbin and jcconfs in nix-store...";
#  cd "${DOT_FILES}"
#
#  cd ./bin
#  nix --extra-experimental-features 'nix-command flakes' build .#mount-configs
#  nix --extra-experimental-features 'nix-command flakes' flake lock
#
#  cd ../confs
#  nix --extra-experimental-features 'nix-command flakes' build .#ryuji-activation
#  nix --extra-experimental-features 'nix-command flakes' flake lock
#
#  cd ..
#  nix --extra-experimental-features 'nix-command flakes' flake update jcbin jcconfs
#  git add .
#  echo "";



# Rebuild system
./bin/bash-scripts/rebuild-system.sh ${HOSTNAME}

# sudo mkdir -p /mnt
# echo -e "Installing system for \033[32m\"${HOSTNAME}\"\033[0m"
# sudo nixos-install --show-trace --flake "${DOT_FILES}#${HOSTNAME}" --option substituters "${substituters}"
