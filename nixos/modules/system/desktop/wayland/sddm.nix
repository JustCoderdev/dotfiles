{ config, lib, pkgs, ... }:

let cfg = config.system.desktop.hyprland; in

{
	config = lib.mkIf cfg.enable {
		services.displayManager.sddm = {
			enable = true;

			wayland.enable = true;
			enableHidpi = true;

			autoNumlock = true;
			theme = "where_is_my_sddm_theme_qt5";
		};

		services.xserver.displayManager.setupCommands = ''
xrandr --output HDMI-A-1 --off
xrandr --output Unknown-1 --off
xrandr --output DP-1 --mode 1920x1080 --pos 0x0 --rotate normal
'';

		environment.systemPackages = [
			(pkgs.where-is-my-sddm-theme.override {
				variants = [ "qt5" ];
				themeConfig.General = {
					passwordInputBackground = "#3b3b3b";
					passwordInputRadius = 4;
					passwordInputCursorVisible=false;

					passwordFontSize=64;
					passwordCursorColor = "#ffffff";
					passwordTextColor = "#ffffff";

					sessionsFontSize=36;
					usersFontSize=36;

					#background = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
					backgroundFill = "#252525";
					backgroundFillMode = "aspect";

					basicTextColor = "#ffffff";
				};
			})
		];
	};
}
