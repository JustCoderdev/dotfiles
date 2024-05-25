{ config, lib, pkgs, ... }:

with lib;
let cfg = config.system.desktop.wayland; in

{
	config = mkIf cfg.enable {
		programs.hyprland = {
			enable = true;
			xwayland.enable = true;

			nvidiaPatches = config.common.core.nvidia.enable;
		};

		xdg.portal = {
			enable = true;
			wlr.enable = true;
			extraPortals = [
				pkgs.xdg-desktop-portal-gtk
				pkgs.xdg-desktop-portal-wlr
			];
		};

		programs.dconf.enable = true;
		services.dbus = {
			enable = true;
			packages = [ pkgs.dconf ];
		};

#		services.gnome.gnome-keyring.enable = true;
		security.pam.services = {
			swaylock = { };
#			swaylock.text = ''
#				auth include login
#			'';
#			login.enableGnomeKeyring = true;
#			#gtklock = {};
		};
	};
}
