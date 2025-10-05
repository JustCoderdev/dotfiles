{ config, lib, pkgs, settings, ... }:

let
	dm-cfg = config.services.xserver.displayManager;
	xfce-cfg = config.system.desktop.xfce;
	i3-cfg = config.system.desktop.i3;
	inherit (settings) username dotfiles_store_path;
in

{
	config = lib.mkIf (xfce-cfg.enable || i3-cfg.enable)
	{
		environment.systemPackages =
		[
			pkgs.gcr # Provides org.gnome.keyring.SystemPrompter
			(pkgs.writeShellScriptBin "refresh-displays" dm-cfg.setupCommands)
		];

		systemd.tmpfiles.rules =
		let
			ldm-grp = config.users.users.lightdm.group;
			icon-path = "${username}.JPEG";
		in
		[
			# Fix icon without exposing home folder
			# Source <https://discourse.nixos.org/t/setting-the-user-profile-image-under-gnome/36233/10>

#			Type Path                                        Mode User Group      Age Argument
			"f+  /var/lib/AccountsService/users/${username}  0640 root ${ldm-grp} -   [User]\\nIcon=/var/lib/AccountsService/icons/${icon-path}\\n"
			"L+  /var/lib/AccountsService/icons/${icon-path} 0640 root ${ldm-grp} -   ${dotfiles_store_path}/confs/users/${icon-path}"
		];

		services =
		{
			xserver = {
				enable = true;
				videoDrivers = lib.mkIf config.host.isVM [ "wmware" ];

				displayManager =
				{
					lightdm.greeters.gtk = {
						extraConfig = ''user-background = false'';
						indicators = [ "~clock" "~power" ];
					};

					setupCommands = let
						xrandr = "${pkgs.xorg.xrandr}/bin/xrandr";
						grep = "${pkgs.gnugrep}/bin/grep";
					in
''
AVAILABLE_DISPLAYS=""
''
					+ (
						builtins.concatStringsSep "\n" (
							lib.attrsets.mapAttrsToList  (
								name: value:
''
${xrandr} | ${grep} '${value.identifier} connected' > /dev/null
if [[ "''${?}" -eq 0 ]]; then
	echo -e "Display ${value.identifier} \033[32mconnected\033[0m"
	${xrandr} --output ${value.identifier} --mode ${value.resolution} --pos ${value.position} --rotate normal
	AVAILABLE_DISPLAYS="''${AVAILABLE_DISPLAYS},${value.identifier}"
else
	echo -e "Display ${value.identifier} \033[31mdisconnected\033[0m"
	${xrandr} --output ${value.identifier} --off
fi
''
							) config.common.core.hardware.displays
						)
					) +
''
AVAILABLE_DISPLAYS="''${AVAILABLE_DISPLAYS:1}"
case $1 in
	surround)

		case $2 in
			enable)
				if [ -n $1 ];
				then
					echo "No display has been found?"
				else
					${xrandr} --setmonitor surround auto $AVAILABLE_DISPLAYS
				fi
			;;

			disable)
				${xrandr} --delmonitor surround
			;;
			*)
				if [ -n $1 ];
				then
					echo "Unknown option '$2', did you meant to write 'enable' or 'disable'?"
				else
					echo "Missing command, available are 'enable' and 'disable'"
				fi
			;;
		esac
	;;

	*)
		if [ -n $1 ];
		then
			echo "Unknown option '$1', did you meant to write 'surround'?"
		fi
	;;
esac
''					;
				};
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

