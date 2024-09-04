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

#xrandr --output HDMI-A-1 --off
#xrandr --output Unknown-1 --off
#xrandr --output DP-1 --mode 1920x1080 --pos 0x0 --rotate normal
				displayManager.setupCommands = ''
					LEFT='Unknown-1'
					CENTER='HDMI-A-1'
					RIGHT='desc:ASUSTek COMPUTER INC ASUS VA24E L7LMTF289885'
					${pkgs.xorg.xrandr}/bin/xrandr --output $CENTER --rotate left --output $LEFT --rotate left --left-of $CENTER --output $RIGHT --right-of $CENTER
				'';
			};

		};

		# Remember windows size stuff
		programs.dconf.enable = true;
	};
}
