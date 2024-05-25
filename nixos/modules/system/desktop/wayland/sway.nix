{ config, lib, pkgs, ... }:

with lib;
let cfg = config.system.desktop.wayland; in

{
	config = mkIf cfg.enable {
		#programs.sway.enable = true;

		security.polkit.enable = true;
		hardware.opengl.enable = true;

		services.greetd = {
			enable = true;
			settings.default_session.command = ''
			${pkgs.greetd.tuigreet}/bin/tuigreet \
				--time \
				--asterisks \
				--user-menu \
				--cmd sway
			'';
		};

		environment.etc."greetd/environments".text = ''
			sway
		'';

#		environment = {
#			systemPackages = with pkgs; [
#				swaybg
#				swayidle
#				swaylock-effects
#				pamixer
#			];
#
#			sessionVariables = {
#				XDG_CURRENT_DESKTOP = "sway";
#				XDG_SESSION_DESKTOP = "sway";
#				XDG_SESSION_TYPE = "wayland";
#				XDG_CACHE_HOME = "\${HOME}/.cache";
#				XDG_CONFIG_HOME = "\${HOME}/.config";
#				XDG_BIN_HOME = "\${HOME}/.local/bin";
#				XDG_DATA_HOME = "\${HOME}/.local/share";
#			};
#		};
	};
}
