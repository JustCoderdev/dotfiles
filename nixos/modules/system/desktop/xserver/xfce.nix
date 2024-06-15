{ config, lib, ... }:

let cfg = config.system.desktop.xfce; in

{
	config = lib.mkIf cfg.enable {
		system.nixos.tags = [ "xfce" ];
		services = {
			xserver.desktopManager.xfce.enable = true;
			displayManager.defaultSession = "xfce";
		};
	};
}
