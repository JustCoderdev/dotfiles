{ config, lib, pkgs, ... }:

let
	cfg = config.system.desktop.hyprland;
	nvidia = config.common.core.nvidia;
in
{
	config = lib.mkIf cfg.enable {
		hardware = {
			opengl = {
				enable = true;
#				driSupport = true;
#				driSupport32Bit = true;
			};

			nvidia.modesetting.enable = nvidia.enable;
		};

#		services.xserver.displayManager.gdm = {
#			enable = true;
#			wayland = true;
#		};

		xdg.portal = {
			enable = true;
			extraPortals = with pkgs; [ xdg-desktop-portal-gtk ];
		};
	};
}


