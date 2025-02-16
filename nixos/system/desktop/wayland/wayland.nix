{ config, lib, pkgs, ... }:

let
	cfg = config.system.desktop.hyprland;
in
{
	config = lib.mkIf cfg.enable {
		environment.systemPackages = with pkgs; [
			dunst      # notification daemon
			libnotify  # dunst dependency
			wl-clipboard
		];

#		services.xserver.displayManager.gdm = {
#			enable = true;
#			wayland = true;
#		};
	};
}


