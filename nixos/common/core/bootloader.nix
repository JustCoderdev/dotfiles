{ config, lib, ... }:

let
	cfg = config.common.core.bootloader;
	cfg-grub = config.boot.loader.grub;

	display-resolution = (
		if cfg.display-resolution != null
		then cfg.display-resolution
		else "auto"
	);
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
	menuentry "Reboot" {
		reboot
	}
	menuentry "Poweroff" {
		halt
	}
}
'';
			};
		};
	};

	# ------------------------------------------------------------ #

	options.common.core.bootloader =
	{
		support-efi = lib.mkEnableOption "Whether the device has efi support";
		display-resolution = lib.mkOption {
			description = "The resolution of the primary display";
			type = lib.types.nullOr lib.types.str;
			example = "1920x1080";
			default = null;
		};
	};
}
