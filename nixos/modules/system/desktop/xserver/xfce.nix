{ config, lib, ... }:

with lib;
let cfg = config.system.desktop.xfce; in

{
	config = mkIf cfg.enable {
		services.xserver = {
			desktopManager.xfce.enable = true;
			displayManager.defaultSession = "xfce";
		};
	};
}
