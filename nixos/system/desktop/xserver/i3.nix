{ config, lib, pkgs, ... }:

let cfg = config.system.desktop.i3; in

{
	config = lib.mkIf cfg.enable {
		system.nixos.tags = [ "i3" ];

		services = {
			displayManager.defaultSession = "none+i3";

			xserver.windowManager.i3 = {
				enable = true;
				extraPackages = with pkgs; [
					dmenu
					i3status
					playerctl
					CuboCore.coreshot
				];
			};

		};
	};
}
