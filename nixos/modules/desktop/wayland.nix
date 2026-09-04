{ config, lib, pkgs, ... }:

let
	cfg = config.modules.desktop.wayland;

	hardware-type = config.common.manifest.self.hardware.type;
	where-is-my-sddm-theme-pkg =
	(
		pkgs.callPackage  ../../unofficial/pkgs/where-is-my-sddm-theme.nix {
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

		programs.hyprland =
		{
			enable = true;
			xwayland.enable = true;
		};

		environment.systemPackages = (lib.optionals (cfg.own-display-manager.enable) [ where-is-my-sddm-theme-pkg ])
		++ (
			with pkgs;
			[
				wl-clipboard
				dunst         # notification daemon
				libnotify     # dunst dependency
				waybar        # status bar
				rofi          # app launcher
				swww          # wallpaper daemon
				playerctl     # media player control
				slurp grim    # screenshots utility
			]
		);

		# For waybar
		fonts.packages = with pkgs;
		[
			nerd-fonts.roboto-mono
			(callPackage  ../../unofficial/pkgs/apple-fonts.nix {}).sf-pro
		];

		# ?
		services = {
			devmon.enable = true;
			udisks2.enable = true;
		};

		environment.sessionVariables = lib.mkIf (hardware-type == "virtual-machine")
		{
			WLR_RENDERER_ALLOW_SOFTWARE = "1"; # Enable software rendering for VMs
			WLR_NO_HARDWARE_CURSORS = "1";     # Enable if cursor is invisible
			NIXOS_OZONE_WL = "1";              # Enable Chromium and Electron apps
		};

		# Display managers
		services.xserver.displayManager.lightdm =
		{
			enable = lib.mkForce (!cfg.own-display-manager.enable);
			greeters.gtk.indicators = lib.mkIf (!cfg.own-display-manager.enable) (lib.mkBefore [ "~session" ]);
		};

		services.displayManager.sddm = lib.mkIf (cfg.own-display-manager.enable)
		{
			enable = true;

			wayland.enable = true;
			enableHidpi = true;

			autoNumlock = true;
			theme = "where_is_my_sddm_theme_qt5";
		};
	};

	# ------------------------------------------------------------ #

	options.modules.desktop.wayland =
	{
		enable = lib.mkEnableOption "wayland support and software";
		own-display-manager.enable = lib.mkEnableOption "wayland's own display manager";
	};
}
