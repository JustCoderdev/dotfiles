{ config, pkgs, settings, ... }:

let
	inherit (settings) dotfiles_path;
	secrets = config.common.core.secrets;
	mdadmhook-path = secrets.discord-hook.path;
in

{
	#Bootloader
	boot.loader.grub.enable = true;
	boot.loader.grub.device = "/dev/sda";
	#boot.loader.grub.configurationLimit = 5;
	boot.loader.grub.useOSProber = false;

	#Virtualisation

	# Intel Graphics
	boot.initrd.kernelModules = [ "i915" ];

	# Raid

	# <https://discourse.nixos.org/t/i-want-to-create-a-raid0-for-var-but-im-unable-to-figure-how-to-load-mdamd-on-boot/30381/5>
	system.nixos.tags = [ "mdadm" ];
	boot.swraid = {
		enable = true;
		mdadmConf = ''
ARRAY /dev/md0 metadata=1.2 UUID=2789150c:8e613590:21576ee7:a7060788
PROGRAM "curl -s -X POST -H 'content-type: application/json' -d \"{ \\\"content\\\": \\\"$(date) ERROR ''${1}: ''${2}\\\" }\" \"$(cat ${mdadmhook-path})\""
'';
	};

	fileSystems."/mnt/md0" = {
		device = "/dev/disk/by-uuid/3e1b8cbb-9c23-4d61-a423-65245733be57";
		fsType = "ext4";
		options = [ "nofail" ];
	};

	# Spindown after 10 minutes
	systemd.services.hd-idle = let
		time_m = 10;
		time_s = toString (time_m * 60);
	in {
		enable = true;
		wantedBy = [ "multi-user.target" ];
		serviceConfig = {
			type = "forking";
			ExecStart = "${pkgs.hd-idle}/bin/hd-idle -i 0 -a sdb -i ${time_s} -a sdc -i ${time_s}";
		};
	};
}
