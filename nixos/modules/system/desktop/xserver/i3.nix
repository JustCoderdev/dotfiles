{ config, lib, pkgs, ... }:

let cfg = config.system.desktop.xfce; in

{
	config = lib.mkIf cfg.enable {
		services = {
			displayManager.defaultSession = lib.mkForce "none+i3";
			xserver = {
				windowManager.i3 = {
					enable = true;
					extraPackages = with pkgs; [
						dmenu
						i3status
						playerctl
						# i3lock
					];
				};

				displayManager.setupCommands = ''
xrandr --output HDMI-A-1 --off
xrandr --output Unknown-1 --off
xrandr --output DP-1 --mode 1920x1080 --pos 0x0 --rotate normal
'';

			};

		};

		# Remember windows size stuff
		programs.dconf.enable = true;
	};
}
