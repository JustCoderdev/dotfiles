# To create the rescue option
# Source <https://github.com/cleverca22/nixos-configs/blob/master/rescue_boot.nix>

{ config, lib, pkgs, settings, ... }:

let
	cfg = config.common.core.bootloader;
	cfg-grub = config.boot.loader.grub;

	display-resolution = (
		if cfg.display-resolution != null
		then cfg.display-resolution
		else "auto"
	);

	installer-netboot = import (pkgs.path + "/nixos/lib/eval-config.nix") {
		inherit (settings) system;
		modules = [ (pkgs.path + "/nixos/modules/installer/netboot/netboot-minimal.nix") ];
	};

	netboot-build = installer-netboot.config.system.build;
	netboot-boot  = installer-netboot.config.boot;
in

{
	config =
	{
		boot.loader = { }
		//
		lib.mkIf (!cfg-grub.enable)
		{
			# --- UEFI --- #

			efi.canTouchEfiVariables = true;
			systemd-boot = {
				enable = true;
				configurationLimit = 5;
			};
		}
		//
		lib.mkIf (cfg-grub.enable)
		{
			# --- GRUB --- #

			grub =
			{
				device = lib.mkIf (cfg.support-efi) "nodev";
				efiInstallAsRemovable = cfg.support-efi;
				efiSupport = cfg.support-efi;

				gfxmodeEfi  = display-resolution;
				gfxmodeBios = display-resolution;
				useOSProber = false;

				extraEntries = ''
submenu "Power options" {

	menuentry "Poweroff" {
		halt
	}

	menuentry "Reboot" {
		reboot
	}

	menuentry "Reboot to Firmware" {
		fwsetup
	}
}
''
+ lib.strings.optionalString (cfg.rescue.enable) ''
menuentry "Rescue Mode" {
	linux ($drive1)/rescue-kernel init=${netboot-build.toplevel}/init ${toString netboot-boot.kernelParams}
	initrd ($drive1)/rescue-initrd
}
'';

				extraFiles = lib.mkIf (cfg.rescue.enable) {
					"rescue-kernel" = "${netboot-build.kernel}/bzImage";
					"rescue-initrd" = "${netboot-build.netbootRamdisk}/initrd";
				};
			};
		};
	};

	# ------------------------------------------------------------ #

	options.common.core.bootloader =
	{
		rescue.enable = lib.mkEnableOption "Add a rescue entry in grub launch options";
		support-efi = lib.mkEnableOption "Whether the device has efi support";
		display-resolution = lib.mkOption {
			description = "The resolution of the primary display";
			type = lib.types.nullOr lib.types.str;
			example = "1920x1080";
			default = null;
		};
	};
}
