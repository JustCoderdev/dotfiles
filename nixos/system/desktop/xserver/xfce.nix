{ config, lib, pkgs, ... }:

let cfg = config.system.desktop.xfce; in

{
	config = lib.mkIf cfg.enable
	{
		system.nixos.tags = [ "xfce" ];
		services = {
			xserver.desktopManager.xfce.enable = true;
			displayManager.defaultSession = "xfce";
		};
	};

	# ------------------------------------------------------------ #

	options.system.desktop.xfce =
	{
		enable = lib.mkOption {
			type = lib.types.bool;
			description = "Enable xfce software suit and support";
			default = false;
		};
	};
}
