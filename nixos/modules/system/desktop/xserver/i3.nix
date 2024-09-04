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

#MSI:
# - DVI-D-0 : disconnected
# - HDMI-0  : connected (DigiQuest)
# - DP-0    : disconnected
# - DP-1    : connected (ASUS)

				displayManager.setupCommands = let
					xrandr = "${pkgs.xorg.xrandr}/bin/xrandr";
				in ''
${xrandr} --output VGA-1 --mode 1920x1080 --pos 0x0 --rotate normal   # Acer
${xrandr} --output HDMI-0 --mode 1920x1080 --pos 0x0 --rotate normal  # DigiQuest
${xrandr} --output DP-1 --mode 1920x1080 --pos 1920x0 --rotate normal # ASUS
'';
			};

		};

		# Remember windows size stuff
		programs.dconf.enable = true;
	};
}
