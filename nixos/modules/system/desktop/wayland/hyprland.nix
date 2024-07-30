{ config, lib, pkgs, settings, ... }:

let
	cfg = config.system.desktop.hyprland;
#	nvidia = config.common.core.nvidia;
in

{
	config = lib.mkIf cfg.enable {
		system.nixos.tags = [ "hyprland" ];

		programs = {
			thunar.enable = true;
			xfconf.enable = true;

			hyprland = {
				enable = true;
				xwayland.enable = true;
			};
		};

		services = {
			# Mount, trash, and other functionalities
			gvfs.enable = true;

			# Thumbnail support for images
			tumbler.enable = true;
		};

		environment = {
			systemPackages = with pkgs; [
				rofi-wayland  # app launcher
				swww          # wallpaper daemon
				baobab        # disk usage application

				# screenshots utility
				slurp
				grim
			];

			sessionVariables = lib.mkIf settings.runningVM {
				# Enable software rendering for VMs
				WLR_RENDERER_ALLOW_SOFTWARE = "1";
				# Enable if cursor is invisible
				WLR_NO_HARDWARE_CURSORS = "1";
				# Enable Chromium and Electron apps
				NIXOS_OZONE_WL = "1";
			};
		};

#		programs.dconf.enable = true;
#		services.dbus = {
#			enable = true;
#			packages = [ pkgs.dconf ];
#		};
#
#		services.gnome.gnome-keyring.enable = true;
#		security.pam.services = {
##			swaylock = { };
##			swaylock.text = ''
##				auth include login
##			'';
#
#			login.enableGnomeKeyring = true;
##			#gtklock = {};
#		};
	};
}
