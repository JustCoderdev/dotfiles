{ config, lib, pkgs, settings, ... }:

let
	inherit (settings) hardware-type;

	cfg = config.system.desktop.wayland;

	where-is-my-sddm-theme-pkg =
	(
		pkgs.callPackage  ../../../unofficial/pkgs/where-is-my-sddm-theme.nix {
			variants = [ "qt5" ];
			themeConfig.General = {
				passwordInputWidth = "0.3";
				passwordInputBackground = "#252525";
				passwordInputRadius = 4;
				passwordInputCursorVisible=false;

				passwordFontSize = 36;
				passwordCursorColor = "#ffffff";
				passwordTextColor = "#ffffff";

				sessionsFontSize = 12;
				usersFontSize = 12;

				backgroundFill = "#000000";
				backgroundFillMode = "aspect";

				basicTextColor = "#ffffff";
			};
		}
	);
in

{
	config = lib.mkIf (cfg.enable)
	{
		system.nixos.tags = [ "hyprland" ];

		environment.systemPackages = [ where-is-my-sddm-theme-pkg ]
		++ (
			with pkgs;
			[
				wl-clipboard
				dunst         # notification daemon
				libnotify     # dunst dependency
				waybar        # status bar
				rofi-wayland  # app launcher
				swww          # wallpaper daemon
				playerctl     # media player control
				slurp grim    # screenshots utility
			]
		);

		programs.hyprland = {
			enable = true;
			xwayland.enable = true;
		};

		# ?
		services = {
			devmon.enable = true;
			udisks2.enable = true;
		};

		# Required for thunar to retain preferences
		programs.xfconf.enable = true;

		environment.sessionVariables = lib.mkIf (hardware-type == "virtual-machine")
		{
			# Enable software rendering for VMs
			WLR_RENDERER_ALLOW_SOFTWARE = "1";
			# Enable if cursor is invisible
			WLR_NO_HARDWARE_CURSORS = "1";
			# Enable Chromium and Electron apps
			NIXOS_OZONE_WL = "1";
		};

		services.displayManager.sddm =
		{
			enable = true;

			wayland.enable = true;
			enableHidpi = true;

			autoNumlock = true;
			theme = "where_is_my_sddm_theme_qt5";
		};

		# -------------------- #

		assertions = [ {
			assertion = !config.system.desktop.xserver.enable;
			message = "Cannot enable hyprland if xserver is enabled";
		} ];
	};

	# ------------------------------------------------------------ #

	options.system.desktop.wayland =
	{
		enable = lib.mkEnableOption "wayland support and software";
	};
}
