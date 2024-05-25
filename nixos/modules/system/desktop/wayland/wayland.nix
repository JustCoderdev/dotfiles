{ config, lib, pkgs, settings, ... }:

with lib;
let
	cfg = config.system.desktop.hyprland;
	nvidia = config.common.core.nvidia;
in
{
	config = mkIf cfg.enable {
		hardware = {
			opengl = {
				enable = true;
#				driSupport = true;
#				driSupport32Bit = true;
			};

			nvidia.modesetting.enable = nvidia.enable;
		};

#		services.xserver = {
##			displayManager.gdm = {
##				enable = true;
##				wayland = true;
##			};
#			displayManager.sddm = {
#				enable = true;
#				wayland.enable = true;
##				enableHidpi = true;
##				theme = "where_is_my_sddm_theme";
##				package = pkgs.sddm;
#			};
#		};

		xdg.portal = {
			enable = true;
			extraPortals = with pkgs; [
				xdg-desktop-portal-gtk
			];
		};
	};
}


