{ config, lib, pkgs, pkgs-unstable, ... }:

with lib;
let cfg = config.system.desktop.wayland; in

{
	config = mkIf cfg.enable {
		hardware = {
			opengl.enable = true;
			nvidia.modesetting.enable = true;
		};

		services.xserver = {
#			displayManager.gdm = {
#				enable = true;
#				wayland = true;
#			};
			displayManager.sddm = {
				enable = true;
#				wayland.enable = true;
				enableHidpi = true;
				theme = "where_is_my_sddm_theme";
#				package = pkgs.sddm;
			};
		};

		environment = {
			systemPackages = with pkgs; [
				pkgs-unstable.where-is-my-sddm-theme
				wayland
				waybar
				rofi-wayland
			];

			sessionVariables = {
				# Enable if cursor is invisible
				WLR_NO_HARDWARE_CURSORS = "1";

				# Enable Chromium and Electron apps
				NIXOS_OZONE_WL = "1";
			};
		};
	};
}


