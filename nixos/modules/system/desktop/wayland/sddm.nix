{ config, lib, pkgs, ... }:

let cfg = config.system.desktop.hyprland; in

{
	config = lib.mkIf cfg.enable {
		services.displayManager.sddm = {
			enable = true;

			wayland.enable = true;
			enableHidpi = true;
#			setupScript = ''
#xrandr --output HDMI-A-1 --off
#xrandr --output Unknown-1 --off
#xrandr --output DP-1 --mode 1920x1080 --pos 0x0 --rotate normal
#'';

			autoNumlock = true;
			theme = "where_is_my_sddm_theme_qt5";
		};

#		services.xserver.displayManager.setupCommands = ''
#xrandr --output HDMI-A-1 --off
#xrandr --output Unknown-1 --off
#xrandr --output DP-1 --mode 1920x1080 --pos 0x0 --rotate normal
#'';

		environment.systemPackages = [
			(pkgs.callPackage  ../../../unofficial/where-is-my-sddm-theme.nix {
				variants = [ "qt5" ];
				themeConfig.General = {
					passwordInputWidth = "0.3";
					passwordInputBackground = "#252525";
					passwordInputRadius = 4;
					passwordInputCursorVisible=false;

					passwordFontSize=28;
					passwordCursorColor = "#ffffff";
					passwordTextColor = "#ffffff";

					sessionsFontSize=12;
					usersFontSize=12;

					#background = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
					backgroundFill = "#000000";
					backgroundFillMode = "aspect";

					basicTextColor = "#ffffff";
				};

			 })
#(pkgs.where-is-my-sddm-theme.override { })
		];
	};
}
