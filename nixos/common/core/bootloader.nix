# TODO: look into how to create the rescue option (use alpine?)
# Source <https://github.com/cleverca22/nixos-configs/blob/master/rescue_boot.nix>

{ config, lib, ... }:

let
	cfg = config.common.core.bootloader;

	grub-power-menu-entry = ''
submenu "Power options" {
	menuentry "Poweroff" { halt }
	menuentry "Reboot" { reboot }
	menuentry "Reboot to Firmware" { fwsetup }
}
'';
in

{
	config =
	{
		boot.loader =
		{
			grub = lib.mkIf (cfg.grub.enable)
			{
				inherit (cfg.grub) enable;
				extraEntries = grub-power-menu-entry;
				useOSProber = false;

				gfxmodeEfi  = cfg.display-resolution;
				gfxmodeBios = cfg.display-resolution;
				configurationLimit = 16;

				# efi support
				device = lib.mkIf (cfg.support-efi) "nodev";
				efiInstallAsRemovable = cfg.support-efi;
				efiSupport = cfg.support-efi;
			};

			# --- PURE UEFI / NO GRUB --- #
			# systemd-boot.enable = true;
			# systemd-boot.configurationLimit = 5;
			# efi.canTouchEfiVariables = true;
			# --- PURE UEFI / NO GRUB --- #
		};
	};

	# ------------------------------------------------------------ #

	options.common.core.bootloader =
	{
		grub.enable = lib.mkEnableOption "grub as the bootloader";

		support-efi = lib.mkEnableOption "efi support on the bootloader for this device";
		display-resolution = lib.mkOption {
			description = "The resolution of the primary display";
			type = lib.types.str;
			example = "1920x1080";
			default = "auto";
		};
	};
}
