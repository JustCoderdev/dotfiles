{ config, lib, pkgs, ... }:

let cfg = config.system.desktop.xfce; in

{
	config = lib.mkIf cfg.enable {
		services = {
			displayManager.defaultSession = lib.mkForce "none+i3";
			xserver = {

#MSI:
# - DVI-D-0 : disconnected
# - HDMI-0  : connected (DigiQuest)
# - DP-0    : disconnected
# - DP-1    : connected (ASUS)

				displayManager.setupCommands = let
					xrandr = "${pkgs.xorg.xrandr}/bin/xrandr";
				in ''
${xrandr} --output VGA-1  --mode 1920x1080 --pos 0x0    --rotate normal # Acer
${xrandr} --output HDMI-0 --mode 1920x1080 --pos 0x0    --rotate normal # DigiQuest
${xrandr} --output DP-1   --mode 1920x1080 --pos 1920x0 --rotate normal # ASUS
'';

				windowManager.i3 = {
					enable = true;
					extraPackages = with pkgs; [
						dmenu
						i3status
						playerctl
						CuboCore.coreshot
					];
				};

			};


			# org.freedesktop.secrets
			dbus.packages = with pkgs; [
				pass-secret-service
				gnome-keyring
			];

			passSecretService.enable = true;
			gnome.gnome-keyring.enable = true;
		};

		programs = {
			# Remember windows size stuff
			dconf.enable = true;
			i3lock.enable = true;
		};
	};
}
