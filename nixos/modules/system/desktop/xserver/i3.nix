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

			# Thunar extensions
			gvfs.enable = true;    # mount, trash, other
			tumbler.enable = true; # img thumbnails
		};

		environment.systemPackages = with pkgs; [
			ffmpegthumbnailer # Thunar extensions video thumbnails
		];

		security.pam = {
			# Enable lightdm to use Gnome Keyring
			services.login.enableGnomeKeyring = true;
			mount.logoutTerm = true;  # Send SIGTERM # Graceful shutdown
			mount.logoutKill = false; # Send SIGKILL # Forceful shutdown
		};

		programs = {
			dconf.enable = true; # Remember windows size stuff
			#i3lock.enable = true;

			thunar = {
				enable = true;
				plugins = with pkgs.xfce; [
					thunar-archive-plugin     # archives context actions
					thunar-media-tags-plugin  # media tags?
					thunar-volman             # drive mounting etc...
				];
			};
		};
	};
}
