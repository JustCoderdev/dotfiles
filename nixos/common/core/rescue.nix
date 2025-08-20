# Create a rescue option
# Source <https://github.com/cleverca22/nixos-configs/blob/master/rescue_boot.nix>

{ config, lib, pkgs, ... }:

let
	cfg = config.common.core.rescue;
in

{
	config = lib.mkIf (cfg.enable)
	let
		netboot = import (pkgs.path + "/nixos/lib/eval-config.nix") {
			modules = [ (pkgs.path + "/nixos/modules/installer/netboot/netboot-minimal.nix") ];
		};

		build = netboot.config.system.build;
		boot = netboot.config.boot;
	in
	{
		boot.loader.grub =
		{
			extraEntries = ''
menuentry "Nixos Installer" {
	linux ($drive1)/rescue-kernel init=${build.toplevel}/init ${toString boot.kernelParams}
	initrd ($drive1)/rescue-initrd
}
'';
			extraFiles = {
				"rescue-kernel" = "${build.kernel}/bzImage";
				"rescue-initrd" = "${build.netbootRamdisk}/initrd";
			};
		};
	};

	# ------------------------------------------------------------ #

	options.common.core.rescue =
	{
		enable = lib.mkOption {
			description = "Add a rescue entry in grub launch options";
			type = lib.types.bool;
			default = false;
			read-only = true;
		};
	};
}

