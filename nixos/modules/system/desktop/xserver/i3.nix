{ config, lib, pkgs, ... }:

with lib;
let cfg = config.system.desktop.xfce; in

{
	config = mkIf cfg.enable {
		services.xserver = {
			displayManager.defaultSession = mkForce "none+i3";

			windowManager.i3 = {
				enable = true;
				extraPackages = with pkgs; [
					dmenu
					i3status
					playerctl
					# i3lock
				];
			};
		};

		# Remember windows size stuff
		programs.dconf.enable = true;
	};
}
