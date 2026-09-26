{ config, pkgs, ... }:

let
	secrets = config.common.core.secrets;
	discord-hooks-errors-path = secrets.discord.hooks.foxburrow.errors.path;
	mdadm-notify-discord-pkg = pkgs.writeShellScriptBin "mdadm-notify-discord" ''
${pkgs.curl}/bin/curl -s -X POST -H 'content-type: application/json' -d "{ \"content\": \"$(${pkgs.coreutils-full}/bin/date) ERROR ''${1}: ''${2}\" }" "$(${pkgs.coreutils-full}/bin/cat ${discord-hooks-errors-path})"
'';

in

{
	boot.loader.grub.device = "/dev/disk/by-id/ata-WDC_WD2500AAKX-08U6AA0_WD-WCC2EVL67736";
	common.core.bootloader =
	{
		grub.enable = true;
		support-efi = true;
		display-resolution = "1920x1080";
	};

	# Raid

	# <https://discourse.nixos.org/t/i-want-to-create-a-raid0-for-var-but-im-unable-to-figure-how-to-load-mdamd-on-boot/30381/5>
	system.nixos.tags = [ "mdadm" ];
	boot.swraid =
	{
		enable = true;
		mdadmConf = ''
ARRAY /dev/md0 metadata=1.2 UUID=2789150c:8e613590:21576ee7:a7060788
PROGRAM ${mdadm-notify-discord-pkg}/bin/mdadm-notify-discord
'';
	};

	fileSystems."/mnt/md0" = {
		device = "/dev/disk/by-uuid/3e1b8cbb-9c23-4d61-a423-65245733be57";
		fsType = "ext4";
		options = [ "nofail" ];
	};
}
