{ config, lib, pkgs, settings, ... }:

let
	xfce_cfg = config.system.desktop.xfce;
	i3_cfg = config.system.desktop.i3;
in

{
	config = lib.mkIf (xfce_cfg.enable || i3_cfg.enable)
	{
		environment.systemPackages =
		[
			pkgs.gcr # Provides org.gnome.keyring.SystemPrompter
			(
				pkgs.writeShellScriptBin "refresh-displays" ''
${config.services.xserver.displayManager.setupCommands}
''
			)
		];

		services =
		{
			displayManager.execCmd = lib.mkForce ''
export PATH=${pkgs.lightdm}/sbin:$PATH
GTK_THEME=Adawaita:dark exec ${pkgs.lightdm}/sbin/lightdm
'';
			xserver = {
				enable = true;
				videoDrivers = lib.mkIf config.host.isVM [ "wmware" ];

				displayManager.setupCommands = let
					xrandr = "${pkgs.xorg.xrandr}/bin/xrandr";
					grep = "${pkgs.gnugrep}/bin/grep";
				in 
				builtins.concatStringsSep "\n" (
					lib.attrsets.mapAttrsToList  (
						name: value:
''
${xrandr} | ${grep} '${value.identifier} connected' > /dev/null
if [[ "''${?}" -eq 0 ]]; then
	echo -e "Display ${value.identifier} \033[32mconnected\033[0m"
	${xrandr} --output ${value.identifier} --mode ${value.resolution} --pos ${value.position} --rotate normal
else
	echo -e "Display ${value.identifier} \033[31mdisconnected\033[0m"
	${xrandr} --output ${value.identifier} --off
fi
''
					) config.common.core.hardware.displays
				);
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
			# dbus.packages = with pkgs; [
			# 	pass-secret-service
			# 	gnome-keyring
			# ];

			# passSecretService.enable = true;
			gnome.gnome-keyring.enable = true;
		};

		# Remember windows size stuff
		programs.dconf.enable = true;

		security.pam = {
			# Enable lightdm to use Gnome Keyring
			services.login.enableGnomeKeyring = true;
			services.display-manager.enableGnomeKeyring = true;
			mount.logoutTerm = true;  # Send SIGTERM # Graceful shutdown
			mount.logoutKill = true;  # Send SIGKILL # Forceful shutdown
		};
	};
}

