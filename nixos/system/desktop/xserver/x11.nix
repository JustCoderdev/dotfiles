{ config, lib, pkgs, settings, ... }:

let
	xfceCfg = config.system.desktop.xfce;
	i3Cfg = config.system.desktop.i3;
in

{
	config = {
		services = {
			xserver = {
				enable = xfceCfg.enable || i3Cfg.enable;
				videoDrivers = lib.mkIf config.host.isVM [ "wmware" ];

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
			};

			libinput = {
				enable = true;

				mouse.middleEmulation = false;
				touchpad = {
					accelProfile = "flat";       # flat, adaptive
					clickMethod = "buttonareas"; # buttonareas, clickfinger

					# dmesg | grep i8042
					# dev = "/devices/platform/i8042/serio1/input/input5";
					middleEmulation = false;
					scrollMethod = "twofinger";

					tapping = true;
					tappingDragLock = false;
					tappingButtonMap = "lrm";
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

		# Remember windows size stuff
		programs.dconf.enable = true;

		security.pam = {
			# Enable lightdm to use Gnome Keyring
			services.login.enableGnomeKeyring = true;
			mount.logoutTerm = true;  # Send SIGTERM # Graceful shutdown
			mount.logoutKill = false; # Send SIGKILL # Forceful shutdown
		};
	};
}

