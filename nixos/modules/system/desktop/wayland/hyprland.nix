{ config, lib, pkgs, inputs, ... }:

with lib;

let
	cfg = config.system.desktop.wayland;
#	pkgs-hypr = inputs.hyprland.inputs.nixpkgs.legacyPackages.${pkgs.stdenv.hostPlatform.system};
in

{
	config = mkIf cfg.enable {

# FROM WAYLAND STUFF
		hardware.opengl = {
			enable = true;
			driSupport = true;
			driSupport32Bit = true;
		};

		environment = {
			systemPackages = with pkgs; [
#				wayland
				waybar
				rofi-wayland
#				pkgs-unstable.where-is-my-sddm-theme
			];

			sessionVariables = {
				# Enable if cursor is invisible
				WLR_NO_HARDWARE_CURSORS = "1";

				# Enable Chromium and Electron apps
				NIXOS_OZONE_WL = "1";
			};
		};
# END WAYLAND STUFF

#		hardware.opengl = {
#			package = pkgs-hypr.mesa.drivers;
#			package32 = pkgs-hypr.pkgsi686Linux.mesa.drivers;
#		};

		programs.hyprland = {
			enable = true;
			xwayland.enable = true;

#			package = inputs.hyprland.packages.${pkgs.system}.hyprland;
#			portalPackage = pkgs.xdg-desktop-portal-hyprland;

#			nvidiaPatches = config.common.core.nvidia.enable;
		};

		xdg.portal = {
			enable = true;
#			wlr.enable = true;
			extraPortals = with pkgs; [
#				xdg-desktop-portal
				xdg-desktop-portal-gtk
#				xdg-desktop-portal-hyprland
			];
		};

		programs.dconf.enable = true;
		services.dbus = {
			enable = true;
			packages = [ pkgs.dconf ];
		};

		services.gnome.gnome-keyring.enable = true;
		security.pam.services = {
#			swaylock = { };
##			swaylock.text = ''
##				auth include login
##			'';
			login.enableGnomeKeyring = true;
##			#gtklock = {};
		};
	};
}
