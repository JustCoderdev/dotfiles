{ config, lib, pkgs, ... }:

with lib;
let cfg = config.system.desktop.wayland; in

{
	config = mkIf cfg.enable {
		hardware = {
			opengl = {
				enable = true;
				driSupport = true;
				driSupport32Bit = true;
			};

#			nvidia.modesetting.enable = true;
		};

		services.xserver = {
#			displayManager.gdm = {
#				enable = true;
#				wayland = true;
#			};
			displayManager.sddm = {
				enable = true;
				wayland.enable = true;
#				enableHidpi = true;
#				theme = "where_is_my_sddm_theme";
#				package = pkgs.sddm;
			};
		};

		environment = {
			systemPackages = with pkgs; [
#				wayland
				waybar
				rofi-wayland
#				where-is-my-sddm-theme
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


