{ config, lib, pkgs, settings, ... }:

let
	dev-cfg = config.system.dev;
	cfg = dev-cfg.android;
in

{
	config = lib.mkIf (dev-cfg.enable && cfg.enable)
	{
		boot.binfmt.emulatedSystems = [ "armv7l-linux" "aarch64-linux" ];
		services.udev.packages = [ pkgs.android-udev-rules ];

		environment.systemPackages = with pkgs; [ scrcpy ];

		programs.adb.enable = true;
		users.users.${settings.username}.extraGroups = [ "adbusers" ];
	};

	# ------------------------------------------------------------ #

	options.system.dev.android =
	{
		enable = lib.mkOption {
			type = lib.types.bool;
			description = "Add android development tools and libs";
			default = false;
		};
	};
}
