{ config, lib, pkgs, settings, ... }:

let
	cfg = config.system.desktop.hyprland;
in

{
	config = lib.mkIf cfg.enable
	{
		system.nixos.tags = [ "hyprland" ];

		programs = {
			# Required for thunar to retain preferences
			xfconf.enable = true;

			hyprland = {
				enable = true;
				xwayland.enable = true;
			};
		};

		services = {
			devmon.enable = true;
			udisks2.enable = true;
		};

		environment = {
			systemPackages = with pkgs; [
				waybar        # status bar
				rofi-wayland  # app launcher
				swww          # wallpaper daemon
				playerctl     # media player control

				# screenshots utility
				slurp
				grim
			];

			sessionVariables = lib.mkIf (settings.hardware-type == "virtual-machine") {
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

	# ------------------------------------------------------------ #

	options.system.desktop.hyprland = {
		enable = lib.mkOption {
			type = lib.types.bool;
			description = "Enable hyprland software suit and support";
			default = false;
		};
	};
}
