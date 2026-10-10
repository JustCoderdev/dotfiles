{ lib, config, pkgs, ... }:

let
	secrets = config.common.core.secrets;
	usb-pkgs =
	let
		write-usb-app = (
			name: text:
			{
				"${name}" = pkgs.writeShellApplication {
					inherit name text;
					runtimeInputs = [ pkgs.uhubctl ];
				};
			}
		);
	in {}
	// (write-usb-app "usb-ports-off" "uhubctl -l 1-1 -p 2 -a 0")
	// (write-usb-app "usb-ports-on"  "uhubctl -l 1-1 -p 2 -a 1")
	;
in

{
	networking.hosts."192.168.1.50" = [ "display.lan" ];
	networking.firewall.allowedTCPPorts = [ 80 ];

	systemd.network = {
		enable = true;
		networks."enu1u1" = {
			matchConfig.Name = "enu1u1";
			address = [ "192.168.1.1/24" ];
			linkConfig.RequiredForOnline = "no";
		};
	};

	# ------------------------------------------------------------ #

	networking =
	{
		useDHCP = false;
		networkmanager.enable = lib.mkForce false;
		interfaces."wlan0".useDHCP = true;
		# interfaces."enu1u1".useDHCP = true;

		wireless = {
			enable = lib.mkForce true;

			userControlled.enable = false;
			interfaces = [ "wlan0" ];

			secretsFile = config.common.core.secrets.wireless.path;
			networks = {
				"WindTower-LTE".pskRaw = "ext:windtower_lte_psk";
				# "NerioGoPro2".pskRaw = "ext:neriogopro_psk";
			};
		};
	};

	environment.systemPackages = []
	++ lib.attrsets.mapAttrsToList (name: pkg: pkg) usb-pkgs;

	services.udev.extraRules = ''
# This is for Linux before 6.0:
SUBSYSTEM=="usb", DRIVER=="hub|usb", MODE="0664", GROUP="dialout"

# This is for Linux 6.0 or later (ok to keep this block present for older Linux kernels):
SUBSYSTEM=="usb", DRIVER=="hub|usb", \
	RUN+="/bin/sh -c \"chown -f root:dialout $sys$devpath/*port*/disable || true\"" \
	RUN+="/bin/sh -c \"chmod -f 660 $sys$devpath/*port*/disable || true\""
'';


	users.users."hass".extraGroups = [ "dialout" ];
	modules.services.home-assistant =
	{
		openFirewall = false;
		proxy = {
			enable = true;
			host = "jarvis.home.lan";
			aliases = [ "192.168.7.8" ];
		};
		packages.usb = usb-pkgs;
	};
}
