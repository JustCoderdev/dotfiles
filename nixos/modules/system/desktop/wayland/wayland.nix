{ config, lib, pkgs, ... }:

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
				theme = "chili";
#				package = pkgs.sddm;
			};
		};

		environment = {
			systemPackages = with pkgs; [
				wayland
				waydroid

				#waybar
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


