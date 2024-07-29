{ config, lib, pkgs, ... }:

let cfg = config.system.desktop.hyprland; in

{
	config = lib.mkIf cfg.enable {
		services.displayManager.sddm = {
			enable = true;

			wayland.enable = true;
			enableHidpi = true;

			autoNumlock = true;
			theme = "where-is-my-sddm";
		};

		environment.systemPackages = [
			(pkgs.where-is-my-sddm-theme.override {
				themeConfig.General = {
					passwordInputBackground = "#3b3b3b";
					passwordInputRadius = 5;

					passwordCursorColor = "#ffffff";
					passwordTextColor = "#ffffff";

					background = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
					backgroundMode = "none";

					#backgroundFill = "#252525";
					#backgroundFillMode = "aspect";

					basicTextColor = "#ffffff";
				};
			})
		];
	};
}
